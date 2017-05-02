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
RUN composer global require hirak/prestissimo \
	&& composer clear-cache

# Switch back to the root user for other installation
USER root

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
        pdo_pgsql \
        intl \
        pdo_mysql \
        mbstring \
        tokenizer \
        zip


#RUN apk add --no-cache libpng \
#	libpng-dev \
#	libjpeg-turbo-dev \
#	libwebp-dev \
#	zlib-dev \
#	libxpm-dev \
#	&& docker-php-ext-install -j$(nproc) mysqli pdo pdo_mysql mbstring tokenizer zip \
#	&& docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
#	&& docker-php-ext-install -j$(nproc) gd
#	 && apk del libpng-devgd libjpeg-turbo-dev libwebp-dev zlib-dev libxpm-dev

# Now clean the cache to reduce final size
#RUN rm /var/cache/apk/*

# Set the workdir to make it easier when entering
WORKDIR /var/www/html

# Set the metadata
LABEL maintainer "Ben Freke (github.com/benfreke)"

USER www-data
