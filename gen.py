#!/usr/bin/env python

# File: all.py
# Version: 0.1
# Description: a renewed XEP compilation tool
# Last Modified: 2009
# Author: Tobias Markmann (tm@ayena.de)
# License: public domain
# HowTo: ./all.py

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

import pickle
import commands
import os
import re
import sys
import getopt

XEPPATH = "/var/www/vhosts/xmpp.org/extensions"
BUILDDICT = "/var/xsf/xepbuild.dict"

verbose = 0
last_build = {}

def filebase( filename ):
	return os.path.splitext(os.path.basename(filename))[0]


def fileHash( filename ):
	f = open(filename, "rb") 
	import hashlib 
	h = hashlib.sha1() 
	h.update(f.read()) 
	hash = h.hexdigest() 
	f.close()
	return hash

def loadDict( filename ):
	try:
		f = open(filename, "rb")
		di = pickle.load(f)
		f.close()
		return di
	except:
		print "failed loading dict."
		return {}
	
def saveDict( filename, di ):
	f = open(filename, "w")
	pickle.dump(di, f)
	f.close()

def buildXHTML( file ):
	nr = re.match("xep-(\d\d\d\d).xml", file).group(1)
	error, desc = commands.getstatusoutput("xsltproc xep.xsl xep-" + nr + ".xml > " + XEPPATH + "/xep-" + nr + ".html")
	if error != 0:
		return False
		
	error, desc = commands.getstatusoutput("xsltproc ref.xsl xep-" + nr + ".xml > " + XEPPATH + "/refs/reference.XSF.XEP-" + nr + ".xml")
	if error != 0:
		return False
	
	error, desc = commands.getstatusoutput("xsltproc examples.xsl xep-" + nr + ".xml > " + XEPPATH + "/examples/" + nr + ".xml")
	if error != 0:
		return False
	
	error, desc = commands.getstatusoutput(" cp xep-" + nr + ".xml " + XEPPATH + "/")
	if error != 0:
		return False
	return True

def buildPDF( file ):
	nr = re.match("xep-(\d\d\d\d).xml", file).group(1)
	
	error, desc = commands.getstatusoutput("xsltproc -o /tmp/xepbuilder/xep-" + nr + ".tex.xml xep2texml.xsl xep-" + nr + ".xml")
	if error != 0:
		if verbose == 1:
			print "Error: ", desc
		return False
	
	error, desc = commands.getstatusoutput("texml -e utf8 /tmp/xepbuilder/xep-" + nr + ".tex.xml /tmp/xepbuilder/xep-" + nr + ".tex")
	if error != 0:
		if verbose == 1:
			print "Error: ", desc
		return False
	
	#detect http urls and escape them to make them breakable
	error, desc = commands.getstatusoutput('''sed -i 's|\([\s"]\)\(http://[^ "]*\)|\1\\path{\2}|g' /tmp/xepbuilder/xep-''' + nr + ".tex")
	if error != 0:
		if verbose == 1:
			print "Error: ", desc
		return False
	
	#adjust references
	error, desc = commands.getstatusoutput('''sed -i 's|\\hyperref\[#\([^}]*\)\]|\\hyperref\[\1\]|g' /tmp/xepbuilder/xep-''' + nr + ".tex")
	if error != 0:
		if verbose == 1:
			print "Error: ", desc
		return False
	
	error, desc = commands.getstatusoutput('''sed -i 's|\\pageref{#\([^}]*\)}|\\pageref{\1}|g' /tmp/xepbuilder/xep-''' + nr + ".tex")
	if error != 0:
		if verbose == 1:
			print "Error: ", desc
		return False
	
	olddir = os.getcwd()
	os.chdir("/tmp/xepbuilder")
	
	error, desc = commands.getstatusoutput("xelatex -interaction=batchmode xep-" + nr + ".tex")
	if error != 0:
		if verbose == 1:
			print "Error: ", desc
		os.chdir(olddir)
		return False
		
	error, desc = commands.getstatusoutput("xelatex -interaction=batchmode xep-" + nr + ".tex")
	if error != 0:
		if verbose == 1:
			print "Error: ", desc
		os.chdir(olddir)
		return False
	
	os.chdir(olddir)
	
	error, desc = commands.getstatusoutput("cp /tmp/xepbuilder/xep-" + nr + ".pdf " + XEPPATH + "/")
	if error != 0:
		if verbose == 1:
			print "Error: ", desc
		return False
		
	return True

def buildXEP( filename ):
	print "Building " + filename + ": ",
	if buildXHTML( filename ):
		print "XHTML(OK) / ",
	else:
		print "XHTML(ERROR) / ",
	
	if buildPDF( filename ):
		print "PDF(OK)"
	else:
		print "PDF(ERROR)"

def main(argv):
	try:
		options, remainder = getopt.gnu_getopt(argv, "x")
	except getopt.GetoptError:
		print "Error"
		sys.exit(2)
	
	for opt, arg in options:
	    if opt in ('-v'):
	        verbose = 1
	
	xep = remainder[0]
		
	last_build = loadDict(BUILDDICT)
	
	commands.getstatusoutput("rm /tmp/xepbuilder")
	commands.getstatusoutput("mkdir /tmp/xepbuilder")
	commands.getstatusoutput("cp ../images/xmpp.pdf /tmp/xepbuilder/xmpp.pdf")
	commands.getstatusoutput("cp ../images/xmpp-text.pdf /tmp/xepbuilder/xmpp-text.pdf")
	
	buildXEP( xep )
	
	saveDict(BUILDDICT, last_build)
	
if __name__ == "__main__":
	main(sys.argv[1:])