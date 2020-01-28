#!/bin/sh

# Bootstrap the web container when running within docker-compose locally.
# This is called by the "command:" key in docker-compose.yml.

set -euo pipefail

source shared.sh

main () {
  echo 'Starting unit test suite'

  # Copy the scripts directory, which is referenced during the build
  # This is removed during cleanup
  cp -R ../scripts scripts

  # Test we have a valid config for the docker-compose files
  testComposeFiles

  echo 'Finished unit test suite'
}

testComposeFiles () {

  # Check that I have valid compose files for PHP versions
  for phpVersion in '73' '74' ; do
    testComposeFile $(getDockerComposeFilename $phpVersion)
    # Check the DB versions are also valid
    for dbType in 'mysql' 'pgsql' ; do
      testComposeFile $(getDockerComposeFilename $phpVersion $dbType)
    done
  done

}

# Test our compose files continue to work
testComposeFile () {
  # Copy the file
  cp "${1}" docker-compose.yml

  # Now make sure the config is good and only echo if something went wrong
  docker-compose config --quiet
}

# Always cleanup at the end
trap "cleanup" EXIT

main "$@"
