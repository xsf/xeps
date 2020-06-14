#!/bin/bash
set -euo pipefail
IFS=$'\n'
filenames="$(git diff-tree -r --no-commit-id --name-only HEAD "$1" | ( grep -P '^(xep-[0-9]{4}|inbox/[^/]+)\.xml$' || true))"
if [ -z "$filenames" ]; then
    exit 0
fi
mkdir -p rendered-changes/
cp xmpp.css prettify.css rendered-changes/
for filename in $filenames; do
    built_filename="build/${filename/%.xml/.html}"
    cp "$built_filename" rendered-changes/
done
