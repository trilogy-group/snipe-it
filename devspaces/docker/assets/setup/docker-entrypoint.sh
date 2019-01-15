#!/bin/bash

echo "Starting MySql 5.6 Service...." >&2
/etc/init.d/mysql start
source /snipe-it-env.sh
mysql -e "CREATE DATABASE $MYSQL_DATABASE"
mysql -e "GRANT ALL PRIVILEGES ON *.* TO '$MYSQL_USER'@'localhost' IDENTIFIED BY '$MYSQL_PASSWORD'"
exec "$@"
