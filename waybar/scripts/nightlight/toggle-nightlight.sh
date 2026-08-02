#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STATE_FILE="${SCRIPT_DIR}/nightlight-temp"
NIGHT_TEMP=3700
STEP=300
MIN_TEMP=1000
MAX_TEMP=6500

current_temp() {
   if [[ -f "$STATE_FILE" ]]; then
      cat "$STATE_FILE"
   else
      echo "$NIGHT_TEMP"
   fi
}

apply() {
   local t="$1"
   pkill -x gammastep
   gammastep -O "$t" >/dev/null 2>&1 &
   echo "$t" > "$STATE_FILE"
   pkill -RTMIN+10 -x waybar
}

case "${1:-toggle}" in
   toggle)
      if pgrep -x gammastep >/dev/null; then
         pkill -x gammastep
      else
         apply "$(current_temp)"
      fi
      ;;
   up)
      t=$(current_temp)
      t=$((t - STEP))
      [[ $t -lt $MIN_TEMP ]] && t=$MIN_TEMP
      apply "$t"
      ;;
   down)
      t=$(current_temp)
      t=$((t + STEP))
      [[ $t -gt $MAX_TEMP ]] && t=$MAX_TEMP
      apply "$t"
      ;;
esac
