set -evu

# fetch source
git fetch --all

ref=`git for-each-ref refs/tags \
  --sort=-authordate \
  --format='%(refname)' \
  --count=1 | cut -d '/' -f 3`

if [ -z $ref ]; then
  exit 1;
fi

# reset HEAD
git reset --hard $ref

# Install dependencies
cd app && npm install --production && cd ..

# Restart services
sv restart app
