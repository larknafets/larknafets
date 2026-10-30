#!/usr/bin/env bash
# Refreshes the generated blocks (stats, principles) and the profile uptime. Needs gh + GH_TOKEN and the full git history.
set -euo pipefail
cd "$(dirname "$0")/.."
u="${1:-larknafets}"
get() { sed -n -E "s/^$1 *= *//p" blocks/config; }
fence='```'

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
human() { awk -v n="$1" 'BEGIN { if (n >= 1000) printf "%.1fk", n / 1000; else print n }'; }
# top 3 public repos by own commits in the last 90 days, dot-padded like the other stat lines
top=$(printf '%s' "$active" | sort -rn | head -3 | awk '{ l = $2 " "; for (i = length(l); i < 20; i++) l = l "."; print l " " $1 " commits" }')
loc="$(human $((add + del))) (+$(human "$add") / -$(human "$del"))"
# keep the previous LOC and top lines if any repo's stats were not ready yet
if [ "$failed" = 1 ]; then
  loc=$(sed -n -E 's/^Lines of code \.+ (.*)/\1/p' blocks/stats.md)
  top=$(awk 'f && !/^```/ { print } /^$/ { f = 1 }' blocks/stats.md)
fi
cat > blocks/stats.md <<EOF
${fence}console
stefan@kral:~\$ gh stats $u --refresh 24h --top 3
Repos ......... $repos
Commits ....... $commits
PRs ........... $prs
Merged ........ $merged
Lines of code . $loc

$top
$fence
EOF

{
  echo "${fence}console"
  echo 'stefan@kral:~$ git log --oneline'
  for h in $(get principles); do
    git log -1 --format='%h %s' "$h" -- 2>/dev/null || echo "principles: no commit $h" >&2
  done
  echo "$fence"
} > blocks/principles.md

age=$(awk -v y="$(date -u +%Y)" -v m="$(date -u +%m)" 'BEGIN { printf "%.1f", ((y - 1979) * 12 + m - 8) / 12 }')
# only the age number and the role are touched, the rest of the profile is hand-written
sed -i.bak -E "s|^(Uptime \.+ )[0-9.]+ years|\1$age years|; s|^(Role \.+ ).*|\1$(get role)|" blocks/profile.md
rm blocks/profile.md.bak
