#!/usr/bin/env python

# File: gen.py
# Version: 0.2
# Description: a renewed XEP compilation tool
# Last Modified: 2009
# Author: Tobias Markmann (tm@ayena.de)
# HowTo: ./gen.py xep-####.xml

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

import pickle
import commands
import os
import re
import sys
import getopt
import glob

from xepinfo import XEPInfo

from xml.dom.minidom import parse,parseString,Document,getDOMImplementation

XEPPATH = "/var/www/vhosts/xmpp.org/extensions"
CONFIGPATH = "/var/local/xsf"

verbose = False
fast = False
last_build = {}

def getText(nodelist):
    thisText = ""
    for node in nodelist:
        if node.nodeType == node.TEXT_NODE:
            thisText = thisText + node.data
    return thisText

def executeCommand( cmd ):
	error, desc = commands.getstatusoutput( cmd )
	return error, desc + "\n" + "executed cmd: " + cmd
 
class XEPTable:
	def __init__(self, filename):
		self.filename = filename
		try:
			self.tableFile = parse(filename)
		except:
			impl = getDOMImplementation()
			self.tableFile = impl.createDocument(None, "table", None)
			self.tableFile.getElementsByTagName("table")[0].setAttribute("class", "sortable")
			self.tableFile.getElementsByTagName("table")[0].setAttribute("id", "xeplist")
			self.tableFile.getElementsByTagName("table")[0].setAttribute("cellspacing", "0")
			self.tableFile.getElementsByTagName("table")[0].setAttribute("cellpadding", "3")
			self.tableFile.getElementsByTagName("table")[0].setAttribute("border", "1")
			
			header = parseString(
'''<tr class='xepheader'>
	<th align='left'>Number</th>
	<th align='left'>Name</th>
	<th align='left'>Type</th>
	<th align='left'>Status</th>
	<th align='left'>Date</th>
</tr>''')
			self.tableFile.getElementsByTagName("table")[0].appendChild(header.getElementsByTagName("tr")[0])
			
	def save(self):
		f = open(self.filename, "wb")
		self.tableFile.getElementsByTagName("table")[0].normalize()
		f.write(self.tableFile.toxml())
		f.close()

	def setXEP(self, info):
		rows = self.tableFile.getElementsByTagName("tr")
		xeprow = 0
		for row in rows:
			if row.getAttribute("id") == "xep" + info.getNr():
				xeprow = row
				break
		
		if xeprow == 0:
			xeprow = self.tableFile.createElement("tr")
			self.tableFile.getElementsByTagName("table")[0].appendChild(xeprow)
			self.tableFile.getElementsByTagName("table")[0].appendChild(self.tableFile.createTextNode('''
'''))
			xeprow.setAttribute("id", "xep" + info.getNr())
			xeprow.setAttribute("class", "tablebody XEP-" + info.getStatus())
		else:
			xeprow.setAttribute("class", "tablebody XEP-" + info.getStatus())
			while(xeprow.hasChildNodes()):
				xeprow.removeChild(xeprow.firstChild)
		
		col = parseString('''<td valign='top'><a href='xep-''' + info.getNr() + ".html'>XEP-" + info.getNr() + '''</a> <a href='xep-''' + info.getNr() + '''.pdf'>(PDF)</a></td>''')
		xeprow.appendChild(col.getElementsByTagName("td")[0])
		
		col = parseString("<td valign='top'>" + info.getTitle() + "</td>")
		xeprow.appendChild(col.getElementsByTagName("td")[0])
		
		col = parseString("<td valign='top'>" + info.getType() + "</td>")
		xeprow.appendChild(col.getElementsByTagName("td")[0])
		
		col = parseString("<td valign='top'>" + info.getStatus() + "</td>")
		xeprow.appendChild(col.getElementsByTagName("td")[0])
		
		col = parseString("<td valign='top'>" + info.getDate() + "</td>")
		xeprow.appendChild(col.getElementsByTagName("td")[0])
		

def filebase( filename ):
	return os.path.splitext(os.path.basename(filename))[0]


def checkError( error, desc):
	global verbose
	
	if error != 0:
		if verbose:
			print "Error: ", desc
		return False
	return True

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
	error, desc = executeCommand("xsltproc xep.xsl xep-" + nr + ".xml > " + XEPPATH + "/xep-" + nr + ".html")
	if not checkError(error, desc):
		return False
		
	error, desc = executeCommand("xsltproc ref.xsl xep-" + nr + ".xml > " + XEPPATH + "/refs/reference.XSF.XEP-" + nr + ".xml")
	if not checkError(error, desc):
		return False
	
	error, desc = executeCommand("xsltproc examples.xsl xep-" + nr + ".xml > " + XEPPATH + "/examples/" + nr + ".xml")
	if not checkError(error, desc):
		return False
	
	error, desc = executeCommand(" cp xep-" + nr + ".xml " + XEPPATH + "/")
	if not checkError(error, desc):
		return False
	return True

def buildPDF( file ):
	nr = re.match("xep-(\d\d\d\d).xml", file).group(1)
	
	error, desc = executeCommand("xsltproc -o /tmp/xepbuilder/xep-" + nr + ".tex.xml xep2texml.xsl xep-" + nr + ".xml")
	if not checkError(error, desc):
		return False
	
	error, desc = executeCommand("texml -e utf8 /tmp/xepbuilder/xep-" + nr + ".tex.xml /tmp/xepbuilder/xep-" + nr + ".tex")
	if not checkError(error, desc):
		return False
	
	#detect http urls and escape them to make them breakable
	error, desc = executeCommand('''sed -i 's|\([\s"]\)\(http://[^ "]*\)|\1\\path{\2}|g' /tmp/xepbuilder/xep-''' + nr + ".tex")
	if not checkError(error, desc):
		return False
	
	#adjust references
	error, desc = executeCommand('''sed -i 's|\\hyperref\[#\([^}]*\)\]|\\hyperref\[\1\]|g' /tmp/xepbuilder/xep-''' + nr + ".tex")
	if error != 0:
		if verbose == 1:
			print "Error: ", desc
		return False
	
	error, desc = executeCommand('''sed -i 's|\\pageref{#\([^}]*\)}|\\pageref{\1}|g' /tmp/xepbuilder/xep-''' + nr + ".tex")
	if not checkError(error, desc):
		return False
	
	olddir = os.getcwd()
	os.chdir("/tmp/xepbuilder")
	
	error, desc = executeCommand("xelatex -interaction=batchmode xep-" + nr + ".tex")
	#if not checkError(error, desc):
	#	os.chdir(olddir)
	#	return False
		
	error, desc = executeCommand("xelatex -interaction=batchmode xep-" + nr + ".tex")
	#if not checkError(error, desc):
	#	os.chdir(olddir)
	#	return False
	
	os.chdir(olddir)
	
	error, desc = executeCommand("cp /tmp/xepbuilder/xep-" + nr + ".pdf " + XEPPATH + "/")
	if not checkError(error, desc):
		return False
		
	return True

def buildXEP( filename ):
	if not fast:
		print "Building " + filename + ": ",
		if buildXHTML( filename ):
			print "XHTML(OK) / ",
		else:
			print "XHTML(ERROR) / ",
		
		if buildPDF( filename ):
			print "PDF(OK)"
		else:
			print "PDF(ERROR)"
	
	x = XEPTable(CONFIGPATH + "/extensions.xml")
	xinfo = XEPInfo(filename)
	x.setXEP( xinfo )
	x.save()

def buildAll():
	files = glob.glob('xep-????.xml')
	files.sort(key=lambda x: x.lower())
	for file in files:
		buildXEP( file )
		
def makeBundle():
	print "Creating the bundle...",
	executeCommand("mkdir /tmp/xepbundle")
	executeCommand("cp " + XEPPATH + "/*.pdf " + "/tmp/xepbundle")
	executeCommand("tar -cf /tmp/xepbundle.tar -C /tmp xepbundle")
	executeCommand("pbzip2 -f -9 /tmp/xepbundle.tar")
	executeCommand("mv -f /tmp/xepbundle.tar.bz2 " + XEPPATH + "/xepbundle.tar.bz2")
	executeCommand("rm -rfd /tmp/xepbundle")
	print "DONE"

def usage():
	print "gen.py: generate nice XHTML and beatuy PDF out of the XEP XML"
	print ""
	print "Usage:"
	print "gen.py xep-####.xml"
	print ""
	print "Options:"
	print "-v  Enable verbose output for debugging."
	print "-a  Build all available XEPs."
	print "-f  Fast; means no actual compiling is done"

def main(argv):
	global verbose
	global CONFIGPATH
	global fast
	buildall = False
	
	try:
		options, remainder = getopt.gnu_getopt(argv, "vaf")
	except getopt.GetoptError:
		usage()
		sys.exit(2)
	
	for opt, arg in options:
		if opt in ('-v'):
			verbose = True
		elif opt in ('-a'):
			buildall = True
		elif opt in ('-f'):
			fast = True
	
	if len(remainder) > 0:
		try:
			xep = int(remainder[0])
			xep = "xep-%04d.xml" % xep
		except:
			xep = remainder[0]
		
	executeCommand("mkdir /tmp/xepbuilder")
	executeCommand("cp ../images/xmpp.pdf /tmp/xepbuilder/xmpp.pdf")
	executeCommand("cp ../images/xmpp-text.pdf /tmp/xepbuilder/xmpp-text.pdf")
	
	if buildall:
		buildAll()
	else:
		buildXEP( xep )
	
	executeCommand("sed -e '1s/<?[^?]*?>//' " + CONFIGPATH + "/extensions.xml > " + XEPPATH + "/../includes/xeplist.txt")
	
	executeCommand("rm -rfd /tmp/xepbuilder")
	
	makeBundle()
	
	
if __name__ == "__main__":
	main(sys.argv[1:])
