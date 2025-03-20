#!/bin/bash

DIR=$(dirname $(realpath $0))
cd ${DIR}

. ${DIR}/config.sh

export USERNAME
envsubst < .scripts/entrypoint_template.sh > .scripts/entrypoint.sh

sh .scripts/setup_ssh.sh

docker build \
  --build-arg USERNAME=${USERNAME} \
  --build-arg PASSWORD=${PASSWORD} \
  --build-arg HOST_UID=${HOST_UID} \
  --build-arg HOST_GID=${HOST_GID} \
  --build-arg ENVNAME=${ENVNAME} \
  --build-arg PYTHON_VERSION=${PYTHON_VERSION} \
  --build-arg MINIFORGE_INSTALLER=${MINIFORGE_INSTALLER} \
  --build-arg MINIFORGE_URL=${MINIFORGE_URL} \
  -t cudaenv/dev:0.1 -f Dockerfile ./
