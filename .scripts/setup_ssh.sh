#!/bin/bash

DIR=$(dirname $(realpath $0))/..
cd ${DIR}

# Import configuration
. ${DIR}/config.sh

rm -f ${DIR}/.ssh_local/*
ssh-keygen -f ${DIR}/.ssh_local/id -N "" -q -t rsa

cat > .ssh_local/config <<EOF
Host localhost${SSH_PORT}
  HostName localhost
  Port ${SSH_PORT}
  User ${USERNAME}
  IdentityFile ${DIR}/.ssh_local/id
  StrictHostKeyChecking no
EOF
