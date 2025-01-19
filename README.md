# cudaenv

## Description
cudaenv makes it easy to set up a Docker environment with CUDA and Miniconda (Miniforge3). It handles the installation and configuration, so you can focus on developing and running your CUDA applications.

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
> Edit `ENVNAME` and `PYTHON_VERSION` for your conda environment.

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
