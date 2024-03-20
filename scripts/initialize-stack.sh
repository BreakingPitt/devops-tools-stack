#!/usr/bin/env bash

set -o errexit
set -o pipefail

COMPOSE_DIR="./"
COMPOSE_MSG="Error: Docker Compose is not installed. Please install Docker Compose before running this script."
DOCKER_MSG="Error: Docker is not installed. Please install Docker before running this script."
FAILURE_MSG="Error: Failed to bring up the DevOps stack. Please check the logs for more details."
SUCCESS_MSG="The DevOps stack has been brought up successfully."
USAGE_MSG="Usage: $0 [OPTIONS]
Options:
  -d, --directory    Specify the directory containing the docker-compose.yml file
  -h, --help         Display this help message"

deploy() {
    docker compose up -d
    if [ $? -eq 0 ]; then
        echo "$SUCCESS_MSG"
    else
        echo "$FAILURE_MSG" >&2
        exit 1
    fi
}

usage() {
    echo "$USAGE_MSG"
    exit 1
}


while [[ $# -gt 0 ]]; do
    case $1 in
        -d|--directory)
            COMPOSE_DIR="$2"
            shift
            ;;
        -h|--help)
            usage
            ;;
        *)
            usage
            ;;
    esac
    shift
done

if ! [ -x "$(command -v docker)" ]; then
  echo "$DOCKER_MSG" >&2
  exit 1
fi

if ! [ -x "$(command -v docker-compose)" ]; then
  echo "$COMPOSE_MSG" >&2
  exit 1
fi

pushd  "$COMPOSE_DIR" || exit
   deploy

   if [ $? -eq 0 ]; then
      echo "$SUCCESS_MSG"
   else
      echo "$FAILURE_MSG" >&2
      exit 1
   fi
popd

exit 0

