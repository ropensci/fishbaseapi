#!/bin/bash



# Must generate a .htpassword file first:
# assuming apache2-utils is installed: sudo htpasswd -cb .htpasswd $USER $PASSWORD

docker run --name fbnginx -d \
  -p 443:443 \
  -v ${PWD}/nginx-ssl.conf:/etc/nginx/nginx.conf \
  -v ${PWD}/.htpasswd:/etc/nginx/.htpasswd \
  -v ${PWD}/ssl.crt:/etc/nginx/ssl/certs/nginx.crt \
  -v ${PWD}/ssl.key:/etc/nginx/ssl/private/nginx.key \
  nginx:latest

