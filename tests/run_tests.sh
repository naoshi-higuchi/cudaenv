#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
cd "${REPO_ROOT}"

if ! command -v docker >/dev/null 2>&1; then
  echo "docker is required but not installed" >&2
  exit 1
fi

if ! command -v ssh >/dev/null 2>&1; then
  echo "ssh is required but not installed" >&2
  exit 1
fi

# Load config variables
set -a
# shellcheck disable=SC1091
. "${REPO_ROOT}/config.sh"
set +a

CONTAINER_NAME="cudaenv_test"
WORKDIR="${REPO_ROOT}/work"
VOLUME_MOUNT="${WORKDIR}:/home/${USERNAME}/work"
SSH_TARGET="localhost${SSH_PORT}"

mkdir -p "${WORKDIR}"

cleanup() {
  set +e
  docker rm -f "${CONTAINER_NAME}" >/dev/null 2>&1
}
trap cleanup EXIT

echo "[1/6] Building image..."
sh docker_build.sh

echo "[2/6] Starting test container..."
docker rm -f "${CONTAINER_NAME}" >/dev/null 2>&1 || true
docker run -d \
  --name "${CONTAINER_NAME}" \
  --gpus all \
  -p "${SSH_PORT}:22" \
  --volume "${VOLUME_MOUNT}" \
  cudaenv/dev:0.1 >/dev/null

echo "[3/6] Verifying container is running..."
for _ in $(seq 1 10); do
  if docker inspect -f '{{.State.Running}}' "${CONTAINER_NAME}" 2>/dev/null | grep -q true; then
    break
  fi
  sleep 1
done
docker inspect -f '{{.State.Running}}' "${CONTAINER_NAME}" | grep -q true

echo "[4/6] Testing SSH connectivity..."
ssh -F .ssh_local/config -o ConnectTimeout=10 "${SSH_TARGET}" whoami | grep -qx "${USERNAME}"

echo "[5/6] Testing uv and Python environment..."
docker exec "${CONTAINER_NAME}" uv --version
PY_PREFIX="$(docker exec "${CONTAINER_NAME}" bash -lc 'source ~/.bashrc && python -c "import sys; print(sys.prefix)"')"
echo "${PY_PREFIX}" | grep -q "/home/${USERNAME}/.venvs/${ENVNAME}"

echo "[6/6] Testing nvidia-smi..."
docker exec "${CONTAINER_NAME}" nvidia-smi >/dev/null

echo "All integration tests passed."
