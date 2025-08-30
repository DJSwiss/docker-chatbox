#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
IMAGE_NAME="chatboxai-multi"
TAG="${1:-latest}"

echo "🚀 Building ChatBoxAI Multi-Architecture Docker Image"
echo "   Image: ${IMAGE_NAME}:${TAG}"
echo "   Platforms: linux/amd64, linux/arm64"
echo

cd "$SCRIPT_DIR"

echo "📋 Checking prerequisites..."

if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed or not in PATH"
    exit 1
fi

if ! docker buildx version &> /dev/null; then
    echo "❌ Docker buildx is not available"
    exit 1
fi

echo "✅ Docker and buildx are available"

echo "🔧 Setting up buildx builder..."
if ! docker buildx inspect chatboxai-builder &> /dev/null; then
    echo "   Creating new builder: chatboxai-builder"
    docker buildx create --name chatboxai-builder --use
else
    echo "   Using existing builder: chatboxai-builder"
    docker buildx use chatboxai-builder
fi

echo "   Bootstrapping builder..."
docker buildx inspect --bootstrap

echo "📦 Building multi-architecture image..."
echo "   This may take several minutes..."

docker buildx build \
    --platform linux/amd64,linux/arm64 \
    -t "${IMAGE_NAME}:${TAG}" \
    -f Dockerfile.multi \
    --load \
    .

echo
echo "✅ Build completed successfully!"
echo "   Image: ${IMAGE_NAME}:${TAG}"
echo
echo "🚀 You can now run the container with:"
echo "   ./run.sh"
echo "   or"
echo "   docker-compose up -d"