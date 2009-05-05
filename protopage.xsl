<!--

Copyright (c) 1999 - 2009 XMPP Standards Foundation

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

  <xsl:output method='html'/>

  <xsl:template match='/'>
    <html>
      <head>
        <title><xsl:value-of select='/xep/header/shortname'/></title>
        <link rel='stylesheet' type='text/css' href='/xmpp.css' />
        <link rel='shortcut icon' type='image/x-icon' href='/favicon.ico' />
        <link>
          <xsl:attribute name='rel'><xsl:text>alternate</xsl:text></xsl:attribute>
          <xsl:attribute name='href'><xsl:text>http://xmpp.org/extensions/xep-</xsl:text><xsl:value-of select='/xep/header/number'/><xsl:text>.html</xsl:text></xsl:attribute>
        </link>
        <!-- BEGIN META TAGS FOR DUBLIN CORE -->
        <meta>
          <xsl:attribute name='name'><xsl:text>DC.Title</xsl:text></xsl:attribute>
          <xsl:attribute name='content'><xsl:value-of select='/xep/header/shortname'/></xsl:attribute>
        </meta>
        <meta>
          <xsl:attribute name='name'><xsl:text>DC.Publisher</xsl:text></xsl:attribute>
          <xsl:attribute name='content'>XMPP Standards Foundation</xsl:attribute>
        </meta>
        <meta>
          <xsl:attribute name='name'><xsl:text>DC.Date</xsl:text></xsl:attribute>
          <xsl:attribute name='content'><xsl:value-of select='/xep/header/revision/date'/></xsl:attribute>
        </meta>
        <!-- END META TAGS FOR DUBLIN CORE -->
      </head>
      <body>
        <h1><xsl:value-of select='/xep/header/shortname'/></h1>
        <p>This page provides information about the XML namespaces defined in 
        <a>
          <xsl:attribute name='href'>
            <xsl:text>http://xmpp.org/extensions/xep-</xsl:text>
            <xsl:value-of select='/xep/header/number'/>
            <xsl:text>.html</xsl:text>
          </xsl:attribute>
          <xsl:text>XEP-</xsl:text><xsl:value-of select='/xep/header/number' />:<xsl:text> </xsl:text><xsl:value-of select='/xep/header/title' />
        </a>
        (part of the <a href="http://xmpp.org/extensions/">XEP series</a> published by the <a href="http://xmpp.org/xsf/">XMPP Standards Foundation</a>).</p>

        <xsl:variable name='schema.count' select='count(/xep/header/schemaloc)'/>
        <xsl:if test='$schema.count &gt; 0'>
          <p>The following XML schemas are available for the <xsl:value-of select='/xep/header/title' /> protocol:</p>
          <ul>
            <xsl:apply-templates select='/xep/header/schemaloc'/>
          </ul>
        </xsl:if>

        <p>Last Updated: <xsl:value-of select='/xep/header/revision/date'/></p>

      </body>
    </html>
  </xsl:template>

  <xsl:template match='schemaloc'>
    <xsl:variable name='this.url' select='url'/>
    <xsl:variable name='ns.count' select='count(ns)'/>
    <xsl:choose>
      <xsl:when test="$ns.count &gt; 0">
        <li><a href='{$this.url}'><xsl:value-of select='url'/></a></li>
      </xsl:when>
      <xsl:otherwise>
        <li><a href='{$this.url}'><xsl:value-of select='url'/></a></li>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
