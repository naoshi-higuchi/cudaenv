# Configuration file for the docker image

# Working directory on the host (not in the container)
WORKDIR="./work"

# Username and password for the user in the container
USERNAME=$(whoami)
PASSWORD=${USERNAME}

# User ID and group ID of the host user
# These values are used to create a user in the container with the same user ID and group ID.
# This is useful for sharing files between the host and the container.
HOST_UID=$(id -u)
HOST_GID=$(id -g)

# Volume mount for sharing files between the host and the container
VOLUME_MOUNT="${WORKDIR}:/home/${USERNAME}/work"

# Conda environment name and Python version
ENVNAME=cuda
PYTHON_VERSION=3.12

# Miniforge installer
MINIFORGE_INSTALLER=Miniforge3-$(uname)-$(uname -m).sh
MINIFORGE_URL=https://github.com/conda-forge/miniforge/releases/latest/download/${MINIFORGE_INSTALLER}
