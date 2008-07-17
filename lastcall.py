#!/usr/bin/env python

# File: lastcall.py
# Version: 0.5
# Description: a script for announcing Last Calls
# Last Modified: 2007-05-16
# Author: Peter Saint-Andre (stpeter@jabber.org)
# License: public domain
# HowTo: ./lastcall.py xepnum enddate

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
# 2. end date

xepnum = sys.argv[1];
enddate = sys.argv[2];

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
# Subject: LAST CALL: XEP-$xepnum ($title)
# Body:
#    This message constitutes notice of a Last Call
#    for comments on XEP-$xepnum ($title).
#
#    Abstract: $abstract
#
#    URL: http://www.xmpp.org/extensions/xep-$xepnum.html
#
#    This Last Call begins today and shall end at the close
#    of business on $enddate.
#
#    Please consider the following questions during this Last Call and
#    send your feedback to the standards@xmpp.org discussion list:
#
#    1. Is this specification needed to fill gaps in the XMPP
#       protocol stack or to clarify an existing protocol?
#    2. Does the specification solve the problem stated in the 
#       introduction and requirements?
#    3. Do you plan to implement this specification in your code? 
#       If not, why not?
#    4. Do you have any security concerns related to this specification?
#    5. Is the specification accurate and clearly written?
#
#    Your feedback is appreciated!
#

fromaddr = "editor@xmpp.org"
# for testing...
# toaddrs = "stpeter@jabber.org"
# for real...
toaddrs = "standards@xmpp.org"

thesubject = 'LAST CALL: XEP-' + xepnum + " (" + title + ")"
introline = 'This message constitutes notice of a Last Call for comments on XEP-' + xepnum + ' (' + title + ').'
abstractline = 'Abstract: ' + abstract
urlline = 'URL: http://www.xmpp.org/extensions/xep-' + xepnum + '.html'
schedline = 'This Last Call begins today and shall end at the close of business on ' + enddate + '.'
qline0 = 'Please consider the following questions during this Last Call and send your feedback to the standards@xmpp.org discussion list:'
qline1 = '1. Is this specification needed to fill gaps in the XMPP protocol stack or to clarify an existing protocol?'
qline2 = '2. Does the specification solve the problem stated in the introduction and requirements?'
qline3 = '3. Do you plan to implement this specification in your code? If not, why not?'
qline4 = '4. Do you have any security concerns related to this specification?'
qline5 = '5. Is the specification accurate and clearly written?'
feedline = 'Your feedback is appreciated!'

#msg = "From: %s\r\n" % fromaddr
msg = "From: XMPP Extensions Editor <%s>\r\n" % fromaddr
msg = msg + "To: %s\r\n" % toaddrs
msg = msg + "Subject: %s\r\n" % thesubject
msg = msg + introline
msg = msg + "\r\n\n"
msg = msg + abstractline
msg = msg + "\r\n\n"
msg = msg + urlline
msg = msg + "\r\n\n"
msg = msg + schedline
msg = msg + "\r\n\n"
msg = msg + qline0
msg = msg + "\r\n\n"
msg = msg + qline1
msg = msg + "\r\n"
msg = msg + qline2
msg = msg + "\r\n"
msg = msg + qline3
msg = msg + "\r\n"
msg = msg + qline4
msg = msg + "\r\n"
msg = msg + qline5
msg = msg + "\r\n\n"
msg = msg + feedline
msg = msg + "\r\n"

server = smtplib.SMTP('localhost')
server.set_debuglevel(1)
server.sendmail(fromaddr, toaddrs, msg)
server.quit()

# END

