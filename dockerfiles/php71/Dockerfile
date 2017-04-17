FROM php:7.1-fpm-alpine

# ensure www-data user exists
# ref: https://gist.github.com/briceburg/47131d8caf235334b6114954a6e64922
RUN set -x \
  addgroup -g 82 -S www-data \
  adduser -u 82 -D -S -G www-data www-data

# Install composer
RUN php -r "readfile('http://getcomposer.org/installer');" | php -- --install-dir=/usr/local/bin --filename=composer

# Now install our global composer packages
USER www-data
RUN composer global require hirak/prestissimo

# Switch back to the root user for other installation
USER root

# Add some extensions that we are always going to need
#RUN apk add libxml2
#RUN docker-php-ext-install mysqli pdo pdo_mysql mbstring tokenizer xml
#RUN docker-php-ext-install mysqli pdo pdo_mysql mbstring tokenizer

# Set the workdir to make it easier when entering
WORKDIR /var/www/html

USER www-data
