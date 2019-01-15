#!/bin/bash

apt-get update --no-install-recommends
apt-get install -y software-properties-common debconf-utils
add-apt-repository 'deb http://archive.ubuntu.com/ubuntu trusty universe'
apt-get update --no-install-recommends
export DEBIAN_FRONTEND="noninteractive"

source mysql-params.sh
echo "Installing MySql Server 5.6..." >&2
debconf-set-selections <<< "mysql-server-5.6 mysql-server/root_password password $MYSQL_ROOT_PASSWORD"
debconf-set-selections <<< "mysql-server-5.6 mysql-server/root_password_again password $MYSQL_ROOT_PASSWORD"
debconf-set-selections <<< 'mysql-server-5.6 mysql-server-5.6/start_on_boot boolean true'
apt install -y mysql-server-5.6
