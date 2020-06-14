#!/bin/bash
set -euo pipefail
IFS=$'\n'
filenames="$(git diff-tree -r --no-commit-id --name-status "$1" HEAD | ( grep -P '^[AM]\t(xep-[0-9]{4}|inbox/[^/]+)\.xml$' || true) | cut -f2)"
if [ -z "$filenames" ]; then
    exit 0
fi
mkdir -p rendered-changes/
cp xmpp.css prettify.css rendered-changes/
for filename in $filenames; do
    built_filename="build/${filename/%.xml/.html}"
    cp "$built_filename" rendered-changes/
done
