#!/bin/bash

docker run --name fbredis -d redis:latest

docker run --name fblogstash -d \
  -v /root \
	-p 9292:9292 \
	-p 9200:9200 \
	-e LOGSTASH_CONFIG_URL=https://raw.githubusercontent.com/ropensci/fishbaseapi/master/logstash.conf \
	pblittle/docker-logstash

docker run --name fbmysql -d -v $HOME/data/fishbase:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=root -p 127.0.0.1:3306:3306 mysql:latest

# Make sure we have the latest version by pulling or building
#docker pull ropensci/fishbaseapi
docker build -t ropensci/fishbaseapi .

# Give the sql database a few seconds to start up first.
sleep 2


## Start fb app, but expose only the nginx port (port 80), not the unicorn port (8080)
docker run --name fbapi -d -p 80:80 --link fbmysql:mysql --link fbredis:redis --volumes-from fblogstash ropensci/fishbaseapi

## NOTE: Sever name must be hardwired into nginx.conf. Please adjust appropriately
docker run --name fbnginx -d --net container:fbapi -v ${PWD}/nginx.conf:/etc/nginx/nginx.conf nginx

