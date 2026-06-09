#!/bin/bash
# ─── Health Check Script ────────────────────────────────────────────
set -e

: "${ALB_DNS_NAME:?ALB_DNS_NAME is required}"
: "${CLOUDFRONT_DOMAIN:?CLOUDFRONT_DOMAIN is required}"

echo "🏥 Running health checks..."

# Backend
for i in $(seq 1 10); do
  HTTP=$(curl -s -o /dev/null -w "%{http_code}" http://$ALB_DNS_NAME/health || echo "000")
  echo "Backend attempt $i/10 — HTTP: $HTTP"
  if [ "$HTTP" = "200" ]; then echo "✅ Backend healthy"; BACKEND_OK=true; break; fi
  sleep 15
done

# Frontend
for i in $(seq 1 10); do
  HTTP=$(curl -s -o /dev/null -w "%{http_code}" https://$CLOUDFRONT_DOMAIN || echo "000")
  echo "Frontend attempt $i/10 — HTTP: $HTTP"
  if [ "$HTTP" = "200" ]; then echo "✅ Frontend healthy"; FRONTEND_OK=true; break; fi
  sleep 15
done

echo "Backend:  $([ "$BACKEND_OK" = true ] && echo '✅ healthy' || echo '❌ unhealthy')"
echo "Frontend: $([ "$FRONTEND_OK" = true ] && echo '✅ healthy' || echo '❌ unhealthy')"

[ "$BACKEND_OK" = true ] && [ "$FRONTEND_OK" = true ] && exit 0 || exit 1
