#!/usr/bin/env bash
# Send a text/HTML file to a Telegram chat as one or more messages.
#
# Usage:
#   send_telegram.sh <file> [--dry-run]
#
# Reads TELEGRAM_BOT_TOKEN and TELEGRAM_CHAT_ID from the environment, falling back
# to a .env file in the current directory. Needs only bash, curl, awk, and sed.

set -euo pipefail

MAX_LEN=4000  # Telegram limit is 4096 chars; awk counts bytes, so this is conservative

file="" dry_run=0
for arg in "$@"; do
  case "$arg" in
    --dry-run) dry_run=1 ;;
    *) file="$arg" ;;
  esac
done
if [[ -z "$file" || ! -f "$file" ]]; then
  echo "Usage: $0 <file> [--dry-run]" >&2
  exit 2
fi

workdir=$(mktemp -d)
trap 'rm -rf "$workdir"' EXIT

# Split on blank lines (paragraphs) so formatting tags stay intact;
# a single paragraph longer than the limit is split on line breaks.
awk -v max="$MAX_LEN" -v dir="$workdir" '
  function flush() { if (cur != "") { n++; printf "%s", cur > sprintf("%s/chunk-%03d", dir, n); close(sprintf("%s/chunk-%03d", dir, n)); cur = "" } }
  function add(text, sep) {
    if (cur == "") cur = text
    else if (length(cur) + length(sep) + length(text) <= max) cur = cur sep text
    else { flush(); cur = text }
  }
  BEGIN { RS = ""; FS = "\n" }
  {
    if (length($0) <= max) { add($0, "\n\n"); next }
    flush()
    for (i = 1; i <= NF; i++) add($i, "\n")
    flush()
  }
  END { flush() }
' "$file"

chunks=("$workdir"/chunk-*)
total=${#chunks[@]}

if (( dry_run )); then
  i=0
  for c in "${chunks[@]}"; do
    i=$((i + 1))
    echo "--- message $i/$total ($(wc -c < "$c" | tr -d ' ') bytes) ---"
    cat "$c"; echo; echo
  done
  exit 0
fi

if [[ -f .env ]]; then
  while IFS='=' read -r key value; do
    [[ -z "$key" || "$key" == \#* ]] && continue
    key=$(echo "$key" | tr -d '[:space:]')
    value=$(echo "$value" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//' -e "s/^[\"']//" -e "s/[\"']$//")
    [[ -z "${!key:-}" ]] && export "$key=$value"
  done < .env
fi

: "${TELEGRAM_BOT_TOKEN:?Missing TELEGRAM_BOT_TOKEN}"
: "${TELEGRAM_CHAT_ID:?Missing TELEGRAM_CHAT_ID}"

send() {  # send <file> <parse_mode or empty>
  local args=(-sS --max-time 30
    --data-urlencode "chat_id=$TELEGRAM_CHAT_ID"
    --data-urlencode "text@$1"
    --data-urlencode "disable_web_page_preview=true")
  [[ -n "$2" ]] && args+=(--data-urlencode "parse_mode=$2")
  curl "${args[@]}" "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage"
}

i=0
for c in "${chunks[@]}"; do
  i=$((i + 1))
  resp=$(send "$c" HTML || true)
  if ! grep -q '"ok":true' <<<"$resp"; then
    # Only an HTML formatting error is worth retrying; anything else (bad token,
    # unknown chat, network) would fail again, so stop here.
    if ! grep -q "can't parse entities" <<<"$resp"; then
      echo "Send failed: $resp" >&2
      exit 1
    fi
    # Invalid HTML formatting: retry as plain text without tags
    echo "HTML send failed ($resp); retrying as plain text" >&2
    sed -E -e 's#</?(b|i|code|pre)>##g' -e 's/&lt;/</g' -e 's/&gt;/>/g' -e 's/&amp;/\&/g' "$c" > "$c.plain"
    resp=$(send "$c.plain" "")
    if ! grep -q '"ok":true' <<<"$resp"; then
      echo "Send failed: $resp" >&2
      exit 1
    fi
  fi
  echo "Sent message $i/$total"
done
