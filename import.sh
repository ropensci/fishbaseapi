#/bin/bash

## First time use only. Imports the latest fishbase data from an fbapp.sql dump

DATAPATH=$HOME/data/fishbase


if [ ! -d "$DATAPATH" ]
then
  mkdir -p $DATAPATH
fi

## Start the mysql container
docker run --name some-mysql -d -v $DATAPATH:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=root mysql:latest
docker run -it --link some-mysql:mysql --rm -v ${PWD}/fbapp.sql:/fbapp.sql mysql sh -c 'exec mysql -h"$MYSQL_PORT_3306_TCP_ADDR" -P"$MYSQL_PORT_3306_TCP_PORT" -uroot -p"$MYSQL_ENV_MYSQL_ROOT_PASSWORD" --execute="SET GLOBAL max_allowed_packet=2000000000; CREATE DATABASE fbapp; USE fbapp; SOURCE fbapp.sql;"'
docker rm -f some-mysql


DATAPATH2=$HOME/data/sealifebase
if [ ! -d "$DATAPATH2" ]
then
  mkdir -p $DATAPATH2
fi
docker run --name some-mysql -d -v $DATAPATH2:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=root mysql:latest
docker run -it --link some-mysql:mysql --rm -v ${PWD}/slbapp.sql:/slbapp.sql mysql sh -c 'exec mysql -h"$MYSQL_PORT_3306_TCP_ADDR" -P"$MYSQL_PORT_3306_TCP_PORT" -uroot -p"$MYSQL_ENV_MYSQL_ROOT_PASSWORD" --execute="SET GLOBAL max_allowed_packet=2000000000; CREATE DATABASE slbapp; USE slbapp; SOURCE slbapp.sql;"'
docker rm -f some-mysql

