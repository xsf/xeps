#!/bin/sh
# archive an old version of a XEP (before publishing new version)
# usage: ./archive.sh xepnum version 

xeppath=/var/www/xmpp.org/extensions

cp $xeppath/xep-$1.html $xeppath/attic/xep-$1-$2.html

# end
