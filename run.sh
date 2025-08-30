#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
IMAGE_NAME="chatboxai-multi"
CONTAINER_NAME="chatboxai"
PORT="${PORT:-3000}"
TAG="${1:-latest}"

echo "🚀 Starting ChatBoxAI Container"
echo "   Image: ${IMAGE_NAME}:${TAG}"
echo "   Container: ${CONTAINER_NAME}"
echo "   Port: ${PORT}"
echo

cd "$SCRIPT_DIR"

echo "📋 Checking prerequisites..."

if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed or not in PATH"
    exit 1
fi

if ! docker image inspect "${IMAGE_NAME}:${TAG}" &> /dev/null; then
    echo "❌ Image ${IMAGE_NAME}:${TAG} not found"
    echo "   Please build the image first with: ./build.sh"
    exit 1
fi

echo "✅ Docker and image are available"

if docker ps -a --filter "name=${CONTAINER_NAME}" --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
    echo "🔄 Stopping and removing existing container..."
    docker stop "${CONTAINER_NAME}" &> /dev/null || true
    docker rm "${CONTAINER_NAME}" &> /dev/null || true
fi

echo "🔧 Checking Wayland environment..."
WAYLAND_SOCKET="/run/user/$(id -u)/wayland-0"
if [ ! -S "$WAYLAND_SOCKET" ]; then
    echo "⚠️  Wayland socket not found at $WAYLAND_SOCKET"
    echo "   The application may not display correctly"
    echo "   Make sure you're running on a Wayland session"
fi

echo "🐳 Starting container..."

docker run -d \
    --name "${CONTAINER_NAME}" \
    -p "${PORT}:3000" \
    -v "${WAYLAND_SOCKET}:/tmp/wayland-0" \
    -e WAYLAND_DISPLAY=wayland-0 \
    -e XDG_RUNTIME_DIR=/tmp \
    -e GDK_BACKEND=wayland \
    -e QT_QPA_PLATFORM=wayland \
    --security-opt no-new-privileges:true \
    --cap-drop=ALL \
    --cap-add=SETUID \
    --cap-add=SETGID \
    "${IMAGE_NAME}:${TAG}"

echo
echo "✅ Container started successfully!"
echo "   Container ID: $(docker ps -q --filter "name=${CONTAINER_NAME}")"
echo "   Port: http://localhost:${PORT}"
echo
echo "📊 Container status:"
docker ps --filter "name=${CONTAINER_NAME}"
echo
echo "📋 Useful commands:"
echo "   View logs:    docker logs ${CONTAINER_NAME}"
echo "   Stop:         docker stop ${CONTAINER_NAME}"
echo "   Restart:      docker restart ${CONTAINER_NAME}"
echo "   Shell:        docker exec -it ${CONTAINER_NAME} /bin/bash"