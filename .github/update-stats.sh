#!/usr/bin/env bash
# Rewrites the stat lines in README.md with all-time counts. Needs gh + GH_TOKEN.
set -euo pipefail
u="${1:-larknafets}"
read -r repos prs merged < <(gh api graphql -f login="$u" \
  -f prs="author:$u type:pr" -f merged="author:$u type:pr is:merged" -f query='
query($login:String!,$prs:String!,$merged:String!){
  user(login:$login){
    repositories(privacy:PUBLIC,ownerAffiliations:OWNER){totalCount}}
  prs:search(query:$prs,type:ISSUE){issueCount}
  merged:search(query:$merged,type:ISSUE){issueCount}}' \
  --jq '.data | [.user.repositories.totalCount, .prs.issueCount, .merged.issueCount] | @tsv')
# shortcut: search counts public default-branch commits only, upgrade if private/other-branch work matters
commits=$(gh api -X GET search/commits -f q="author:$u" --jq .total_count)
# shortcut: sums contributor stats of own non-fork repos, so vendored or generated files inflate it, upgrade by excluding paths
add=0; del=0; failed=0; since=$(($(date -u +%s) - 90 * 86400)); active=""
for r in $(gh api "users/$u/repos" --paginate --jq '.[] | select(.fork | not) | .name'); do
  out=""
  for _ in 1 2 3 4 5; do
    # stats answer 202 with an empty body while GitHub computes them
    out=$(gh api "repos/$u/$r/stats/contributors" --jq "[.[]? | select(.author.login == \"$u\") | .weeks[]] as \$w | [(\$w | map(.a) | add // 0), (\$w | map(.d) | add // 0), (\$w | map(select(.w >= $since) | .c) | add // 0)] | @tsv" 2>/dev/null) || out=""
    [ -n "$out" ] && break
    sleep 3
  done
  [ -z "$out" ] && failed=1 && continue
  read -r a d c <<<"$out"
  add=$((add + a)); del=$((del + d))
  # the profile repos are always busy, keep them out of the top list
  case "$r" in "$u" | "$u.github.io") ;; *) active+="$c $r"$'\n' ;; esac
done
# top 3 public repos by own commits in the last 90 days, dot-padded like the other stat lines
top=$(printf '%s' "$active" | sort -rn | head -3 | awk '{ l = $2 " "; for (i = length(l); i < 20; i++) l = l "."; print l " " $1 " commits" }')
human() { awk -v n="$1" 'BEGIN { if (n >= 1000) printf "%.1fk", n / 1000; else print n }'; }
# keep the previous LOC line if any repo's stats were not ready yet
if [ "$failed" = 1 ]; then loc=$(sed -n -E 's/^Lines of code \.+ (.*)/\1/p' README.md); else loc="$(human $((add + del))) (+$(human "$add") / -$(human "$del"))"; fi
# age from birth year+month only (1979-08), one decimal
age=$(awk -v y="$(date -u +%Y)" -v m="$(date -u +%m)" 'BEGIN { printf "%.1f", ((y - 1979) * 12 + m - 8) / 12 }')
sed -i.bak -E \
  -e "s/^(Uptime \.+ )[0-9.]+ years/\1$age years/" \
  -e "s/^(Repos \.+ ).*/\1$repos/" \
  -e "s/^(Commits \.+ ).*/\1$commits/" \
  -e "s/^(PRs \.+ ).*/\1$prs/" \
  -e "s/^(Merged \.+ ).*/\1$merged/" \
  -e "s|^(Lines of code \.+ ).*|\1$loc|" README.md
rm README.md.bak
# swap the blank line + 3 repo lines under "Lines of code", unless some repo's stats were not ready yet
if [ "$failed" = 0 ]; then
  top="$top" awk '/^Lines of code/ { print; print ""; print ENVIRON["top"]; skip = 4; next } skip > 0 { skip--; next } { print }' README.md > README.md.new
  mv README.md.new README.md
fi
