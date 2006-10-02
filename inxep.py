#!/usr/bin/env python

# File: protojep.py
# Version: 0.1
# Description: a script for announcing proto-JEPs
# Last Modified: 2004-09-14
# Author: Peter Saint-Andre (stpeter@jabber.org)
# License: public domain
# HowTo: ./protojep.py filename
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
# 1. JEP filename (sans extension)

jepname = sys.argv[1];

jepfile = 'inbox/' + jepname + '.xml'

# PARSE JEP HEADERS:
#
# - title
# - abstract
# - version
# - date
# - initials
# - remark

thejep = parse(jepfile)
jepNode = (thejep.getElementsByTagName("jep")[0])
headerNode = (jepNode.getElementsByTagName("header")[0])
titleNode = (headerNode.getElementsByTagName("title")[0])
title = getText(titleNode.childNodes)
abstractNode = (headerNode.getElementsByTagName("abstract")[0])
abstract = getText(abstractNode.childNodes)
statusNode = (headerNode.getElementsByTagName("status")[0])
jepstatus = getText(statusNode.childNodes)
typeNode = (headerNode.getElementsByTagName("type")[0])
jeptype = getText(typeNode.childNodes)
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
# Subject: LAST CALL: JEP-$jepnum ($title)
# Body:
#    The JEP Editor has received a proposal for a new JEP.
#
#    Title: $title
#
#    Abstract: $abstract
#
#    URL: http://www.jabber.org/jeps/inbox/$jepname.html
#
#    The Jabber Council will now consider whether to accept
#    this proposal as a full JEP.
#

fromaddr = "editor@jabber.org"
# for testing...
# toaddrs = "stpeter@jabber.org"
# for real...
toaddrs = "standards-jig@jabber.org"

thesubject = 'proto-JEP: ' + title
introline = 'The JEP Editor has received a proposal for a new JEP.'
titleline = 'Title: ' + title
abstractline = 'Abstract: ' + abstract
urlline = 'URL: http://www.jabber.org/jeps/inbox/' + jepname + '.html'
actionline = 'The Jabber Council will decide within 7 days (or at its next meeting) whether to accept this proposal as an official JEP.'

#msg = "From: %s\r\n" % fromaddr
msg = "From: JEP Editor <%s>\r\n" % fromaddr
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

