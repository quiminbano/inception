#!/bin/sh

#Creates the folder /run/mysqld if does not exits.
if [ ! -d "/run/mysqld" ]; then
	mkdir -p /run/mysqld
	chown -R mysql:mysql /run/mysqld
fi

#Creates the path /var/log/mysql if does not exists.
mkdir -p /var/log/mysql
chown -R mysql:mysql /var/log/mysql

#Gives the proper permissions to the path /var/lib/mysql if the folder mysql inside /var/log/mysql
#does not exits.
if [ ! -d "/var/lib/mysql/mysql" ]; then
	chown -R mysql:mysql /var/lib/mysql
fi

# init database
mysql_install_db --basedir=/usr --datadir=/var/lib/mysql --user=mysql --rpm > /dev/null
