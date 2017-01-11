<?xml version='1.0' encoding='UTF-8'?>

<!--

Copyright (c) 1999 - 2017 XMPP Standards Foundation

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

-->

<!-- Author: stpeter -->

<xsl:stylesheet xmlns:xsl='http://www.w3.org/1999/XSL/Transform' version='1.0'>

  <xsl:output method='xml'/>

  <xsl:template match='/'>
    <xsl:comment> These are the examples for XSF XEP-<xsl:value-of select='/xep/header/number'/>:<xsl:text> </xsl:text><xsl:value-of select='/xep/header/title' /> </xsl:comment>
    <stream xml:lang='en' xmlns='jabber:client' xmlns:stream='http://etherx.jabber.org/streams'>
      <xsl:apply-templates select='//example'/>
    </stream>
  </xsl:template>

  <xsl:template match='example'>
    <xsl:comment> Example <xsl:number level='any' count='example'/> </xsl:comment>
    <xsl:value-of select='.' disable-output-escaping='yes'/>
  </xsl:template>

</xsl:stylesheet>
