#!/bin/bash

DIR=$(dirname $(realpath $0))
cd ${DIR}

# Import USERNAME in the container
. ${DIR}/config.sh

# Working directory on the host (not in the container)
WORKDIR="./work"

# Volume mount for sharing files between the host and the container
VOLUME_MOUNT="${WORKDIR}:/home/${USERNAME}/work"

docker run -it --rm -p ${SSH_PORT}:22 --gpus all --volume ${VOLUME_MOUNT} --name cudaenv cudaenv/dev:0.1 /bin/bash
