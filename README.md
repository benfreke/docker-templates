# docker-templates

A collection of Dockerfiles and Docker Compose files for easier local development. Do not use these in production without optimisation

## How to use

1. Make sure [Docker](https://docs.docker.com/) is installed on your macahine
1. Copy the entire `scripts` directory to your project
1. Copy the chosen docker-compose file (from the `compose` directory) to the root of your project, and rename it to `docker-compose.yml`
    1. The format of the filename is `docker-compose-<phpVersion>-<databaseType>.yml`
1. In your terminal, type the command `docker-compose up`

## Assumptions

1. Your path on the server will be `/var/www/html`
1. For XDebug to work, You have mapped `/var/www/html` to the root of your project
1. You add this to your query string when debugging on the frontend. `XDEBUG_SESSION_START=1&XDEBUG_IDE_KEY=docker`
1. You will add the needed variables to your `.env` 
1. You can read the `docker-compose.yml` file to understand what needs to be in the `.env` file
1. You will not use these in production 
1. You will only use these for Laravel. I'm sure they work for other projects but it is very heavily customised

## Folder structure

### compose

A collection of Docker Compose files, from which to choose the appropriate solution.

### scripts

The collection of various Dockerfiles that are useful to match the Docker Compose files.
