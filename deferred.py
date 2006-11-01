#!/usr/bin/env python

# File: deferred.py
# Version: 0.3
# Description: a script for setting a XEP to Deferred
# Last Modified: 2006-11-01
# Author: Peter Saint-Andre (stpeter@jabber.org)
# License: public domain
# HowTo: ./deferred.py xepnum dbuser dbpw 

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
theNotes = "Version " + version + " of XEP-" + xepnum + " released " + date + "; consideration deferred because of inactivity."
theLog = remark + " (" + initials + ")"
theStatement = "UPDATE jeps SET name='" + title + "', type='" + xeptype + "', status='Deferred', notes='" + theNotes + "', version='" + str(version) + "', last_modified='" + str(now) + "', abstract='" + abstract + "', changelog='" + theLog + "' WHERE number='" + str(xepnum) + "';"
cursor.execute(theStatement) 
result = cursor.fetchall()

# SEND MAIL:
#
# From: editor@jabber.org
# To: standards-jig@jabber.org
# Subject: DEFERRED: XEP-$xepnum ($title)
# Body:
#    XEP-$xepnum ($title) has been Deferred because of inactivity.
#
#    Abstract: $abstract
#
#    URL: http://www.xmpp.org/extensions/xep-$xepnum.html
#
#    If and when a new revision of this XEP is published,
#    its status will be changed back to Experimental.
#

fromaddr = "editor@jabber.org"
# for testing...
# toaddrs = "stpeter@jabber.org"
# for real...
toaddrs = "standards-jig@jabber.org"

thesubject = 'DEFERRED: XEP-' + xepnum + " (" + title + ")"
introline = 'XEP-' + xepnum + ' (' + title + ') has been Deferred because of inactivity.'
abstractline = 'Abstract: ' + abstract
urlline = 'URL: http://www.xmpp.org/extensions/xep-' + xepnum + '.html'
endline = 'If and when a new revision of this XEP is published, its status will be changed back to Experimental.'

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
msg = msg + endline
msg = msg + "\r\n"

server = smtplib.SMTP('localhost')
server.set_debuglevel(1)
server.sendmail(fromaddr, toaddrs, msg)
server.quit()

# END

