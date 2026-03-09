# Configuration file for the docker image

# uv virtual environment name and Python version
ENVNAME=cuda
PYTHON_VERSION=3.12

# Username and password for the user in the container
USERNAME=$(whoami)
PASSWORD=${USERNAME}

# User ID and group ID of the host user
# These values are used to create a user in the container with the same user ID and group ID.
# This is useful for sharing files between the host and the container.
HOST_UID=$(id -u)
HOST_GID=$(id -g)

# uv installer
UV_VERSION=v0.4.30
UV_INSTALL_URL=https://astral.sh/uv/install.sh

# SSH config
SSH_PORT=22022
