# Copilot Instructions

## Overview

`cudaenv` is a Docker-based development environment setup tool that creates a container with CUDA, cuDNN, and a uv-managed Python toolchain. The container runs an SSH server so it can be accessed like a remote machine.

## Key Workflow

1. Edit `config.sh` to set environment name, Python version, and SSH port
2. Run `sh docker_build.sh` to build the image — this also generates `.scripts/entrypoint.sh` (from template) and SSH keys in `.ssh_local/`
3. Run `sh run.sh` to start the container
4. Connect via `ssh -F .ssh_local/config localhost22022`

## Architecture

- **`config.sh`** — single source of truth for all configuration variables (`ENVNAME`, `PYTHON_VERSION`, `USERNAME`, `HOST_UID`, `HOST_GID`, `SSH_PORT`). Sourced by all shell scripts.
- **`docker_build.sh`** — calls `envsubst` to render `.scripts/entrypoint_template.sh` → `.scripts/entrypoint.sh` (substitutes `$USERNAME`), then calls `.scripts/setup_ssh.sh` to regenerate SSH keys, then builds the Docker image passing all config as `--build-arg`.
- **`Dockerfile`** — base image is `nvidia/cuda:12.6.3-cudnn-runtime-ubuntu24.04`; user is created via `.scripts/adduser.sh` to match host UID/GID (avoids file permission issues on volume mounts); uv is installed per-user, a matching Python toolchain is provisioned, and the named virtual environment is activated by default in `.bashrc`.
- **`.scripts/entrypoint.sh`** — generated file (gitignored), not hand-edited. Edit `.scripts/entrypoint_template.sh` instead.
- **`.ssh_local/`** — generated directory containing `id`, `id.pub`, and `config`. The public key is baked into the image as `authorized_keys`.
- **`run.sh`** — mounts `./work` as `/home/$USERNAME/work` inside the container. Edit `WORKDIR` and `VOLUME_MOUNT` here to change the mount.

## Key Conventions

- All scripts `cd` to their own directory using `$(dirname $(realpath $0))` before sourcing `config.sh`, so they work regardless of where they are invoked from.
- `.scripts/entrypoint.sh` is gitignored (listed in `.scripts/.gitignore`) — always edit the `_template` variant.
- `.ssh_local/` contents are regenerated on every `docker_build.sh` run; do not hand-edit files there.
- The `adduser.sh` script handles a special case: if the host UID matches the default `ubuntu` user UID (1000) inside the container, it renames `ubuntu` rather than creating a new user.
- To pre-install Python packages in the image, add `uv pip install ...` lines after the virtual environment creation step in the `Dockerfile`.
- Image is tagged `cudaenv/dev:0.1`. Update this tag in both `docker_build.sh` and `run.sh` together when bumping versions.
