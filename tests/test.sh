#!/bin/sh

# Bootstrap the web container when running within docker-compose locally.
# This is called by the "command:" key in docker-compose.yml.

set -euo pipefail

main () {
  echo 'Starting test suite'

  testComposeFiles

  echo 'Finished test suite'
}

testComposeFiles () {

  # Check that I have valid compose files
  for phpVersion in '73' '74' ; do
    testComposeFile $phpVersion
    for dbType in 'mysql' 'pgsql' ; do
      testComposeFile $phpVersion $dbType
    done
  done

}

# Test our compose files continue to work
testComposeFile () {
  ENV_FILE_TO_COPY=''
  if [ $# -eq 2 ]; then
    ENV_FILE_TO_COPY=env-files/env-${2}.example
    COMPOSE_FILE_TO_COPY=compose/docker-compose-php${1}-${2}.yml
  else
    COMPOSE_FILE_TO_COPY=compose/docker-compose-php${1}.yml
  fi
  echo "$COMPOSE_FILE_TO_COPY"

  # Copy the file
  cp "$COMPOSE_FILE_TO_COPY" docker-compose.yml

  # Potentially copy to .env
  if [ ! -z "$ENV_FILE_TO_COPY" ]; then
    cp "$ENV_FILE_TO_COPY" .env
  fi

  # Now make sure the config is good
  docker-compose config --quiet

  # Clean up
  rm -f .env
  rm -f docker-compose.yml
}

main "$@"
