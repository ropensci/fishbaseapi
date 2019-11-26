#/bin/bash

## First time use only. Imports the latest fishbase data from an fbapp.sql dump

DATAPATH=$HOME/volume/data/fishbase

if [ ! -d "$DATAPATH" ]
then
  mkdir -p $DATAPATH
fi

## Start the mysql container
# docker run --name some-mysql -d -v $DATAPATH:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=root mysql:5.7
# docker run -it --link some-mysql:mysql --rm -v ${PWD}/fbapp.sql:/fbapp.sql mysql:5.7 sh -c 'exec mysql -h"$MYSQL_PORT_3306_TCP_ADDR" -P"$MYSQL_PORT_3306_TCP_PORT" -uroot -p"$MYSQL_ENV_MYSQL_ROOT_PASSWORD" --execute="SET GLOBAL max_allowed_packet=2000000000; CREATE DATABASE fbapp; USE fbapp; SOURCE fbapp.sql;"'
# docker rm -f some-mysql


DATAPATH2=$HOME/volume/data/sealifebase
if [ ! -d "$DATAPATH2" ]
then
  mkdir -p $DATAPATH2
fi
# SLBAPP, "2015_OR_2016" DOESN'T EXIST ANYMORE
# docker run --name some-mysql -d -v $HOME/volume/data/sealifebase:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=root mysql:5.7
# docker run -it --link some-mysql:mysql --rm -v ${PWD}/slbapp.sql:/slbapp.sql mysql:5.7 sh -c 'exec mysql -h"$MYSQL_PORT_3306_TCP_ADDR" -P"$MYSQL_PORT_3306_TCP_PORT" -uroot -p"$MYSQL_ENV_MYSQL_ROOT_PASSWORD" --execute="SET GLOBAL max_allowed_packet=2000000000; CREATE DATABASE slbapp; USE slbapp; SOURCE slbapp.sql;"'
# docker rm -f some-mysql


### LOAD DATA
docker run --name some-mysql -d -v $HOME/volume/data/fishbase:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=root mysql:5.7
docker run -it --link some-mysql:mysql --rm -v ${PWD}/fbapp.sql:/fbapp.sql mysql:5.7 sh -c 'exec mysql -h"$MYSQL_PORT_3306_TCP_ADDR" -P"$MYSQL_PORT_3306_TCP_PORT" -uroot -p"$MYSQL_ENV_MYSQL_ROOT_PASSWORD" --execute="DROP DATABASE fbapp;"'
docker run -it --link some-mysql:mysql --rm -v ${PWD}/fbapp.sql:/fbapp.sql mysql:5.7 sh -c 'exec mysql -h"$MYSQL_PORT_3306_TCP_ADDR" -P"$MYSQL_PORT_3306_TCP_PORT" -uroot -p"$MYSQL_ENV_MYSQL_ROOT_PASSWORD" --execute="SET GLOBAL max_allowed_packet=2,000,000,000 20,000,000; CREATE DATABASE fbapp; USE fbapp; SOURCE fbapp.sql;"'
docker rm -f some-mysql


## FISHBASE
# for previous fishbase database fbapp_201601
docker run --name some-mysql -d -v $HOME/volume/data/fishbase:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=root mysql:5.7
# docker run -it --link some-mysql:mysql --rm -v ${PWD}/fbapp_mirror_2016Jan_clean.sql:/fbapp_mirror_2016Jan_clean.sql mysql:5.7  sh -c 'exec mysql -h"$MYSQL_PORT_3306_TCP_ADDR" -P"$MYSQL_PORT_3306_TCP_PORT" -uroot -p"$MYSQL_ENV_MYSQL_ROOT_PASSWORD" --default-character-set=latin1 --execute="SET GLOBAL max_allowed_packet=10000000000; CREATE DATABASE fbapp_mirror; USE fbapp_mirror; SOURCE fbapp_mirror_2016Jan_clean.sql;"'
docker run -it --link some-mysql:mysql --rm -v ${PWD}/fbapp_mirror_2016Jan.sql:/fbapp_mirror_2016Jan.sql mysql:5.7  sh -c 'exec mysql -h"$MYSQL_PORT_3306_TCP_ADDR" -P"$MYSQL_PORT_3306_TCP_PORT" -uroot -p"$MYSQL_ENV_MYSQL_ROOT_PASSWORD" --default-character-set=latin1 --execute="SET GLOBAL max_allowed_packet=10000000000; CREATE DATABASE fbapp_mirror; USE fbapp_mirror; SOURCE fbapp_mirror_2016Jan.sql;"'

# for new fishbase database fbapp_201703
docker run --name some-mysql -d -v $HOME/volume/data/fishbase:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=root mysql:5.7
docker run -it --link some-mysql:mysql --rm -v ${PWD}/fbapp.sql:/fbapp.sql mysql:5.7 sh -c 'exec mysql -h"$MYSQL_PORT_3306_TCP_ADDR" -P"$MYSQL_PORT_3306_TCP_PORT" -uroot -p"$MYSQL_ENV_MYSQL_ROOT_PASSWORD" --execute="SET GLOBAL max_allowed_packet=2000000000; CREATE DATABASE fbapp_201703; USE fbapp_201703; SOURCE fbapp.sql;"'

# for new fishbase database fbapp_201712
docker run --name some-mysql -d -v $HOME/volume/data/fishbase:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=root mysql:5.7
docker run -it --link some-mysql:mysql --rm -v ${PWD}/fbapp.sql:/fbapp.sql mysql:5.7 sh -c 'exec mysql -h"$MYSQL_PORT_3306_TCP_ADDR" -P"$MYSQL_PORT_3306_TCP_PORT" -uroot -p"$MYSQL_ENV_MYSQL_ROOT_PASSWORD" --execute="SET GLOBAL max_allowed_packet=2000000000; CREATE DATABASE fbapp_201712; USE fbapp_201712; SOURCE fbapp.sql;"'

# for new fishbase database fbapp_201809
docker run --name some-mysql -d -v $HOME/volume/data/fishbase:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=root mysql:5.7
docker run -it --link some-mysql:mysql --rm -v ${PWD}/fbapp_9_24_2018.sql:/fbapp_9_24_2018.sql mysql:5.7 sh -c 'exec mysql -h"$MYSQL_PORT_3306_TCP_ADDR" -P"$MYSQL_PORT_3306_TCP_PORT" -uroot -p"$MYSQL_ENV_MYSQL_ROOT_PASSWORD" --execute="DROP DATABASE fbapp_201809;"'
docker run -it --link some-mysql:mysql --rm -v ${PWD}/fbapp_9_24_2018.sql:/fbapp_9_24_2018.sql mysql:5.7 sh -c 'exec mysql -h"$MYSQL_PORT_3306_TCP_ADDR" -P"$MYSQL_PORT_3306_TCP_PORT" -uroot -p"$MYSQL_ENV_MYSQL_ROOT_PASSWORD" --execute="SET GLOBAL max_allowed_packet=2000000000; CREATE DATABASE fbapp_201809; USE fbapp_201809; SOURCE fbapp_9_24_2018.sql;"'

# for Jan 2019 fishbase
sed -i 's/fbapp/fbapp_201901/g' fbapp10_2018.sql
docker run --name some-mysql -d -v $HOME/volume/data/fishbase:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=root mysql:5.7
docker run -it --link some-mysql:mysql --rm -v ${PWD}/fbapp10_2018.sql:/fbapp10_2018.sql mysql:5.7 sh -c 'exec mysql -h"$MYSQL_PORT_3306_TCP_ADDR" -P"$MYSQL_PORT_3306_TCP_PORT" -uroot -p"$MYSQL_ENV_MYSQL_ROOT_PASSWORD" --execute="DROP DATABASE fbapp_201901;"'
docker run -it --link some-mysql:mysql --rm -v ${PWD}/fbapp10_2018.sql:/fbapp10_2018.sql mysql:5.7 sh -c 'exec mysql -h"$MYSQL_PORT_3306_TCP_ADDR" -P"$MYSQL_PORT_3306_TCP_PORT" -uroot -p"$MYSQL_ENV_MYSQL_ROOT_PASSWORD" --execute="SET GLOBAL max_allowed_packet=2000000000; CREATE DATABASE fbapp_201901; USE fbapp_201901; SOURCE fbapp10_2018.sql;"'

# for Feb 2019 fishbase
sed -i 's/fbapp/fbapp_201902/g' fbapp02_2019.sql
docker run --name some-mysql -d -v $HOME/volume/data/fishbase:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=root mysql:5.7
docker run -it --link some-mysql:mysql --rm -v ${PWD}/fbapp02_2019.sql:/fbapp02_2019.sql mysql:5.7 sh -c 'exec mysql -h"$MYSQL_PORT_3306_TCP_ADDR" -P"$MYSQL_PORT_3306_TCP_PORT" -uroot -p"$MYSQL_ENV_MYSQL_ROOT_PASSWORD" --execute="DROP DATABASE fbapp_201902;"'
docker run -it --link some-mysql:mysql --rm -v ${PWD}/fbapp02_2019.sql:/fbapp02_2019.sql mysql:5.7 sh -c 'exec mysql -h"$MYSQL_PORT_3306_TCP_ADDR" -P"$MYSQL_PORT_3306_TCP_PORT" -uroot -p"$MYSQL_ENV_MYSQL_ROOT_PASSWORD" --execute="SET GLOBAL max_allowed_packet=2000000000; CREATE DATABASE fbapp_201902; USE fbapp_201902; SOURCE fbapp02_2019.sql;"'

# for Apr 2019 fishbase
mv fbapp.sql fbapp04_2019.sql
sed -i 's/fbapp/fbapp_201904/g' fbapp04_2019.sql
docker run --name some-mysql -d -v $HOME/volume/data/fishbase:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=root mysql:5.7
docker run -it --link some-mysql:mysql --rm -v ${PWD}/fbapp04_2019.sql:/fbapp04_2019.sql mysql:5.7 sh -c 'exec mysql -h"$MYSQL_PORT_3306_TCP_ADDR" -P"$MYSQL_PORT_3306_TCP_PORT" -uroot -p"$MYSQL_ENV_MYSQL_ROOT_PASSWORD" --execute="DROP DATABASE fbapp_201904;"'
docker run -it --link some-mysql:mysql --rm -v ${PWD}/fbapp04_2019.sql:/fbapp04_2019.sql mysql:5.7 sh -c 'exec mysql -h"$MYSQL_PORT_3306_TCP_ADDR" -P"$MYSQL_PORT_3306_TCP_PORT" -uroot -p"$MYSQL_ENV_MYSQL_ROOT_PASSWORD" --execute="SET GLOBAL max_allowed_packet=2000000000; CREATE DATABASE fbapp_201904; USE fbapp_201904; SOURCE fbapp04_2019.sql;"'

# for Aug 2019 fishbase
sed -i 's/fbapp/fbapp_201908/g' fbapp.sql
docker run --name some-mysql -d -v $HOME/volume/data/fishbase:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=root mysql:5.7
docker run -it --link some-mysql:mysql --rm -v ${PWD}/fbapp.sql:/fbapp.sql mysql:5.7 sh -c 'exec mysql -h"$MYSQL_PORT_3306_TCP_ADDR" -P"$MYSQL_PORT_3306_TCP_PORT" -uroot -p"$MYSQL_ENV_MYSQL_ROOT_PASSWORD" --execute="DROP DATABASE fbapp_201908;"'
docker run -it --link some-mysql:mysql --rm -v ${PWD}/fbapp.sql:/fbapp.sql mysql:5.7 sh -c 'exec mysql -h"$MYSQL_PORT_3306_TCP_ADDR" -P"$MYSQL_PORT_3306_TCP_PORT" -uroot -p"$MYSQL_ENV_MYSQL_ROOT_PASSWORD" --execute="SET GLOBAL max_allowed_packet=2000000000; CREATE DATABASE fbapp_201908; USE fbapp_201908; SOURCE fbapp.sql;"'




## SEALIFEBASE
# for sealifebase database slbapp_201712
docker run --name some-mysql -d -v $HOME/volume/data/sealifebase:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=root mysql:5.7
docker run -it --link some-mysql:mysql --rm -v ${PWD}/slbapp.sql:/slbapp.sql mysql:5.7 sh -c 'exec mysql -h"$MYSQL_PORT_3306_TCP_ADDR" -P"$MYSQL_PORT_3306_TCP_PORT" -uroot -p"$MYSQL_ENV_MYSQL_ROOT_PASSWORD" --execute="DROP DATABASE slbapp_201712;"'
docker run -it --link some-mysql:mysql --rm -v ${PWD}/slbapp.sql:/slbapp.sql mysql:5.7 sh -c 'exec mysql -h"$MYSQL_PORT_3306_TCP_ADDR" -P"$MYSQL_PORT_3306_TCP_PORT" -uroot -p"$MYSQL_ENV_MYSQL_ROOT_PASSWORD" --execute="SET GLOBAL max_allowed_packet=2000000000; CREATE DATABASE slbapp_201712; USE slbapp_201712; SOURCE slbapp.sql;"'

# for sealifebase database slbapp_201809
docker run --name some-mysql -d -v $HOME/volume/data/sealifebase:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=root mysql:5.7
docker run -it --link some-mysql:mysql --rm -v ${PWD}/slbapp.sql:/slbapp.sql mysql:5.7 sh -c 'exec mysql -h"$MYSQL_PORT_3306_TCP_ADDR" -P"$MYSQL_PORT_3306_TCP_PORT" -uroot -p"$MYSQL_ENV_MYSQL_ROOT_PASSWORD" --execute="DROP DATABASE slbapp_201809;"'
docker run -it --link some-mysql:mysql --rm -v ${PWD}/slbapp.sql:/slbapp.sql mysql:5.7 sh -c 'exec mysql -h"$MYSQL_PORT_3306_TCP_ADDR" -P"$MYSQL_PORT_3306_TCP_PORT" -uroot -p"$MYSQL_ENV_MYSQL_ROOT_PASSWORD" --execute="SET GLOBAL max_allowed_packet=2000000000; CREATE DATABASE slbapp_201809; USE slbapp_201809; SOURCE slbapp.sql;"'

# for Jan 2019 sealifebase
sed -i 's/slbapp/slbapp_201901/g' slbapp10_2018.sql
docker run --name some-mysql -d -v $HOME/volume/data/sealifebase:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=root mysql:5.7
docker run -it --link some-mysql:mysql --rm -v ${PWD}/slbapp10_2018.sql:/slbapp10_2018.sql mysql:5.7 sh -c 'exec mysql -h"$MYSQL_PORT_3306_TCP_ADDR" -P"$MYSQL_PORT_3306_TCP_PORT" -uroot -p"$MYSQL_ENV_MYSQL_ROOT_PASSWORD" --execute="DROP DATABASE slbapp_201901;"'
docker run -it --link some-mysql:mysql --rm -v ${PWD}/slbapp10_2018.sql:/slbapp10_2018.sql mysql:5.7 sh -c 'exec mysql -h"$MYSQL_PORT_3306_TCP_ADDR" -P"$MYSQL_PORT_3306_TCP_PORT" -uroot -p"$MYSQL_ENV_MYSQL_ROOT_PASSWORD" --execute="SET GLOBAL max_allowed_packet=2000000000; CREATE DATABASE slbapp_201901; USE slbapp_201901; SOURCE slbapp10_2018.sql;"'

# for Feb 2019 sealifebase
sed -i 's/slbapp/slbapp_201902/g' slbapp02_2019.sql
docker run --name some-mysql -d -v $HOME/volume/data/sealifebase:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=root mysql:5.7
docker run -it --link some-mysql:mysql --rm -v ${PWD}/slbapp02_2019.sql:/slbapp02_2019.sql mysql:5.7 sh -c 'exec mysql -h"$MYSQL_PORT_3306_TCP_ADDR" -P"$MYSQL_PORT_3306_TCP_PORT" -uroot -p"$MYSQL_ENV_MYSQL_ROOT_PASSWORD" --execute="DROP DATABASE slbapp_201902;"'
docker run -it --link some-mysql:mysql --rm -v ${PWD}/slbapp02_2019.sql:/slbapp02_2019.sql mysql:5.7 sh -c 'exec mysql -h"$MYSQL_PORT_3306_TCP_ADDR" -P"$MYSQL_PORT_3306_TCP_PORT" -uroot -p"$MYSQL_ENV_MYSQL_ROOT_PASSWORD" --execute="SET GLOBAL max_allowed_packet=2000000000; CREATE DATABASE slbapp_201902; USE slbapp_201902; SOURCE slbapp02_2019.sql;"'

# for Apr 2019 sealifebase
sed -i 's/slbapp/slbapp_201904/g' slbapp04_2019.sql
docker run --name some-mysql -d -v $HOME/volume/data/sealifebase:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=root mysql:5.7
docker run -it --link some-mysql:mysql --rm -v ${PWD}/slbapp04_2019.sql:/slbapp04_2019.sql mysql:5.7 sh -c 'exec mysql -h"$MYSQL_PORT_3306_TCP_ADDR" -P"$MYSQL_PORT_3306_TCP_PORT" -uroot -p"$MYSQL_ENV_MYSQL_ROOT_PASSWORD" --execute="DROP DATABASE slbapp_201904;"'
docker run -it --link some-mysql:mysql --rm -v ${PWD}/slbapp04_2019.sql:/slbapp04_2019.sql mysql:5.7 sh -c 'exec mysql -h"$MYSQL_PORT_3306_TCP_ADDR" -P"$MYSQL_PORT_3306_TCP_PORT" -uroot -p"$MYSQL_ENV_MYSQL_ROOT_PASSWORD" --execute="SET GLOBAL max_allowed_packet=2000000000; CREATE DATABASE slbapp_201904; USE slbapp_201904; SOURCE slbapp04_2019.sql;"'

# for Aug 2019 sealifebase
sed -i 's/slbapp/slbapp_201908/g' slbapp.sql
docker run --name some-mysql -d -v $HOME/volume/data/sealifebase:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=root mysql:5.7
docker run -it --link some-mysql:mysql --rm -v ${PWD}/slbapp.sql:/slbapp.sql mysql:5.7 sh -c 'exec mysql -h"$MYSQL_PORT_3306_TCP_ADDR" -P"$MYSQL_PORT_3306_TCP_PORT" -uroot -p"$MYSQL_ENV_MYSQL_ROOT_PASSWORD" --execute="DROP DATABASE slbapp_201908;"'
docker run -it --link some-mysql:mysql --rm -v ${PWD}/slbapp.sql:/slbapp.sql mysql:5.7 sh -c 'exec mysql -h"$MYSQL_PORT_3306_TCP_ADDR" -P"$MYSQL_PORT_3306_TCP_PORT" -uroot -p"$MYSQL_ENV_MYSQL_ROOT_PASSWORD" --execute="SET GLOBAL max_allowed_packet=2000000000; CREATE DATABASE slbapp_201908; USE slbapp_201908; SOURCE slbapp.sql;"'


