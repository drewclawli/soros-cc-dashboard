#!/bin/bash
CC_URL="${1:-http://127.0.0.1:5050}"
API_KEY="87722f91af012051769962fe380464217c14510d62cd4410e94f986b210039e6"
OUT="$(dirname "$0")/public/snapshot.json"

SNAPSHOT=$(curl -s --max-time 5 "$CC_URL/api/snapshot" 2>/dev/null)

if [ -z "$SNAPSHOT" ]; then
  echo '{"ok":false,"error":"CC unreachable","ts":"'$(date -u +%Y-%m-%dT%H:%M:%SZ)'"}' > "$OUT"
  echo "CC unreachable"
  exit 1
fi

echo "$SNAPSHOT" > "$OUT"
echo "Snapshot written to $OUT ($(wc -c < "$OUT") bytes)"
