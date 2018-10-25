FROM php:7.2-fpm-alpine as base

# Set the metadata
LABEL maintainer="Ben Freke (github.com/benfreke)"

# Add some extensions that we are always going to need
# Install into alpine what we need to support the install
# Install using the PHP supported tools
# Finally remove cache folder (just in case, it should have been removed already)
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

# Set the workdir to make it easier when entering
WORKDIR /var/www/html

COPY php-fpm.conf /etc/php/7.2/fpm/php-fpm.conf

ENTRYPOINT ["php-fpm", "-F", "-R"]

FROM base as development
RUN apk add --no-cache --virtual .build-deps \
        autoconf \
        gcc \
        coreutils \
        g++ \
        make \
        git \
    && NPROC=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || 1) \
    && docker-php-ext-install -j${NPROC} \
        zip \
    && pecl install xdebug \
    && docker-php-ext-enable xdebug

# Install composer (taken from composer dockerfile)
ENV COMPOSER_ALLOW_SUPERUSER 1
ENV COMPOSER_HOME /tmp
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

COPY xdebug.ini /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN chmod 777 /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

# The entrypoint will set up xdebug if needed
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
RUN chmod 777 /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

# Install the very handy tool to get multiple packages at the same time
RUN composer global require hirak/prestissimo