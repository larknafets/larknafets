#!/usr/bin/env bash
# Rewrites the stat lines in README.md with all-time counts. Needs gh + GH_TOKEN.
set -euo pipefail
u="${1:-larknafets}"
read -r created repos prs merged < <(gh api graphql -f login="$u" \
  -f prs="author:$u type:pr" -f merged="author:$u type:pr is:merged" -f query='
query($login:String!,$prs:String!,$merged:String!){
  user(login:$login){createdAt
    repositories(privacy:PUBLIC,ownerAffiliations:OWNER){totalCount}}
  prs:search(query:$prs,type:ISSUE){issueCount}
  merged:search(query:$merged,type:ISSUE){issueCount}}' \
  --jq '.data | [.user.createdAt, .user.repositories.totalCount, .prs.issueCount, .merged.issueCount] | @tsv')
# shortcut: search counts public default-branch commits only, upgrade if private/other-branch work matters
commits=$(gh api -X GET search/commits -f q="author:$u" --jq .total_count)
# shortcut: sums contributor stats of own non-fork repos, so vendored or generated files inflate it, upgrade by excluding paths
add=0; del=0; failed=0
for r in $(gh api "users/$u/repos" --paginate --jq '.[] | select(.fork | not) | .name'); do
  out=""
  for _ in 1 2 3 4 5; do
    # stats answer 202 with an empty body while GitHub computes them
    out=$(gh api "repos/$u/$r/stats/contributors" --jq "[.[]? | select(.author.login == \"$u\") | .weeks[]] | [(map(.a) | add // 0), (map(.d) | add // 0)] | @tsv" 2>/dev/null) || out=""
    [ -n "$out" ] && break
    sleep 3
  done
  [ -z "$out" ] && failed=1 && continue
  read -r a d <<<"$out"
  add=$((add + a)); del=$((del + d))
done
human() { awk -v n="$1" 'BEGIN { if (n >= 1000) printf "%.1fk", n / 1000; else print n }'; }
# keep the previous LOC line if any repo's stats were not ready yet
if [ "$failed" = 1 ]; then loc=$(sed -n -E 's/^Lines of code \.+ (.*)/\1/p' README.md); else loc="$(human $((add + del))) (+$(human "$add") / -$(human "$del"))"; fi
months=$((($(date -u +%Y) - ${created:0:4}) * 12 + 10#$(date -u +%m) - 10#${created:5:2} ))
uptime="$((months / 12))y $((months % 12))m"
# age from birth year+month only (1979-08), one decimal
age=$(awk -v y="$(date -u +%Y)" -v m="$(date -u +%m)" 'BEGIN { printf "%.1f", ((y - 1979) * 12 + m - 8) / 12 }')
# two Uptime lines: the first (neofetch block) is the age, the one after "gh stats" is the GitHub account age
sed -i.bak -E \
  -e "1,/gh stats/ s/^(Uptime \.+ ).*/\1$age years/" \
  -e "/gh stats/,\$ s/^(Uptime \.+ ).*/\1$uptime/" \
  -e "s/^(Repos \.+ ).*/\1$repos/" \
  -e "s/^(Commits \.+ ).*/\1$commits/" \
  -e "s/^(PRs \.+ ).*/\1$prs/" \
  -e "s/^(Merged \.+ ).*/\1$merged/" \
  -e "s|^(Lines of code \.+ ).*|\1$loc|" README.md
rm README.md.bak
