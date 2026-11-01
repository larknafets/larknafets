# Sourced by build.sh and update-blocks.sh after get() is defined: exits on the first bad value in blocks/config.
die() { echo "config: $*" >&2; exit 1; }
oneof() { local v; v=$(get "$1"); shift; for a in "$@"; do [ "$v" = "$a" ] && return; done; die "'$v' is not one of: $*"; }
oneof status employed open unemployed away
oneof seeking "permanent position" freelance
oneof location remote-first hybrid onsite
[[ $(get birth) =~ ^[0-9]{4}-(0[1-9]|1[0-2])$ ]] || die "birth '$(get birth)' is not YYYY-MM"
[[ $(get width) =~ ^[0-9]+$ ]] || die "width '$(get width)' is not an integer"
for k in topics role; do [ -n "$(get $k)" ] || die "$k is empty"; done
for h in $(get principles); do git rev-parse -q --verify "$h^{commit}" >/dev/null || die "no commit $h"; done
for n in $(grep -E '^[^#=]+\.md *=' blocks/config | cut -d= -f2); do [ -f "blocks/$n.md" ] || die "no block $n"; done
