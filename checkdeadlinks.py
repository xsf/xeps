#!/usr/bin/env python

# File: checkdeadlinks.py
# Version: 0.1
# Description: a script for checking XEPs for dead links
# Last Modified: 2009-04-06
# Author: Tobias Markmann (tm@ayena.de)
# License: public domain
# HowTo: ./checkdeadlinks.py xepnum

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

import glob
import os
from select import select
import socket
from string import split,strip,join,find
import sys
import time
import re
import urllib

from xml.dom.minidom import parse,parseString,Document

xepnum = sys.argv[1];

xepfile = 'xep-' + xepnum + '.xml'
thexep = parse(xepfile)

links = thexep.getElementsByTagName("link")
deadlinks = 0

for link in links:
	url = link.getAttribute("url")
	if re.match("^(http|https)", url):
		try:
			urllib.urlopen(url)
		except:
			print "dead-url: " + url
			deadlinks = deadlinks + 1

if deadlinks < 1:
	print "all http/https links are good"
	