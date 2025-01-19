#!/bin/bash

DIR=$(dirname $(realpath $0))
cd ${DIR}

. ${DIR}/config.sh

docker run -it --rm --gpus all --volume ${VOLUME_MOUNT} --name cudaenv cudaenv/dev:0.1 /bin/bash
