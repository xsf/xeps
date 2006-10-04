
<!-- Author: stpeter -->

<xsl:stylesheet xmlns:xsl='http://www.w3.org/1999/XSL/Transform' version='1.0'>

  <xsl:output method='html'/>

  <xsl:template match='/'>
    <html>
      <head>
        <title><xsl:value-of select='/jep/header/shortname'/></title>
        <link rel='stylesheet' type='text/css' href='/xmpp.css' />
        <link rel='shortcut icon' type='image/x-icon' href='/favicon.ico' />
        <link>
          <xsl:attribute name='rel'><xsl:text>alternate</xsl:text></xsl:attribute>
          <xsl:attribute name='href'><xsl:text>http://www.jabber.org/jeps/jep-</xsl:text><xsl:value-of select='/jep/header/number'/><xsl:text>.html</xsl:text></xsl:attribute>
        </link>
        <!-- BEGIN META TAGS FOR DUBLIN CORE -->
        <meta>
          <xsl:attribute name='name'><xsl:text>DC.Title</xsl:text></xsl:attribute>
          <xsl:attribute name='content'><xsl:value-of select='/jep/header/shortname'/></xsl:attribute>
        </meta>
        <meta>
          <xsl:attribute name='name'><xsl:text>DC.Publisher</xsl:text></xsl:attribute>
          <xsl:attribute name='content'>Jabber Software Foundation</xsl:attribute>
        </meta>
        <meta>
          <xsl:attribute name='name'><xsl:text>DC.Date</xsl:text></xsl:attribute>
          <xsl:attribute name='content'><xsl:value-of select='/jep/header/revision/date'/></xsl:attribute>
        </meta>
        <!-- END META TAGS FOR DUBLIN CORE -->
      </head>
      <body>
        <h1><xsl:value-of select='/jep/header/shortname'/></h1>
        <p>This page provides information about the XML namespaces defined in 
        <a>
          <xsl:attribute name='href'>
            <xsl:text>http://www.jabber.org/jeps/jep-</xsl:text>
            <xsl:value-of select='/jep/header/number'/>
            <xsl:text>.html</xsl:text>
          </xsl:attribute>
          <xsl:text>XEP-</xsl:text><xsl:value-of select='/jep/header/number' />:<xsl:text> </xsl:text><xsl:value-of select='/jep/header/title' />
        </a>
        (part of the <a href="http://www.jabber.org/jeps/">XEP series</a> published by the <a href="http://www.jabber.org/jsf/">Jabber Software Foundation</a>).</p>

        <xsl:variable name='schema.count' select='count(/jep/header/schemaloc)'/>
        <xsl:if test='$schema.count &gt; 0'>
          <p>The following XML schemas are available for the <xsl:value-of select='/jep/header/title' /> protocol:</p>
          <ul>
            <xsl:apply-templates select='/jep/header/schemaloc'/>
          </ul>
        </xsl:if>

        <p>Last Updated: <xsl:value-of select='/jep/header/revision/date'/></p>

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
