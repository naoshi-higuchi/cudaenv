#!/bin/bash

DIR=$(dirname $(realpath $0))
cd ${DIR}

docker container prune -f
docker image prune -f
