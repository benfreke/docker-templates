# docker-templates

A collection of Dockerfiles and docker-compose files for easier local development. Do not use these in production without optimisation

## Assumptions

1. Your path on the server will be `/var/www/html`
1. For XDebug to work, You have mapped `/var/www/html` to the root of your Laravel project
1. You add this to your query string when debugging. `XDEBUG_SESSION_START=1&XDEBUG_IDE_KEY=docker`
1. You will add the needed variables to your `.env` 
1. You can read the `docker-compose.yml` file to understand what needs to be in the `.env` file
1. You will not use these in production 
1. You will only use these for Laravel. I'm sure they work for other projects but it is very heavily customised

## Folder structure

### compose

A large docker-compose file, from which to cherry pick sections

### dockerfiles

The collection of various dockerfiles that are useful

### scripts 

A collection of scripts that make starting and creating images easier

### stack 

A large docker-compose file, from which to cherry pick sections