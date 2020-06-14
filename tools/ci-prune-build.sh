#!/bin/bash
set -euo pipefail
outdir="build"
# clean out tex build logs etc.
find "$outdir" -type f '(' -iname "*.aux" -o -iname "*.log" -o -iname "*.toc" -o -iname "*.tex" -o -iname "*.tex.xml" -o -iname "*.out" ')' -print0 | xargs -0r -- rm

find "$outdir" -type f '(' -iname "*.xml" -o -iname "*.html" -o -iname "*.pdf" ')' -print0 | while read -d $'\0' filename; do
    if [ "$filename" = 'build/xmpp.pdf' ] || [ "$filename" = 'build/xmpp-text.pdf' ] || [ "$filename" = 'build/xeplist.xml' ]; then
        continue
    fi

    if [[ "$filename" =~ build/refs/reference.*.xml ]]; then
        base_filename="$(echo "$filename" | sed -r 's#^build/refs/reference\.XSF\.XEP-([0-9]+)\.xml#xep-\1.xml#')"
    else
        base_filename="$(echo "$filename" | sed -r 's#^build/(.+)\.[^.]+$#\1.xml#')"
    fi

    if [ ! -e "$base_filename" ]; then
        printf 'deleting %q for which no source file (%q) exists\n' "$filename" "$base_filename"
        rm "$filename"
    fi
done
