FROM php:7.1-fpm-alpine

# Set as a non-root user
RUN adduser -S phpimage
USER phpimage

# Install composer and parallel downloads package
RUN php -r "readfile('http://getcomposer.org/installer');" | php -- --install-dir=/usr/bin/ --filename=composer
RUN composer global require hirak/prestissimo

# Set the workdir to where we need it to be
RUN mkdir -p /var/www/html
WORKDIR /var/www/html
