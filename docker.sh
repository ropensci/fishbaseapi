#!/bin/bash

# fig doesn't always act the way I expect. So this script does the same thing manually
# by just launching the three containers from the commandline.
# Note that ropensci/fishbaseapi is built by DockerHub automated build.


## Start the redis container
docker run --name fbredis -d redis:latest

## get etcd
# docker run --name fbetcd --rm -it -p 4001:4001 -p 7001:7001 -v /var/etcd/:/data microbox/etcd:latest
### official from etcd
# docker run -p 4001:4001 -v /usr/share/ca-certificates/:/etc/ssl/certs quay.io/coreos/etcd:v2.0.2


## Hmm, not clear why we aren't using linking here instead of exporting ports..
## get logstash and embeded elasticsearch
docker run --name fblogstash -d \
  -v ${PWD}:/data \
	-p 9292:9292 \
	-p 9200:9200 \
	pblittle/docker-logstash
	# -e LOGSTASH_CONFIG_URL=https://raw.githubusercontent.com/ropensci/fishbaseapi/logging/logstashconfig.conf \

# We use this dir for permanent storage of the database even if the MySQL container is killed.
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
# FIXME (Perhaps the api.rb could be convinced to re-attempt `Client.new` at intervals if the mysql server isn't there)
sleep 5

# Make sure we have the latest version
docker pull ropensci/fishbaseapi

# Start the API on port 4567
docker run --name fbapi -d -p 4567:4567 --link fbmysql:mysql --link fbredis:redis --link fblogstash:logstash -v ${PWD}:/data ropensci/fishbaseapi:logging

