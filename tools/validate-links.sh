#!/bin/bash

# Checks that all links in the provided file (filename to be provided as first argument) are either absolute URIs (e.g.
# 'https://xmpp.org/extensions/xep-0001.html') or references to an anchor within the same document (e.g. '#intro').
# See https://github.com/xsf/xeps/issues/338
#
# Relative links (such as 'xep-0001.html', or an anchor name that lacks the leading '#') only resolve when the document
# is served from one particular location, and do not work at all in the PDF rendition of a XEP.
#
# Expected to be executed from the directory that holds all xep XML files.
# Requires one argument: the file name of the xep to be validated, eg:
#
# $ tools/validate-links.sh xep-0010.xml
#
# exit status will be non-zero upon validation failure.
#
# requires: bash, xmllint

set -euo pipefail

# ANSI color definitions
ANSI_PASS='\033[1;92m';
ANSI_FAIL='\033[1;91m';
ANSI_RESET='\033[0m';

# Selects every link whose URL (which may be missing) neither starts with '#', nor with a URI scheme (RFC 3986, section
# 3.1) followed by a colon. Entities are expanded, so that links defined in (local) entity declarations are checked too.
relative_links_xpath="//link[not(starts-with(@url, '#')) and not(substring-before(@url, ':') != '' and translate(substring-before(@url, ':'), 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789+-.', '') = '')]"

echo -e "Start validating links in file '$1'."
echo ""

# The matches are counted rather than relying on the exit status of xmllint for an empty result, as the latter differs
# between libxml2 versions (see https://github.com/xsf/xeps/issues/1316).
if ! relative_links_count=$(xmllint --nonet --noent --loaddtd --xpath "count($relative_links_xpath)" "$1")
then
  echo -e "${ANSI_FAIL}[FAIL]${ANSI_RESET} The file could not be parsed (see the error(s) above)."
  echo ""
  echo "Issues found!"
  exit 1
fi

if [ "$relative_links_count" = "0" ]
then
  echo -e "${ANSI_PASS}[PASS]${ANSI_RESET} All links are absolute URIs or references to an anchor in the same document."
  echo ""
  echo "No issues found."
  exit 0
fi

echo -e "${ANSI_FAIL}[FAIL]${ANSI_RESET} Found $relative_links_count link(s) that are neither an absolute URI nor a reference to an anchor in the same document (but should be):"
xmllint --nonet --noent --loaddtd --xpath "$relative_links_xpath" "$1" | sed 's/^ */       /'
echo ""
echo "       Use an absolute URI (e.g. 'https://xmpp.org/extensions/xep-0001.html#intro') for links to other documents,"
echo "       and prefix the anchor name with '#' (e.g. '#intro') for links to a section in the same document."
echo ""
echo "Issues found!"
exit 1
