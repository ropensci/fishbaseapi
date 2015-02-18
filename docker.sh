#!/bin/bash
docker rm -f fbredis fbmysql fbapi fblogstash fbnginx

docker run --name fbredis -d redis:latest
docker run --name fblogstash -d \
  -v /root \
	-p 9292:9292 \
	-p 9200:9200 \
	-e LOGSTASH_CONFIG_URL=https://raw.githubusercontent.com/ropensci/fishbaseapi/master/logstash.conf \
	pblittle/docker-logstash

docker run --name fbmysql --restart=always -d -v $HOME/data/fishbase:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=root mysql:latest
docker build -t  ropensci/fishbaseapi:latest .

docker run --name fbapi -d --link fbmysql:mysql --link fbredis:redis --volumes-from fblogstash ropensci/fishbaseapi:latest
docker run --name fbnginx -d -p 80:80 --link fbapi:api -v ${PWD}/nginx.conf:/etc/nginx/nginx.conf nginx:latest

