#!/bin/sh
# makes protocol pages at http://www.jabber.org/protocol/foo/
# usage: ./schemagen.sh

## LICENSE ##
#
# Copyright (c) 1999 - 2009 XMPP Standards Foundation
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

protopath=/var/www/jabber.org/protocol

xsltproc protopage.xsl xep-0003.xml > $protopath/pass/index.html
xsltproc protopage.xsl xep-0004.xml > $protopath/x-data/index.html
xsltproc protopage.xsl xep-0009.xml > $protopath/jabber-rpc/index.html
xsltproc protopage.xsl xep-0011.xml > $protopath/iq-browse/index.html
xsltproc protopage.xsl xep-0012.xml > $protopath/iq-last/index.html
xsltproc protopage.xsl xep-0013.xml > $protopath/offline/index.html
xsltproc protopage.xsl xep-0020.xml > $protopath/feature-neg/index.html
xsltproc protopage.xsl xep-0022.xml > $protopath/x-event/index.html
xsltproc protopage.xsl xep-0023.xml > $protopath/x-expire/index.html
xsltproc protopage.xsl xep-0027.xml > $protopath/openpgp/index.html
xsltproc protopage.xsl xep-0030.xml > $protopath/disco/index.html
xsltproc protopage.xsl xep-0033.xml > $protopath/address/index.html
xsltproc protopage.xsl xep-0045.xml > $protopath/muc/index.html
xsltproc protopage.xsl xep-0047.xml > $protopath/ibb/index.html
xsltproc protopage.xsl xep-0048.xml > $protopath/bookmarks/index.html
xsltproc protopage.xsl xep-0049.xml > $protopath/iq-private/index.html
xsltproc protopage.xsl xep-0050.xml > $protopath/commands/index.html
xsltproc protopage.xsl xep-0055.xml > $protopath/iq-search/index.html
xsltproc protopage.xsl xep-0059.xml > $protopath/rsm/index.html
xsltproc protopage.xsl xep-0060.xml > $protopath/pubsub/index.html
xsltproc protopage.xsl xep-0065.xml > $protopath/bytestreams/index.html
xsltproc protopage.xsl xep-0066.xml > $protopath/oob/index.html
xsltproc protopage.xsl xep-0070.xml > $protopath/http-auth/index.html
xsltproc protopage.xsl xep-0071.xml > $protopath/xhtml-im/index.html
xsltproc protopage.xsl xep-0072.xml > $protopath/soap/index.html
xsltproc protopage.xsl xep-0077.xml > $protopath/iq-register/index.html
xsltproc protopage.xsl xep-0078.xml > $protopath/iq-auth/index.html
xsltproc protopage.xsl xep-0079.xml > $protopath/amp/index.html
xsltproc protopage.xsl xep-0080.xml > $protopath/geoloc/index.html
xsltproc protopage.xsl xep-0083.xml > $protopath/nestedgroups/index.html
xsltproc protopage.xsl xep-0085.xml > $protopath/chatstates/index.html
xsltproc protopage.xsl xep-0090.xml > $protopath/iq-time/index.html
xsltproc protopage.xsl xep-0091.xml > $protopath/x-delay/index.html
xsltproc protopage.xsl xep-0092.xml > $protopath/iq-version/index.html
xsltproc protopage.xsl xep-0093.xml > $protopath/x-roster/index.html
xsltproc protopage.xsl xep-0095.xml > $protopath/si/index.html
xsltproc protopage.xsl xep-0096.xml > $protopath/si/profile/file-transfer/index.html
xsltproc protopage.xsl xep-0100.xml > $protopath/iq-gateway/index.html
xsltproc protopage.xsl xep-0107.xml > $protopath/mood/index.html
xsltproc protopage.xsl xep-0108.xml > $protopath/activity/index.html
xsltproc protopage.xsl xep-0112.xml > $protopath/physloc/index.html
xsltproc protopage.xsl xep-0114.xml > $protopath/component/index.html
xsltproc protopage.xsl xep-0115.xml > $protopath/caps/index.html
xsltproc protopage.xsl xep-0118.xml > $protopath/tune/index.html
xsltproc protopage.xsl xep-0122.xml > $protopath/xdata-validate/index.html
xsltproc protopage.xsl xep-0124.xml > $protopath/httpbind/index.html
xsltproc protopage.xsl xep-0130.xml > $protopath/waitinglist/index.html
xsltproc protopage.xsl xep-0131.xml > $protopath/shim/index.html
xsltproc protopage.xsl xep-0137.xml > $protopath/sipub/index.html
xsltproc protopage.xsl xep-0138.xml > $protopath/compress/index.html
xsltproc protopage.xsl xep-0141.xml > $protopath/xdata-layout/index.html
xsltproc protopage.xsl xep-0144.xml > $protopath/rosterx/index.html
xsltproc protopage.xsl xep-0145.xml > $protopath/rosternotes/index.html
xsltproc protopage.xsl xep-0153.xml > $protopath/vcard-avatar/index.html
xsltproc protopage.xsl xep-0172.xml > $protopath/nick/index.html

# END
