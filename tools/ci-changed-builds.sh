#!/bin/bash
set -euo pipefail
IFS=$'\n'
if ! merge_base="$(git merge-base "$1" HEAD)"; then
    echo 'Failed to find merge base to detect changed files' >&2
    echo 'This indicates that your branch is too old and needs to be rebased' >&2
    exit 2
fi
filenames="$(git diff-tree -r --no-commit-id --name-status "$merge_base" HEAD | ( grep -P '^[AM]\t(xep-[0-9]{4}|inbox/[^/]+)\.xml$' || true) | cut -f2)"
if [ -z "$filenames" ]; then
    exit 0
fi
mkdir -p rendered-changes/
cp xmpp.css prettify.css rendered-changes/
for filename in $filenames; do
    built_filename="build/${filename/%.xml/.html}"
    cp "$built_filename" rendered-changes/
done
