#!/bin/bash
# ─── Rollback Script ────────────────────────────────────────────────
set -e

: "${ASG_NAME:=starttech-prod-asg}"
: "${ROLLBACK_TAG:?ROLLBACK_TAG is required}"

echo "⏪ Starting rollback to: $ROLLBACK_TAG"

aws autoscaling cancel-instance-refresh \
  --auto-scaling-group-name $ASG_NAME 2>/dev/null || true

sleep 5

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
  if [ "$STATUS" = "Successful" ]; then echo "✅ Rollback complete"; exit 0; fi
  if [ "$STATUS" = "Failed" ] || [ "$STATUS" = "Cancelled" ]; then echo "❌ Rollback failed"; exit 1; fi
  sleep 20
done
echo "⏱ Timed out"
exit 1
