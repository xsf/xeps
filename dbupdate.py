#!/usr/bin/env python

# File: dbupdate.py
# Version: 0.1
# Description: a script for updating the XEP database
# Last Modified: 2006-12-07
# Author: Peter Saint-Andre (stpeter@jabber.org)
# License: public domain
# HowTo: ./dbupdate.py dbuser dbpw xepnum 

## LICENSE ##
#
# Copyright (c) 1999 - 2009 XMPP Standards Foundation
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
import MySQLdb
import os
from select import select
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

dbuser = sys.argv[1];
dbpw = sys.argv[2];
xepnum = sys.argv[3];

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

# END

