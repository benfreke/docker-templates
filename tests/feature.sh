#!/bin/sh

# Bootstrap the web container when running within docker-compose locally.
# This is called by the "command:" key in docker-compose.yml.

set -euo pipefail

source shared.sh

main () {
  echo 'Starting features test suite'

  testComposeFiles
  cleanup

  echo 'Finished features test suite'
}

cleanup () {
  echo 'Removing all files'
  rm -rf scripts
  rm -f docker-compose.yml
}

testComposeFiles () {

  # Check that I have valid compose files for PHP versions
  for phpVersion in '73' '74' ; do
    testComposeFile $(getDockerComposeFilename $phpVersion)
    # Check the DB versions are also valid
    for dbType in 'mysql' 'pgsql' ; do
      testComposeFile $(getDockerComposeFilename $phpVersion $dbType) $dbType
    done
  done

}

# Test our compose files continue to work
testComposeFile () {
  # Copy the file
  cp "${1}" docker-compose.yml

  if [ $# -eq 2 ]; then
    cp ../env-files/env-${2}.example .env
  fi

  # Make sure the build works
  docker-compose build php

  # Now make sure the config is good and only echo if something went wrong
  docker-compose config --quiet
}

main "$@"
