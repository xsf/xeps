#!/bin/sh
# for all XEPs, generates HTML files and IETF-style reference, then copies XML file
# usage: ./all.sh

## LICENSE ##
#
# Copyright (c) 1999 - 2008 XMPP Standards Foundation
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#
## END LICENSE ##

xeppath=/var/www/vhosts/xmpp.org/extensions

ls xep-0*.xml > tmp1.txt
sed s/^xep-// tmp1.txt > tmp2.txt
sed s/.xml$// tmp2.txt > nums.txt
rm tmp*.txt

while read f
do
    xsltproc xep.xsl xep-$f.xml > $xeppath/xep-$f.html
    xsltproc ref.xsl xep-$f.xml > $xeppath/refs/reference.XSF.XEP-$f.xml
    xsltproc examples.xsl xep-$f.xml > $xeppath/examples/$f.xml
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
