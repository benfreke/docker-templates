#!/bin/sh

# Bootstrap the web container when running within docker-compose locally.
# This is called by the "command:" key in docker-compose.yml.

set -euo pipefail

source unit.sh
#source feature.sh
