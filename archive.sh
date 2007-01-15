#!/bin/sh
# archive an old version of a XEP (before publishing new version)
# usage: ./archive.sh xepnum version 

# STAGE
#xeppath=/var/www/stage.xmpp.org/extensions
# PRODUCTION
xeppath=/var/www/xmpp.org/extensions

cp $xeppath/xep-$1.html $xeppath/attic/xep-$1-$2.html

# end
