set -evu

if [ $# -ne 3 ]; then
  echo "USAGE: $0 name command"
  exit 1
fi

ubuntu_home=/home/ubuntu

# Set the service name
service_name=$1

# Set the command
service_command=$2

# Setting runit to run $service_name...
mkdir -p /etc/service/$service_name/log

cat <<EOS > /etc/service/$service_name/run
#!/bin/sh
exec 2>&1
. /etc/profile
. $ubuntu_home/.profile
exec $service_command
EOS
chmod +x /etc/service/$service_name/run

# Setting up runit logging...
mkdir -p $ubuntu_home/logs/$service_name

cat <<EOS > /etc/service/$service_name/log/run
#!/bin/sh
exec svlogd -tt $ubuntu_home/logs/$service_name
EOS
chmod +x /etc/service/$service_name/log/run

# Waiting for runit to recognize the new service...
while [ ! -d /etc/service/$service_name/supervise ]; do
  sleep 5 && echo "waiting..."
done
sleep 1

# Turning off the server until the first deploy...
sv stop $service_name
> $ubuntu_home/logs/$service_name/current

# Giving the ubuntu user the ability to control the service...
chown -R ubuntu /etc/service/$service_name/supervise
chown -R ubuntu $ubuntu_home/logs
