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

<!-- Author: stpeter
     Description: transforms XEP meta-data into IETF reference
-->

<xsl:stylesheet xmlns:xsl='http://www.w3.org/1999/XSL/Transform' version='1.0'>

  <xsl:output method='xml' indent='yes' version='1.0' encoding='UTF-8'/>

  <xsl:template match='/'>
    <reference>
      <xsl:attribute name='anchor'><xsl:text>XEP-</xsl:text><xsl:value-of select='/xep/header/number'/></xsl:attribute>
      <front>
        <title><xsl:value-of select='/xep/header/title' /></title>
        <xsl:apply-templates select='/xep/header/author'/>
        <xsl:variable name='fulldate' select='/xep/header/revision[position()=1]/date'/>
        <xsl:variable name='year' select='substring-before($fulldate,"-")'/>
        <xsl:variable name='monthday' select='substring-after($fulldate,"-")'/>
        <xsl:variable name='month' select='substring-before($monthday,"-")'/>
        <xsl:variable name='day' select='substring-after($monthday,"-")'/>
        <date>
          <xsl:attribute name='day'><xsl:value-of select='$day'/></xsl:attribute>
          <xsl:choose>
            <xsl:when test='$month = "01"'>
              <xsl:attribute name='month'><xsl:text>January</xsl:text></xsl:attribute>
            </xsl:when>
            <xsl:when test='$month = "02"'>
              <xsl:attribute name='month'><xsl:text>February</xsl:text></xsl:attribute>
            </xsl:when>
            <xsl:when test='$month = "03"'>
              <xsl:attribute name='month'><xsl:text>March</xsl:text></xsl:attribute>
            </xsl:when>
            <xsl:when test='$month = "04"'>
              <xsl:attribute name='month'><xsl:text>April</xsl:text></xsl:attribute>
            </xsl:when>
            <xsl:when test='$month = "05"'>
              <xsl:attribute name='month'><xsl:text>May</xsl:text></xsl:attribute>
            </xsl:when>
            <xsl:when test='$month = "06"'>
              <xsl:attribute name='month'><xsl:text>June</xsl:text></xsl:attribute>
            </xsl:when>
            <xsl:when test='$month = "07"'>
              <xsl:attribute name='month'><xsl:text>July</xsl:text></xsl:attribute>
            </xsl:when>
            <xsl:when test='$month = "08"'>
              <xsl:attribute name='month'><xsl:text>August</xsl:text></xsl:attribute>
            </xsl:when>
            <xsl:when test='$month = "09"'>
              <xsl:attribute name='month'><xsl:text>September</xsl:text></xsl:attribute>
            </xsl:when>
            <xsl:when test='$month = "10"'>
              <xsl:attribute name='month'><xsl:text>October</xsl:text></xsl:attribute>
            </xsl:when>
            <xsl:when test='$month = "11"'>
              <xsl:attribute name='month'><xsl:text>November</xsl:text></xsl:attribute>
            </xsl:when>
            <xsl:when test='$month = "12"'>
              <xsl:attribute name='month'><xsl:text>December</xsl:text></xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
              <xsl:attribute name='month'><xsl:text></xsl:text></xsl:attribute>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:attribute name='year'><xsl:value-of select='$year'/></xsl:attribute>
        </date>
      </front>
      <seriesInfo>
        <xsl:attribute name='name'><xsl:text>XSF XEP</xsl:text></xsl:attribute>
        <xsl:attribute name='value'><xsl:value-of select='/xep/header/number'/></xsl:attribute>
      </seriesInfo>
      <format>
        <xsl:attribute name='type'><xsl:text>HTML</xsl:text></xsl:attribute>
        <xsl:attribute name='target'><xsl:text>http://xmpp.org/extensions/xep-</xsl:text><xsl:value-of select='/xep/header/number'/><xsl:text>.html</xsl:text></xsl:attribute>
      </format>
    </reference>
  </xsl:template>

  <xsl:template match='author'>
    <author>
      <xsl:variable name='fname' select='firstname'/>
      <xsl:choose>
        <xsl:when test='starts-with($fname,"A")'><xsl:attribute name='initials'><xsl:text>A.</xsl:text></xsl:attribute></xsl:when>
        <xsl:when test='starts-with($fname,"B")'><xsl:attribute name='initials'><xsl:text>B.</xsl:text></xsl:attribute></xsl:when>
        <xsl:when test='starts-with($fname,"C")'><xsl:attribute name='initials'><xsl:text>C.</xsl:text></xsl:attribute></xsl:when>
        <xsl:when test='starts-with($fname,"D")'><xsl:attribute name='initials'><xsl:text>D.</xsl:text></xsl:attribute></xsl:when>
        <xsl:when test='starts-with($fname,"E")'><xsl:attribute name='initials'><xsl:text>E.</xsl:text></xsl:attribute></xsl:when>
        <xsl:when test='starts-with($fname,"F")'><xsl:attribute name='initials'><xsl:text>F.</xsl:text></xsl:attribute></xsl:when>
        <xsl:when test='starts-with($fname,"G")'><xsl:attribute name='initials'><xsl:text>G.</xsl:text></xsl:attribute></xsl:when>
        <xsl:when test='starts-with($fname,"H")'><xsl:attribute name='initials'><xsl:text>H.</xsl:text></xsl:attribute></xsl:when>
        <xsl:when test='starts-with($fname,"I")'><xsl:attribute name='initials'><xsl:text>I.</xsl:text></xsl:attribute></xsl:when>
        <xsl:when test='starts-with($fname,"J")'><xsl:attribute name='initials'><xsl:text>J.</xsl:text></xsl:attribute></xsl:when>
        <xsl:when test='starts-with($fname,"K")'><xsl:attribute name='initials'><xsl:text>K.</xsl:text></xsl:attribute></xsl:when>
        <xsl:when test='starts-with($fname,"L")'><xsl:attribute name='initials'><xsl:text>L.</xsl:text></xsl:attribute></xsl:when>
        <xsl:when test='starts-with($fname,"M")'><xsl:attribute name='initials'><xsl:text>M.</xsl:text></xsl:attribute></xsl:when>
        <xsl:when test='starts-with($fname,"N")'><xsl:attribute name='initials'><xsl:text>N.</xsl:text></xsl:attribute></xsl:when>
        <xsl:when test='starts-with($fname,"O")'><xsl:attribute name='initials'><xsl:text>O.</xsl:text></xsl:attribute></xsl:when>
        <xsl:when test='starts-with($fname,"P")'><xsl:attribute name='initials'><xsl:text>P.</xsl:text></xsl:attribute></xsl:when>
        <xsl:when test='starts-with($fname,"Q")'><xsl:attribute name='initials'><xsl:text>Q.</xsl:text></xsl:attribute></xsl:when>
        <xsl:when test='starts-with($fname,"R")'><xsl:attribute name='initials'><xsl:text>R.</xsl:text></xsl:attribute></xsl:when>
        <xsl:when test='starts-with($fname,"S")'><xsl:attribute name='initials'><xsl:text>S.</xsl:text></xsl:attribute></xsl:when>
        <xsl:when test='starts-with($fname,"T")'><xsl:attribute name='initials'><xsl:text>T.</xsl:text></xsl:attribute></xsl:when>
        <xsl:when test='starts-with($fname,"U")'><xsl:attribute name='initials'><xsl:text>U.</xsl:text></xsl:attribute></xsl:when>
        <xsl:when test='starts-with($fname,"V")'><xsl:attribute name='initials'><xsl:text>V.</xsl:text></xsl:attribute></xsl:when>
        <xsl:when test='starts-with($fname,"W")'><xsl:attribute name='initials'><xsl:text>W.</xsl:text></xsl:attribute></xsl:when>
        <xsl:when test='starts-with($fname,"X")'><xsl:attribute name='initials'><xsl:text>X.</xsl:text></xsl:attribute></xsl:when>
        <xsl:when test='starts-with($fname,"Y")'><xsl:attribute name='initials'><xsl:text>Y.</xsl:text></xsl:attribute></xsl:when>
        <xsl:when test='starts-with($fname,"Z")'><xsl:attribute name='initials'><xsl:text>Z.</xsl:text></xsl:attribute></xsl:when>
        <xsl:otherwise>
          <xsl:attribute name='initals'><xsl:text></xsl:text></xsl:attribute>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:attribute name='surname'><xsl:value-of select='surname'/></xsl:attribute>
      <xsl:attribute name='fullname'><xsl:value-of select='firstname'/><xsl:text> </xsl:text><xsl:value-of select='surname'/></xsl:attribute>
      <organization/>
      <address>
        <email><xsl:value-of select='email'/></email>
      </address>
    </author>
  </xsl:template>

</xsl:stylesheet>
