#!/bin/bash

# Set some basic error checking
# e says to exit on first error
# u says to exit if an unnamed parameter is called
# o says to give the exit status of the last failed command, not the last executed command
set -euo pipefail

# My main function to call everyting
main() {

  ### Fix the filepath of the file we're checking
  CLIENT_FILE_TO_BE_CHECKED_FILEPATH=$(getClientFilepath "$1")
  # Now remove that argument from the list by shifting left
  shift

  ### Remove the $PWD from the filepath to the phpcs style file
  CLIENT_STANDARD_FILEPATH=$(getStandardFilepath "$1")
  # Now remove that argument from the list by shifting left
  shift

  # Now we can call Docker with the arguments we need changed filepaths for
  docker-compose exec -T web ./vendor/bin/phpcs "$CLIENT_FILE_TO_BE_CHECKED_FILEPATH" "$CLIENT_STANDARD_FILEPATH" "$@"
}

### Get the real path for the file we're checking. Yes this is a hack. ###
### The expected argument is the first bash parameter
getClientFilepath() {
  # Convert the string to remove the host specific path
  echo "$1" | cut -d "/" -f9-
}

##
 # PhpStorm provides the absolute path to the xml file
 # This is another hack, but since I know it is in the same directory as the calling script, replace
 # PWD with nothing to give the correct location in the docker container
getStandardFilepath() {
  # Add a / to the end of PWD
  SEARCH="$PWD/"

  echo ${1/${SEARCH}/''}
}

main "$@"

