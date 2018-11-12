#!/usr/bin/env bash

# -rm remove intermediate containers (keeps host clean)
# -t tags the image name
# -f location of the dockerfile
# --target which stage to build (not shown)
# . The context (files sent to Docker for build).
docker build --rm -t benfreke/laravel-php72:latest -t benfreke/octobercms-php72:latest -f build/php/ .