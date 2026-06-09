#!/bin/bash
# ─── Deploy Backend via ASG Instance Refresh ───────────────────────
set -e

: "${ASG_NAME:=starttech-prod-asg}"
: "${IMAGE_TAG:?IMAGE_TAG is required}"
: "${ECR_REGISTRY:?ECR_REGISTRY is required}"

echo "🚀 Starting backend deployment..."

REFRESH_ID=$(aws autoscaling start-instance-refresh \
  --auto-scaling-group-name $ASG_NAME \
  --preferences '{"MinHealthyPercentage":50,"InstanceWarmup":90}' \
  --query 'InstanceRefreshId' \
  --output text)

echo "Refresh ID: $REFRESH_ID"

for i in $(seq 1 60); do
  STATUS=$(aws autoscaling describe-instance-refreshes \
    --auto-scaling-group-name $ASG_NAME \
    --instance-refresh-ids $REFRESH_ID \
    --query 'InstanceRefreshes[0].Status' \
    --output text)
  echo "Attempt $i/60 — Status: $STATUS"
  if [ "$STATUS" = "Successful" ]; then
    echo "✅ Backend deployed successfully"
    exit 0
  elif [ "$STATUS" = "Failed" ] || [ "$STATUS" = "Cancelled" ]; then
    echo "❌ Deployment failed"
    exit 1
  fi
  sleep 20
done
echo "⏱ Timed out"
exit 1
