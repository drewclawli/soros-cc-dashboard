#!/bin/bash
# Pushes live CC data to Vercel dashboard via POST /api/snapshot
# Usage: ./snapshot.sh [CC_URL] [VERCEL_URL]

CC_URL="${1:-http://127.0.0.1:5050}"
VERCEL_URL="${2:-https://monitor-ui-kohl.vercel.app}"

# Pull from local CC
SNAPSHOT=$(curl -s --max-time 5 "$CC_URL/api/snapshot" 2>/dev/null)

if [ -z "$SNAPSHOT" ]; then
  echo '{"ok":false,"error":"CC unreachable"}'
  exit 1
fi

# Push to Vercel
RESULT=$(echo "$SNAPSHOT" | curl -s --max-time 5 -X POST "$VERCEL_URL/api/snapshot" -H "Content-Type: application/json" -d @- 2>/dev/null)

echo "Pushed to $VERCEL_URL: $RESULT"
