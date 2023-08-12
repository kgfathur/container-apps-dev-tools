#!/bin/bash

echo -e "\n## -- OS Info"
cat /etc/os-release

echo -e "\n## -- NGINX Version"
nginx -V

echo -e "\n## --> /etc/nginx"
ls -lh /etc/nginx
echo -e "\n## --> /tmp/nginx"
ls -lh /tmp/nginx
echo -e "\n## --> /var/cache/nginx"
ls -lh /var/cache/nginx
echo -e "\n## --> /var/log/nginx"
ls -lh /var/log/nginx
echo -e "\n## --> /var/run/nginx"
ls -lh /var/run/nginx
echo -e "\n## --> /usr/share/nginx"
ls -lh /usr/share/nginx
