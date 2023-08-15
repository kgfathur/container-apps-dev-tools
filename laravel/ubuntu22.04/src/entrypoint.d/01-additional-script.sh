#!/bin/bash
# This is a sample additional startup script
# You can add script to /entrypoint.d/ with format: .sh or .envsh
# Will always be executed before starting your container [CMD]

echo -e "\n## -- OS Info"
cat /etc/os-release

echo -e "\n## -- NGINX Version"
nginx -v
echo -e "\n## -- PHP Version"
php --version
echo -e "\n## -- Node.js Version"
node -v
echo -e "\n## -- NPM Version"
npm -v
echo -e "\n## -- yarn Version"
yarn --version

