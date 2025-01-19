# cudaenv

## Description
cudaenv makes it easy to set up a Docker environment with CUDA and Miniconda (Miniforge3). It handles the installation and configuration, so you can focus on developing and running your CUDA applications.

## Installation

### Clone the repository

```sh
git clone https://github.com/yourusername/cudaenv.git
cd cudaenv
```

### Update config.sh
Update cudaenv/config.sh for your needs.

```sh
vim config.sh
```

### Build your docker image.

```sh
sh docker_build.sh
```

## Usage

```sh
sh run.sh
```