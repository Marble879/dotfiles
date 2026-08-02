#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STATE_FILE="${SCRIPT_DIR}/nightlight-temp"

t=$(cat "$STATE_FILE" 2>/dev/null || echo 3700)

if pgrep -x gammastep >/dev/null; then
   printf '%sK \n' "$t"
else
   printf '%sK\n' "$t"
fi
