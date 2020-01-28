#!/bin/sh

getDockerComposeFilename () {
  if [ $# -eq 2 ]; then
    COMPOSE_FILE_TO_COPY=../compose/docker-compose-php${1}-${2}.yml
  else
    COMPOSE_FILE_TO_COPY=../compose/docker-compose-php${1}.yml
  fi

  echo "$COMPOSE_FILE_TO_COPY"
}

cleanup () {
  echo 'Removing all files'
  rm -rf scripts
  rm -f docker-compose.yml
}
