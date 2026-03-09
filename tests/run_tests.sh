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

if ! command -v python3 >/dev/null 2>&1; then
  echo "python3 is required but not installed" >&2
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
HOST_SSH_PORT=$(python3 - <<'PY'
import socket
with socket.socket() as sock:
    sock.bind(('', 0))
    print(sock.getsockname()[1])
PY
)

mkdir -p "${WORKDIR}"

cleanup() {
  set +e
  docker rm -f "${CONTAINER_NAME}" >/dev/null 2>&1
}
trap cleanup EXIT

echo "[1/6] Building image..."
sh docker_build.sh

echo "[2/6] Starting test container on SSH port ${HOST_SSH_PORT}..."
docker rm -f "${CONTAINER_NAME}" >/dev/null 2>&1 || true
docker run -dit \
  --name "${CONTAINER_NAME}" \
  --gpus all \
  -p "127.0.0.1:${HOST_SSH_PORT}:22" \
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
ssh -i .ssh_local/id \
  -o StrictHostKeyChecking=no \
  -o UserKnownHostsFile=/dev/null \
  -o ConnectTimeout=10 \
  -p "${HOST_SSH_PORT}" \
  "${USERNAME}@localhost" whoami | grep -qx "${USERNAME}"

echo "[5/6] Testing uv and Python environment..."
docker exec --user "${USERNAME}" "${CONTAINER_NAME}" uv --version
PY_PREFIX=$(docker exec --user "${USERNAME}" "${CONTAINER_NAME}" bash -lc "source ~/.venvs/${ENVNAME}/bin/activate && python -c 'import sys; print(sys.prefix)'")
echo "${PY_PREFIX}" | grep -q "/home/${USERNAME}/.venvs/${ENVNAME}"

echo "[6/6] Testing nvidia-smi..."
docker exec "${CONTAINER_NAME}" nvidia-smi >/dev/null

echo "All integration tests passed."
