#!/usr/bin/env bash
# Generates the status block from blocks/config, then assembles every output listed there from blocks/<name>.md,
# wrapped to the configured width.
set -euo pipefail
cd "$(dirname "$0")/.."
get() { sed -n -E "s/^$1 *= *//p" blocks/config; }
fence='```'

case "$(get status)" in
  employed)   dot='●'; active='active (running)';          msg='200 OK' ;;
  open)       dot='●'; active='active (running)';          msg='200 OK, accepting new connections' ;;
  unemployed) dot='○'; active='inactive (dead)';           msg='ready to start' ;;
  away)       dot='●'; active='activating (auto-restart)'; msg='offline, back soon' ;;
  *) echo "status: '$(get status)' is not one of employed, open, unemployed, away" >&2; exit 1 ;;
esac
cat > blocks/status.md <<EOF
${fence}console
stefan@kral:~\$ sudo systemctl status larknafets
$dot larknafets.service - Stefan Kral
     Active: $active
     Status: "$msg"
$fence
EOF

grep -E '^[^#=]+\.md *=' blocks/config | while IFS='=' read -r out names; do
  out=${out// /}
  mkdir -p "$(dirname "$out")"
  sep=""
  for n in $names; do
    printf '%s' "$sep"; cat "blocks/$n.md"; sep=$'\n'
  done | python3 -I .github/wrap.py "$(get width)" > "$out"
done
