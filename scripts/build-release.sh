#!/usr/bin/bash
npm run build
nginx="/usr/share/nginx"
rm -rf ./dist/data
rm -rf $nginx/html/piko
mv ./dist $nginx/html/piko
ln -s $nginx/piko-data $nginx/html/piko/data
