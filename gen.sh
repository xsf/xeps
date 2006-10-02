#!/bin/sh
# for one XEP, generates HTML file and IETF reference, then copies XML file
# usage: ./gen.sh xxxx 
# (where xxxx is the 4-digit XEP number)

xeppath=/var/www/stage.xmpp.org/extensions

xsltproc xep.xsl xep-$1.xml > $xeppath/jep-$1.html
xsltproc ref.xsl xep-$1.xml > $xeppath/refs/reference.JSF.XEP-$1.xml
cp xep-$1.xml $xeppath/

# end
