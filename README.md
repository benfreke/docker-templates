# docker-templates

A collection of Dockerfiles and docker-compose files for easier local development. Do not use these in production.

## Understanding the folder structure

All images in the dockerfiles directory are built in the namespace benfreke. 

The second level is the folder underneath the `dockerfiles` directory

Then the next directory is after the hyphen in the name.

e.g. benfreke/nginx-laravel or benfreke/php7.1-laravel

## Using the build file

./build folder1 folder2 tag e.g. `./build.sh php7.1 laravel 0.0.1`