#!/bin/sh

# turn off xdebug if we don't want it
if [ "$XDEBUG_ENABLED" -eq "1" ]; then
    sed -i "s/xdebug\.remote_enable.*/xdebug\.remote_enable\=1/g" /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
else
    sed -i "s/xdebug\.remote_enable.*/xdebug\.remote_enable\=0/g" /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
fi

SAME=$(php -r 'echo count(array_diff_key(parse_ini_file("/var/www/html/.env", false, INI_SCANNER_RAW),  parse_ini_file("/var/www/html/.env.example", false, INI_SCANNER_RAW))) ? "0" : "1";')

# run PHP-FPM in the foreground, as root
if [ "$SAME" -eq "1" ]; then
    php-fpm -F -R
else
    echo 'Not starting due to missing options in .env.example file'
fi