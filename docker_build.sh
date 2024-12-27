#!/bin/bash

DIR=$(dirname $(realpath $0))
cd ${DIR}

. ${DIR}/config.sh

docker build \
  --build-arg USERNAME=${USERNAME} \
  --build-arg ENVNAME=${ENVNAME} \
  --build-arg PYTHON_VERSION=${PYTHON_VERSION} \
  --build-arg MINIFORGE_INSTALLER=${MINIFORGE_INSTALLER} \
  --build-arg MINIFORGE_URL=${MINIFORGE_URL} \
  -t cudaenv/dev:0.1 -f Dockerfile ./
