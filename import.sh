#!/bin/bash
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


docker stop fbmysql
docker rm fbmysql
