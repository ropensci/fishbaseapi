#!/bin/bash

# Remove any versions of running containers first
docker rm -f -v fbredis fbmysql slbmysql fbapi fbnginx

# Make sure services are up-to-date
docker pull redis:latest
docker pull mysql:latest
docker pull nginx:latest

## Start some services: redis, elasticsearch, logstash, freegeoip
docker run --name fbredis -d redis:latest


######### FishBase DataBase ##################

docker run --name fbmysql \
  --restart=always -d \
  -v $HOME/data/fishbase:/var/lib/mysql \
  -e MYSQL_ROOT_PASSWORD=root \
  mysql:latest

###### SeaLifeBase DataBase & API ############

docker run --name slbmysql \
  --restart=always -d \
  -v $HOME/data/sealifebase:/var/lib/mysql \
  -e MYSQL_ROOT_PASSWORD=root \
  mysql:latest



docker build -t ropensci/fishbaseapi:latest .
docker run --name fbapi -d \
  --link slbmysql:sealifebase \
  --link fbmysql:mysql \
  --link fbredis:redis \
  ropensci/fishbaseapi:latest


# Must generate a .htpassword file first:
# assuming apache2-utils is installed: sudo htpasswd -cb .htpasswd $USER $PASSWORD

docker run --name fbnginx -d \
  -p 80:80 \
  --link fbapi:api \
  -v ${PWD}/nginx.conf:/etc/nginx/nginx.conf \
  nginx:latest
