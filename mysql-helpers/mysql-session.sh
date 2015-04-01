#!/bin/bash

## Start the mysql container if necessary, and then drop into an interactive MySQL session
CONTAINER=$(docker ps -a | grep "fbmysql" | cut -f1 -d" ") 

if [ -z "$CONTAINER" ]; then
  docker run --name fbmysql -d \
    -v $HOME/data/fishbase:/var/lib/mysql \
    -e MYSQL_ROOT_PASSWORD=root mysql:latest
fi

docker run --rm -ti --link fbmysql:mysql \
  -v ${PWD}/fbapp.sql:/data/fbapp.sql \
  -v ${PWD}/run-mysql:/data/run-mysql \
  -w /data \
  --entrypoint '/bin/bash' \
  mysql:latest run-mysql 
