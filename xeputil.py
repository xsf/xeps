# File: xeputil.py
# Version: 0.1
# Description: xep utility functions 
# Last Modified: 2010
# Author: Tobias Markmann (tm@ayena.de)

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

import pysvn
import os
import tempfile
from xepinfo import XEPInfo
from xml.dom.minidom import parse,parseString,Document,getDOMImplementation

def getText(nodelist):
    thisText = ""
    for node in nodelist:
        if node.nodeType == node.TEXT_NODE:
            thisText = thisText + node.data
    return thisText

class XEP:
	def __init__(self, BASEDIR, nr):
		self.nr = nr
		self.BASEDIR = BASEDIR

	def revisions(self):
		client = pysvn.Client(self.BASEDIR);
		rev = client.info("xep-" + self.nr + ".xml").revision.number
		log = client.log("xep-" + self.nr + ".xml", pysvn.Revision( pysvn.opt_revision_kind.number, 0 ),pysvn.Revision( pysvn.opt_revision_kind.number, rev ), True)

		revs = []
		for l in log:
			revs.append(l.revision.number)
		return sorted(revs)

	def contentOfRevision(self, revision):
		client = pysvn.Client(self.BASEDIR);

		# load content for that revision
		file_text = client.cat( "xep-" + self.nr + ".xml", pysvn.Revision( pysvn.opt_revision_kind.number, revision))
		return file_text


def getLatestXEPFilename(XEPDIR, nr, no_interim=True):
    try:
        xep = XEP(XEPDIR, nr)
        revs = xep.revisions()
        revs.reverse()
        content = ""
        if no_interim:
            for rev in revs:
                tmp_content = xep.contentOfRevision(rev)
		info = XEPInfo(tmp_content, " ")
                if not info.interim:
                    content = tmp_content
                    break;

        else:
            content = xep.contentOfRevision(revs[len(revs)-1])

        (fd, name) = tempfile.mkstemp();
        handle = os.fdopen(fd, "w+b")
        handle.write(content)
        handle.close()
        return name;
    except:
        return False;
