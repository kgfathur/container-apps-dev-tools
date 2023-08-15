#!/bin/bash
# This is a sample additional startup script
# You can add script to /entrypoint.d/ with format: .sh or .envsh
# Will always be executed before starting your container [CMD]

echo -e "\n## -- OS Info"
cat /etc/os-release

echo -e "\n## -- NGINX Version"
nginx -V

echo "$(date +'%Y-%m-%d %H:%M:%S.%3N') | Running: php-fpm -D"
php-fpm -D
echo "$(date +'%Y-%m-%d %H:%M:%S.%3N') | 'php-fpm -D' exec code $?"