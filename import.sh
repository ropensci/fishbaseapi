#!/bin/bash

## First time use only. Imports the latest fishbase data from an fbapp.sql dump

DATAPATH=$HOME/data/fishbase-dev
LOGPATH=$HOME/log/fishbase-dev


if [ ! -d "$DATAPATH" ]
then
  mkdir -p $DATAPATH
fi
if [ ! -d "$LOGPATH" ]
then
  mkdir -p $LOGPATH
fi

## Start the mysql container
docker run --name some-mysql -d -v $DATAPATH:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=root mysql:latest

## Import the database if we don't have it.
## Assumes the database is called fbapp.sql and is in the working dir 

## FIXME First set max_packet before running this: http://stackoverflow.com/questions/12425287/mysql-server-has-gone-away-when-importing-large-sql-file/26884290#26884290

#docker run -it --link some-mysql:mysql --rm -v ${PWD}/fbapp.sql:/fbapp.sql mysql sh -c 'exec mysql -h"$MYSQL_PORT_3306_TCP_ADDR" -P"$MYSQL_PORT_3306_TCP_PORT" -uroot -p"$MYSQL_ENV_MYSQL_ROOT_PASSWORD" --execute="CREATE DATABASE fbapp; SOURCE fbapp.sql;"'

## FIXME for some reason, not even this can run from the script, but it works just fine if you paste it into the commandline

docker run -it --link some-mysql:mysql --rm -v ${PWD}/fbapp.sql:/fbapp.sql mysql sh -c 'exec mysql -h"$MYSQL_PORT_3306_TCP_ADDR" -P"$MYSQL_PORT_3306_TCP_PORT" -uroot -p"$MYSQL_ENV_MYSQL_ROOT_PASSWORD"'

## FIXME now you still need to go and probably change permissions of $DATAPATH/fbapp dir/contents.  

docker stop some-mysql
docker rm some-mysql
