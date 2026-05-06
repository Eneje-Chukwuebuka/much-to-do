#!/bin/bash
set -e

echo "Building Docker image..."
docker build -t much-to-do-backend:latest .
echo "Build complete!"
