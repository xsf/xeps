#!/usr/bin/env python

# File: announce.py
# Version: 0.8
# Description: a script for announcing XEPs
# Last Modified: 2006-10-03
# Author: Peter Saint-Andre (stpeter@jabber.org)
# License: public domain
# HowTo: ./announce.py xepnum dbuser dbpw 'cvsmodsurl'
#        NOTE: the cvsmodsurl MUST be in quotes!

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
# 2. database user
# 3. database password

xepnum = sys.argv[1];
dbuser = sys.argv[2];
dbpw = sys.argv[3];
mods = sys.argv[4];

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
elif (xepstatus == "Deferred"):
    xepflag = "defer"

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
theNotes = "Version " + version + " of XEP-" + xepnum + " released " + date + "."
theLog = remark + " (" + initials + ")"
if xepflag == "new":
    theStatement = "INSERT INTO jeps VALUES ('" + str(xepnum) + "', '" + title + "', '" + xeptype + "', '" + xepstatus + "', '" + theNotes + "', '" + str(version) + "', '" + str(now) + "', '" + abstract + "', '" + theLog + "', '0', '5', 'Proposed', 'none');"
    cursor.execute(theStatement)
else:
    theStatement = "UPDATE jeps SET name='" + title + "', type='" + xeptype + "', status='" + xepstatus + "', notes='" + theNotes + "', version='" + str(version) + "', last_modified='" + str(now) + "', abstract='" + abstract + "', changelog='" + theLog + "' WHERE number='" + str(xepnum) + "';"
    cursor.execute(theStatement) 
result = cursor.fetchall()

## SEND MAIL:
#
# From: editor@jabber.org
# To: standards-jig@jabber.org
# Subject: UPDATED: XEP-$xepnum ($title)
# [or "NEW..." if version 0.1]
# Body:
#    Version $version of XEP-$xepnum ($title) is now available.
#    Abstract: $abstract
#    Changelog: $remark ($initials)
#    CVS Diff: $mods
#    URL: http://www.xmpp.org/extensions/xep-$xepnum.html

fromaddr = "editor@jabber.org"
# for testing...
# toaddrs = "stpeter@jabber.org"
# for real...
toaddrs = "standards-jig@jabber.org"

if xepflag == "new":
    thesubject = 'NEW: XEP-'
elif xepflag == "draft":
    thesubject = 'DRAFT: XEP-'
    toaddrs = toaddrs + ", jdev@jabber.org"
elif xepflag == "final":
    thesubject = 'FINAL: XEP-'
    toaddrs = toaddrs + ", jdev@jabber.org"
elif xepflag == "active":
    thesubject = 'ACTIVE: XEP-'
elif xepflag == "retract":
    thesubject = 'RETRACTED: XEP-'
elif xepflag == "defer":
    thesubject = 'DEFERRED: XEP-'
else:
    thesubject = 'UPDATED: XEP-'
thesubject = thesubject + xepnum + ' (' + title + ')'

versionline = 'Version ' + version + ' of XEP-' + xepnum + ' (' + title + ') has been released.' 
abstractline = 'Abstract: ' + abstract
changelogline = 'Changelog: ' + remark + ' (' + initials + ')'
modsline = 'CVS Diff: ' + mods
urlline = 'URL: http://www.xmpp.org/extensions/xep-' + xepnum + '.html'

msg = "From: XMPP Extensions Editor <%s>\r\n" % fromaddr
msg = msg + "To: %s\r\n" % toaddrs
msg = msg + "Subject: %s\r\n" % thesubject
msg = msg + versionline
msg = msg + "\r\n\n"
msg = msg + abstractline
msg = msg + "\r\n\n"
msg = msg + changelogline
msg = msg + "\r\n\n"
msg = msg + modsline
msg = msg + "\r\n\n"
msg = msg + urlline
msg = msg + "\r\n\n"

server = smtplib.SMTP('localhost')
server.set_debuglevel(1)
server.sendmail(fromaddr, toaddrs, msg)
server.quit()

# END

