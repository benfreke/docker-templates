#!/usr/bin/env bash

if [ ! $# -eq 3 ]
  then
    echo "3 arguments required"
    echo "Directory 1 i.e. nginx"
    echo "Directory 2 i.e. laravel"
    echo "Tag i.e. 1.0"
    exit 1;
fi

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

docker build -t "benfreke/$1-$2:$3" -t benfreke/$1-$2:latest ./$1/$2
