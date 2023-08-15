#!/bin/bash
set -e

APP_GID=1000
APP_UID=1000
APP_USER=node
APP_HOME=${APP_HOME:-/app}
NODE_VERSION=${NODE_VERSION:-18}
OS_CODENAME=$(grep -Po 'VERSION_CODENAME=\K\w+' /etc/os-release)

echo "Pre-setup file and dir..."
set +e
mkdir -vp /entrypoint.d/ \
          ${APP_HOME}

set -e
cp -vrf /src/entrypoint.sh /entrypoint.sh
cp -vrf /src/entrypoint.d /

chown -vR $APP_UID:0 ${APP_HOME}

echo "Add User & Group"
groupadd --gid $APP_GID $APP_USER

useradd \
  --gid $APP_GID \
  --uid $APP_UID \
  --no-create-home \
  --home ${APP_HOME} \
  --shell /bin/false \
  $APP_USER

id $APP_USER

echo "Setup: repo"
apt-get update
apt-get install -y --no-install-recommends curl ca-certificates gnupg2 ubuntu-keyring

echo "Confirming Node.js ${NODE_VERSION} is supported on ${OS_CODENAME}"
curl -sLf -o /dev/null "https://deb.nodesource.com/node_${NODE_VERSION}.x/dists/${OS_CODENAME}/Release"

APT_KEYRING_PATH=/etc/apt/trusted.gpg.d/nodesource.gpg
curl -sL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | gpg  -v --yes --dearmor -o ${APT_KEYRING_PATH}
gpg --dry-run --quiet --no-keyring --import --import-options import-show ${APT_KEYRING_PATH}
echo "deb [signed-by=${APT_KEYRING_PATH}] https://deb.nodesource.com/node_${NODE_VERSION}.x jammy main
# deb-src [signed-by=${APT_KEYRING_PATH}] https://deb.nodesource.com/node_${NODE_VERSION}.x jammy main" | \
tee /etc/apt/sources.list.d/nodesource.list

APT_KEYRING_PATH=/etc/apt/trusted.gpg.d/yarnkey.gpg
curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | gpg  -v --yes --dearmor -o ${APT_KEYRING_PATH}
gpg --dry-run --quiet --no-keyring --import --import-options import-show ${APT_KEYRING_PATH}
echo "deb [signed-by=${APT_KEYRING_PATH}] \
https://dl.yarnpkg.com/debian stable main" | \
tee /etc/apt/sources.list.d/yarn.list

apt-get update
apt-get install -y --no-install-recommends nodejs yarn
node -v
npm -v
yarn --version

apt-get clean autoclean
apt-get autoremove --yes

rm -vrf /var/lib/{apt,cache,log}/
rm -vrf /var/log/{apt,*.log}

echo "Prepare file and dir"
cp -vrf /src/app/*.js ${APP_HOME}/

chown -vR $APP_UID:0 /entrypoint.sh
chmod -vR 750 /entrypoint.sh
chown -vR $APP_UID:0 /entrypoint.d
set +e
chmod -vR 750 /entrypoint.d/{*.sh,*.envsh} || echo -n
