# Much To Do — StartTech Application

A full-stack todo application built with React/Vite (frontend) and Golang/Gin (backend), deployed on AWS with fully automated CI/CD pipelines.

## Live URLs

| Service | URL |
|---|---|
| Frontend | https://dw77jeqi4cbdr.cloudfront.net |
| Backend API | http://starttech-prod-alb-1966841913.us-east-1.elb.amazonaws.com |
| API Docs | http://starttech-prod-alb-1966841913.us-east-1.elb.amazonaws.com/swagger/index.html |

## Application Stack

| Layer | Technology |
|---|---|
| Frontend | React 19, Vite, TanStack Router, TanStack Query, Tailwind CSS |
| Backend | Golang 1.24, Gin framework, Swagger docs |
| Database | MongoDB Atlas |
| Cache | AWS ElastiCache Redis 7 |
| Container | Docker (multi-stage build) |

## Repository Structure
- Images tagged with full git SHA for precise rollback
- Rolling deploy keeps app live during deployment (MinHealthyPercentage: 50%)
- Health endpoint always returns 200 for ALB compatibility

## API Endpoints

| Method | Path | Auth | Description |
|---|---|---|---|
| GET | /health | No | Health check |
| GET | /swagger/* | No | API docs |
| POST | /auth/register | No | Register |
| POST | /auth/login | No | Login |
| GET | /tasks | Yes | Get todos |
| POST | /tasks | Yes | Create todo |
| PUT | /tasks/:id | Yes | Update todo |
| DELETE | /tasks/:id | Yes | Delete todo |
| GET | /users/me | Yes | Current user |

## GitHub Secrets Required

| Secret | Pipeline |
|---|---|
| `AWS_ACCESS_KEY_ID` | Both |
| `AWS_SECRET_ACCESS_KEY` | Both |
| `VITE_API_BASE_URL` | Frontend |
| `S3_BUCKET_NAME` | Frontend |
| `CLOUDFRONT_DISTRIBUTION_ID` | Frontend |
| `CLOUDFRONT_DOMAIN` | Frontend |
| `MONGO_URI` | Backend |
| `JWT_SECRET` | Backend |
| `ALB_DNS_NAME` | Backend |

## Local Development

### Frontend
```bash
cd Client
npm install
# create .env.local with VITE_API_BASE_URL=http://localhost:8080
npm run dev
```

### Backend
```bash
cd Server/MuchToDo
cp .env.example .env
# fill in MONGO_URI, JWT_SECRET_KEY, REDIS_ADDR
make run
```
