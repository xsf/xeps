#!/usr/bin/env python

# File: lastcall.py
# Version: 0.2
# Description: a script for announcing Last Calls
# Last Modified: 2004-09-29
# Author: Peter Saint-Andre (stpeter@jabber.org)
# License: public domain
# HowTo: ./lastcall.py jepnum enddate dbuser dbpw

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

jepnum = sys.argv[1];
enddate = sys.argv[2];
dbuser = sys.argv[3];
dbpw = sys.argv[4];

jepfile = jepnum + '/jep-' + jepnum + '.xml'

# PARSE XEP HEADERS:
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

# UPDATE DATABASE:
#
# number is $jepnum
# name is $title
# type is $jeptype
# status is $jepstatus
# notes is "Version $version of XEP-$jepnum released $date."
# version is $version
# last_modified is $now
# abstract is $abstract
# changelog is "$remark ($initials)"

db = MySQLdb.connect("localhost", dbuser, dbpw, "foundation")
cursor = db.cursor()
theNotes = "Version " + version + " of XEP-" + jepnum + " released " + date + "; Last Call ends " + enddate + "."
theLog = remark + " (" + initials + ")"
theStatement = "UPDATE jeps SET name='" + title + "', type='" + jeptype + "', status='Proposed', notes='" + theNotes + "', version='" + str(version) + "', last_modified='" + str(now) + "', abstract='" + abstract + "', changelog='" + theLog + "' WHERE number='" + str(jepnum) + "';"
cursor.execute(theStatement) 
result = cursor.fetchall()

# SEND MAIL:
#
# From: editor@jabber.org
# To: standards-jig@jabber.org
# Subject: LAST CALL: XEP-$jepnum ($title)
# Body:
#    This message constitutes notice of a Last Call
#    for XEP-$jepnum ($title).
#
#    Abstract: $abstract
#
#    URL: http://www.jabber.org/jeps/jep-$jepnum.html
#
#    This Last Call begins now and shall end at the close
#    of business on $enddate.
#

fromaddr = "editor@jabber.org"
# for testing...
# toaddrs = "stpeter@jabber.org"
# for real...
toaddrs = "standards-jig@jabber.org"

thesubject = 'LAST CALL: XEP-' + jepnum + " (" + title + ")"
introline = 'This message constitutes notice of a Last Call for XEP-' + jepnum + ' (' + title + ').'
abstractline = 'Abstract: ' + abstract
urlline = 'URL: http://www.jabber.org/jeps/jep-' + jepnum + '.html'
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

