#!/bin/sh
# for one XEP, generates HTML file and IETF reference, then copies XML file
# usage: ./gen.sh xxxx 
# (where xxxx is the 4-digit XEP number)

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

# PRODUCTION
xeppath=/var/www/xmpp.org/extensions

xsltproc xep.xsl xep-$1.xml > $xeppath/xep-$1.html
xsltproc ref.xsl xep-$1.xml > $xeppath/refs/reference.XSF.XEP-$1.xml

cp xep-$1.xml $xeppath/

# END
