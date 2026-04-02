#!/bin/bash
# Pulls live data from local CC and writes it to snapshot.json for Vercel deploy
# Usage: ./snapshot.sh [CC_URL]

CC_URL="${1:-http://127.0.0.1:5051}"
API_KEY="87722f91af012051769962fe380464217c14510d62cd4410e94f986b210039e6"
OUT="$(dirname "$0")/public/snapshot.json"

# Fetch overview (includes runs, trades, config, totals)
OVERVIEW=$(curl -s --max-time 5 "$CC_URL/api/overview" 2>/dev/null)

if [ -z "$OVERVIEW" ]; then
  echo '{"ok":false,"error":"CC unreachable","ts":"'$(date -u +%Y-%m-%dT%H:%M:%SZ)'"}' > "$OUT"
  echo "CC unreachable, wrote error snapshot"
  exit 1
fi

# Add ok flag and timestamp
echo "$OVERVIEW" | python3 -c "
import json,sys
d=json.load(sys.stdin)
d['ok']=True
d['ts']=__import__('datetime').datetime.utcnow().isoformat()+'Z'
print(json.dumps(d,indent=2))
" > "$OUT"

echo "Snapshot written to $OUT"
