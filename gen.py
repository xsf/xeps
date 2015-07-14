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
import tempfile

from xepinfo import XEPInfo
from xeputil import getLatestXEPFilename

from xml.dom.minidom import parse,parseString,Document,getDOMImplementation

# for serializing inline images
import base64
import urlparse
import urllib

XEPPATH = "/var/www/vhosts/xmpp.org/extensions"
CONFIGPATH = "/var/local/xsf"

verbose = False
fast = False
last_build = {}

files_to_delete = [];

def serializeInlineImage(output_dir, xep_nr, no, attrValue):
	up = urlparse.urlparse(attrValue)
	if up.scheme == 'data':
		head, data = up.path.split(',')
		bits = head.split(';')
		mime_type = bits[0] if bits[0] else 'text/plain'
		charset, b64 = 'ASCII', False
		for bit in bits[1]:
			if bit.startswith('charset='):
				charset = bit[8:]
			elif bit == 'base64':
				b64 = True
	
		# Do something smart with charset and b64 instead of assuming
		plaindata = base64.b64decode(data)
	
		# Do something smart with mime_type
		if mime_type in ('image/png', 'image/jpeg'):
			file_ext = mime_type.split('/')[1]
			f = open(output_dir + '/' + 'inlineimage-' + xep_nr + '-' + str(no) + '.' + file_ext, 'wb')
			f.write(plaindata)
	elif up.scheme == 'http':
		file_name, file_ext = os.path.splitext(up.path)
		urllib.urlretrieve(attrValue, output_dir + '/' + 'inlineimage-' + xep_nr + '-' + str(no) + file_ext)

def serializeXEPInlineImages(output_dir, xep_nr, filename):
	dom = parse(filename)
	imgs = dom.getElementsByTagName('img')
	for (no, img) in enumerate(imgs):
		serializeInlineImage(output_dir, xep_nr, no, img.attributes["src"].value)

def getText(nodelist):
    thisText = ""
    for node in nodelist:
        if node.nodeType == node.TEXT_NODE:
            thisText = thisText + node.data
    return thisText

def executeCommand( cmd ):
	error, desc = commands.getstatusoutput( cmd )
	return error, desc + "\n" + "executed cmd: " + cmd
 
## creates a HTML table (for the human reader) and XML table (for bots)
class XEPTable:
	def __init__(self, filename, shortXMLfilename):
		self.filename = filename
		self.shortXMLfilename = shortXMLfilename
		
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
		
		try:
			self.botsFile = parse(shortXMLfilename)
		except:
			impl = getDOMImplementation()
			self.botsFile = impl.createDocument(None, "xeps", None)

	def save(self):
		f = open(self.filename, "wb")
		self.tableFile.getElementsByTagName("table")[0].normalize()
		f.write(self.tableFile.toxml())
		f.close()
		
		f = open(self.shortXMLfilename, "wb")
		self.botsFile.getElementsByTagName("xeps")[0].normalize()
		f.write(self.botsFile.toxml())
		f.close()

	def setXEP(self, info):
		## set for HTML table
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
		
		col = parseString('''<td valign='top'><a href='/extensions/xep-''' + info.getNr() + ".html'>XEP-" + info.getNr() + '''</a> <a href='/extensions/xep-''' + info.getNr() + '''.pdf'>(PDF)</a></td>''')
		xeprow.appendChild(col.getElementsByTagName("td")[0])
		
		col = parseString("<td valign='top'>" + info.getTitle() + "</td>")
		xeprow.appendChild(col.getElementsByTagName("td")[0])
		
		col = parseString("<td valign='top'>" + info.getType() + "</td>")
		xeprow.appendChild(col.getElementsByTagName("td")[0])
		
		col = parseString("<td valign='top'>" + info.getStatus() + "</td>")
		xeprow.appendChild(col.getElementsByTagName("td")[0])
		
		col = parseString("<td valign='top'>" + info.getDate() + "</td>")
		xeprow.appendChild(col.getElementsByTagName("td")[0])
		
		## set for bots file
		xeps = self.botsFile.getElementsByTagName("xep")
		xep = 0
		for xeps_xep in xeps:
			if xeps_xep.getElementsByTagName("number")[0].firstChild.data == info.getNr():
				xep = xeps_xep
				break
		
		if xep == 0:
			xep = self.botsFile.createElement("xep")
			self.botsFile.getElementsByTagName("xeps")[0].appendChild(xep)
			self.botsFile.getElementsByTagName("xeps")[0].appendChild(self.botsFile.createTextNode('''
'''))
		else:
			while(xep.hasChildNodes()):
				xep.removeChild(xep.firstChild)
		
		child = parseString("<number>" + info.getNr() + "</number>")
		xep.appendChild(child.getElementsByTagName("number")[0])
		
		child = parseString("<name>" + info.getTitle() + "</name>")
		xep.appendChild(child.getElementsByTagName("name")[0])
		
		child = parseString("<type>" + info.getType() + "</type>")
		xep.appendChild(child.getElementsByTagName("type")[0])
		
		child = parseString("<status>" + info.getStatus() + "</status>")
		xep.appendChild(child.getElementsByTagName("status")[0])
		
		child = parseString("<updated>" + info.getDate() + "</updated>")
		xep.appendChild(child.getElementsByTagName("updated")[0])
		
		child = parseString("<shortname>" + info.getShortname() + "</shortname>")
		xep.appendChild(child.getElementsByTagName("shortname")[0])
		
		child = parseString("<abstract>" + info.getAbstract() + "</abstract>")
		xep.appendChild(child.getElementsByTagName("abstract")[0])

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

def buildXHTML( file, nr ):
	error, desc = executeCommand("xsltproc xep.xsl " + file + " > " + XEPPATH + "/xep-" + nr + ".html")
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

def buildPDF( file, nr ):
	serializeXEPInlineImages("/tmp/xepbuilder", nr, file)

	error, desc = executeCommand("xsltproc -o /tmp/xepbuilder/xep-" + nr + ".tex.xml xep2texml.xsl " + file)
	if not checkError(error, desc):
		return False
	
	error, desc = executeCommand("texml -e utf8 /tmp/xepbuilder/xep-" + nr + ".tex.xml /tmp/xepbuilder/xep-" + nr + ".tex")
	if not checkError(error, desc):
		return False
	
	#detect http urls and escape them to make them breakable
	# this should match all urls in free text; not the urls in xml:ns or so..so no " or ' in front.
	error, desc = executeCommand('''sed -i 's|\([\s"]\)\([^"]http://[^ "]*\)|\1\\path{\2}|g' /tmp/xepbuilder/xep-''' + nr + ".tex")
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
		
	#error, desc = executeCommand("xelatex -interaction=batchmode xep-" + nr + ".tex")
	#if not checkError(error, desc):
	#	os.chdir(olddir)
	#	return False
	
	os.chdir(olddir)
	
	error, desc = executeCommand("cp /tmp/xepbuilder/xep-" + nr + ".pdf " + XEPPATH + "/")
	if not checkError(error, desc):
		return False
		
	return True

def buildXEP( filename ):
	nr = re.match("xep-(\d\d\d\d).xml", filename).group(1)
	xepfilepath = getLatestXEPFilename("./", nr);
	if not xepfilepath:
		print "getLatestXEPContent (ERROR)"
		return
	
	files_to_delete.append(xepfilepath)
	if not fast:
		print "Building " + filename + ": ",
		if buildXHTML( xepfilepath, nr ):
			print "XHTML(OK) / ",
		else:
			print "XHTML(ERROR) / ",
		
		if buildPDF( xepfilepath, nr ):
			print "PDF(OK)"
		else:
			print "PDF(ERROR)"
	else:
		print "Building " + filename + " (FAST MODE)"
	
	x = XEPTable(CONFIGPATH + "/extensions.xml", XEPPATH + "/xeps.xml")
	xinfo = XEPInfo(xepfilepath, False)
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
	print "gen.py: generate nice XHTML and beautiful PDF out of the XEP XML files"
	print ""
	print "Usage:"
	print "gen.py xep-####.xml"
	print ""
	print "Options:"
	print "-v  Enable verbose output for debugging."
	print "-a  Build all available XEPs."
	print "-f  Fast; means no actual compiling is done."

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
	executeCommand("cp -r deps/* /tmp/xepbuilder/")
	
	executeCommand("cp xep.ent /tmp/xep.ent")
	files_to_delete.append("/tmp/xep.ent")
	
	if buildall:
		buildAll()
	else:
		buildXEP( xep )
	
	# remove xep temporary files
	for filename in files_to_delete:
	    executeCommand("rm " + filename)
	
	executeCommand("sed -e '1s/<?[^?]*?>//' " + CONFIGPATH + "/extensions.xml > " + XEPPATH + "/../includes/xeplist.txt")
	
	executeCommand("rm -rfd /tmp/xepbuilder")
	
	makeBundle()
	
	
if __name__ == "__main__":
	main(sys.argv[1:])
