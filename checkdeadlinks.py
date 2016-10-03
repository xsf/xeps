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

'''
A script for checking XEPs for dead links.
'''

from argparse import ArgumentParser
import sys
import re
import urllib2

from xml.dom.minidom import parse

def is_dead(url):
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
                print "XEP-" + xepnum + " - DEAD: " + url + " [" + reason + "]"
            return True
        else:
            if verbose:
                print 'OK'
            return False
    else:
        return False

def main():
    parser = ArgumentParser(description=__doc__)
    parser.add_argument('-v', '--verbose', action='store_true', help='Enables more verbosity')
    parser.add_argument('-x', '--xep', type=int, help='Defines the number of the XEP to check')
    args = parser.parse_args()

    global xepnum
    xepnum = '%04d' % args.xep

    global verbose
    verbose = args.verbose

    xepfile = 'xep-' + xepnum + '.xml'
    thexep = parse(xepfile)

    if verbose:
        print 'Checking XEP-' + xepnum + ':'

    urls = [link.getAttribute("url") for link in thexep.getElementsByTagName("link")]
    urls += [image.getAttribute("src") for image in thexep.getElementsByTagName("img")]

    deadlinks = [url for url in set(urls) if is_dead(url)]

    if deadlinks:
        for url in deadlinks:
            print url
        sys.exit(1)

if __name__ == "__main__":
    main()
