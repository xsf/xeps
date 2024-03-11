<?xml version='1.0' encoding='UTF-8'?>

<!--

Copyright (c) 1999 - 2021 XMPP Standards Foundation

Permission is hereby granted, free of charge, to any
person obtaining a copy of this software and
associated documentation files (the "Software"), to
deal in the Software without restriction, including
without limitation the rights to use, copy, modify,
merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom
the Software is furnished to do so, subject to the
following conditions:

The above copyright notice and this permission notice
shall be included in all copies or substantial portions
of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF
ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED
TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT
SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR
ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE
OR OTHER DEALINGS IN THE SOFTWARE.

-->

<!-- Authors: stpeter and temas -->

<xsl:stylesheet xmlns:xsl='http://www.w3.org/1999/XSL/Transform' version='1.0'>

  <xsl:output method='html' media-type='text/html' encoding='utf-8' omit-xml-declaration='yes' indent='no' doctype-system='about:legacy-compat'/>

  <xsl:template name="status-notice">
    <xsl:param name="thestatus"/>
    <xsl:param name="thetype"/>
    <div id='status-notice'>
      <xsl:attribute name='class'><xsl:value-of select='translate($thestatus, "ABCDEFGHIJKLMNOPQRSTUVWXYZ", "abcdefghijklmnopqrstuvwxyz")'/><xsl:text> </xsl:text><xsl:value-of select='translate($thetype, "ABCDEFGHIJKLMNOPQRSTUVWXYZ", "abcdefghijklmnopqrstuvwxyz")'/></xsl:attribute>
      <xsl:if test='$thestatus = "Active" and $thetype = "Historical"'>
        <xsl:text>NOTICE: This Historical specification provides canonical documentation of a protocol that is in use within the Jabber/XMPP community. This document is not a standards-track specification within the XMPP Standards Foundation's standards process; however, it might be converted to standards-track in the future or might be obsoleted by a more modern protocol.</xsl:text>
      </xsl:if>
      <xsl:if test='$thestatus = "Active" and $thetype = "Humorous"'>
        <xsl:text>NOTICE: This document is Humorous. It MAY provide amusement but SHOULD NOT be taken seriously.</xsl:text>
      </xsl:if>
      <xsl:if test='$thestatus = "Active" and $thetype = "Informational"'>
        <xsl:text>NOTICE: This Informational specification defines a best practice or protocol profile that has been approved by the XMPP Council and/or the XSF Board of Directors. Implementations are encouraged and the best practice or protocol profile is appropriate for deployment in production systems.</xsl:text>
      </xsl:if>
      <xsl:if test='$thestatus = "Active" and $thetype = "Procedural"'>
        <xsl:text>NOTICE: This Procedural document defines a process or activity of the XMPP Standards Foundation (XSF) that has been approved by the XMPP Council and/or the XSF Board of Directors. The XSF is currently following the process or activity defined herein and will do so until this document is deprecated or obsoleted.</xsl:text>
      </xsl:if>
      <xsl:if test='$thestatus = "Deferred"'>
        <xsl:text>WARNING: This document has been automatically Deferred after 12 months of inactivity in its previous Experimental state. Implementation of the protocol described herein is not recommended for production systems. However, exploratory implementations are encouraged to resume the standards process.</xsl:text>
      </xsl:if>
      <xsl:if test='$thestatus = "Deprecated"'>
        <xsl:text>WARNING: This document has been </xsl:text><strong>Deprecated</strong><xsl:text> by the XMPP Standards Foundation. Implementation of the protocol described herein is not recommended. Developers desiring similar functionality are advised to implement the protocol that supersedes this one </xsl:text>
        <xsl:variable name='supersededby.count' select='count(/xep/header/supersededby/spec)'/>
        <xsl:choose>
          <xsl:when test='$supersededby.count &gt; 0'>
            <xsl:text>(</xsl:text>
            <xsl:apply-templates select='/xep/header/supersededby/spec'>
              <xsl:with-param name='speccount' select='$supersededby.count'/>
            </xsl:apply-templates>
            <xsl:text>).</xsl:text>
          </xsl:when>
          <xsl:otherwise>(if any).</xsl:otherwise>
        </xsl:choose>
      </xsl:if>
      <xsl:if test='$thestatus = "Draft"'>
        <xsl:text>NOTICE: The protocol defined herein is a </xsl:text><strong>Stable Standard</strong><xsl:text> of the XMPP Standards Foundation. Implementations are encouraged and the protocol is appropriate for deployment in production systems, but some changes to the protocol are possible before it becomes a Final Standard.</xsl:text>
      </xsl:if>
      <xsl:if test='$thestatus = "Experimental" and $thetype = "Historical"'>
        <xsl:text>NOTICE: This Historical document attempts to provide canonical documentation of a protocol that is in use within the Jabber/XMPP community. Publication as an XMPP Extension Protocol does not imply approval of this proposal by the XMPP Standards Foundation. This document is not a standards-track specification within the XMPP Standards Foundation's standards process; however, it might be converted to standards-track in the future or might be obsoleted by a more modern protocol.</xsl:text>
      </xsl:if>
      <xsl:if test='$thestatus = "Experimental" and $thetype = "Informational"'>
        <xsl:text>WARNING: This Informational document is Experimental. Publication as an XMPP Extension Protocol does not imply approval of this proposal by the XMPP Standards Foundation. Implementation of the best practice or protocol profile described herein is encouraged in exploratory implementations, although production systems are advised to carefully consider whether it is appropriate to deploy implementations of this protocol before it advances to a status of Stable.</xsl:text>
      </xsl:if>
      <xsl:if test='$thestatus = "Experimental" and $thetype = "Procedural"'>
        <xsl:text>NOTICE: This Procedural document proposes that the process or activity defined herein shall be followed by the XMPP Standards Foundation (XSF). However, this process or activity has not yet been approved by the XMPP Council and/or the XSF Board of Directors and is therefore not currently in force.</xsl:text>
      </xsl:if>
      <xsl:if test='$thestatus = "Experimental" and $thetype = "Standards Track"'>
        <xsl:text>WARNING: This Standards-Track document is Experimental. Publication as an XMPP Extension Protocol does not imply approval of this proposal by the XMPP Standards Foundation. Implementation of the protocol described herein is encouraged in exploratory implementations, but production systems are advised to carefully consider whether it is appropriate to deploy implementations of this protocol before it advances to a status of Draft.</xsl:text>
      </xsl:if>
      <xsl:if test='$thestatus = "Final"'>
        <xsl:text>NOTICE: The protocol defined herein is a </xsl:text><strong>Final Standard</strong><xsl:text> of the XMPP Standards Foundation and can be considered a stable technology for implementation and deployment.</xsl:text>
      </xsl:if>
      <xsl:if test='$thestatus = "Obsolete"'>
        <xsl:text>WARNING: This document has been obsoleted by the XMPP Standards Foundation. Implementation of the protocol described herein is not recommended. Developers desiring similar functionality are advised to implement the protocol that supersedes this one </xsl:text>
        <xsl:variable name='supersededby.count' select='count(/xep/header/supersededby/spec)'/>
        <xsl:choose>
          <xsl:when test='$supersededby.count &gt; 0'>
            <xsl:text>(</xsl:text>
            <xsl:apply-templates select='/xep/header/supersededby/spec'>
              <xsl:with-param name='speccount' select='$supersededby.count'/>
            </xsl:apply-templates>
            <xsl:text>).</xsl:text>
          </xsl:when>
          <xsl:otherwise>(if any).</xsl:otherwise>
        </xsl:choose>
      </xsl:if>
      <xsl:if test='$thestatus = "Proposed"'>
        <xsl:text>NOTICE: This document is currently within Last Call or under consideration by the XMPP Council for advancement to the next stage in the XSF standards process. </xsl:text>
        <xsl:if test='/xep/header/lastcall'>The Last Call ends on <xsl:value-of select='/xep/header/lastcall'/>.
        </xsl:if>
        <xsl:text>Please send your feedback to the </xsl:text><a href='https://mail.jabber.org/mailman/listinfo/standards'>standards@xmpp.org</a><xsl:text> discussion list.</xsl:text>
      </xsl:if>
      <xsl:if test='$thestatus = "ProtoXEP"'>
        <xsl:text>WARNING: This document has not yet been accepted for consideration or approved in any official manner by the XMPP Standards Foundation, and this document is not yet an XMPP Extension Protocol (XEP). If this document is accepted as a XEP by the XMPP Council, it will be published at &lt;</xsl:text><a href="https://xmpp.org/extensions/">https://xmpp.org/extensions/</a><xsl:text>&gt; and announced on the &lt;standards@xmpp.org&gt; mailing list.</xsl:text>
      </xsl:if>
      <xsl:if test='$thestatus = "Rejected"'>
        <xsl:text>WARNING: This document has been Rejected by the XMPP Council. Implementation of the protocol described herein is not recommended under any circumstances.</xsl:text>
      </xsl:if>
      <xsl:if test='$thestatus = "Retracted"'>
        <xsl:text>WARNING: This document has been retracted by the author(s). Implementation of the protocol described herein is not recommended. Developers desiring similar functionality are advised to implement the protocol that supersedes this one </xsl:text>
        <xsl:variable name='supersededby.count' select='count(/xep/header/supersededby/spec)'/>
        <xsl:choose>
          <xsl:when test='$supersededby.count &gt; 0'>
            <xsl:text>(</xsl:text>
            <xsl:apply-templates select='/xep/header/supersededby/spec'>
              <xsl:with-param name='speccount' select='$supersededby.count'/>
            </xsl:apply-templates>
            <xsl:text>).</xsl:text>
          </xsl:when>
          <xsl:otherwise>(if any).</xsl:otherwise>
        </xsl:choose>
      </xsl:if>
    </div>
  </xsl:template>

  <xsl:template name='make-timeline'>
    <xsl:param name='thestatus'/>
    <xsl:param name='thetype'/>
    <xsl:choose>
      <xsl:when test='$thetype = "Standards Track"'>
        <li><xsl:if test='$thestatus = "Experimental"'><xsl:attribute name='class'>current</xsl:attribute></xsl:if>Experimental</li>
        <xsl:if test='$thestatus = "Deferred"'><li class='current inserted'>Deferred</li></xsl:if>
        <xsl:if test='$thestatus = "Retracted"'><li class='current inserted'>Retracted</li></xsl:if>
        <li><xsl:if test='$thestatus = "Proposed"'><xsl:attribute name='class'>current</xsl:attribute></xsl:if>Proposed</li>
        <xsl:if test='$thestatus = "Rejected"'><li class='current inserted'>Rejected</li></xsl:if>
        <li><xsl:if test='$thestatus = "Draft"'><xsl:attribute name='class'>current</xsl:attribute></xsl:if>Stable</li>
        <li><xsl:if test='$thestatus = "Final"'><xsl:attribute name='class'>current</xsl:attribute></xsl:if>Final</li>
        <xsl:if test='$thestatus = "Deprecated" or $thestatus = "Obsolete"'>
          <li><xsl:if test='$thestatus = "Deprecated"'><xsl:attribute name='class'>current</xsl:attribute></xsl:if>Deprecated</li>
          <li><xsl:if test='$thestatus = "Obsolete"'><xsl:attribute name='class'>current</xsl:attribute></xsl:if>Obsolete</li>
        </xsl:if>
      </xsl:when>
      <xsl:when test='$thetype = "Procedural" or $thetype = "Informational" or $thetype = "Historical"'>
        <li><xsl:if test='$thestatus = "Experimental"'><xsl:attribute name='class'>current</xsl:attribute></xsl:if>Experimental</li>
        <xsl:if test='$thestatus = "Deferred"'><li class='current inserted'>Deferred</li></xsl:if>
        <xsl:if test='$thestatus = "Retracted"'><li class='current inserted'>Retracted</li></xsl:if>
        <li><xsl:if test='$thestatus = "Proposed"'><xsl:attribute name='class'>current</xsl:attribute></xsl:if>Proposed</li>
        <xsl:if test='$thestatus = "Rejected"'><li class='current inserted'>Rejected</li></xsl:if>
        <li><xsl:if test='$thestatus = "Active"'><xsl:attribute name='class'>current</xsl:attribute></xsl:if>Active</li>
        <xsl:if test='$thestatus = "Deprecated" or $thestatus = "Obsolete"'>
          <li><xsl:if test='$thestatus = "Deprecated"'><xsl:attribute name='class'>current</xsl:attribute></xsl:if>Deprecated</li>
          <li><xsl:if test='$thestatus = "Obsolete"'><xsl:attribute name='class'>current</xsl:attribute></xsl:if>Obsolete</li>
        </xsl:if>
      </xsl:when>
      <xsl:when test='$thetype = "Humorous"'>
        <li><xsl:if test='$thestatus = "Active"'><xsl:attribute name='class'>current</xsl:attribute></xsl:if>Active</li>
      </xsl:when>
      <xsl:otherwise>
        <li class='current inserted'><xsl:value-of select='$thestatus'/></li>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match='/'>
    <html lang='en'>
      <head>
        <title>XEP-<xsl:value-of select='/xep/header/number'/>:<xsl:text> </xsl:text><xsl:value-of select='/xep/header/title' /></title>
        <style type='text/css'>
/* don't mind this hack */
nav#toc h2:before {
display: none;
content: "XEP-<xsl:value-of select='/xep/header/number'/>";
}
        </style>
        <link rel='stylesheet' type='text/css' href='xmpp.css' />
        <link href="prettify.css" type="text/css" rel="stylesheet" />
        <link rel='shortcut icon' type='image/x-icon' href='/favicon.ico' />
        <script type="text/javascript" src="prettify.js">
          <xsl:comment></xsl:comment>
        </script>
        <!-- making things mobile-friendly... -->
        <meta>
          <xsl:attribute name='name'><xsl:text>viewport</xsl:text></xsl:attribute>
          <xsl:attribute name='content'>width=device-width, initial-scale=1.0</xsl:attribute>
        </meta>
        <!-- BEGIN META TAGS FOR DUBLIN CORE -->
        <meta>
          <xsl:attribute name='name'><xsl:text>DC.Title</xsl:text></xsl:attribute>
          <xsl:attribute name='content'><xsl:value-of select='/xep/header/title'/></xsl:attribute>
        </meta>
        <xsl:apply-templates select='/xep/header/author' mode='meta'/>
        <meta>
          <xsl:attribute name='name'><xsl:text>DC.Description</xsl:text></xsl:attribute>
          <xsl:attribute name='content'><xsl:value-of select='/xep/header/abstract'/></xsl:attribute>
        </meta>
        <meta>
          <xsl:attribute name='name'><xsl:text>DC.Publisher</xsl:text></xsl:attribute>
          <xsl:attribute name='content'>XMPP Standards Foundation</xsl:attribute>
        </meta>
        <meta>
          <xsl:attribute name='name'><xsl:text>DC.Contributor</xsl:text></xsl:attribute>
          <xsl:attribute name='content'>XMPP Extensions Editor</xsl:attribute>
        </meta>
        <meta>
          <xsl:attribute name='name'><xsl:text>DC.Date</xsl:text></xsl:attribute>
          <xsl:attribute name='content'><xsl:value-of select='/xep/header/revision/date'/></xsl:attribute>
        </meta>
        <meta>
          <xsl:attribute name='name'><xsl:text>DC.Type</xsl:text></xsl:attribute>
          <xsl:attribute name='content'>XMPP Extension Protocol</xsl:attribute>
        </meta>
        <meta>
          <xsl:attribute name='name'><xsl:text>DC.Format</xsl:text></xsl:attribute>
          <xsl:attribute name='content'>XHTML</xsl:attribute>
        </meta>
        <meta>
          <xsl:attribute name='name'><xsl:text>DC.Identifier</xsl:text></xsl:attribute>
          <xsl:attribute name='content'>XEP-<xsl:value-of select='/xep/header/number'/></xsl:attribute>
        </meta>
        <meta>
          <xsl:attribute name='name'><xsl:text>DC.Language</xsl:text></xsl:attribute>
          <xsl:attribute name='content'>en</xsl:attribute>
        </meta>
        <meta>
          <xsl:attribute name='name'><xsl:text>DC.Rights</xsl:text></xsl:attribute>
          <xsl:attribute name='content'><xsl:value-of select='/xep/header/legal/copyright'/></xsl:attribute>
        </meta>
        <!-- END META TAGS FOR DUBLIN CORE -->
      </head>
      <body onload="prettyPrint()">
        <!-- TITLE -->
        <h1>XEP-<xsl:value-of select='/xep/header/number' />:<xsl:text> </xsl:text><xsl:value-of select='/xep/header/title' /></h1>
        <!-- TOP TABLE -->
        <xsl:variable name='authors.count' select='count(/xep/header/author)'/>
        <div class="docmeta-wrap">
        <dl id="docmeta" class='compact'>
          <dt>Abstract</dt>
          <dd><xsl:value-of select='/xep/header/abstract'/></dd>
          <xsl:if test='$authors.count=1'>
            <dt>Author</dt>
            <dd><xsl:value-of select='/xep/header/author/firstname'/><xsl:text> </xsl:text><xsl:value-of select='/xep/header/author/surname'/></dd>
          </xsl:if>
          <xsl:if test='$authors.count&gt;1'>
            <dt>Authors</dt>
            <dd><ul class='authors'>
                <xsl:for-each select='/xep/header/author'>
                  <li><xsl:value-of select='firstname'/><xsl:text> </xsl:text><xsl:value-of select='surname'/></li>
                </xsl:for-each>
            </ul></dd>
          </xsl:if>
          <dt>Copyright</dt>
          <!-- Extract the copyright years from the dates via
               substring(). If we ever use XSL 2.0, then we could use
               year-from-date(xs:date()) -->
          <dd>&#169; <xsl:value-of select='substring(/xep/header/revision[position()=last()]/date,1,4)'/> &#x2013; <xsl:value-of select='substring(/xep/header/revision[position()=1]/date,1,4)'/> XMPP Standards Foundation. <a href='#appendix-legal'>SEE LEGAL NOTICES</a>.</dd>
          <dt>Status</dt>
          <dd>
            <p><xsl:choose>
              <xsl:when test='string(/xep/header/status) = "Draft"'>Stable</xsl:when>
              <xsl:otherwise><xsl:value-of select='/xep/header/status'/></xsl:otherwise>
            </xsl:choose></p>
            <xsl:call-template name='status-notice'>
              <xsl:with-param name='thestatus' select='/xep/header/status'/>
              <xsl:with-param name='thetype' select='/xep/header/type'/>
            </xsl:call-template>
          </dd>
          <xsl:variable name='supersedes.count' select='count(/xep/header/supersedes/spec)'/>
          <xsl:choose>
            <xsl:when test='$supersedes.count &gt; 0'>
              <dt>Supersedes</dt>
              <dd>
                <xsl:apply-templates select='/xep/header/supersedes/spec'>
                  <xsl:with-param name='speccount' select='$supersedes.count'/>
                </xsl:apply-templates>
              </dd>
            </xsl:when>
          </xsl:choose>
            <xsl:variable name='supersededby.count' select='count(/xep/header/supersededby/spec)'/>
          <xsl:choose>
            <xsl:when test='$supersededby.count &gt; 0'>
              <dt>Superseded By</dt>
              <dd>
                <xsl:apply-templates select='/xep/header/supersededby/spec'>
                  <xsl:with-param name='speccount' select='$supersededby.count'/>
                </xsl:apply-templates>
              </dd>
            </xsl:when>
          </xsl:choose>
          <dt>Type</dt>
          <dd><xsl:value-of select='/xep/header/type'/></dd>
          <dt>Version</dt>
          <dd><xsl:value-of select='/xep/header/revision[position()=1]/version'/> (<xsl:value-of select='/xep/header/revision[position()=1]/date'/>)</dd>
        </dl>
        <div class="timeline-wrap">
          <div class="timeline-head">Document Lifecycle</div>
          <ol class="timeline">
            <xsl:call-template name='make-timeline'>
              <xsl:with-param name='thestatus' select='/xep/header/status'/>
              <xsl:with-param name='thetype' select='/xep/header/type'/>
            </xsl:call-template>
        </ol></div>
        </div>
        <!-- COUNCIL NOTE -->
        <xsl:apply-templates select='/xep/header/councilnote'/>
        <!-- TABLE OF CONTENTS -->
        <nav id="toc">
          <xsl:call-template name='processTOC' />
        </nav>
        <!-- END FRONT MATTER -->
        <!-- BEGIN XEP CONTENTS -->
        <xsl:apply-templates select='/xep/section1'/>
        <!-- END XEP CONTENTS -->
        <!-- BEGIN APPENDICES -->
        <hr />
        <a name='appendices'></a>
        <h2>Appendices</h2>
        <!-- XEP INFO -->
        <h3 id='appendix-docinfo'>Appendix A: Document Information<xsl:call-template name='anchor-link'><xsl:with-param name='anchor' select='"appendix-docinfo"'/></xsl:call-template></h3>
        <dl class='compact'>
          <dt>Series</dt>
          <dd><a href='https://xmpp.org/extensions/'>XEP</a></dd>
          <dt>Number</dt>
          <dd><xsl:value-of select='/xep/header/number'/></dd>
          <dt>Publisher</dt>
          <dd><a href='/xsf/'>XMPP Standards Foundation</a></dd>
          <dt>Status</dt>
          <dd><a>
            <xsl:attribute name='href'><xsl:text>https://xmpp.org/extensions/xep-0001.html#states-</xsl:text><xsl:value-of select='/xep/header/status'/></xsl:attribute>
            <xsl:choose>
              <xsl:when test='string(/xep/header/status) = "Draft"'>Stable</xsl:when>
              <xsl:otherwise><xsl:value-of select='/xep/header/status'/></xsl:otherwise>
              <xsl:value-of select='/xep/header/status'/>
            </xsl:choose>
          </a></dd>
          <dt>Type</dt>
          <dd><a>
            <xsl:attribute name='href'><xsl:text>https://xmpp.org/extensions/xep-0001.html#types-</xsl:text><xsl:value-of select='/xep/header/type'/></xsl:attribute>
            <xsl:value-of select='/xep/header/type'/>
          </a></dd>
          <dt>Version</dt>
          <dd><xsl:value-of select='/xep/header/revision[position()=1]/version'/></dd>
          <dt>Last Updated</dt>
          <dd><xsl:value-of select='/xep/header/revision[position()=1]/date'/></dd>
          <xsl:variable name='expires.count' select='count(/xep/header/expires)'/>
          <xsl:if test='$expires.count=1'>
            <dt>Expires</dt><dd><xsl:value-of select='/xep/header/expires'/></dd>
          </xsl:if>
          <xsl:variable name='ApprovingBody' select='/xep/header/approver'/>
          <dt>Approving Body</dt>
          <xsl:choose>
            <xsl:when test='$ApprovingBody = "Board"'>
              <dd><a href='https://xmpp.org/xsf/board/'>XSF Board of Directors</a></dd>
            </xsl:when>
            <xsl:otherwise>
              <dd><a href='https://xmpp.org/council/'>XMPP Council</a></dd>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:variable name='dependencies.count' select='count(/xep/header/dependencies/spec)'/>
          <dt>Dependencies</dt>
          <dd>
            <xsl:choose>
              <xsl:when test='$dependencies.count &gt; 0'>
                <xsl:apply-templates select='/xep/header/dependencies/spec'>
                  <xsl:with-param name='speccount' select='$dependencies.count'/>
                </xsl:apply-templates>
              </xsl:when>
              <xsl:otherwise>
                None
              </xsl:otherwise>
            </xsl:choose>
          </dd>
          <dt>Supersedes</dt>
          <dd>
            <xsl:variable name='supersedes.count' select='count(/xep/header/supersedes/spec)'/>
            <xsl:choose>
              <xsl:when test='$supersedes.count &gt; 0'>
                <xsl:apply-templates select='/xep/header/supersedes/spec'>
                  <xsl:with-param name='speccount' select='$supersedes.count'/>
                </xsl:apply-templates>
              </xsl:when>
              <xsl:otherwise>None</xsl:otherwise>
            </xsl:choose>
          </dd>
          <dt>Superseded By</dt>
          <dd>
            <xsl:variable name='supersededby.count' select='count(/xep/header/supersededby/spec)'/>
            <xsl:choose>
              <xsl:when test='$supersededby.count &gt; 0'>
                <xsl:apply-templates select='/xep/header/supersededby/spec'>
                  <xsl:with-param name='speccount' select='$supersededby.count'/>
                </xsl:apply-templates>
              </xsl:when>
              <xsl:otherwise>None</xsl:otherwise>
            </xsl:choose>
          </dd>
          <dt>Short Name</dt>
          <dd><xsl:value-of select='/xep/header/shortname'/></dd>
          <xsl:variable name='schema.count' select='count(/xep/header/schemaloc)'/>
          <xsl:if test='$schema.count &gt; 0'>
            <dt>Schema</dt>
            <xsl:apply-templates select='/xep/header/schemaloc'/>
          </xsl:if>
          <xsl:variable name='reg.count' select='count(/xep/header/registry)'/>
          <xsl:if test='$reg.count=1'>
            <dt>Registry</dt>
            <dd>
              <xsl:variable name='registryURL'>
                <xsl:text>https://xmpp.org/registrar/</xsl:text>
                <xsl:value-of select='/xep/header/shortname'/>
                <xsl:text>.html</xsl:text>
              </xsl:variable>
              &lt;<a href='{$registryURL}'><xsl:value-of select='$registryURL'/></a>&gt;
            </dd>
          </xsl:if>
          <xsl:variable name='sourceHTML'>
            <xsl:text>https://github.com/xsf/xeps/blob/master/xep-</xsl:text>
            <xsl:value-of select='/xep/header/number'/>
            <xsl:text>.xml</xsl:text>
          </xsl:variable>
          <xsl:if test='/xep/header/status != "ProtoXEP"'>
            <dt>Source Control</dt>
            <dd><a class='standardsButton' href='{$sourceHTML}'>HTML</a></dd>
          </xsl:if>
        </dl>
        <p>
          <xsl:variable name='formatXML'>
            <xsl:text>https://xmpp.org/extensions/xep-</xsl:text>
            <xsl:value-of select='/xep/header/number'/>
            <xsl:text>.xml</xsl:text>
          </xsl:variable>
          <xsl:variable name='formatPDF'>
            <xsl:text>https://xmpp.org/extensions/xep-</xsl:text>
            <xsl:value-of select='/xep/header/number'/>
            <xsl:text>.pdf</xsl:text>
          </xsl:variable>
          This document in other formats:
          <a class='standardsButton' href='{$formatXML}'>XML</a>&#160;
          <a class='standardsButton' href='{$formatPDF}'>PDF</a>
        </p>
        <!-- AUTHOR INFO -->
        <h3 id='appendix-authorinfo'>Appendix B: Author Information<xsl:call-template name='anchor-link'><xsl:with-param name='anchor' select='"appendix-authorinfo"'/></xsl:call-template></h3>
        <xsl:apply-templates select='/xep/header/author'/>
        <!-- LEGAL NOTICES -->
        <h3 id='appendix-legal'>Appendix C: Legal Notices<xsl:call-template name='anchor-link'><xsl:with-param name='anchor' select='"appendix-legal"'/></xsl:call-template></h3>
        <xsl:apply-templates select='/xep/header/legal'/>
        <!-- XMPP NOTICE -->
        <h3 id='appendix-xmpp'>Appendix D: Relation to XMPP<xsl:call-template name='anchor-link'><xsl:with-param name='anchor' select='"appendix-xmpp"'/></xsl:call-template></h3>
        <p class='indent'>The Extensible Messaging and Presence Protocol (XMPP) is defined in the XMPP Core (RFC 6120) and XMPP IM (RFC 6121) specifications contributed by the XMPP Standards Foundation to the Internet Standards Process, which is managed by the Internet Engineering Task Force in accordance with RFC 2026. Any protocol defined in this document has been developed outside the Internet Standards Process and is to be understood as an extension to XMPP rather than as an evolution, development, or modification of XMPP itself.</p>
        <!-- DISCUSSION VENUE -->
        <h3 id='appendix-discuss'>Appendix E: Discussion Venue<xsl:call-template name='anchor-link'><xsl:with-param name='anchor' select='"appendix-discuss"'/></xsl:call-template></h3>
        <xsl:variable name='discuss.count' select='count(/xep/header/discuss)'/>
        <xsl:variable name='discuss.venue' select='count(/xep/header/discuss)'/>
        <xsl:if test='$discuss.count=1'>
          <xsl:variable name='discussWeb'>
            <xsl:text>https://mail.jabber.org/mailman/listinfo/</xsl:text>
            <xsl:value-of select='/xep/header/discuss'/>
          </xsl:variable>
          <xsl:variable name='discussMail'>
            <xsl:value-of select='/xep/header/discuss'/>
            <xsl:text>@xmpp.org</xsl:text>
          </xsl:variable>
          <p class='indent'>There exists a special venue for discussion related to the technology described in this document: the &lt;<a href='{$discussWeb}'><xsl:value-of select='$discussMail'/></a>&gt; mailing list.</p>
        </xsl:if>
        <xsl:variable name='Approver' select='/xep/header/approver'/>
        <xsl:choose>
          <xsl:when test='$Approver = "Board"'>
            <p class='indent'>The primary venue for discussion of XMPP Extension Protocols is the &lt;<a href="https://mail.jabber.org/mailman/listinfo/standards">standards@xmpp.org</a>&gt; discussion list.</p>
            <p class='indent'>Discussion by the membership of the XSF might also be appropriate (see &lt;<a href="https://mail.jabber.org/mailman/listinfo/members">https://mail.jabber.org/mailman/listinfo/members</a>&gt; for details).</p>
          </xsl:when>
          <xsl:otherwise>
            <p class='indent'>The primary venue for discussion of XMPP Extension Protocols is the &lt;<a href="https://mail.jabber.org/mailman/listinfo/standards">standards@xmpp.org</a>&gt; discussion list.</p>
            <p class='indent'>Discussion on other xmpp.org discussion lists might also be appropriate; see &lt;<a href='https://xmpp.org/community/'>https://xmpp.org/community/</a>&gt; for a complete list.</p>
            <xsl:if test='contains(/xep/header/dependencies,"RFC")'>
              <p class='indent'>Given that this XMPP Extension Protocol normatively references IETF technologies, discussion on the &lt;<a href="https://mail.jabber.org/mailman/listinfo/xsf-ietf">xsf-ietf@xmpp.org</a>&gt; list might also be appropriate.</p>
            </xsl:if>
          </xsl:otherwise>
        </xsl:choose>
        <p class='indent'>Errata can be sent to &lt;<a href='mailto:editor@xmpp.org'>editor@xmpp.org</a>&gt;.</p>
        <!-- CONFORMANCE TERMS-->
        <h3 id='appendix-conformance'>Appendix F: Requirements Conformance<xsl:call-template name='anchor-link'><xsl:with-param name='anchor' select='"appendix-conformance"'/></xsl:call-template></h3>
        <p class='indent'>
          The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT",
          "SHOULD", "SHOULD NOT", "RECOMMENDED", "NOT RECOMMENDED",
          "MAY", and "OPTIONAL" in this document are to be interpreted as
          described in <a href="https://tools.ietf.org/rfc/bcp/bcp14.txt">BCP 14</a>
          [<a href="https://www.ietf.org/rfc/rfc2119.txt">RFC2119</a>]
          [<a href="https://tools.ietf.org/rfc/rfc8174.txt">RFC8174</a>] when,
          and only when, they appear in all capitals, as shown here.
        </p>
        <!-- NOTES -->
        <h3 id='appendix-notes'>Appendix G: Notes<xsl:call-template name='anchor-link'><xsl:with-param name='anchor' select='"appendix-notes"'/></xsl:call-template></h3>
          <div class='indent'>
          <xsl:for-each select="//note">
            <xsl:variable name='me' select='.' />
            <xsl:variable name='firstOccurrence' select='(//note[. = $me])[1]' />
            <xsl:variable name='oid' select='generate-id($firstOccurrence)' />
            <xsl:variable name='notenum' select='count($firstOccurrence/preceding::note[not(.=preceding::note)]) + count($me/ancestor::note) + 1' />
            <xsl:if test='generate-id($me) = generate-id($firstOccurrence)'>
              <p>
                <a name='nt-{$oid}'><xsl:value-of select='$notenum'/></a>
                <xsl:text>. </xsl:text>
                <xsl:apply-templates/>
              </p>
            </xsl:if>
          </xsl:for-each>
          </div>
        <!-- REVISION HISTORY -->
        <h3 id='appendix-revs'>Appendix H: Revision History<xsl:call-template name='anchor-link'><xsl:with-param name='anchor' select='"appendix-revs"'/></xsl:call-template></h3>
          <p>Note: Older versions of this specification might be available at <a href='https://xmpp.org/extensions/attic/'>https://xmpp.org/extensions/attic/</a></p>
          <ol class="revision-history">
            <xsl:apply-templates select='/xep/header/revision'/>
          </ol>
        <h3 id='appendix-biblatex'>Appendix I: Bib(La)TeX Entry</h3>
        <xsl:variable name="lowercase" select="'abcdefghijklmnopqrstuvwxyz'" />
        <xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />
        <xsl:variable name="lowercased-surname-firstauthor">
          <xsl:value-of select='translate(/xep/header/author[position()=1]/surname, $uppercase, $lowercase)'/>
        </xsl:variable>
        <xsl:variable name="year-of-first-history-entry">
          <xsl:value-of select='substring(/xep/header/revision[position()=last()]/date,1,4)'/>
        </xsl:variable>
        <!-- Use the XEPs shortname as citekey postfix if one was
             assigned, otherwise the XEP number -->
        <xsl:variable name="bibtex-citekey-postfix">
          <xsl:choose>
            <xsl:when test='/xep/header/shortname = "NOT_YET_ASSIGNED"'>
              <xsl:text>xep</xsl:text><xsl:value-of select='/xep/header/number'/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select='translate(/xep/header/shortname, $uppercase, $lowercase)'/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="bibtex-url">
          <xsl:choose>
            <!-- XEPs after a certain number have an immutable version to which we preferably link -->
            <!-- TODO: We currently have no versioned link for the latest version of a XEP,
                 hence the logic below is disabled for all XEPs, by testing for XEP version number > 99999 -->
            <xsl:when test='/xep/header/number &gt; 999999'>
              <xsl:text>https://xmpp.org/extensions/attic/xep-</xsl:text>
              <xsl:value-of select='/xep/header/number'/>
              <xsl:text>-</xsl:text>
              <xsl:value-of select='/xep/header/revision[position()=1]/version'/>
              <xsl:text>.html</xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>https://xmpp.org/extensions/xep-</xsl:text>
              <xsl:value-of select='/xep/header/number'/>
              <xsl:text>.html</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <pre>
<!-- If we had XSL 2.0 we could use year-from-date() and lower-case() below. -->
@report{<xsl:value-of select='$lowercased-surname-firstauthor'/><xsl:value-of select='$year-of-first-history-entry'/><xsl:value-of select='$bibtex-citekey-postfix'/>,
  title = {<xsl:value-of select='/xep/header/title'/>},
  author = {<xsl:for-each select='/xep/header/author'><xsl:value-of select='surname'/><xsl:text>, </xsl:text><xsl:value-of select='firstname'/><xsl:if test="not(position() = last())"> and </xsl:if></xsl:for-each>},
  type = {XEP},
  number = {<xsl:value-of select='/xep/header/number'/>},
  version = {<xsl:value-of select='/xep/header/revision[position()=1]/version'/>},
  institution = {XMPP Standards Foundation},
  url = {<xsl:value-of select='$bibtex-url'/>},
  date = {<xsl:value-of select='/xep/header/revision[position()=last()]/date'/>/<xsl:value-of select='/xep/header/revision[position()=1]/date'/>},
}</pre>
        <p>END</p>
      </body>
    </html>
  </xsl:template>

  <!-- From the docbook XSL -->
  <xsl:template name="object.id">
    <xsl:param name="object" select="."/>
    <xsl:choose>
      <xsl:when test="$object/@id">
        <xsl:value-of select="$object/@id"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="generate-id($object)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name='processTOC'>
    <a href="#top"><h2>Table of Contents</h2></a>
    <ol class='toc'>
      <xsl:apply-templates select='//section1' mode='toc'/>
    </ol>
    <h6><a href='#appendices'>Appendices</a></h6>
    <ol class='toc-appendices'>
      <li><a href="#appendix-docinfo">Document Information</a></li>
      <li><a href="#appendix-authorinfo">Author Information</a></li>
      <li><a href="#appendix-legal">Legal Notices</a></li>
      <li><a href="#appendix-xmpp">Relation to XMPP</a></li>
      <li><a href="#appendix-discuss">Discussion Venue</a></li>
      <li><a href="#appendix-conformance">Requirements Conformance</a></li>
      <li><a href="#appendix-notes">Notes</a></li>
      <li><a href="#appendix-revs">Revision History</a></li>
      <li><a href="#appendix-biblatex">Bib(La)Tex Entry</a></li>
    </ol>
  </xsl:template>

  <xsl:template match='councilnote'>
    <hr />
    <div>
      <h3>COUNCIL NOTE</h3>
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <xsl:template match='author' mode='meta'>
    <meta>
      <xsl:attribute name='name'><xsl:text>DC.Creator</xsl:text></xsl:attribute>
      <xsl:attribute name='content'><xsl:value-of select='firstname'/><xsl:text> </xsl:text><xsl:value-of select='surname'/></xsl:attribute>
    </meta>
  </xsl:template>

  <xsl:template match='author'>
    <h5><xsl:value-of select='firstname'/><xsl:text> </xsl:text><xsl:value-of select='surname'/></h5>
    <xsl:variable name='org.count' select='count(org)'/>
    <xsl:variable name='email.count' select='count(email)'/>
    <xsl:variable name='jid.count' select='count(jid)'/>
    <xsl:variable name='uri.count' select='count(uri)'/>
    <xsl:variable name='authornote.count' select='count(authornote)'/>
    <xsl:if test='$authornote.count &gt; 0'>
      See <a href='#authornote'>Author Note</a><br />
    </xsl:if>
    <dl class='compact'>
      <xsl:if test='$org.count=1'>
        <dt>Organization</dt>
        <dd><xsl:value-of select='org'/></dd>
      </xsl:if>
      <xsl:if test='$email.count=1'>
        <dt>Email</dt>
        <dd>
          <a>
            <xsl:attribute name='href'>
              <xsl:text>mailto:</xsl:text>
              <xsl:value-of select='email' />
            </xsl:attribute>
            <xsl:value-of select='email' />
          </a>
        </dd>
      </xsl:if>
      <xsl:if test='$jid.count=1'>
        <dt>JabberID</dt>
        <dd>
          <a>
            <xsl:attribute name='href'>
              <xsl:text>xmpp:</xsl:text>
              <xsl:value-of select='jid' />
            </xsl:attribute>
            <xsl:value-of select='jid' />
          </a>
        </dd>
      </xsl:if>
      <xsl:if test='$uri.count=1'>
        <dt>URI</dt>
        <dd>
          <a>
            <xsl:attribute name='href'>
              <xsl:value-of select='uri' />
            </xsl:attribute>
            <xsl:value-of select='uri' />
          </a>
        </dd>
      </xsl:if>
    </dl>
  </xsl:template>

  <xsl:template match='legal'>
    <div class='indent'>
      <h4>Copyright</h4>
      <p><xsl:apply-templates select='/xep/header/legal/copyright'/></p>
      <h4>Permissions</h4>
      <p><xsl:apply-templates select='/xep/header/legal/permissions'/></p>
      <h4>Disclaimer of Warranty</h4>
      <p class="box info">
        <xsl:apply-templates select='/xep/header/legal/warranty'/>
      </p>
      <h4>Limitation of Liability</h4>
      <p><xsl:apply-templates select='/xep/header/legal/liability'/></p>
      <h4>IPR Conformance</h4>
      <p><xsl:apply-templates select='/xep/header/legal/conformance'/></p>
      <h4>Visual Presentation</h4>
      <p>The HTML representation (you are looking at) is maintained by the XSF. It is based on the <a href="http://yaml.de">YAML CSS Framework</a>, which is licensed under the terms of the <a href="https://creativecommons.org/licenses/by/2.0/">CC-BY-SA 2.0</a> license.</p>
    </div>
  </xsl:template>

  <xsl:template match='spec'>
    <xsl:param name='speccount' select='""'/>
    <xsl:variable name='specpos' select='position()'/>
    <xsl:variable name='spec' select='translate(string(.), "ABCDEFGHIJKLMNOPQRSTUVWXYZ", "abcdefghijklmnopqrstuvwxyz")'/>
    <xsl:choose>
      <xsl:when test='starts-with($spec, "xep-")'><a>
        <xsl:attribute name="href"><xsl:value-of select="$spec"/>.html</xsl:attribute>
        <xsl:value-of select='.'/>
      </a></xsl:when>
      <xsl:when test='starts-with($spec, "rfc ")'>
        <xsl:variable name='rfcno' select='substring-after($spec, "rfc ")'/>
        <a>
          <xsl:attribute name="href">https://datatracker.ietf.org/doc/html/rfc<xsl:value-of select="$rfcno"/></xsl:attribute>
          <xsl:value-of select='.'/>
        </a>
      </xsl:when>
      <xsl:otherwise><xsl:value-of select='.'/></xsl:otherwise>
    </xsl:choose>
    <xsl:if test='$specpos &lt; $speccount'>
      <xsl:text>, </xsl:text>
    </xsl:if>
  </xsl:template>

  <xsl:template match='schemaloc'>
    <xsl:variable name='this.url' select='url'/>
    <xsl:variable name='ns.count' select='count(ns)'/>
    <dd>
    <xsl:choose>
      <xsl:when test="$ns.count=1">
        XML Schema for the '<xsl:value-of select='ns'/>' namespace: &lt;<a href='{$this.url}'><xsl:value-of select='url'/></a>&gt;<br />
      </xsl:when>
      <xsl:otherwise>
        &lt;<a href='{$this.url}'><xsl:value-of select='url'/></a>&gt;<br />
      </xsl:otherwise>
    </xsl:choose>
    </dd>
  </xsl:template>

  <xsl:template match='revision'>
    <li>
      <xsl:variable name='anchor'>revision-history-v<xsl:value-of select='version'/></xsl:variable>
      <xsl:attribute name='id'><xsl:value-of select='$anchor'/></xsl:attribute>
      <div class='revision-head'>Version <a>
        <xsl:attribute name='href'>
          <xsl:text>https://xmpp.org/extensions/attic/xep-</xsl:text>
          <xsl:value-of select='/xep/header/number'/>
          <xsl:text>-</xsl:text>
          <xsl:value-of select='version'/>
          <xsl:text>.html</xsl:text>
        </xsl:attribute>
        <xsl:value-of select='version'/>
      </a>
      <xsl:text> </xsl:text>(<xsl:value-of select='date'/>)<xsl:call-template name='anchor-link'><xsl:with-param name='anchor' select='$anchor'/></xsl:call-template></div>
      <xsl:apply-templates select='remark'/>
      <div class='revision-author'><xsl:value-of select='initials'/></div>
    </li>
  </xsl:template>

  <xsl:template match='section1' mode='toc'>
    <xsl:variable name='oid'>
      <xsl:call-template name='object.id'/>
    </xsl:variable>
    <xsl:variable name='anch'>
      <xsl:value-of select='@anchor'/>
    </xsl:variable>
    <xsl:variable name='num'>
      <xsl:number level='multiple' count='section1'/><xsl:text>.</xsl:text>
    </xsl:variable>
    <xsl:variable name='sect2.count' select='count(section2)'/>
    <li>
      <a>
        <xsl:attribute name='href'>
          <xsl:text>#</xsl:text>
          <xsl:choose>
            <xsl:when test='$anch != ""'>
              <xsl:value-of select='@anchor'/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>sect-</xsl:text>
              <xsl:value-of select='$oid'/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
        <xsl:value-of select='@topic' />
      </a>
      <xsl:if test='$sect2.count &gt; 0'>
        <ol>
          <xsl:apply-templates select='section2' mode='toc'>
            <xsl:with-param name='prevnum' select='$num'/>
          </xsl:apply-templates>
        </ol>
      </xsl:if>
    </li>
  </xsl:template>

  <xsl:template match='section1'>
    <xsl:variable name='oid'>
      <xsl:call-template name='object.id'/>
    </xsl:variable>
    <xsl:variable name='anch'>
      <xsl:value-of select='@anchor'/>
    </xsl:variable>
    <h2>
      <xsl:variable name='anchor'>
        <xsl:choose>
          <xsl:when test='$anch != ""'>
            <xsl:value-of select='@anchor'/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>sect-</xsl:text><xsl:value-of select='$oid'/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:attribute name='id'><xsl:value-of select='$anchor'/></xsl:attribute>
      <xsl:number level='single' count='section1'/>.
      <xsl:text> </xsl:text>
      <xsl:value-of select='@topic' />
      <xsl:call-template name='anchor-link'><xsl:with-param name='anchor' select='$anchor'/></xsl:call-template>
    </h2>
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match='section2' mode='toc'>
    <xsl:param name='prevnum' select='""'/>
    <xsl:variable name='oid'>
      <xsl:call-template name='object.id'/>
    </xsl:variable>
    <xsl:variable name='anch'>
      <xsl:value-of select='@anchor'/>
    </xsl:variable>
    <xsl:variable name='num'>
      <xsl:value-of select='$prevnum'/><xsl:number level='multiple' count='section2'/><xsl:text>.</xsl:text>
    </xsl:variable>
    <xsl:variable name='sect3.count' select='count(section3)'/>
    <li>
      <a>
        <xsl:attribute name='href'>
          <xsl:text>#</xsl:text>
          <xsl:choose>
            <xsl:when test='$anch != ""'>
              <xsl:value-of select='@anchor'/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>sect-</xsl:text><xsl:value-of select='$oid'/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
        <xsl:value-of select='@topic' />
      </a>
      <xsl:if test='$sect3.count &gt; 0'>
        <ol>
          <xsl:apply-templates select='section3' mode='toc'>
            <xsl:with-param name='prevnum' select='$num'/>
          </xsl:apply-templates>
        </ol>
      </xsl:if>
    </li>
  </xsl:template>

  <xsl:template match='section2'>
    <xsl:variable name='oid'>
      <xsl:call-template name='object.id'/>
    </xsl:variable>
    <xsl:variable name='anch'>
      <xsl:value-of select='@anchor'/>
    </xsl:variable>
    <div class='indent'>
    <h3>
      <xsl:variable name='anchor'>
        <xsl:choose>
          <xsl:when test='$anch != ""'>
            <xsl:value-of select='@anchor'/>
          </xsl:when>
          <xsl:otherwise>
              <xsl:text>sect-</xsl:text><xsl:value-of select='$oid'/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:attribute name='id'><xsl:value-of select='$anchor'/></xsl:attribute>
      <xsl:number level='single' count='section1'/>.<xsl:number level='single' count='section2'/>
      <xsl:text> </xsl:text>
      <xsl:value-of select='@topic' />
      <xsl:call-template name='anchor-link'><xsl:with-param name='anchor' select='$anchor'/></xsl:call-template>
    </h3>
    <xsl:apply-templates/>
    </div>
  </xsl:template>

  <xsl:template match='section3' mode='toc'>
    <xsl:param name='prevnum' select='""'/>
    <xsl:variable name='oid'>
      <xsl:call-template name='object.id'/>
    </xsl:variable>
    <xsl:variable name='anch'>
      <xsl:value-of select='@anchor'/>
    </xsl:variable>
    <xsl:variable name='num'>
      <xsl:value-of select='$prevnum'/><xsl:number level='multiple' count='section3'/><xsl:text>.</xsl:text>
    </xsl:variable>
    <xsl:variable name='sect4.count' select='count(section4)'/>
    <li>
      <a>
        <xsl:attribute name='href'>
          <xsl:text>#</xsl:text>
          <xsl:choose>
            <xsl:when test='$anch != ""'>
              <xsl:value-of select='@anchor'/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>sect-</xsl:text><xsl:value-of select='$oid'/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
        <xsl:value-of select='@topic' />
      </a>
      <xsl:if test='$sect4.count &gt; 0'>
        <ol>
          <xsl:apply-templates select='section4' mode='toc'>
            <xsl:with-param name='prevnum' select='$num'/>
          </xsl:apply-templates>
        </ol>
      </xsl:if>
    </li>
  </xsl:template>

  <xsl:template match='section3'>
    <xsl:variable name='oid'>
      <xsl:call-template name='object.id'/>
    </xsl:variable>
    <xsl:variable name='anch'>
      <xsl:value-of select='@anchor'/>
    </xsl:variable>
    <div class='indent'>
    <h4>
      <xsl:variable name='anchor'>
        <xsl:choose>
          <xsl:when test='$anch != ""'>
            <xsl:value-of select='@anchor'/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>sect-</xsl:text><xsl:value-of select='$oid'/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:attribute name='id'><xsl:value-of select='$anchor'/></xsl:attribute>
      <xsl:number level='single' count='section1'/>.<xsl:number level='single' count='section2'/>.<xsl:number level='single' count='section3'/>
      <xsl:text> </xsl:text>
      <xsl:value-of select='@topic' />
      <xsl:call-template name='anchor-link'><xsl:with-param name='anchor' select='$anchor'/></xsl:call-template>
    </h4>
    <xsl:apply-templates/>
    </div>
  </xsl:template>

  <xsl:template match='section4' mode='toc'>
    <xsl:param name='prevnum' select='""'/>
    <xsl:variable name='oid'>
      <xsl:call-template name='object.id'/>
    </xsl:variable>
    <xsl:variable name='anch'>
      <xsl:value-of select='@anchor'/>
    </xsl:variable>
    <xsl:variable name='num'>
      <xsl:value-of select='$prevnum'/><xsl:number level='multiple' count='section4'/><xsl:text>.</xsl:text>
    </xsl:variable>
    <li>
      <a>
        <xsl:attribute name='href'>
          <xsl:text>#</xsl:text>
          <xsl:choose>
            <xsl:when test='$anch != ""'>
              <xsl:value-of select='@anchor'/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>sect-</xsl:text><xsl:value-of select='$oid'/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
        <xsl:value-of select='@topic' />
      </a>
    </li>
  </xsl:template>

  <xsl:template match='section4'>
    <xsl:variable name='oid'>
      <xsl:call-template name='object.id'/>
    </xsl:variable>
    <xsl:variable name='anch'>
      <xsl:value-of select='@anchor'/>
    </xsl:variable>
    <div class='indent'>
    <h5>
      <xsl:attribute name='id'>
        <xsl:choose>
          <xsl:when test='$anch != ""'>
            <xsl:value-of select='@anchor'/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>sect-</xsl:text><xsl:value-of select='$oid'/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:number level='single' count='section1'/>.<xsl:number level='single' count='section2'/>.<xsl:number level='single' count='section3'/>.<xsl:number level='single' count='section4'/>
      <xsl:text> </xsl:text>
      <xsl:value-of select='@topic' />
    </h5>
    <xsl:apply-templates/>
    </div>
  </xsl:template>

  <xsl:template match='section5'>
    <xsl:variable name='oid'>
      <xsl:call-template name='object.id'/>
    </xsl:variable>
    <xsl:variable name='anch'>
      <xsl:value-of select='@anchor'/>
    </xsl:variable>
    <div class='indent'>
    <h6>
      <xsl:attribute name='id'>
        <xsl:choose>
          <xsl:when test='$anch != ""'>
            <xsl:value-of select='@anchor'/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>sect-</xsl:text><xsl:value-of select='$oid'/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:number level='single' count='section1'/>.<xsl:number level='single' count='section2'/>.<xsl:number level='single' count='section3'/>.<xsl:number level='single' count='section4'/>.<xsl:number level='single' count='section5'/>
      <xsl:text> </xsl:text>
      <xsl:value-of select='@topic' />
    </h6>
    <xsl:apply-templates/>
    </div>
  </xsl:template>

  <xsl:template match='remark'>
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match='p'>
    <p>
      <xsl:variable name='class.count' select='count(@class)'/>
      <xsl:if test='$class.count=1'>
        <xsl:attribute name='class'><xsl:value-of select='@class'/></xsl:attribute>
      </xsl:if>
      <xsl:variable name='style.count' select='count(@style)'/>
      <xsl:if test='$style.count=1'>
        <xsl:attribute name='style'><xsl:value-of select='@style'/></xsl:attribute>
      </xsl:if>
      <xsl:apply-templates/>
    </p>
  </xsl:template>

  <xsl:template match='br'>
    <br />
  </xsl:template>

  <xsl:template match='ul'>
    <ul>
      <xsl:variable name='class.count' select='count(@class)'/>
      <xsl:if test='$class.count=1'>
        <xsl:attribute name='class'><xsl:value-of select='@class'/></xsl:attribute>
      </xsl:if>
      <xsl:variable name='style.count' select='count(@style)'/>
      <xsl:if test='$style.count=1'>
        <xsl:attribute name='style'><xsl:value-of select='@style'/></xsl:attribute>
      </xsl:if>
      <xsl:apply-templates/>
    </ul>
  </xsl:template>

  <xsl:template match='ol'>
    <ol>
      <xsl:variable name='start.count' select='count(@start)'/>
      <xsl:if test='$start.count=1'>
        <xsl:attribute name='start'><xsl:value-of select='@start'/></xsl:attribute>
      </xsl:if>
      <xsl:variable name='class.count' select='count(@class)'/>
      <xsl:if test='$class.count=1'>
        <xsl:attribute name='class'><xsl:value-of select='@class'/></xsl:attribute>
      </xsl:if>
      <xsl:variable name='style.count' select='count(@style)'/>
      <xsl:if test='$style.count=1'>
        <xsl:attribute name='style'><xsl:value-of select='@style'/></xsl:attribute>
      </xsl:if>
      <xsl:apply-templates/>
    </ol>
  </xsl:template>

  <xsl:template match='li'>
    <li>
      <xsl:variable name='class.count' select='count(@class)'/>
      <xsl:if test='$class.count=1'>
        <xsl:attribute name='class'><xsl:value-of select='@class'/></xsl:attribute>
      </xsl:if>
      <xsl:variable name='style.count' select='count(@style)'/>
      <xsl:if test='$style.count=1'>
        <xsl:attribute name='style'><xsl:value-of select='@style'/></xsl:attribute>
      </xsl:if>
      <xsl:apply-templates/>
    </li>
  </xsl:template>

  <xsl:template match='link'>
    <a>
      <xsl:attribute name='href'><xsl:value-of select='@url'/></xsl:attribute>
      <xsl:apply-templates/>
    </a>
  </xsl:template>

  <xsl:template name='anchor-link'>
    <xsl:param name='anchor'/>
    <a class='anchor-link'>
      <xsl:attribute name='href'>#<xsl:value-of select='$anchor'/></xsl:attribute>
      <abbr title="Link to this point in the document">¶</abbr>
    </a>
  </xsl:template>

  <xsl:template match='example'>
    <figure class='code-example'>
      <xsl:variable name='anchor'><xsl:text>example-</xsl:text><xsl:number level='any' count='example'/></xsl:variable>
      <xsl:attribute name='id'><xsl:value-of select='$anchor'/></xsl:attribute>
      <figcaption><strong>Example <xsl:number level='any' count='example'/>.</strong><xsl:text> </xsl:text><xsl:value-of select='@caption'/><xsl:call-template name='anchor-link'><xsl:with-param name='anchor' select='$anchor'/></xsl:call-template></figcaption>
      <pre class='prettyprint'><xsl:apply-templates/></pre>
    </figure>
  </xsl:template>

  <xsl:template match='code'>
    <figure class='code'>
      <figcaption><xsl:value-of select='@caption'/></figcaption>
      <pre class='prettyprint'><xsl:apply-templates/></pre>
    </figure>
  </xsl:template>

  <xsl:template match='cve'>
    <figure class='cve'>
      <figcaption>CVE-<xsl:value-of select='@id'/>
	(<a><xsl:attribute name='href'>https://nvd.nist.gov/vuln/detail/CVE-<xsl:value-of select='@id'/></xsl:attribute>NIST</a>,
	<a><xsl:attribute name='href'>https://cve.mitre.org/cgi-bin/cvename.cgi?name=<xsl:value-of select='@id'/></xsl:attribute>Mitre</a>)
      </figcaption>
      <xsl:choose>
	<xsl:when test="@url != ''">
	  <a>
	    <xsl:attribute name='href'><xsl:value-of select='@url'/></xsl:attribute>
	    <xsl:apply-templates/>
	  </a>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:apply-templates/>
	</xsl:otherwise>
      </xsl:choose>
    </figure>
  </xsl:template>

  <xsl:template match='img'>
    <img>
      <xsl:attribute name='alt'><xsl:value-of select='@alt'/></xsl:attribute>
      <xsl:attribute name='height'><xsl:value-of select='@height'/></xsl:attribute>
      <xsl:attribute name='src'><xsl:value-of select='@src'/></xsl:attribute>
      <xsl:attribute name='width'><xsl:value-of select='@width'/></xsl:attribute>
    </img>
  </xsl:template>

  <xsl:template match='table'>
    <figure class='table'>
      <figcaption>
        <xsl:variable name='anchor'><xsl:text>table-</xsl:text><xsl:number level='any' count='table'/></xsl:variable>
        <xsl:attribute name='id'><xsl:value-of select='$anchor'/></xsl:attribute>
        <strong>Table <xsl:number level='any' count='table'/>:</strong><xsl:text> </xsl:text><xsl:value-of select='@caption'/>
        <xsl:call-template name='anchor-link'><xsl:with-param name='anchor' select='$anchor'/></xsl:call-template>
      </figcaption>
      <table>
        <xsl:apply-templates/>
      </table>
    </figure>
  </xsl:template>

  <xsl:template match='tr'>
    <tr class='body'>
      <xsl:apply-templates/>
    </tr>
  </xsl:template>

  <xsl:template match='th'>
    <th>
      <xsl:variable name='colspan.count' select='count(@colspan)'/>
      <xsl:variable name='rowspan.count' select='count(@rowspan)'/>
      <xsl:if test='$colspan.count=1'>
        <xsl:attribute name='colspan'><xsl:value-of select='@colspan'/></xsl:attribute>
      </xsl:if>
      <xsl:if test='$rowspan.count=1'>
        <xsl:attribute name='rowspan'><xsl:value-of select='@rowspan'/></xsl:attribute>
      </xsl:if>
      <xsl:apply-templates/>
    </th>
  </xsl:template>

  <xsl:template match='td'>
    <td>
      <xsl:variable name='align.count' select='count(@align)'/>
      <xsl:variable name='colspan.count' select='count(@colspan)'/>
      <xsl:variable name='rowspan.count' select='count(@rowspan)'/>
      <xsl:if test='$align.count=1'>
        <xsl:attribute name='align'><xsl:value-of select='@align'/></xsl:attribute>
      </xsl:if>
      <xsl:if test='$colspan.count=1'>
        <xsl:attribute name='colspan'><xsl:value-of select='@colspan'/></xsl:attribute>
      </xsl:if>
      <xsl:if test='$rowspan.count=1'>
        <xsl:attribute name='rowspan'><xsl:value-of select='@rowspan'/></xsl:attribute>
      </xsl:if>
      <xsl:apply-templates/>
    </td>
  </xsl:template>

  <xsl:template match='dl'>
    <div class='indent'>
      <dl>
        <xsl:apply-templates/>
      </dl>
    </div>
  </xsl:template>

  <xsl:template match='di'>
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match='dt'>
    <dt>
      <strong><xsl:apply-templates/></strong>
    </dt>
  </xsl:template>

  <xsl:template match='dd'>
    <dd>
      <xsl:apply-templates/>
    </dd>
  </xsl:template>


  <xsl:template match='note'>
    <xsl:variable name='me' select='.' />
    <xsl:variable name='firstOccurrence' select='(//note[. = $me])[1]' />
    <xsl:variable name='oid' select='generate-id($firstOccurrence)' />
    <xsl:variable name='notenum' select='count($firstOccurrence/preceding::note[not(.=preceding::note)]) + count($me/ancestor::note) + 1' />
    <xsl:text> [</xsl:text><a href='#nt-{$oid}'>
    <xsl:value-of select='$notenum'/></a>
    <xsl:text>]</xsl:text>
  </xsl:template>

<!-- PRESENTATIONAL ELEMENTS -->

  <xsl:template match='blockquote'>
    <blockquote>
      <xsl:apply-templates/>
    </blockquote>
  </xsl:template>

  <xsl:template match='cite'>
    <span class='ref'>
      <xsl:apply-templates/>
    </span>
  </xsl:template>

  <xsl:template match='dfn'>
    <span class='dfn'>
      <xsl:apply-templates/>
    </span>
  </xsl:template>

  <xsl:template match='div'>
    <xsl:variable name='type'>
      <xsl:choose>
        <xsl:when test='@class = "example"'>figure</xsl:when>
        <xsl:otherwise>div</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:element name='{$type}'>
      <xsl:variable name='class.count' select='count(@class)'/>
      <xsl:if test='$class.count=1'>
        <xsl:attribute name='class'><xsl:value-of select='@class'/></xsl:attribute>
      </xsl:if>
      <xsl:variable name='style.count' select='count(@style)'/>
      <xsl:if test='$style.count=1'>
        <xsl:attribute name='style'><xsl:value-of select='@style'/></xsl:attribute>
      </xsl:if>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match='em'>
    <em>
      <xsl:apply-templates/>
    </em>
  </xsl:template>

  <xsl:template match='sub'>
    <sub><xsl:apply-templates/></sub>
  </xsl:template>

  <xsl:template match='pre'>
    <pre><xsl:apply-templates/></pre>
  </xsl:template>

  <xsl:template match='span'>
    <span>
      <xsl:variable name='class.count' select='count(@class)'/>
      <xsl:if test='$class.count=1'>
        <xsl:attribute name='class'><xsl:value-of select='@class'/></xsl:attribute>
      </xsl:if>
      <xsl:variable name='style.count' select='count(@style)'/>
      <xsl:if test='$style.count=1'>
        <xsl:attribute name='style'><xsl:value-of select='@style'/></xsl:attribute>
      </xsl:if>
      <xsl:apply-templates/>
    </span>
  </xsl:template>

  <xsl:template match='strong'>
    <strong>
      <xsl:apply-templates/>
    </strong>
  </xsl:template>

  <xsl:template match='tt'>
    <code>
      <xsl:apply-templates/>
    </code>
  </xsl:template>

<!-- END OF PRESENTATIONAL ELEMENTS -->

</xsl:stylesheet>
