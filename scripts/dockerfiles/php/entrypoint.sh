#!/bin/sh

# Exit the script if there is an error
set -e

# switch to enable/disable xdebug
if [ "$XDEBUG_ENABLED" -eq "1" ]; then
    sed -i "s/xdebug\.remote_enable.*/xdebug\.remote_enable\=1/g" /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
else
    sed -i "s/xdebug\.remote_enable.*/xdebug\.remote_enable\=0/g" /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
fi

php /usr/local/bin/file-compare.php

php-fpm -F -R
