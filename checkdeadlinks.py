#!/usr/bin/env python

# File: checkdeadlinks.py
# Version: 0.1
# Description: a script for checking XEPs for dead links
# Last Modified: 2009-04-06
# Author: Tobias Markmann (tm@ayena.de)
# License: public domain
# HowTo: ./checkdeadlinks.py --xep=xepnum

## LICENSE ##
#
# Copyright (c) 1999 - 2010 XMPP Standards Foundation
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
import getopt
from string import split,strip,join,find
import sys
import time
import re
import urllib
import urllib2

from xml.dom.minidom import parse,parseString,Document

def usage():
    print "checkdeadlinks.py"
    print ""
    print "-h, --help           Print this help message"
    print "-x, --xep [number]   Defines the number of the XEP to check"
    print "-v, --verbose        Enables more verbosity"

def main(argv):
    try:
        opts, args = getopt.gnu_getopt(argv, "hv:x", ["help", "verbose", "xep="])
    except getopt.GetoptError:
        usage()
        sys.exit(2)

    global verbose
    verbose = 0
    for opt, arg in opts:
        if opt in ("-h", "--help"):
            usage()
            sys.exit()
        elif opt in ("-x", "--xep"):
            global xepnum
            xepnum = arg
        elif opt in ("-v", "--verbose"):
            verbose = 1

    xepfile = 'xep-' + xepnum + '.xml'
    thexep = parse(xepfile)

    links = thexep.getElementsByTagName("link")
    deadlinks = 0
    if verbose:
        print 'Checking XEP-' + xepnum + ':'

    for link in links:
        url = link.getAttribute("url")
        if re.match("^(http|https)", url):
            if verbose:
                print url + ' :',
            page = 0
            try:
                request = urllib2.Request(url)
                request.add_header('User-Agent', "Mozilla/5.001 (windows; U; NT4.0; en-US; rv:1.0) Gecko/25250101")
                opener = urllib2.build_opener()
                page = opener.open(request).read()
            except Exception, e:
                reason = str(e)
                if verbose:
                    print "DEAD"
                else:
                    print "XEP-" + xepnum + " - DEAD: " + url + " [" + reason + "]"
                deadlinks = deadlinks + 1
            else:
                if verbose:
                    print 'OK'

    #if deadlinks = 0:
        #print "all http/https links are good"

if __name__ == "__main__":
    main(sys.argv[1:])
