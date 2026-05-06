#!/bin/bash
set -e

echo "Starting services with Docker Compose..."
docker compose up --build -d
echo ""
echo "Services running!"
echo "API available at: http://localhost:8080"
echo "Health check at: http://localhost:8080/health"
echo "Swagger UI at:   http://localhost:8080/swagger/index.html"
