#!/bin/bash
set -e

echo "Creating Kind cluster..."
kind create cluster --name muchtodo

echo "Building Docker image..."
docker build -t much-to-do-backend:latest .

echo "Loading image into Kind..."
kind load docker-image much-to-do-backend:latest --name muchtodo

echo "Deploying to Kubernetes..."
kubectl apply -f kubernetes/namespace.yaml
kubectl apply -f kubernetes/mongodb/
kubectl apply -f kubernetes/backend/
kubectl apply -f kubernetes/ingress.yaml

echo ""
echo "Deployment complete!"
echo "Run: kubectl get pods -n muchtodo"
