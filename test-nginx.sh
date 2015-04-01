#!/bin/bash

docker rm -f nginx

# Must generate a .htpassword file first:
# assuming apache2-utils is installed: sudo htpasswd -cb .htpasswd $USER $PASSWORD

docker run --name nginx -d \
  -p 443:443 \
  -v ${PWD}/nginx-ssl.conf:/etc/nginx/nginx.conf \
  -v ${PWD}/.htpasswd:/etc/nginx/.htpasswd \
  -v ${PWD}/bundle.crt:/etc/nginx/ssl/nginx.crt \
  -v ${PWD}/ssl.key:/etc/nginx/ssl/nginx.key \
  nginx:latest

