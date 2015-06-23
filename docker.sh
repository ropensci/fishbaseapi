#!/bin/bash

docker rm -f -v fbredis fbes fblogstash fbgeoip fbmysql slbmysql fbapi fbnginx


## Start some services: redis, elasticsearch, logstash, freegeoip
docker run --name fbredis -d redis:latest
docker run --name fbes -d -v "$HOME/log/fishbase":/usr/share/elasticsearch/data elasticsearch:latest
docker run --name fblogstash --link fbes:es -d -v "$PWD/logstashconf":/config-dir -v $HOME/log/fishbase:/var/log/fishbase logstash:latest logstash -f /config-dir/logstash.conf
docker run --name fbgeoip -d allingeek/docker-freegeoip


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
#docker pull ropensci/fishbaseapi:latest
docker run --name fbapi -d \
  --link slbmysql:sealifebase \
  --link fbmysql:mysql \
  --link fbredis:redis \
  --link fbgeoip:geoip \
  --volumes-from fblogstash \
  ropensci/fishbaseapi:latest


# Must generate a .htpassword file first:
# assuming apache2-utils is installed: sudo htpasswd -cb .htpasswd $USER $PASSWORD

docker run --name fbnginx -d \
  -p 80:80 -p 9200:9200 \
  --link fbes:es \
  --link fblogstash:logstash \
  --link fbapi:api \
  -v ${PWD}/nginx.conf:/etc/nginx/nginx.conf \
  -v ${PWD}/.htpasswd:/etc/nginx/.htpasswd \
  -v ${PWD}/bundle.crt:/etc/ssl/certs/es.crt \
  -v ${PWD}/ssl.key:/etc/ssl/private/es.key \
  nginx:latest

