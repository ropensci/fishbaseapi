FROM debian:testing 

RUN apt-get update \
  && apt-get install -y \
      bundler \
      ca-certificates \
      git \
      libmysqlclient-dev \
      ruby \
  && git clone https://github.com/ropensci/fishbaseapi.git /root/sinatra \
  && cd /root/sinatra \
  && bundle install

EXPOSE 4567

CMD ["/usr/local/bin/foreman","start","-d","/root/sinatra"]
