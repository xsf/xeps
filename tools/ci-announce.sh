#!/bin/bash
set -euo pipefail
state_dir=state
old_xeplist="$state_dir/old-xeplist.xml"
new_xeplist="build/xeplist.xml"
mkdir -p "$state_dir"

function update_state() {
  cp "$new_xeplist" "$old_xeplist"
}

if [ ! -f "$old_xeplist" ]; then
  printf '%q does not exist; assuming this is the first run!' "$old_xeplist" >&2
  update_state
  exit 0
fi

./tools/send-updates.py -y -c "$EMAIL_CFG" --no-editorial -- "$old_xeplist" "$new_xeplist" $EMAIL_RECIPIENTS
update_state
