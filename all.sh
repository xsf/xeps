#!/bin/sh
# for all XEPs, generates HTML files and IETF-style reference, then copies XML file
# usage: ./all.sh

xeppath=/var/www/xmpp.org/extensions

ls xep-0*.xml > tmp1.txt
sed s/^xep-// tmp1.txt > tmp2.txt
sed s/.xml$// tmp2.txt > nums.txt
rm tmp*.txt

while read f
do
    xsltproc xep.xsl xep-$f.xml > $xeppath/xep-$f.html
    xsltproc ref.xsl xep-$f.xml > $xeppath/refs/reference.JSF.XEP-$f.xml
    cp xep-$f.xml $xeppath/
done < nums.txt

rm nums.txt

xsltproc xep.xsl xep-README.xml > $xeppath/README.html
xsltproc xep.xsl xep-template.xml > $xeppath/template.html

cp *.dtd $xeppath/
cp *.ent $xeppath/
cp *.gif $xeppath/
cp *.html $xeppath/
cp *.shtml $xeppath/
cp *.xsd $xeppath/

# END
