#!/bin/bash

# fig doesn't always act the way I expect. So this script does the same thing manually
# by just launching the three containers from the commandline.  
# Note that ropensci/fishbaseapi is built by DockerHub automated build. 


## Start the redis container
docker run --name fbredis -d redis:latest

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
    -w /data mysql mysql \
    --host=$MYSQL_PORT_3306_TCP_ADDR \
    --protocol=$MYSQL_PORT_3306_TCP_PROTO \
    --password=$MYSQL_ENV_MYSQL_ROOT_PASSWORD \
    fbapp < fbapp.sql
fi



# Give the sql database a few seconds to start up first. 
# FIXME (Perhaps the api.rb could be convinced to re-attempt `Client.new` at intervals if the mysql server isn't there)
sleep 5

# Make sure we have the latest version
docker pull ropensci/fishbaseapi

# Start the API on port 4567
docker run --name fbapi -d -p 4567:4567 --link fbmysql:mysql --link fbredis:redis ropensci/fishbaseapi

