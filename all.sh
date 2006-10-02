#!/bin/sh
# for each XEP, generates HTML file and IETF reference, then copies XML file
# also generates HTML for the README and template
# finally, copies the stylesheet, DTD, and schema
# usage: ./all.sh

xeppath=/var/www/stage.xmpp.org/extensions

ls xep-0*.xml > tmp.txt
sed s/xep-\(.*\).xml/\1/ tmp.txt > nums.txt
rm tmp.txt

while read f
do
    xsltproc xep.xsl xep-$f.xml > $xeppath/xep-$f.html
    xsltproc ref.xsl xep-$f.xml > $xeppath/refs/reference.JSF.XEP-$f.xml
    cp xep-$f.xml $xeppath/
done < nums.txt

rm nums.txt

xsltproc xep.xsl xep-README.xml > $xeppath/README.html
xsltproc xep.xsl xep-template.xml > $xeppath/template.html

cp xep.dtd $xeppath/
cp xep.ent $xeppath/
cp xep.xsd $xeppath/
cp xep.xsl $xeppath/

# END

