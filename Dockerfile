# Run the mysql database first: (password can be anything):
#    docker run --name some-mysql -e MYSQL_ROOT_PASSWORD=mysecretpassword -d -v /local/path:/var/lib/mysql mysql
#
# First time only: Import the database (replace /path/to/fbapp.sql with your local path!):
#    docker run --rm -ti --link mysql:mysql -v /path/to/fbapp.sql:/data/fbapp.sql -w /data mysql \
#    mysql --host=$MYSQL_PORT_3306_TCP_ADDR --protocol=$MYSQL_PORT_3306_TCP_PROTO --password=$MYSQL_ENV_MYSQL_ROOT_PASSWORD fbapp < fbapp.sql
#
# Now, build and run this container, linking to the database:
#    docker build -t ropensci/rfishbase
#    docker run -d -p 4567:4567 --link mysql:mysql --link fbredis:redis ropensci/rfishbase
#

FROM debian:testing

RUN apt-get update \
  && apt-get install -y \
      bundler \
      libmysqlclient-dev \
      ruby

COPY . /opt/sinatra

RUN cd /opt/sinatra \
  && bundle install

EXPOSE 4567


WORKDIR /opt/sinatra
CMD ["unicorn","-d","-c", "unicorn.conf"]

# CMD ["ruby", "/opt/sinatra/api.rb", "-o", "0.0.0.0"]
