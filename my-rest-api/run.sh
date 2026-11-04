#!/usr/bin/env bash

set -Eeuo pipefail

IMAGE_NAME="my-rest-api:1.0"
CONTAINER_NAME="my-rest-api-container"

HOST_PORT="${HOST_PORT:-5000}"
CONTAINER_PORT="5000"

PROJECT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
cd "$PROJECT_DIR"

echo "=== My REST API ==="


if ! command -v docker >/dev/null 2>&1; then
    echo "Docker is not installed!"
    exit 1
fi

if ! docker info >/dev/null 2>&1; then
    echo "Docker is not running!"
    exit 1
fi

echo "Building Docker image..."

docker build -t "$IMAGE_NAME" .


if docker container inspect "$CONTAINER_NAME" >/dev/null 2>&1; then
    echo "Removing old container..."
    docker rm -f "$CONTAINER_NAME"
fi


echo "Starting container..."

docker run -d \
    --name "$CONTAINER_NAME" \
    -p "127.0.0.1:${HOST_PORT}:${CONTAINER_PORT}" \
    --restart unless-stopped \
    "$IMAGE_NAME"

echo "Application started successfully!"

echo "API: http://localhost:${HOST_PORT}/"
echo "Hello: http://localhost:${HOST_PORT}/hello?name=Ivan"
echo "Health: http://localhost:${HOST_PORT}/health"

echo "Container status:"
docker ps