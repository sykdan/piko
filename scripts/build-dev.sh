#!/usr/bin/bash
npm run build
nginx="/usr/share/nginx"
rm -rf ./dist/data
rm -rf $nginx/html/piko-dev
mv ./dist $nginx/html/piko-dev
ln -s $nginx/piko-data $nginx/html/piko-dev/data
