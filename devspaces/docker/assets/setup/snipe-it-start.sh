#!/bin/bash

displayUsage() {
	echo "---------------------------------------------------------------------------"
	echo "Command usage: "
	echo "  ./snipe-it-start.sh <host> <port>"
	echo "---------------------------------------------------------------------------"
	exit 1
}
if [ "x$1" == "x" ] || [ "x$2" == "x" ] ; then
	displayUsage
fi
HOST=$1
PORT=$2
sed -i "s;#ServerName.*;ServerName $HOST;g" /etc/apache2/sites-available/000-default.conf
APP_URL="http://$HOST:$PORT"
sed -i "s;APP_URL=.*;APP_URL=$APP_URL;g" snipe-it-env.sh
pushd /data
if [ -d /var/www/html/vendor ]; then
  rm -rf vendor
  rm -rf .env
  cp -rf /var/www/html/vendor vendor
  cp -f /var/www/html/.env .env
  rm -rf /var/www/html
  chown -R docker:root .
  chown -R docker:staff vendor
fi
APP_KEY=$(php artisan key:generate --show)
popd
echo "Using APP_KEY '$APP_KEY'" >&2
sed -i "s;APP_KEY=.*;APP_KEY=$APP_KEY;g" snipe-it-env.sh
source snipe-it-env.sh
echo "Starting Apache2 Service in Background..." >&2
nohup "/entrypoint.sh" &> entrypoint.out &
echo "See logs for:"
echo "Apache Service in /var/log/apache2 folder" >&2
echo "Snipe-IT App in /data/storage/logs/" >&2
