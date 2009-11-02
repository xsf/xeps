<?xml version='1.0' encoding='UTF-8'?>

<!--

Copyright (c) 1999 - 2009 XMPP Standards Foundation

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

  <xsl:output doctype-public='-//W3C//DTD XHTML 1.0 Transitional//EN' doctype-system='http://www.w3.org/TR/xhtml1/DTD/xhtml1-loose.dtd' method='xml'/>

  <xsl:template match='/'>
    <html>
      <head>
        <title>XEP-<xsl:value-of select='/xep/header/number'/>:<xsl:text> </xsl:text><xsl:value-of select='/xep/header/title' /></title>
        <link rel='stylesheet' type='text/css' href='../xmpp.css' />
        <link href="../prettify.css" type="text/css" rel="stylesheet" />
        <link rel='shortcut icon' type='image/x-icon' href='/favicon.ico' />
        <script type="text/javascript" src="../prettify.js"></script>
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
        <table>
          <tr valign='top'>
            <td><strong>Abstract:</strong></td>
            <td><xsl:value-of select='/xep/header/abstract'/></td>
          </tr>
          <xsl:if test='$authors.count=1'>
            <tr valign='top'>
              <td><strong>Author:</strong></td>
              <td><xsl:value-of select='/xep/header/author/firstname'/><xsl:text> </xsl:text><xsl:value-of select='/xep/header/author/surname'/></td>
            </tr>
          </xsl:if>
          <xsl:if test='$authors.count&gt;1'>
            <tr valign='top'>
              <td><strong>Authors:</strong></td>
              <td>
                <xsl:for-each select='/xep/header/author'>
                  <xsl:if test="position()!=last()">
                    <xsl:value-of select='firstname'/>
                    <xsl:text> </xsl:text>
                    <xsl:value-of select='surname'/>
                    <xsl:text>, </xsl:text>
                  </xsl:if>
                  <xsl:if test="position()=last()">
                    <xsl:value-of select='firstname'/>
                    <xsl:text> </xsl:text>
                    <xsl:value-of select='surname'/>
                  </xsl:if>
                </xsl:for-each>
              </td>
            </tr>
          </xsl:if>
          <tr valign='top'>
            <td><strong>Copyright:</strong></td>
            <td>&#169; 1999 - 2009 XMPP Standards Foundation. <a href='#appendix-legal'>SEE LEGAL NOTICES</a>.</td>
          </tr>
          <tr valign='top'>
            <td><strong>Status:</strong></td>
            <td><xsl:value-of select='/xep/header/status'/></td>
          </tr>
          <tr valign='top'>
            <td><strong>Type:</strong></td>
            <td><xsl:value-of select='/xep/header/type'/></td>
          </tr>
          <tr valign='top'>
            <td><strong>Version:</strong></td>
            <td><xsl:value-of select='/xep/header/revision[position()=1]/version'/></td>
          </tr>
          <tr valign='top'>
            <td><strong>Last&#160;Updated:</strong></td>
            <td><xsl:value-of select='/xep/header/revision[position()=1]/date'/></td>
          </tr>
        </table>
        <!-- DEPLOYABILITY -->
        <hr />
        <xsl:variable name='thestatus' select='/xep/header/status'/>
        <xsl:variable name='thetype' select='/xep/header/type'/>
        <xsl:if test='$thestatus = "Active" and $thetype = "Historical"'>
          <p style='color:green'>NOTICE: This Historical specification provides canonical documentation of a protocol that is in use within the Jabber/XMPP community. This document is not a standards-track specification within the XMPP Standards Foundation's standards process; however, it might be converted to standards-track in the future or might be obsoleted by a more modern protocol.</p>
        </xsl:if>
        <xsl:if test='$thestatus = "Active" and $thetype = "Humorous"'>
          <p style='color:green'>NOTICE: This document is Humorous. It MAY provide amusement but SHOULD NOT be taken seriously.</p>
        </xsl:if>
        <xsl:if test='$thestatus = "Active" and $thetype = "Informational"'>
          <p style='color:green'>NOTICE: This Informational specification defines a best practice or protocol profile that has been approved by the XMPP Council and/or the XSF Board of Directors. Implementations are encouraged and the best practice or protocol profile is appropriate for deployment in production systems.</p>
        </xsl:if>
        <xsl:if test='$thestatus = "Active" and $thetype = "Procedural"'>
          <p style='color:green'>NOTICE: This Procedural document defines a process or activity of the XMPP Standards Foundation (XSF) that has been approved by the XMPP Council and/or the XSF Board of Directors. The XSF is currently following the process or activity defined herein and will do so until this document is deprecated or obsoleted.</p>
        </xsl:if>
        <xsl:if test='$thestatus = "Deferred"'>
          <p style='color:red'>WARNING: Consideration of this document has been <strong>Deferred</strong> by the XMPP Standards Foundation. Implementation of the protocol described herein is not recommended.</p>
        </xsl:if>
        <xsl:if test='$thestatus = "Deprecated"'>
          <p style='color:red'>WARNING: This document has been <strong>Deprecated</strong> by the XMPP Standards Foundation. Implementation of the protocol described herein is not recommended. Developers desiring similar functionality are advised to implement the protocol that supersedes this one (if any).</p>
        </xsl:if>
        <xsl:if test='$thestatus = "Draft"'>
          <p style='color:green'>NOTICE: The protocol defined herein is a <strong>Draft Standard</strong> of the XMPP Standards Foundation. Implementations are encouraged and the protocol is appropriate for deployment in production systems, but some changes to the protocol are possible before it becomes a Final Standard.</p>
        </xsl:if>
        <xsl:if test='$thestatus = "Experimental" and $thetype = "Historical"'>
          <p style='color:red'>NOTICE: This Historical document attempts to provide canonical documentation of a protocol that is in use within the Jabber/XMPP community. Publication as an XMPP Extension Protocol does not imply approval of this proposal by the XMPP Standards Foundation. This document is not a standards-track specification within the XMPP Standards Foundation's standards process; however, it might be converted to standards-track in the future or might be obsoleted by a more modern protocol.</p>
        </xsl:if>
        <xsl:if test='$thestatus = "Experimental" and $thetype = "Informational"'>
          <p style='color:red'>WARNING: This Informational document is Experimental. Publication as an XMPP Extension Protocol does not imply approval of this proposal by the XMPP Standards Foundation. Implementation of the best practice or protocol profile described herein is encouraged in exploratory implementations, although production systems are advised to carefully consider whether it is appropriate to deploy implementations of this protocol before it advances to a status of Draft.</p>
        </xsl:if>
        <xsl:if test='$thestatus = "Experimental" and $thetype = "Procedural"'>
          <p style='color:red'>NOTICE: This Procedural document proposes that the process or activity defined herein shall be followed by the XMPP Standards Foundation (XSF). However, this process or activity has not yet been approved by the XMPP Council and/or the XSF Board of Directors and is therefore not currently in force.</p>
        </xsl:if>
        <xsl:if test='$thestatus = "Experimental" and $thetype = "Standards Track"'>
          <p style='color:red'>WARNING: This Standards-Track document is Experimental. Publication as an XMPP Extension Protocol does not imply approval of this proposal by the XMPP Standards Foundation. Implementation of the protocol described herein is encouraged in exploratory implementations, but production systems are advised to carefully consider whether it is appropriate to deploy implementations of this protocol before it advances to a status of Draft.</p>
        </xsl:if>
        <xsl:if test='$thestatus = "Final"'>
          <p style='color:green'>NOTICE: The protocol defined herein is a <strong>Final Standard</strong> of the XMPP Standards Foundation and can be considered a stable technology for implementation and deployment.</p>
        </xsl:if>
        <xsl:if test='$thestatus = "Obsolete"'>
          <p style='color:red'>WARNING: This document has been obsoleted by the XMPP Standards Foundation. Implementation of the protocol described herein is not recommended. Developers desiring similar functionality are advised to implement the protocol that supersedes this one (if any).</p>
        </xsl:if>
        <xsl:if test='$thestatus = "Proposed"'>
          <p style='color:red'>NOTICE: This document is currently within Last Call or under consideration by the XMPP Council for advancement to the next stage in the XSF standards process. The Last Call ends on <xsl:value-of select='/xep/header/lastcall'/>. Please send your feedback to the <a href='http://mail.jabber.org/mailman/listinfo/standards'>standards@xmpp.org</a> discussion list.</p>
        </xsl:if>
        <xsl:if test='$thestatus = "ProtoXEP"'>
          <p style='color:red'>WARNING: This document has not yet been accepted for consideration or approved in any official manner by the XMPP Standards Foundation, and this document is not yet an XMPP Extension Protocol (XEP). If this document is accepted as a XEP by the XMPP Council, it will be published at &lt;<a href="http://xmpp.org/extensions/">http://xmpp.org/extensions/</a>&gt; and announced on the &lt;standards@xmpp.org&gt; mailing list.</p>
        </xsl:if>
        <xsl:if test='$thestatus = "Rejected"'>
          <p style='color:red'>WARNING: This document has been Rejected by the XMPP Council. Implementation of the protocol described herein is not recommended under any circumstances.</p>
        </xsl:if>
        <xsl:if test='$thestatus = "Retracted"'>
          <p style='color:red'>WARNING: This document has been retracted by the author(s). Implementation of the protocol described herein is not recommended. Developers desiring similar functionality are advised to implement the protocol that supersedes this one (if any).</p>
        </xsl:if>
        <!-- TABLE OF CONTENTS -->
        <hr />
        <xsl:call-template name='processTOC' />
        <!-- END FRONT MATTER -->
        <!-- BEGIN XEP CONTENTS -->
        <hr />
        <xsl:apply-templates select='/xep/section1'/>
        <!-- END XEP CONTENTS -->
        <!-- BEGIN APPENDICES -->
        <hr />
        <a name='appendices'></a>
        <h2>Appendices</h2>
        <hr />
        <!-- XEP INFO -->
        <a name='appendix-docinfo'></a>
        <h3>Appendix A: Document Information</h3>
          <p class='indent'>
            Series: <a href='http://xmpp.org/extensions/'>XEP</a><br />
            Number: <xsl:value-of select='/xep/header/number'/><br />
            Publisher: <a href='/xsf/'>XMPP Standards Foundation</a><br />
            Status: 
            <a>
              <xsl:attribute name='href'><xsl:text>http://xmpp.org/extensions/xep-0001.html#states-</xsl:text><xsl:value-of select='/xep/header/status'/></xsl:attribute>
              <xsl:value-of select='/xep/header/status'/>
            </a>
            <br />
            Type:
            <a>
              <xsl:attribute name='href'><xsl:text>http://xmpp.org/extensions/xep-0001.html#types-</xsl:text><xsl:value-of select='/xep/header/type'/></xsl:attribute>
              <xsl:value-of select='/xep/header/type'/>
            </a>
            <br />
            Version: <xsl:value-of select='/xep/header/revision[position()=1]/version'/><br />
            Last Updated: <xsl:value-of select='/xep/header/revision[position()=1]/date'/><br />
            <xsl:variable name='expires.count' select='count(/xep/header/expires)'/>
            <xsl:if test='$expires.count=1'>
              Expires: <xsl:value-of select='/xep/header/expires'/><br />
            </xsl:if>
            <xsl:variable name='ApprovingBody' select='/xep/header/approver'/>
            <xsl:choose>
              <xsl:when test='$ApprovingBody = "Board"'>
                Approving Body: <a href='http://xmpp.org/xsf/board/'>XSF Board of Directors</a><br />
              </xsl:when>
              <xsl:otherwise>
                Approving Body: <a href='http://xmpp.org/council/'>XMPP Council</a><br />
              </xsl:otherwise>
            </xsl:choose>
            <xsl:variable name='dependencies.count' select='count(/xep/header/dependencies/spec)'/>
            <xsl:choose>
              <xsl:when test='$dependencies.count &gt; 0'>
                <xsl:text>Dependencies: </xsl:text>
                <xsl:apply-templates select='/xep/header/dependencies/spec'>
                  <xsl:with-param name='speccount' select='$dependencies.count'/>
                </xsl:apply-templates>
                <br />
              </xsl:when>
              <xsl:otherwise>
                Dependencies: None<br />
              </xsl:otherwise>
            </xsl:choose>
            <xsl:variable name='supersedes.count' select='count(/xep/header/supersedes/spec)'/>
            <xsl:choose>
              <xsl:when test='$supersedes.count &gt; 0'>
                <xsl:text>Supersedes: </xsl:text>
                <xsl:apply-templates select='/xep/header/supersedes/spec'>
                  <xsl:with-param name='speccount' select='$supersedes.count'/>
                </xsl:apply-templates>
                <br />
              </xsl:when>
              <xsl:otherwise>
                Supersedes: None<br />
              </xsl:otherwise>
            </xsl:choose>
            <xsl:variable name='supersededby.count' select='count(/xep/header/supersededby/spec)'/>
            <xsl:choose>
              <xsl:when test='$supersededby.count &gt; 0'>
                <xsl:text>Superseded By: </xsl:text>
                <xsl:apply-templates select='/xep/header/supersededby/spec'>
                  <xsl:with-param name='speccount' select='$supersededby.count'/>
                </xsl:apply-templates>
                <br />
              </xsl:when>
              <xsl:otherwise>
                Superseded By: None<br />
              </xsl:otherwise>
            </xsl:choose>
            Short Name: <xsl:value-of select='/xep/header/shortname'/><br />
            <xsl:variable name='schema.count' select='count(/xep/header/schemaloc)'/>
            <xsl:if test='$schema.count &gt; 0'>
              <xsl:apply-templates select='/xep/header/schemaloc'/>
            </xsl:if>
            <xsl:variable name='reg.count' select='count(/xep/header/registry)'/>
            <xsl:if test='$reg.count=1'>
              Registry: 
              <xsl:variable name='registryURL'>
                <xsl:text>http://xmpp.org/registrar/</xsl:text>
                <xsl:value-of select='/xep/header/shortname'/>
                <xsl:text>.html</xsl:text>
              </xsl:variable>
              &lt;<a href='{$registryURL}'><xsl:value-of select='$registryURL'/></a>&gt;
              <br />
            </xsl:if>
            <xsl:variable name='sourceHTML'>
              <xsl:text>http://svn.xmpp.org:18080/browse/XMPP/trunk/extensions/xep-</xsl:text>
              <xsl:value-of select='/xep/header/number'/>
              <xsl:text>.xml</xsl:text>
            </xsl:variable>
            <xsl:variable name='sourceRSS'>
              <xsl:text>http://svn.xmpp.org:18080//changelog/~rss/XMPP/trunk/extensions/xep-</xsl:text>
              <xsl:value-of select='/xep/header/number'/>
              <xsl:text>.xml/rss.xml</xsl:text>
            </xsl:variable>
            <xsl:if test='$thestatus != "ProtoXEP"'>
              Source Control: 
                <a class='standardsButton' href='{$sourceHTML}'>HTML</a>&#160;
                <a class='standardsButton' href='{$sourceRSS}'>RSS</a>
            </xsl:if>
          </p>
        <hr />
        <!-- AUTHOR INFO -->
        <a name='appendix-authorinfo'></a>
        <h3>Appendix B: Author Information</h3>
        <div class='indent'>
          <xsl:apply-templates select='/xep/header/author'/>
        </div>
        <hr />
        <!-- LEGAL NOTICES -->
        <a name='appendix-legal'></a>
        <h3>Appendix C: Legal Notices</h3>
        <xsl:apply-templates select='/xep/header/legal'/>
        <hr />
        <!-- XMPP NOTICE -->
        <a name='appendix-xmpp'></a>
        <h3>Appendix D: Relation to XMPP</h3>
        <p class='indent'>The Extensible Messaging and Presence Protocol (XMPP) is defined in the XMPP Core (RFC 3920) and XMPP IM (RFC 3921) specifications contributed by the XMPP Standards Foundation to the Internet Standards Process, which is managed by the Internet Engineering Task Force in accordance with RFC 2026. Any protocol defined in this document has been developed outside the Internet Standards Process and is to be understood as an extension to XMPP rather than as an evolution, development, or modification of XMPP itself.</p>
        <hr />
        <!-- DISCUSSION VENUE -->
        <a name='appendix-discuss'></a>
        <h3>Appendix E: Discussion Venue</h3>
        <xsl:variable name='discuss.count' select='count(/xep/header/discuss)'/>
        <xsl:variable name='discuss.venue' select='count(/xep/header/discuss)'/>
        <xsl:if test='$discuss.count=1'>
          <xsl:variable name='discussWeb'>
            <xsl:text>http://mail.jabber.org/mailman/listinfo/</xsl:text>
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
            <p class='indent'>The primary venue for discussion of XMPP Extension Protocols is the &lt;<a href="http://mail.jabber.org/mailman/listinfo/standards">standards@xmpp.org</a>&gt; discussion list.</p>
            <p class='indent'>Discussion by the membership of the XSF might also be appropriate (see &lt;<a href="http://mail.jabber.org/mailman/listinfo/members">http://mail.jabber.org/mailman/listinfo/members</a>&gt; for details).</p>
          </xsl:when>
          <xsl:otherwise>
            <p class='indent'>The primary venue for discussion of XMPP Extension Protocols is the &lt;<a href="http://mail.jabber.org/mailman/listinfo/standards">standards@xmpp.org</a>&gt; discussion list.</p>
            <p class='indent'>Discussion on other xmpp.org discussion lists might also be appropriate; see &lt;<a href='http://xmpp.org/about/discuss.shtml'>http://xmpp.org/about/discuss.shtml</a>&gt; for a complete list.</p>
            <xsl:if test='contains(/xep/header/dependencies,"RFC")'>
              <p class='indent'>Given that this XMPP Extension Protocol normatively references IETF technologies, discussion on the &lt;<a href="http://mail.jabber.org/mailman/listinfo/xsf-ietf">xsf-ietf@xmpp.org</a>&gt; list might also be appropriate.</p>
            </xsl:if>
          </xsl:otherwise>
        </xsl:choose>
        <p class='indent'>Errata can be sent to &lt;<a href='mailto:editor@xmpp.org'>editor@xmpp.org</a>&gt;.</p>
        <hr />
        <!-- CONFORMANCE TERMS-->
        <a name='appendix-conformance'></a>
        <h3>Appendix F: Requirements Conformance</h3>
        <p class='indent'>The following requirements keywords as used in this document are to be interpreted as described in <a href='http://www.ietf.org/rfc/rfc2119.txt'>RFC 2119</a>: "MUST", "SHALL", "REQUIRED"; "MUST NOT", "SHALL NOT"; "SHOULD", "RECOMMENDED"; "SHOULD NOT", "NOT RECOMMENDED"; "MAY", "OPTIONAL".</p>
        <hr />
        <!-- NOTES -->
        <a name="appendix-notes"></a>
        <h3>Appendix G: Notes</h3>
        <div class='indent'>
          <xsl:apply-templates select='//note' mode='endlist'/>
        </div>
        <!-- REVISION HISTORY -->
        <hr />
        <a name="appendix-revs"></a>
        <h3>Appendix H: Revision History</h3>
          <div class='indent'>
            <xsl:apply-templates select='/xep/header/revision'/>
          </div>
        <hr />
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
    <h2>Table of Contents</h2>
    <div class='indent'>
    <p><xsl:apply-templates select='//section1' mode='toc'/></p>
    <p><a href='#appendices'>Appendices</a>
      <br />&#160;&#160;&#160;&#160;<a href="#appendix-docinfo">A: Document Information</a>
      <br />&#160;&#160;&#160;&#160;<a href="#appendix-authorinfo">B: Author Information</a>
      <br />&#160;&#160;&#160;&#160;<a href="#appendix-legal">C: Legal Notices</a>
      <br />&#160;&#160;&#160;&#160;<a href="#appendix-xmpp">D: Relation to XMPP</a>
      <br />&#160;&#160;&#160;&#160;<a href="#appendix-discuss">E: Discussion Venue</a>
      <br />&#160;&#160;&#160;&#160;<a href="#appendix-conformance">F: Requirements Conformance</a>
      <br />&#160;&#160;&#160;&#160;<a href="#appendix-notes">G: Notes</a>
      <br />&#160;&#160;&#160;&#160;<a href="#appendix-revs">H: Revision History</a>
    </p>
    </div>
  </xsl:template>
    
  <xsl:template match='author' mode='meta'>
    <meta>
      <xsl:attribute name='name'><xsl:text>DC.Creator</xsl:text></xsl:attribute>
      <xsl:attribute name='content'><xsl:value-of select='firstname'/><xsl:text> </xsl:text><xsl:value-of select='surname'/></xsl:attribute>
    </meta>
  </xsl:template>

  <xsl:template match='author'>
    <h3><xsl:value-of select='firstname'/><xsl:text> </xsl:text><xsl:value-of select='surname'/></h3>
    <p class='indent'>
      <xsl:variable name='org.count' select='count(org)'/>
      <xsl:variable name='email.count' select='count(email)'/>
      <xsl:variable name='jid.count' select='count(jid)'/>
      <xsl:variable name='uri.count' select='count(uri)'/>
      <xsl:variable name='authornote.count' select='count(authornote)'/>
      <xsl:if test='$authornote.count &gt; 0'>
        See <a href='#authornote'>Author Note</a><br />
      </xsl:if>
      <xsl:if test='$org.count=1'>
        Organization: <xsl:value-of select='org'/><br />
      </xsl:if>
      <xsl:if test='$email.count=1'>
        Email:
        <a>
          <xsl:attribute name='href'>
            <xsl:text>mailto:</xsl:text>
            <xsl:value-of select='email' />
          </xsl:attribute>
          <xsl:value-of select='email' />
        </a>
        <br />
      </xsl:if>
      <xsl:if test='$jid.count=1'>
        JabberID: 
        <a>
          <xsl:attribute name='href'>
            <xsl:text>xmpp:</xsl:text>
            <xsl:value-of select='jid' />
          </xsl:attribute>
          <xsl:value-of select='jid' />
        </a>
        <br />
      </xsl:if>
      <xsl:if test='$uri.count=1'>
        URI: 
        <a>
          <xsl:attribute name='href'>
            <xsl:value-of select='uri' />
          </xsl:attribute>
          <xsl:value-of select='uri' />
        </a>
        <br />
      </xsl:if>
    </p>
  </xsl:template>

  <xsl:template match='legal'>
    <div class='indent'>
      <h4>Copyright</h4>
      <xsl:apply-templates select='/xep/header/legal/copyright'/>
      <h4>Permissions</h4>
      <xsl:apply-templates select='/xep/header/legal/permissions'/>
      <h4>Disclaimer of Warranty</h4>
      <span style='font-weight: bold'>
        <xsl:apply-templates select='/xep/header/legal/warranty'/>
      </span>
      <h4>Limitation of Liability</h4>
      <xsl:apply-templates select='/xep/header/legal/liability'/>
      <h4>IPR Conformance</h4>
      <xsl:apply-templates select='/xep/header/legal/conformance'/>
    </div>
  </xsl:template>

  <xsl:template match='spec'>
    <xsl:param name='speccount' select='""'/>
    <xsl:variable name='specpos' select='position()'/>
    <xsl:choose>
      <xsl:when test='$specpos &lt; $speccount'>
        <xsl:value-of select='.'/><xsl:text>, </xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select='.'/>
      </xsl:otherwise>
     </xsl:choose>
  </xsl:template>

  <xsl:template match='schemaloc'>
    <xsl:variable name='this.url' select='url'/>
    <xsl:variable name='ns.count' select='count(ns)'/>
    <xsl:choose>
      <xsl:when test="$ns.count=1">
        XML Schema for <xsl:value-of select='ns'/> namespace: &lt;<a href='{$this.url}'><xsl:value-of select='url'/></a>&gt;<br />
      </xsl:when>
      <xsl:otherwise>
        Schema: &lt;<a href='{$this.url}'><xsl:value-of select='url'/></a>&gt;<br />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match='revision'>
    <h4>Version <xsl:value-of select='version'/><xsl:text> </xsl:text>(<xsl:value-of select='date'/>)</h4>
    <div class='indent'>
      <xsl:apply-templates select='remark'/>
      <xsl:text> </xsl:text>(<xsl:value-of select='initials'/>)
    </div>
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
    <br />
      <xsl:value-of select='$num'/> <xsl:text>  </xsl:text>
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
        <xsl:apply-templates select='section2' mode='toc'>
          <xsl:with-param name='prevnum' select='$num'/>
        </xsl:apply-templates>
    </xsl:if>
  </xsl:template>

  <xsl:template match='section1'>
    <xsl:variable name='oid'>
      <xsl:call-template name='object.id'/>
    </xsl:variable>
    <xsl:variable name='anch'>
      <xsl:value-of select='@anchor'/>
    </xsl:variable>
    <h2>
      <xsl:number level='single' count='section1'/>.
      <xsl:text> </xsl:text>
      <a>
        <xsl:attribute name='name'>
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
    <br />&#160;&#160;&#160;
      <xsl:value-of select='$num'/> <xsl:text>  </xsl:text>
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
        <xsl:apply-templates select='section3' mode='toc'>
          <xsl:with-param name='prevnum' select='$num'/>
        </xsl:apply-templates>
    </xsl:if>
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
      <xsl:number level='single' count='section1'/>.<xsl:number level='single' count='section2'/>
      <xsl:text> </xsl:text>
      <a>
        <xsl:attribute name='name'>
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
    <br />&#160;&#160;&#160;&#160;&#160;&#160;
      <xsl:value-of select='$num'/> <xsl:text>  </xsl:text>
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
        <xsl:apply-templates select='section4' mode='toc'>
          <xsl:with-param name='prevnum' select='$num'/>
        </xsl:apply-templates>
    </xsl:if>
  </xsl:template>

  <xsl:template match='section3'>
    <xsl:variable name='oid'>
      <xsl:call-template name='object.id'/>
    </xsl:variable>
    <xsl:variable name='anch'>
      <xsl:value-of select='@anchor'/>
    </xsl:variable>
    <div class='indent'>
    <h3>
      <xsl:number level='single' count='section1'/>.<xsl:number level='single' count='section2'/>.<xsl:number level='single' count='section3'/>
      <xsl:text> </xsl:text>
      <a>
        <xsl:attribute name='name'>
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
    </h3>
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
    <br />&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;
      <xsl:value-of select='$num'/> <xsl:text>  </xsl:text>
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
  </xsl:template>

  <xsl:template match='section4'>
    <xsl:variable name='oid'>
      <xsl:call-template name='object.id'/>
    </xsl:variable>
    <xsl:variable name='anch'>
      <xsl:value-of select='@anchor'/>
    </xsl:variable>
    <div class='indent'>
    <h3>
      <xsl:number level='single' count='section1'/>.<xsl:number level='single' count='section2'/>.<xsl:number level='single' count='section3'/>.<xsl:number level='single' count='section4'/>
      <xsl:text> </xsl:text>
      <a>
        <xsl:attribute name='name'>
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
    </h3>
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

  <xsl:template match='example'>
    <p class='caption'><a><xsl:attribute name='name'><xsl:text>example-</xsl:text><xsl:number level='any' count='example'/></xsl:attribute></a>Example <xsl:number level='any' count='example'/>.<xsl:text> </xsl:text><xsl:value-of select='@caption'/></p>
    <div class='indent'>
      <pre class='prettyprint'><xsl:apply-templates/></pre>
    </div>
  </xsl:template>

  <xsl:template match='code'>
    <p class='caption'><xsl:value-of select='@caption'/></p>
    <div class='indent'>
      <pre class='prettyprint'><xsl:apply-templates/></pre>
    </div>
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
    <div class='indent'>
      <p class='caption'><a><xsl:attribute name='name'><xsl:text>table-</xsl:text><xsl:number level='any' count='table'/></xsl:attribute></a>Table <xsl:number level='any' count='table'/>:<xsl:text> </xsl:text><xsl:value-of select='@caption'/></p>
      <table border='1' cellpadding='3' cellspacing='0'>
        <xsl:apply-templates/>
      </table>
    </div>
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
    <di>
      <xsl:apply-templates/>
    </di>
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
    <xsl:variable name='notenum'>
      <xsl:number level='any' count='note'/>
    </xsl:variable> 
    <xsl:variable name='oid'>
      <xsl:call-template name='object.id'/>
    </xsl:variable>
    <xsl:text> [</xsl:text><a href='#nt-{$oid}'>
    <xsl:value-of select='$notenum'/></a>
    <xsl:text>]</xsl:text>
  </xsl:template>

  <xsl:template match='note' mode='endlist'>
    <p>
      <xsl:variable name='oid'>
        <xsl:call-template name='object.id'/>
      </xsl:variable> 
      <a name='nt-{$oid}'><xsl:value-of select='position()'/></a>
      <xsl:text>. </xsl:text>
        <xsl:apply-templates/>
    </p>
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
    <div>
      <xsl:variable name='class.count' select='count(@class)'/>
      <xsl:if test='$class.count=1'>
        <xsl:attribute name='class'><xsl:value-of select='@class'/></xsl:attribute>
      </xsl:if>
      <xsl:variable name='style.count' select='count(@style)'/>
      <xsl:if test='$style.count=1'>
        <xsl:attribute name='style'><xsl:value-of select='@style'/></xsl:attribute>
      </xsl:if>
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <xsl:template match='em'>
    <span class='em'>
      <xsl:apply-templates/>
    </span>
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
    <span class='strong'>
      <xsl:apply-templates/>
    </span>
  </xsl:template>

  <xsl:template match='tt'>
    <tt>
      <xsl:apply-templates/>
    </tt>
  </xsl:template>

<!-- END OF PRESENTATIONAL ELEMENTS -->

</xsl:stylesheet>
