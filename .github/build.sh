#!/usr/bin/env bash
# Generates the status block from blocks/config, then assembles every output listed there from blocks/<name>.md,
# wrapped to the configured width.
set -euo pipefail
cd "$(dirname "$0")/.."
get() { sed -n -E "s/^$1 *= *//p" blocks/config; }
fence='```'

. .github/check-config.sh

p='larknafets[337]:'
open="$p seeking: $(get seeking)"$'\n'"$p location: $(get location)"$'\n'"$p topics: $(get topics)"
case "$(get status)" in
  employed)   dot='●'; active='active (running)';          msg='200 OK'
              log="$p employed, not looking" ;;
  open)       dot='●'; active='active (running)';          msg='200 OK, accepting new connections'
              log="$p employed, open to new things"$'\n'"$open" ;;
  unemployed) dot='○'; active='inactive (dead)';           msg='ready to start'
              log="$p between jobs"$'\n'"$open" ;;
  away)       dot='●'; active='activating (auto-restart)'; msg='offline, back soon'
              log="$p on vacation, offline"$'\n'"$p auto-restart pending" ;;
esac
cat > blocks/status.md <<EOF
${fence}console
stefan@kral:~\$ sudo systemctl status larknafets
$dot larknafets.service - Stefan Kral
     Active: $active
     Status: "$msg"

$log
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
