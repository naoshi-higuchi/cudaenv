# cudaenv

## Description
cudaenv makes it easy to set up a Docker environment with CUDA plus a uv-managed Python toolchain. It installs uv, provisions the requested Python version, and activates a ready-to-use virtual environment so you can immediately focus on developing and running your CUDA applications.

## Prerequisites
- Docker
- NVIDIA Container Toolkit

## Installation

### Clone the repository

```sh
git clone https://github.com/naoshi-higuchi/cudaenv.git
cd cudaenv
```

### Modify config.sh
Modify `cudaenv/config.sh` if needed.

```sh
vim config.sh
```
> [!TIP]
> Edit `ENVNAME` and `PYTHON_VERSION` to control the uv virtual environment that will be created inside the container.

### Build your Docker image

```sh
sh docker_build.sh
```

### Modify run.sh
Modify `cudaenv/run.sh` if needed.

```sh
vim run.sh
```

> [!TIP]
> Edit `WORKDIR` and `VOLUME_MOUNT` for sharing files between the host and the container.


## Usage

```sh
sh run.sh
```

After attaching via SSH, the `${ENVNAME}` uv virtual environment activates automatically, so `python` and `pip` already point to the requested interpreter. Install additional packages with:

```sh
uv pip install <package>
```

To inspect available Python toolchains or install another minor version:

```sh
uv python list
```


## ssh

```sh
ssh -F .ssh_local/config localhost22022
```
