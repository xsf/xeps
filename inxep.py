#!/usr/bin/env python

# File: inxep.py
# Version: 0.1
# Description: a script for announcing proto-XEPs
# Last Modified: 2004-09-14
# Author: Peter Saint-Andre (stpeter@jabber.org)
# License: public domain
# HowTo: ./inxep.py filename
# (note: do not include extension!)

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

# READ IN ARGS: 
#
# 1. XEP filename (sans extension)

xepname = sys.argv[1];

xepfile = xepname + '.xml'

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
# From: editor@jabber.org
# To: standards-jig@jabber.org
# Subject: Proposed XMPP Extension: XEP-$xepnum ($title)
# Body:
#    The XMPP Extensions Editor has received a proposal for a new XEP.
#
#    Title: $title
#
#    Abstract: $abstract
#
#    URL: http://www.xmpp.org/extensions/inbox/$xepname.html
#
#    The XMPP Council will now consider whether to accept
#    this proposal as a full XEP.
#

fromaddr = "editor@jabber.org"
# for testing...
# toaddrs = "stpeter@jabber.org"
# for real...
toaddrs = "standards-jig@jabber.org"

thesubject = 'Proposed XMPP Extension: ' + title
introline = 'The XMPP Extensions Editor has received a proposal for a new XEP.'
titleline = 'Title: ' + title
abstractline = 'Abstract: ' + abstract
urlline = 'URL: http://www.xmpp.org/extensions/inbox/' + xepname + '.html'
actionline = 'The XMPP Council will decide within 7 days (or at its next meeting) whether to accept this proposal as an official XEP.'

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

