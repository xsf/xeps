#!/bin/bash
# md-diff
# arguments: file commit commit [diff tool with args]

if [ $# -lt 3 ]; then
	echo 'arguments: file commit commit [diff tool with args]' >&2
	exit 1;
fi

${4:-diff} \
	<(git show "$2:$1" | ${0%/*}/xep2md.sh -) \
	<(git show "$3:$1"  | ${0%/*}/xep2md.sh -)
