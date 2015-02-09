#!/bin/bash

# fig doesn't always act the way I expect. So this script does the same thing manually
# by just launching the three containers from the commandline.  
# Note that ropensci/fishbaseapi is built by DockerHub auotmated build. 

docker run --name fbredis -d redis:latest

docker run --name fbmysql -d -v /home/cboettig/data/fishbase:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=root mysql:latest

# Give the sql database a few seconds to start up first. 
# Perhaps the api.rb could be convinced to re-attempt `Client.new` at intervals if the mysql server isn't there
sleep 5

# Make sure we have the latest version
docker pull ropensci/rfishbaseapi
docker run --name fbapi -d -p 4567:4567 --link fbmysql:mysql --link fbredis:redis ropensci/fishbaseapi

