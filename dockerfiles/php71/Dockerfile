FROM php:7.1-alpine

# Install composer
RUN php -r "readfile('http://getcomposer.org/installer');" | php -- --install-dir=/usr/bin/ --filename=composer

# Set the workdir to where we need it to be
WORKDIR /var/www/html

# Ensure we have an interactive shell
CMD ["/bin/sh", "-c"]
