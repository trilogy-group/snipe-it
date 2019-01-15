#!/bin/bash

source mysql-params.sh
echo '[mysqld]' >> /etc/mysql/conf.d/mysql.cnf
echo 'bind-address=0.0.0.0' >> /etc/mysql/conf.d/mysql.cnf
cat > ~/.my.cnf <<EOF
[mysql]
user=root
password=$MYSQL_ROOT_PASSWORD
EOF
chmod 400 ~/.my.cnf
sed -i "s;<Directory /var/www/>;<Directory /data/>;g" /etc/apache2/apache2.conf
for file in /etc/apache2/sites-available/000-default.conf /entrypoint.sh
do
    sed -i "s;/var/www/html;/data;g" $file
done
cat mysql-params.sh mail-params.sh snipe-it-settings.sh > /snipe-it-env.sh
chmod +x snipe-it-start.sh
mv snipe-it-start.sh /
chmod +x docker-entrypoint.sh
mv docker-entrypoint.sh /
