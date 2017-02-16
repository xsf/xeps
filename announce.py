#!/usr/bin/env python

# File: announce.py
# Version: 0.9
# Description: a script for announcing XEPs
# Last Modified: 2016-10-03
# Author: Peter Saint-Andre (stpeter@jabber.org)
# License: public domain
# HowTo: ./announce.py xepnum

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

# IMPORTS:
#
import glob
import os
from select import select
import smtplib
import socket
from string import split,strip,join,find
import sys
import time
from xml.dom.minidom import parse,parseString,Document

def getText(nodelist):
    thisText = ""
    for node in nodelist:
        if node.nodeType == node.TEXT_NODE:
            thisText = thisText + node.data
    return thisText

# get the seconds in the Unix era
now = int(time.time())

# READ IN ARGS: 
#
# 1. XEP number

xepnum = sys.argv[1];

xepfile = 'xep-' + xepnum + '.xml'

# PARSE XEP HEADERS:
#
# - title
# - abstract
# - version
# - date
# - initials
# - remark

thexep = parse(xepfile)
xepNode = (thexep.getElementsByTagName("xep")[0])
headerNode = (xepNode.getElementsByTagName("header")[0])
titleNode = (headerNode.getElementsByTagName("title")[0])
title = getText(titleNode.childNodes)
abstractNode = (headerNode.getElementsByTagName("abstract")[0])
abstract = getText(abstractNode.childNodes)
statusNode = (headerNode.getElementsByTagName("status")[0])
xepstatus = getText(statusNode.childNodes)
typeNode = (headerNode.getElementsByTagName("type")[0])
xeptype = getText(typeNode.childNodes)
revNodes = headerNode.getElementsByTagName("revision")
revNode = revNodes[0]
versionNode = (revNode.getElementsByTagName("version")[0])
version = getText(versionNode.childNodes)
dateNode = (revNode.getElementsByTagName("date")[0])
date = getText(dateNode.childNodes)
initialsNode = (revNode.getElementsByTagName("initials")[0])
initials = getText(initialsNode.childNodes)
remNode = (revNode.getElementsByTagName("remark")[0])
# could be <p> or <ul>
testRemarkNode = remNode.firstChild.nodeName
# print testRemarkNode
if (testRemarkNode == "p"):
    remarkNode = (remNode.getElementsByTagName("p")[0])
    remark = getText(remarkNode.childNodes)
else:
    remark = "[See revision history]"

# what kind of action are we taking?
xepflag = ""
if (version == "0.1"):
    xepflag = "new"
elif ((version == "1.0") & (xeptype == "Standards Track")):
    xepflag = "draft"
elif ((version == "1.0") & (xeptype != "Standards Track")):
    xepflag = "active"
elif (version == "2.0"):
    xepflag = "final"
elif (xepstatus == "Retracted"):
    xepflag = "retract"
elif (xepstatus == "Deprecated"):
    xepflag = "deprecate"
elif (xepstatus == "Obsolete"):
    xepflag = "obsolete"
elif (xepstatus == "Deferred"):
    xepflag = "defer"

# generate the diffs URL
if len(revNodes) > 1:
    prevRevNode = revNodes[1]
    prevVersionNode = (prevRevNode.getElementsByTagName("version")[0])
    prevVersion = getText(prevVersionNode.childNodes)
    diffs = 'https://xmpp.org/extensions/diff/api/xep/' + xepnum + '/diff/' + prevVersion + '/vs/' + version
else:
    diffs = 'N/A'

## SEND MAIL:
#
# From: editor@xmpp.org
# To: standards@xmpp.org
# Subject: UPDATED: XEP-$xepnum ($title)
# [or "NEW..." if version 0.1]
# Body:
#    Version $version of XEP-$xepnum ($title) is now available.
#    Abstract: $abstract
#    Changelog: $remark ($initials)
#    Diff: $diffs   ### no longer in use
#    URL: https://xmpp.org/extensions/xep-$xepnum.html

fromaddr = "editor@xmpp.org"
# for testing...
# toaddrs = "stpeter@jabber.org"
# for real...
toaddrs = "standards@xmpp.org"

if xepflag == "new":
    thesubject = 'NEW: XEP-'
elif xepflag == "draft":
    thesubject = 'DRAFT: XEP-'
elif xepflag == "final":
    thesubject = 'FINAL: XEP-'
elif xepflag == "active":
    thesubject = 'ACTIVE: XEP-'
elif xepflag == "retract":
    thesubject = 'RETRACTED: XEP-'
elif xepflag == "deprecate":
    thesubject = 'DEPRECATED: XEP-'
elif xepflag == "obsolete":
    thesubject = 'OBSOLETE: XEP-'
elif xepflag == "defer":
    thesubject = 'DEFERRED: XEP-'
else:
    thesubject = 'UPDATED: XEP-'
thesubject = thesubject + xepnum + ' (' + title + ')'

versionline = 'Version ' + version + ' of XEP-' + xepnum + ' (' + title + ') has been released.' 
abstractline = 'Abstract: ' + abstract
changelogline = 'Changelog: ' + remark + ' (' + initials + ')'
diffsline = 'Diff: ' + diffs
urlline = 'URL: https://xmpp.org/extensions/xep-' + xepnum + '.html'

msg = "From: XMPP Extensions Editor <%s>\r\n" % fromaddr
msg = msg + "To: %s\r\n" % toaddrs
msg = msg + "Subject: %s\r\n" % thesubject
msg = msg + versionline
msg = msg + "\r\n\n"
msg = msg + abstractline
msg = msg + "\r\n\n"
msg = msg + changelogline
msg = msg + "\r\n\n"
msg = msg + diffsline
msg = msg + "\r\n\n"
msg = msg + urlline
msg = msg + "\r\n\n"

server = smtplib.SMTP('localhost')
server.set_debuglevel(1)
server.sendmail(fromaddr, toaddrs, msg)
server.quit()

# END

