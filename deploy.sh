set -evu

# fetch source
git fetch --all

# latest ref
ref=`git for-each-ref --sort=-authordate --format='%(refname)' --count=1 | cut -d '/' -f 3`

if [ -z $ref ]; then
  exit 1;
fi

# reset HEAD
git reset --hard $ref

# Install dependencies
cd app && npm install --production && cd .. 2>&1

# Restart services
sv restart app
