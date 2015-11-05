#!/bin/bash

# Remove any versions of running containers first
docker rm -fv fbredis fbapi

# Grab latest and start redis
docker pull redis:latest
docker run --name fbredis -dP redis:latest

# Build and run the API image and link redis
docker build -t ropensci/fishbaseapi:latest .
docker run --name fbapi -dP --link fbredis:redis ropensci/fishbaseapi:latest

# Get the API host:port, then
host=$(command -v docker-machine > /dev/null && echo `docker-machine ip default` || echo "localhost")
port=`docker port fbapi 8888`
url="http://$host:${port:8}"

# Open the heartbeat page if able
if command -v open > /dev/null; then
  open "$url/heartbeat"
elif command -v xdg-open > /dev/null; then
  xdg-open "$url/heartbeat"
else
  echo "Open $url in your browser of choice"
fi
