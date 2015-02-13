#!/bin/bash
docker run --name fbredis -d redis:latest
docker run --name fblogstash -d \
  -v /root \
	-p 9292:9292 \
	-p 9200:9200 \
	-e LOGSTASH_CONFIG_URL=https://raw.githubusercontent.com/ropensci/fishbaseapi/logging/logstash.conf \
	pblittle/docker-logstash

## First time use only
if [ ! -d "$HOME/data/fishbase" ]
then
  mkdir -p $HOME/data/fishbase
fi

## Start the mysql container
docker run --name fbmysql -d -v $HOME/data/fishbase:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=root mysql:latest

## Import the database if we don't have it.
## Assumes the database is called fbapp.sql and is in the working directory
if [ ! -e "$HOME/data/fishbase/fbapp" ]
then
  docker run --rm --link fbmysql:mysql \
    -v ${PWD}/fbapp.sql:/data/fbapp.sql \
    -v ${PWD}/mysql_import.sh:/data/mysql_import.sh \
    -w /data mysql bash mysql_import.sh 
fi

# Give the sql database a few seconds to start up first.
sleep 2

# Make sure we have the latest version
docker pull ropensci/fishbaseapi
# Or just build locally to get the latest version
# docker build -t ropensci/fishbaseapi:logging .

## Start fb app, but expose only the nginx port (port 80), not the unicorn port (8080)
docker run --name fbapi -d -p 80:80 --link fbmysql:mysql --link fbredis:redis --link fblogstash:logstash --volumes-from fblogstash ropensci/fishbaseapi:logging

## NOTE: Sever name must be hardwired into nginx.conf. Please adjust appropriately
docker run --name fbnginx -d --net container:fbapi -v $(pwd)/nginx.conf:/etc/nginx/nginx.conf nginx

