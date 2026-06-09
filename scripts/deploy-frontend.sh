#!/bin/bash
# ─── Deploy Frontend to S3 + Invalidate CloudFront ─────────────────
set -e

: "${S3_BUCKET_NAME:?S3_BUCKET_NAME is required}"
: "${CLOUDFRONT_DISTRIBUTION_ID:?CLOUDFRONT_DISTRIBUTION_ID is required}"
: "${VITE_API_BASE_URL:?VITE_API_BASE_URL is required}"

echo "🚀 Starting frontend deployment..."

cd "$(dirname "$0")/../Client"
npm ci
VITE_API_BASE_URL=$VITE_API_BASE_URL npm run build

aws s3 sync dist/ s3://$S3_BUCKET_NAME \
  --delete \
  --cache-control "public, max-age=31536000, immutable" \
  --exclude "index.html"

aws s3 cp dist/index.html s3://$S3_BUCKET_NAME/index.html \
  --cache-control "no-cache, no-store, must-revalidate"

aws cloudfront create-invalidation \
  --distribution-id $CLOUDFRONT_DISTRIBUTION_ID \
  --paths "/*"

echo "✅ Frontend deployed successfully"
