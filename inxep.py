#!/usr/bin/env python

# File: inxep.py
# Version: 0.1
# Description: a script for announcing proto-XEPs
# Last Modified: 2004-09-14
# Author: Peter Saint-Andre (stpeter@jabber.org)
# License: public domain
# HowTo: ./inxep.py filename approver
# (note: do not include extension!)

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

# READ in XEP filename (sans extension)

xepname = sys.argv[1];
if len(sys.argv) >= 3:
    approver = sys.argv[2]
else:
    approver = "XMPP Council"

xepfile = 'inbox/' + xepname + '.xml'

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
revNode = (headerNode.getElementsByTagName("revision")[0])
versionNode = (revNode.getElementsByTagName("version")[0])
version = getText(versionNode.childNodes)
dateNode = (revNode.getElementsByTagName("date")[0])
date = getText(dateNode.childNodes)
initialsNode = (revNode.getElementsByTagName("initials")[0])
initials = getText(initialsNode.childNodes)
remarkNode = (revNode.getElementsByTagName("remark")[0])
remark = getText(remarkNode.childNodes)

# SEND MAIL:
#
# From: editor@xmpp.org
# To: standards@xmpp.org
# Subject: Proposed XMPP Extension: XEP-$xepnum ($title)
# Body:
#    The XMPP Extensions Editor has received a proposal for a new XEP.
#
#    Title: $title
#
#    Abstract: $abstract
#
#    URL: https://xmpp.org/extensions/inbox/$xepname.html
#
#    The $approver will now consider whether to accept
#    this proposal as a full XEP.
#

fromaddr = "editor@xmpp.org"
# for testing...
# toaddrs = "editor@jabber.org"
# for real...
toaddrs = "standards@xmpp.org"

thesubject = 'Proposed XMPP Extension: ' + title
introline = 'The XMPP Extensions Editor has received a proposal for a new XEP.'
titleline = 'Title: ' + title
abstractline = 'Abstract: ' + abstract
urlline = 'URL: https://xmpp.org/extensions/inbox/' + xepname + '.html'
actionline = 'The ' + approver + ' will decide in the next two weeks whether to accept this proposal as an official XEP.'

msg = "From: XMPP Extensions Editor <%s>\r\n" % fromaddr
msg = msg + "To: %s\r\n" % toaddrs
msg = msg + "Subject: %s\r\n" % thesubject
msg = msg + introline
msg = msg + "\r\n\n"
msg = msg + titleline
msg = msg + "\r\n\n"
msg = msg + abstractline
msg = msg + "\r\n\n"
msg = msg + urlline
msg = msg + "\r\n\n"
msg = msg + actionline
msg = msg + "\r\n\n"

server = smtplib.SMTP('localhost')
server.set_debuglevel(1)
server.sendmail(fromaddr, toaddrs, msg)
server.quit()

# END
