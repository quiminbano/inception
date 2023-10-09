#!/bin/sh

#Creates the path /var/log/mysql if does not exists.
mkdir -p /var/log/mysql
chown -R mysql:mysql /var/log/mysql

#Creates the folder /run/mysqld if does not exits.
if [ ! -d "/run/mysqld" ]; then
	mkdir -p /run/mysqld
	chown -R mysql:mysql /run/mysqld
fi

#Gives the proper permissions to the path /var/lib/mysql if the folder mysql inside /var/log/mysql
#does not exits.
if [ ! -d "/var/lib/mysql/mysql" ]; then
	chown -R mysql:mysql /var/lib/mysql

	# init database
	echo "CREATING THE DATABASE TABLES."
	mysql_install_db --basedir=/usr --datadir=/var/lib/mysql --user=mysql --rpm > /dev/null
	echo "DATABASE TABLES CREATED."

	#Start mysqld service and setup the information written down as input for mariadb (mysql)
	echo "SETTING UP A USER IN THE DATABASE."
	mysqld --bootstrap --datadir=/var/lib/mysql --user=mysql << EOF 
USE mysql;
FLUSH PRIVILEGES;
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';

CREATE DATABASE ${MYSQL_DATABASE} CHARACTER SET utf8 COLLATE utf8_general_ci;
CREATE USER '${MYSQL_USER}'@'%' IDENTIFIED by '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';

FLUSH PRIVILEGES;
EOF
	echo "USER CREATED."
fi

#Starts mariadb
echo "RUNNING MARIADB."
mysqld_safe