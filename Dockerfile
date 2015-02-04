FROM debian:testing 

RUN apt-get update \
  && apt-get install -y \
      bundler \
      libmysqlclient-dev \
      ruby

COPY . /root/sinatra

RUN cd /root/sinatra \
  && bundle install

EXPOSE 4567

CMD ["ruby", "/root/sinatra/api.rb"]
