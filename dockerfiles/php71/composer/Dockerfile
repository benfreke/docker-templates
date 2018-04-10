FROM composer:latest as composer

FROM php:7.1-cli-alpine

# ensure www-data user exists
# ref: https://gist.github.com/briceburg/47131d8caf235334b6114954a6e64922
RUN set -x \
  addgroup -g 82 -S www-data \
  adduser -u 82 -D -S -G www-data www-data

COPY --from=composer /usr/bin/composer /usr/bin/composer

WORKDIR /app

COPY --from=composer /docker-entrypoint.sh /docker-entrypoint.sh

# Set the metadata
LABEL maintainer="Ben Freke (github.com/benfreke)"

ENTRYPOINT ["sh", "/docker-entrypoint.sh"]

CMD ["composer"]