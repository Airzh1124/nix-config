#!/usr/bin/env bash
# Claude Code status line: cwd, git branch, model, effort, and remaining
# context / 5h / weekly quota. Requires jq (installed via home/packages.nix).

input=$(cat)
j() { echo "$input" | jq -r "$1 // empty"; }

d=$(j .workspace.current_dir)
b=$(git -C "$d" --no-optional-locks branch --show-current 2>/dev/null)
sep=' \033[2m·\033[0m '

# Print remaining percentage, colored green/yellow/red by how much is left.
pct() {
  l=$(awk -v u="$2" 'BEGIN{l=100-u; if(l<0)l=0; printf "%.0f", l}')
  if [ "$l" -le 20 ]; then c=31; elif [ "$l" -le 50 ]; then c=33; else c=32; fi
  printf "$sep"'\033[2m%s\033[0m \033[%sm%s%%\033[0m \033[2mleft\033[0m' "$1" "$c" "$l"
}

# Print the reset time of a quota window, if Claude Code reported one.
rst() {
  [ -n "$1" ] || return 0
  t=$(date -d "@${1%.*}" +"$2" 2>/dev/null) && printf ' \033[2m(reset at %s)\033[0m' "$t"
}

printf '\033[34m%s\033[0m' "${d/#$HOME/\~}"
[ -n "$b" ] && printf ' \033[35m%s\033[0m' "$b"
printf ' \033[36m%s\033[0m' "$(j .model.display_name)"
e=$(j .effort.level)
[ -n "$e" ] && printf ' \033[2;36m%s\033[0m' "$e"
pct ctx "$(j .context_window.used_percentage)"
r=$(j .rate_limits.five_hour.used_percentage)
[ -n "$r" ] && { pct 5h "$r"; rst "$(j .rate_limits.five_hour.resets_at)" '%H:%M'; }
w=$(j .rate_limits.seven_day.used_percentage)
[ -n "$w" ] && { pct weekly "$w"; rst "$(j .rate_limits.seven_day.resets_at)" '%m/%d %H:%M'; }
true
