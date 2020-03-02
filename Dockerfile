FROM ruby:2.7.0

COPY . /opt/sinatra
RUN cd /opt/sinatra \
  && bundle install
EXPOSE 8888

WORKDIR /opt/sinatra
CMD ["unicorn", "-d", "-c", "unicorn.conf"]
