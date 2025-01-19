#!/bin/sh

USERNAME=$1
PASSWORD=$2
HOST_UID=$3
HOST_GID=$4

# Get the UID of the default user 'ubuntu' in the container.
UBUNTU_UID=$(id -u ubuntu)

# Note that the password must be hashed.
HASHED_PASSWORD=$(openssl passwd -6 ${PASSWORD})

if [ ${HOST_UID} = ${UBUNTU_UID} ]; then
  # HOST_UID conflicts with UBUNTU_UID.
  # Change the username of the default user 'ubuntu' to the desired username.
  echo "User ID is the same as the ubuntu user in the container"
  usermod -l ${USERNAME} --password ${HASHED_PASSWORD} -d /home/${USERNAME} -m ubuntu
else
  # Add a new user with the desired username.
  echo "User ID is different from the ubuntu user in the container"
  useradd -m -u ${HOST_UID} --password ${HASHED_PASSWORD} -g ${HOST_GID} --groups adm,sudo,audio,video ${USERNAME}
fi
