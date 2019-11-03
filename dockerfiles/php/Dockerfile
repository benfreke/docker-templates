# This stage is my base PHP image. It does not have composer, etc, as they are not needed for all PHP
FROM php:7.3.11-fpm-alpine as application-base

# Set the metadata
LABEL maintainer="Ben Freke (github.com/benfreke)"

# Add some extensions that we are always going to need
# Install into alpine what we need to support the install
# This is split into build dependencies, and the libraries that actually required
# `docker-php-ext-configure` to use the php docker tools to configure GD
# `--no-cache` to remove cache folders
RUN apk add --no-cache --virtual .build-deps \
        freetype-dev \
        libjpeg-turbo-dev \
        postgresql-dev \
        libpng-dev \
        icu-dev \
    && apk add --no-cache --virtual .required-deps \
        freetype \
        libjpeg-turbo \
        postgresql \
        libpng \
        icu-libs \
    && docker-php-ext-configure gd \
        --with-gd \
        --with-freetype-dir=/usr/include/ \
        --with-png-dir=/usr/include/ \
        --with-jpeg-dir=/usr/include/ \
    && NPROC=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || 1) \
    && docker-php-ext-install -j${NPROC} \
        gd \
        mysqli \
        opcache \
        intl \
        pdo_pgsql \
        pdo_mysql \
        mbstring \
        tokenizer

# Get a working php-fpm
# This is correct for PHP7.3 only
COPY php-fpm-73.conf /etc/php/7.3/fpm/php-fpm.conf

# Install composer (taken from composer dockerfile)
# You may want to do a `docker pull composer:latest before building this dockerfile
ENV COMPOSER_HOME /tmp
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Create a group and user so we're not running as root always
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Tell docker that all future commands should run as the appuser we just created
USER appuser

# Run PHP in the foreground so the container continues to run
# -F run in the foreground
# -R allow php-fpm to run as root
ENTRYPOINT ["php-fpm", "-F", "-R"]

# This is my development image. We add xdebug because it is awesome
FROM application-base as development

USER root

RUN apk add --no-cache --virtual .xdebug-deps \
        autoconf \
        coreutils \
        g++ \
        gcc \
        git \
        make \
        libzip-dev \
    && docker-php-ext-install \
        zip \
    && pecl install xdebug \
    && docker-php-ext-enable xdebug

# Copy xdebug and ensure we can use it
COPY xdebug.ini /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
# Obviously don't use 777 in production
RUN chmod 777 /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN chmod 777 /usr/local/etc/php/conf.d

# The entrypoint will set up xdebug based on the flag and ensure the we have the right number of values in .env files
# Modify this entrypoint as needed
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
RUN chmod 777 /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
WORKDIR /var/www/html

# Set the user to not be root now we've installed everything
USER appuser
