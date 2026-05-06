# MuchToDo API - Containerization Assessment

A Golang REST API containerized with Docker and deployed to Kubernetes using Kind.

---

## Prerequisites

- Docker Desktop
- Kind
- kubectl
- Go 1.25+

---

## Project Structure
much-to-do/
├── Dockerfile
├── docker-compose.yml
├── .dockerignore
├── .env
├── .env.example
├── kubernetes/
│   ├── namespace.yaml
│   ├── mongodb/
│   │   ├── mongodb-secret.yaml
│   │   ├── mongodb-configmap.yaml
│   │   ├── mongodb-pvc.yaml
│   │   ├── mongodb-deployment.yaml
│   │   └── mongodb-service.yaml
│   ├── backend/
│   │   ├── backend-secret.yaml
│   │   ├── backend-configmap.yaml
│   │   ├── backend-deployment.yaml
│   │   └── backend-service.yaml
│   └── ingress.yaml
├── scripts/
│   ├── docker-build.sh
│   ├── docker-run.sh
│   ├── k8s-deploy.sh
│   └── k8s-cleanup.sh
└── evidence/

---

## Phase 1 - Docker Setup

### Build The Image
```bash
./scripts/docker-build.sh
```

### Run With Docker Compose
```bash
./scripts/docker-run.sh
```

### Access The Application
- API: http://localhost:8080
- Health Check: http://localhost:8080/health
- Swagger UI: http://localhost:8080/swagger/index.html

### Stop The Application
```bash
docker compose down
```

---

## Phase 2 - Kubernetes Deployment

### Deploy Everything
```bash
./scripts/k8s-deploy.sh
```

### Access The Application
```bash
kubectl port-forward -n muchtodo service/backend-service 8081:80
```
Then visit: http://localhost:8081/health

### Check Status
```bash
kubectl get pods -n muchtodo
kubectl get services -n muchtodo
kubectl get deployments -n muchtodo
kubectl get ingress -n muchtodo
```

### Clean Up
```bash
./scripts/k8s-cleanup.sh
```

---

## Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| PORT | Application port | 8080 |
| MONGO_URI | MongoDB connection string | - |
| DB_NAME | Database name | much_todo_db |
| JWT_SECRET_KEY | JWT signing key | - |
| JWT_EXPIRATION_HOURS | JWT token expiry | 72 |
| ENABLE_CACHE | Enable Redis cache | false |
| LOG_LEVEL | Logging level | DEBUG |
| LOG_FORMAT | Log format | text |

---

## Architecture
Internet
↓
Ingress (muchtodo.local)
↓
backend-service (NodePort 30080)
↓
backend pods (x2)
↓
mongodb-service (ClusterIP)
↓
mongodb pod (x1)

