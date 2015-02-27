docker run --name logstash -d \
  -p 9292:9292 \
  -e ES_HOST=localhost\
  -e LOGSTASH_CONFIG_URL=https://raw.githubusercontent.com/ropensci/fishbaseapi/logstash/logstashconf/logstash.conf\
  pblittle/docker-logstash

