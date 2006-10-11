#!/usr/bin/env python

# File: lastcall.py
# Version: 0.3
# Description: a script for announcing Last Calls
# Last Modified: 2006-10-11
# Author: Peter Saint-Andre (stpeter@jabber.org)
# License: public domain
# HowTo: ./lastcall.py xepnum enddate dbuser dbpw

# IMPORTS:
#
import glob
import MySQLdb
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
# 3. database user
# 4. database password

xepnum = sys.argv[1];
enddate = sys.argv[2];
dbuser = sys.argv[3];
dbpw = sys.argv[4];

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

# UPDATE DATABASE:
#
# number is $xepnum
# name is $title
# type is $xeptype
# status is $xepstatus
# notes is "Version $version of XEP-$xepnum released $date."
# version is $version
# last_modified is $now
# abstract is $abstract
# changelog is "$remark ($initials)"

db = MySQLdb.connect("localhost", dbuser, dbpw, "foundation")
cursor = db.cursor()
theNotes = "Version " + version + " of XEP-" + xepnum + " released " + date + "; Last Call ends " + enddate + "."
theLog = remark + " (" + initials + ")"
theStatement = "UPDATE jeps SET name='" + title + "', type='" + xeptype + "', status='Proposed', notes='" + theNotes + "', version='" + str(version) + "', last_modified='" + str(now) + "', abstract='" + abstract + "', changelog='" + theLog + "' WHERE number='" + str(xepnum) + "';"
cursor.execute(theStatement) 
result = cursor.fetchall()

# SEND MAIL:
#
# From: editor@jabber.org
# To: standards-jig@jabber.org
# Subject: LAST CALL: XEP-$xepnum ($title)
# Body:
#    This message constitutes notice of a Last Call
#    for XEP-$xepnum ($title).
#
#    Abstract: $abstract
#
#    URL: http://www.xmpp.org/extensions/xep-$xepnum.html
#
#    This Last Call begins now and shall end at the close
#    of business on $enddate.
#

fromaddr = "editor@jabber.org"
# for testing...
# toaddrs = "stpeter@jabber.org"
# for real...
toaddrs = "standards-jig@jabber.org"

thesubject = 'LAST CALL: XEP-' + xepnum + " (" + title + ")"
introline = 'This message constitutes notice of a Last Call for XEP-' + xepnum + ' (' + title + ').'
abstractline = 'Abstract: ' + abstract
urlline = 'URL: http://www.xmpp.org/extensions/xep-' + xepnum + '.html'
schedline = 'This Last Call begins today and shall end at the close of business on ' + enddate + '.'

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
msg = msg + "\r\n"

server = smtplib.SMTP('localhost')
server.set_debuglevel(1)
server.sendmail(fromaddr, toaddrs, msg)
server.quit()

# END

