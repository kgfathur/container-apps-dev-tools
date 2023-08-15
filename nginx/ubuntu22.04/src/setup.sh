#!/bin/bash
set -e

APP_GID=${APP_USERID:-1000}
APP_UID=${APP_USERID:-1000}
APP_USER=${APP_USER:-nginx}
APP_HOME=${APP_HOME:-/usr/share/nginx/html}
WWW_ROOT=${WWW_ROOT:-/usr/share/nginx/html}
NGINX_VERSION=${NGINX_VERSION:-1.22}
OS_CODENAME=$(grep -Po 'VERSION_CODENAME=\K\w+' /etc/os-release)

echo "Pre-setup file and dir..."
set +e
mkdir -vp /entrypoint.d/ \
          ${APP_HOME} \
          ${WWW_ROOT} \
          /var/run/nginx \
          /tmp/nginx

set -e
cp -vrf /src/entrypoint.sh /entrypoint.sh
cp -vrf /src/entrypoint.d /

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
apt-get install -y --no-install-recommends curl gnupg2 ca-certificates ubuntu-keyring

APT_KEYRING_PATH=/etc/apt/trusted.gpg.d/nginx-archive-keyring.gpg
curl -s https://nginx.org/keys/nginx_signing.key | gpg  -v --yes --dearmor -o ${APT_KEYRING_PATH}
gpg --dry-run --quiet --no-keyring --import --import-options import-show ${APT_KEYRING_PATH}

echo "deb [signed-by=${APT_KEYRING_PATH}] \
http://nginx.org/packages/ubuntu ${OS_CODENAME} nginx" \
  | tee /etc/apt/sources.list.d/nginx.list

apt-get update
apt-get install -y --no-install-recommends nginx=${NGINX_VERSION}*

apt-get clean autoclean
apt-get autoremove --yes

rm -vrf /var/lib/{apt,cache,log}/
rm -vrf /var/log/{apt,*.log}

ln -vsf /dev/stdout /var/log/nginx/access.log
ln -vsf /dev/stderr /var/log/nginx/error.log

echo "Prepare file and dir"
cp -vrf /src/app/* ${WWW_ROOT}/
cp -vrf /src/nginx.conf /etc/nginx/nginx.conf
cp -vrf /src/nginx.conf.d/* /etc/nginx/conf.d/

sed -i "s|^\(user\s\+\).*;$|\1${APP_USER};|" /etc/nginx/nginx.conf
sed -i "s|\(root\s\+\).*;$|\1${WWW_ROOT};|" /etc/nginx/conf.d/default.conf

chown -vR $APP_UID:0 ${APP_HOME}
chown -vR $APP_UID:0 ${WWW_ROOT}
chown -vR $APP_UID:0 /etc/nginx
chmod -vR g+w /etc/nginx
chown -vR $APP_UID:0 /tmp/nginx
chmod -vR g+w /tmp/nginx
chown -vR $APP_UID:0 /var/cache/nginx
chmod -vR g+w /var/cache/nginx
chown -vR $APP_UID:0 /var/log/nginx
chmod -vR g+w /var/log/nginx
chown -vR $APP_UID:0 /var/run/nginx
chmod -vR g+w /var/run/nginx
chown -vR $APP_UID:0 /usr/share/nginx
chmod -vR g+w /etc/nginx

chown -vR $APP_UID:0 /entrypoint.sh
chmod -vR 750 /entrypoint.sh
chown -vR $APP_UID:0 /entrypoint.d
set +e
chmod -vR 750 /entrypoint.d/{*.sh,*.envsh} || echo -n
