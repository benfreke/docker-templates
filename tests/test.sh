#!/bin/bash

# Bootstrap the web container when running within docker-compose locally.
# This is called by the "command:" key in docker-compose.yml.

set -euo pipefail

main () {
  echo 'Starting test suite'

  # Check that I have valid compose files
  for phpVersion in '73' '74' ; do
#    echo docker-compose-php${phpVersion}.yml
    cp compose/docker-compose-php${phpVersion}.yml docker-compose.yml
    docker-compose config --quiet
    # Now test the other db versions
    for dbType in 'mysql' 'pgsql' ; do
      # Copy the correct env file at this point
      cp compose/docker-compose-php${phpVersion}-${dbType}.yml docker-compose.yml
      docker-compose config --quiet
    done
  done
  rm docker-compose.yml
  echo 'Finished test suite'
}

main "$@"
