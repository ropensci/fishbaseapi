#!/bin/bash

SERVER=server.carlboettiger.info
PORT=80
NGINX_CONF=${PWD}/nginx.conf

docker run --name fbredis -d redis:latest
docker run --name fblogstash -d \
  -v /root \
	-p 9292:9292 \
	-p 9200:9200 \
  -e ES_HOST=${SERVER}\
	-e LOGSTASH_CONFIG_URL=https://raw.githubusercontent.com/ropensci/fishbaseapi/master/logstash.conf\
	pblittle/docker-logstash

docker run --name fbmysql --restart=always -d -v $HOME/data/fishbase:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=root mysql:latest
docker pull ropensci/fishbaseapi:latest

docker run --name fbapi -d --link fbmysql:mysql --link fbredis:redis --volumes-from fblogstash ropensci/fishbaseapi:latest
docker run --name fbnginx -d -p ${PORT}:80 --link fbapi:api -v ${NGINX_CONF}:/etc/nginx/nginx.conf nginx:latest

