#!/usr/bin/env bash
# Refreshes the generated blocks (stats, principles) and the profile uptime. Needs gh, jq, python3, GH_TOKEN and the full git history.
set -euo pipefail
cd "$(dirname "$0")/.."
u="${1:-larknafets}"
get() { sed -n -E "s/^$1 *= *//p" blocks/config; }
fence='```'
. .github/check-config.sh

from=$(python3 -I -c 'import datetime as d; print((d.datetime.now(d.timezone.utc) - d.timedelta(days=90)).strftime("%Y-%m-%dT%H:%M:%SZ"))')
g=$(gh api graphql -f login="$u" -f from="$from" -f to="$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
  -f prs="author:$u type:pr" -f merged="author:$u type:pr is:merged" -f query='
query($login:String!,$from:DateTime!,$to:DateTime!,$prs:String!,$merged:String!){
  user(login:$login){
    repositories(privacy:PUBLIC,ownerAffiliations:OWNER){totalCount}
    contributionsCollection(from:$from,to:$to){
      commitContributionsByRepository(maxRepositories:100){repository{name isFork} contributions{totalCount}}}}
  prs:search(query:$prs,type:ISSUE){issueCount}
  merged:search(query:$merged,type:ISSUE){issueCount}}')
read -r repos prs merged < <(jq -r '.data | [.user.repositories.totalCount, .prs.issueCount, .merged.issueCount] | @tsv' <<<"$g")
# shortcut: search counts public default-branch commits only, upgrade if private/other-branch work matters
commits=$(gh api -X GET search/commits -f q="author:$u" --jq .total_count)
# shortcut: sums contributor stats of own non-fork repos, so vendored or generated files inflate it, upgrade by excluding paths
add=0; del=0; failed=0
for r in $(gh api "users/$u/repos" --paginate --jq '.[] | select(.fork | not) | .name'); do
  out=""
  for _ in 1 2 3 4 5 6 7 8 9 10; do
    # GitHub answers 202 (empty body) while it computes the stats, and a push to the default branch resets them: wait until my entry shows up
    out=$(gh api "repos/$u/$r/stats/contributors" --jq "[.[]? | select(.author.login == \"$u\")] | if length == 0 then empty else .[0].weeks as \$w | [(\$w | map(.a) | add // 0), (\$w | map(.d) | add // 0)] | @tsv end" 2>/dev/null) || out=""
    [ -n "$out" ] && break
    sleep 6
  done
  if [ -z "$out" ]; then echo "stats: $r not ready, keeping the old LOC" >&2; failed=1; continue; fi
  read -r a d <<<"$out"
  add=$((add + a)); del=$((del + d))
done
human() { awk -v n="$1" 'BEGIN { if (n >= 1000) printf "%.1fk", n / 1000; else print n }'; }
# top 3 public repos by own commits in the last 90 days, dot-padded like the other stat lines; the profile repos are always busy, keep them out
top=$(jq -r --arg u "$u" '[.data.user.contributionsCollection.commitContributionsByRepository[] | select(.repository.isFork | not) | select(.repository.name != $u and .repository.name != ($u + ".github.io")) | [.contributions.totalCount, .repository.name]] | sort_by(-.[0]) | .[:3][] | @tsv' <<<"$g" \
  | awk -F'\t' '{ l = $2 " "; for (i = length(l); i < 20; i++) l = l "."; print l " " $1 " commits" }')
loc="$(human $((add + del))) (+$(human "$add") / -$(human "$del"))"
# keep the previous LOC if any repo's stats were not ready yet
if [ "$failed" = 1 ]; then
  loc=$(sed -n -E 's/^Lines of code \.+ (.*)/\1/p' blocks/stats.md)
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

birth=$(get birth)
role=$(get role | sed 's/[&|\\]/\\&/g') # & and | would break the sed replacement below
age=$(awk -v y="$(date -u +%Y)" -v m="$(date -u +%m)" -v by="${birth%-*}" -v bm="${birth#*-}" 'BEGIN { printf "%.1f", ((y - by) * 12 + m - bm) / 12 }')
# only the age number and the role are touched, the rest of the profile is hand-written
sed -i.bak -E "s|^(Uptime \.+ )[0-9.]+ years|\1$age years|; s|^(Role \.+ ).*|\1$role|" blocks/profile.md
rm blocks/profile.md.bak
