mysql -uroot --default-character-set=utf8 --execute="SET GLOBAL max_allowed_packet=2000000000; CREATE DATABASE fbapp_mirror; USE fbapp_mirror; SOURCE fbapp_mirror_2016Jan_clean.sql;"



mysql -uroot --default-character-set=utf8 --execute="SET GLOBAL max_allowed_packet=2000000000; CREATE DATABASE fbapp_mirror; USE fbapp_mirror; SOURCE fbapp_mirror_2016Jan.sql;"



# April 2017 work
mysql -uroot --default-character-set=utf8 --execute="SET GLOBAL max_allowed_packet=2000000000; CREATE DATABASE fbapp; USE fbapp; SOURCE fbapp.sql;"
