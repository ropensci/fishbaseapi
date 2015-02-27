#!/bin/bash

docker rm -f -v fbredis fbmysql fbapi fblogstash fbnginx fbgeoip
docker run --name fbredis -d redis:latest
docker run --name fblogstash -d \
  -v /var/log/fishbase \
  -v ${PWD}/logstashconf:/opt/logstash/conf.d \
	pblittle/docker-logstash
## ##  -e LOGSTASH_CONFIG_URL=https://raw.githubusercontent.com/ropensci/fishbaseapi/master/logstash.conf \

docker run --name fbmysql --restart=always -d -v $HOME/data/fishbase:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=root mysql:latest
docker build -t  ropensci/fishbaseapi:latest .

docker run --name fbgeoip -d allingeek/docker-freegeoip

docker run --name fbapi -d --link fbmysql:mysql --link fbredis:redis --link fbgeoip:geoip --volumes-from fblogstash ropensci/fishbaseapi:latest

# Must generate a .htpassword file first:
# assuming apache2-utils is installed: sudo htpasswd -cb .htpasswd $USER $PASSWORD

docker run --name fbnginx -d -p 80:80 --link fblogstash:logstash --link fbapi:api -v ${PWD}/nginx.conf:/etc/nginx/nginx.conf -v ${PWD}/.htpasswd:/etc/nginx/.htpasswd nginx:latest

