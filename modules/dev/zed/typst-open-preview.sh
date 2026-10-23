# shellcheck shell=bash
# Open the live tinymist preview for the Typst file in $TYPST_FILE.
#
# Zed runs one tinymist per project window, with the project root as its
# working directory and its background preview on a random port. Pick the
# instance whose root contains the file and open its preview, unless a browser
# tab is already connected to it.

file=${TYPST_FILE:?TYPST_FILE is not set}

root="" port=""
for pid in $(pgrep -x tinymist); do
  cwd=$(readlink "/proc/$pid/cwd") || continue
  case "$file" in "$cwd"/*) ;; *) continue ;; esac
  # Prefer the innermost project when roots are nested.
  ((${#cwd} > ${#root})) || continue
  p=$(ss -ltnpH | awk -v pid="pid=$pid," '!found && index($0, pid) { n = split($4, a, ":"); print a[n]; found = 1 }')
  [[ -n $p ]] || continue
  root=$cwd port=$p
done

if [[ -z $port ]]; then
  notify-send "Typst preview" "No tinymist preview found for $file"
  exit 1
fi

# The preview page keeps a websocket open to its server, so an established
# connection means a tab is already showing this project.
if [[ -n $(ss -tnH state established "( sport = :$port )") ]]; then
  notify-send "Typst preview" "Already open at http://127.0.0.1:$port"
  exit 0
fi

exec xdg-open "http://127.0.0.1:$port"
