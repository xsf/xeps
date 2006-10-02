
<!-- Authors: stpeter and temas -->

<xsl:stylesheet xmlns:xsl='http://www.w3.org/1999/XSL/Transform' version='1.0'>

  <xsl:output method='html'/>

  <xsl:template match='/'>
    <html>
      <head>
        <title>JEP-<xsl:value-of select='/jep/header/number'/>:<xsl:text> </xsl:text><xsl:value-of select='/jep/header/title' /></title>
        <link rel='stylesheet' type='text/css' href='jep.css' />
        <link rel='shortcut icon' type='image/x-icon' href='/favicon.ico' />
        <!-- BEGIN META TAGS FOR DUBLIN CORE -->
        <meta>
          <xsl:attribute name='name'><xsl:text>DC.Title</xsl:text></xsl:attribute>
          <xsl:attribute name='content'><xsl:value-of select='/jep/header/title'/></xsl:attribute>
        </meta>
        <xsl:apply-templates select='/jep/header/author' mode='meta'/>
        <meta>
          <xsl:attribute name='name'><xsl:text>DC.Description</xsl:text></xsl:attribute>
          <xsl:attribute name='content'><xsl:value-of select='/jep/header/abstract'/></xsl:attribute>
        </meta>
        <meta>
          <xsl:attribute name='name'><xsl:text>DC.Publisher</xsl:text></xsl:attribute>
          <xsl:attribute name='content'>Jabber Software Foundation</xsl:attribute>
        </meta>
        <meta>
          <xsl:attribute name='name'><xsl:text>DC.Contributor</xsl:text></xsl:attribute>
          <xsl:attribute name='content'>JEP Editor</xsl:attribute>
        </meta>
        <meta>
          <xsl:attribute name='name'><xsl:text>DC.Date</xsl:text></xsl:attribute>
          <xsl:attribute name='content'><xsl:value-of select='/jep/header/revision/date'/></xsl:attribute>
        </meta>
        <meta>
          <xsl:attribute name='name'><xsl:text>DC.Type</xsl:text></xsl:attribute>
          <xsl:attribute name='content'>Jabber Enhancement Proposal</xsl:attribute>
        </meta>
        <meta>
          <xsl:attribute name='name'><xsl:text>DC.Format</xsl:text></xsl:attribute>
          <xsl:attribute name='content'>XHTML</xsl:attribute>
        </meta>
        <meta>
          <xsl:attribute name='name'><xsl:text>DC.Identifier</xsl:text></xsl:attribute>
          <xsl:attribute name='content'>JEP-<xsl:value-of select='/jep/header/number'/></xsl:attribute>
        </meta>
        <meta>
          <xsl:attribute name='name'><xsl:text>DC.Language</xsl:text></xsl:attribute>
          <xsl:attribute name='content'>en</xsl:attribute>
        </meta>
        <meta>
          <xsl:attribute name='name'><xsl:text>DC.Rights</xsl:text></xsl:attribute>
          <xsl:attribute name='content'><xsl:value-of select='/jep/header/legal'/></xsl:attribute>
        </meta>
        <!-- END META TAGS FOR DUBLIN CORE -->
      </head>
      <body>
        <!-- TITLE -->
        <h1>JEP-<xsl:value-of select='/jep/header/number' />:<xsl:text> </xsl:text><xsl:value-of select='/jep/header/title' /></h1>
        <!-- ABSTRACT -->
        <p><xsl:value-of select='/jep/header/abstract'/></p>
        <!-- NOTICE -->
        <p><hr/></p>
        <xsl:variable name='thestatus' select='/jep/header/status'/>
        <xsl:variable name='thetype' select='/jep/header/type'/>
        <xsl:if test='$thestatus = "Active" and $thetype = "Historical"'>
          <p style='color:green'>NOTICE: This Historical JEP provides canonical documentation of a protocol that is in use within the Jabber/XMPP community. This JEP is not a standards-track specification within the Jabber Software Foundation's standards process; however, it may be converted to standards-track in the future or may be obsoleted by a more modern protocol.</p>
        </xsl:if>
        <xsl:if test='$thestatus = "Active" and $thetype = "Humorous"'>
          <p style='color:green'>NOTICE: This JEP is Humorous. It MAY provide amusement but SHOULD NOT be taken seriously.</p>
        </xsl:if>
        <xsl:if test='$thestatus = "Active" and $thetype = "Informational"'>
          <p style='color:green'>NOTICE: This Informational JEP defines a best practice or protocol profile that has been approved by the Jabber Council and/or the JSF Board of Directors. Implementations are encouraged and the best practice or protocol profile is appropriate for deployment in production systems.</p>
        </xsl:if>
        <xsl:if test='$thestatus = "Active" and $thetype = "Procedural"'>
          <p style='color:green'>NOTICE: This Procedural JEP defines a process or activity of the Jabber Software Foundation (JSF) that has been approved by the Jabber Council and/or the JSF Board of Directors. The JSF is currently following the process or activity defined herein and will do so until this JEP is deprecated or obsoleted.</p>
        </xsl:if>
        <xsl:if test='$thestatus = "Deferred"'>
          <p style='color:red'>WARNING: Consideration of this JEP has been Deferred by the Jabber Software Foundation. Implementation of the protocol described herein is not recommended.</p>
        </xsl:if>
        <xsl:if test='$thestatus = "Deprecated"'>
          <p style='color:red'>WARNING: This JEP has been deprecated by the Jabber Software Foundation. Implementation of the protocol described herein is not recommended. Developers desiring similar functionality should implement the protocol that supersedes this one (if any).</p>
        </xsl:if>
        <xsl:if test='$thestatus = "Draft"'>
          <p style='color:green'>NOTICE: The protocol defined herein is a Draft Standard of the Jabber Software Foundation. Implementations are encouraged and the protocol is appropriate for deployment in production systems, but some changes to the protocol are possible before it becomes a Final Standard.</p>
        </xsl:if>
        <xsl:if test='$thestatus = "Experimental" and $thetype = "Historical"'>
          <p style='color:red'>NOTICE: This Historical JEP attempts to provide canonical documentation of a protocol that is in use within the Jabber/XMPP community. Publication as a Jabber Enhancement Proposal does not imply approval of this proposal by the Jabber Software Foundation. This JEP is not a standards-track specification within the Jabber Software Foundation's standards process; however, it may be converted to standards-track in the future or may be obsoleted by a more modern protocol.</p>
        </xsl:if>
        <xsl:if test='$thestatus = "Experimental" and $thetype = "Informational"'>
          <p style='color:red'>WARNING: This Informational JEP is Experimental. Publication as a Jabber Enhancement Proposal does not imply approval of this proposal by the Jabber Software Foundation. Implementation of the best practice or protocol profile described herein is encouraged in exploratory implementations, although production systems should not deploy implementations of this protocol until it advances to a status of Draft.</p>
        </xsl:if>
        <xsl:if test='$thestatus = "Experimental" and $thetype = "Procedural"'>
          <p style='color:red'>NOTICE: This Procedural JEP proposes that the process or activity defined herein shall be followed by the Jabber Software Foundation (JSF). However, this process or activity has not yet been approved by the Jabber Council and/or the JSF Board of Directors and is therefore not currently in force.</p>
        </xsl:if>
        <xsl:if test='$thestatus = "Experimental" and $thetype = "Standards Track"'>
          <p style='color:red'>WARNING: This Standards-Track JEP is Experimental. Publication as a Jabber Enhancement Proposal does not imply approval of this proposal by the Jabber Software Foundation. Implementation of the protocol described herein is encouraged in exploratory implementations, but production systems should not deploy implementations of this protocol until it advances to a status of Draft.</p>
        </xsl:if>
        <xsl:if test='$thestatus = "Final"'>
          <p style='color:green'>NOTICE: The protocol defined herein is a Final Standard of the Jabber Software Foundation and may be considered a stable technology for implementation and deployment.</p>
        </xsl:if>
        <xsl:if test='$thestatus = "Obsolete"'>
          <p style='color:red'>WARNING: This JEP has been obsoleted by the Jabber Software Foundation. Implementation of the protocol described herein is not recommended. Developers desiring similar functionality should implement the protocol that supersedes this one (if any).</p>
        </xsl:if>
        <xsl:if test='$thestatus = "Proposed"'>
          <p style='color:red'>NOTICE: This JEP is currently within Last Call or under consideration by the Jabber Council for advancement to the next stage in the JSF standards process.</p>
        </xsl:if>
        <xsl:if test='$thestatus = "ProtoJEP"'>
          <p style='color:red'>WARNING: This document has not yet been accepted for consideration or approved in any official manner by the Jabber Software Foundation, and this document must not be referred to as a Jabber Enhancement Proposal (JEP). If this document is accepted as a JEP by the Jabber Council, it will be published at &lt;<a href="http://www.jabber.org/jeps/">http://www.jabber.org/jeps/</a>&gt; and announced on the &lt;standards-jig@jabber.org&gt; mailing list.</p>
        </xsl:if>
        <xsl:if test='$thestatus = "Rejected"'>
          <p style='color:red'>WARNING: This JEP has been Rejected by the Jabber Council. Implementation of the protocol described herein is not recommended under any circumstances.</p>
        </xsl:if>
        <xsl:if test='$thestatus = "Retracted"'>
          <p style='color:red'>WARNING: This JEP has been retracted by the author(s). Implementation of the protocol described herein is not recommended. Developers desiring similar functionality should implement the protocol that supersedes this one (if any).</p>
        </xsl:if>
        <p><hr /></p>
        <!-- JEP INFO -->
        <h2>JEP Information</h2>
          <p class='indent'>
            Status: 
            <a>
              <xsl:attribute name='href'><xsl:text>http://www.jabber.org/jeps/jep-0001.html#states-</xsl:text><xsl:value-of select='/jep/header/status'/></xsl:attribute>
              <xsl:value-of select='/jep/header/status'/>
            </a>
            <br />
            Type:
            <a>
              <xsl:attribute name='href'><xsl:text>http://www.jabber.org/jeps/jep-0001.html#types-</xsl:text><xsl:value-of select='/jep/header/type'/></xsl:attribute>
              <xsl:value-of select='/jep/header/type'/>
            </a>
            <br />
            Number: <xsl:value-of select='/jep/header/number'/><br />
            Version: <xsl:value-of select='/jep/header/revision[position()=1]/version'/><br />
            Last Updated: <xsl:value-of select='/jep/header/revision[position()=1]/date'/><br />
            <xsl:variable name='expires.count' select='count(/jep/header/expires)'/>
            <xsl:if test='$expires.count &gt; 0'>
              Expires: <xsl:value-of select='/jep/header/expires'/><br />
            </xsl:if>
            JIG: <xsl:value-of select='/jep/header/jig'/><br />
            <xsl:variable name='ApprovingBody' select='/jep/header/approver'/>
            <xsl:choose>
              <xsl:when test='$ApprovingBody = "Board"'>
                Approving Body: <a href='http://www.jabber.org/board/'>JSF Board of Directors</a><br />
              </xsl:when>
              <xsl:otherwise>
                Approving Body: <a href='http://www.jabber.org/council/'>Jabber Council</a><br />
              </xsl:otherwise>
            </xsl:choose>
            <xsl:variable name='dependencies.count' select='count(/jep/header/dependencies/spec)'/>
            <xsl:choose>
              <xsl:when test='$dependencies.count &gt; 0'>
                <xsl:text>Dependencies: </xsl:text>
                <xsl:apply-templates select='/jep/header/dependencies/spec'>
                  <xsl:with-param name='speccount' select='$dependencies.count'/>
                </xsl:apply-templates>
                <br />
              </xsl:when>
              <xsl:otherwise>
                Dependencies: None<br />
              </xsl:otherwise>
            </xsl:choose>
            <xsl:variable name='supersedes.count' select='count(/jep/header/supersedes/spec)'/>
            <xsl:choose>
              <xsl:when test='$supersedes.count &gt; 0'>
                <xsl:text>Supersedes: </xsl:text>
                <xsl:apply-templates select='/jep/header/supersedes/spec'>
                  <xsl:with-param name='speccount' select='$supersedes.count'/>
                </xsl:apply-templates>
                <br />
              </xsl:when>
              <xsl:otherwise>
                Supersedes: None<br />
              </xsl:otherwise>
            </xsl:choose>
            <xsl:variable name='supersededby.count' select='count(/jep/header/supersededby/spec)'/>
            <xsl:choose>
              <xsl:when test='$supersededby.count &gt; 0'>
                <xsl:text>Superseded By: </xsl:text>
                <xsl:apply-templates select='/jep/header/supersededby/spec'>
                  <xsl:with-param name='speccount' select='$supersededby.count'/>
                </xsl:apply-templates>
                <br />
              </xsl:when>
              <xsl:otherwise>
                Superseded By: None<br />
              </xsl:otherwise>
            </xsl:choose>
            Short Name: <xsl:value-of select='/jep/header/shortname'/><br />
            <xsl:variable name='schema.count' select='count(/jep/header/schemaloc)'/>
            <xsl:if test='$schema.count &gt; 0'>
              <xsl:apply-templates select='/jep/header/schemaloc'/>
            </xsl:if>
            <xsl:variable name='reg.count' select='count(/jep/header/registry)'/>
            <xsl:if test='$reg.count &gt; 0'>
              Registry: 
              <xsl:variable name='registryURL'>
                <xsl:text>http://www.jabber.org/registrar/</xsl:text>
                <xsl:value-of select='/jep/header/shortname'/>
                <xsl:text>.html</xsl:text>
              </xsl:variable>
              &lt;<a href='{$registryURL}'><xsl:value-of select='$registryURL'/></a>&gt;
              <br />
            </xsl:if>
            <xsl:variable name='wikiURL'>
              <xsl:text>http://wiki.jabber.org/index.php/</xsl:text>
              <xsl:value-of select='/jep/header/title'/>
              <xsl:text> (JEP-</xsl:text>
              <xsl:value-of select='/jep/header/number'/>
              <xsl:text>)</xsl:text>
            </xsl:variable>
            <xsl:if test='$thestatus != "ProtoJEP"'>
              Wiki Page: &lt;<a href='{$wikiURL}'><xsl:value-of select='$wikiURL'/></a>&gt;
            </xsl:if>
          </p>
        <!-- AUTHOR INFO -->
        <h2>Author Information</h2>
        <div class='indent'>
          <xsl:apply-templates select='/jep/header/author'/>
        </div>
        <!-- LEGAL NOTICE -->
        <xsl:apply-templates select='/jep/header/legal'/>
        <!-- DISCUSSION VENUE -->
        <h2>Discussion Venue</h2>
        <xsl:variable name='Approver' select='/jep/header/approver'/>
        <xsl:choose>
          <xsl:when test='$Approver = "Board"'>
            <p class='indent'>The preferred venue for discussion of this document is the Standards-JIG discussion list: &lt;<a href="http://mail.jabber.org/mailman/listinfo/standards-jig">http://mail.jabber.org/mailman/listinfo/standards-jig</a>&gt;.</p>
            <p class='indent'>Discussion by the membership of the JSF may also be appropriate (see &lt;<a href="http://mail.jabber.org/mailman/listinfo/members">http://mail.jabber.org/mailman/listinfo/members</a>&gt; for details).</p>
          </xsl:when>
          <xsl:otherwise>
            <p class='indent'>The preferred venue for discussion of this document is the Standards-JIG discussion list: &lt;<a href="http://mail.jabber.org/mailman/listinfo/standards-jig">http://mail.jabber.org/mailman/listinfo/standards-jig</a>&gt;.</p>
            <xsl:if test='contains(/jep/header/dependencies,"RFC")'>
              <p class='indent'>Given that this JEP normatively references IETF technologies, discussion on the JSF-IETF list may also be appropriate (see &lt;<a href="http://mail.jabber.org/mailman/listinfo/jsf-ietf">http://mail.jabber.org/mailman/listinfo/jsf-ietf</a>&gt; for details).</p>
            </xsl:if>
          </xsl:otherwise>
        </xsl:choose>
        <!-- XMPP NOTICE AND CONFORMANCE TERMS-->
        <!-- (we don't put these on Procedural JEPs) -->
        <xsl:if test='$thetype = "Standards Track" or $thetype = "Historical" or $thetype = "Informational"'>
          <h2>Relation to XMPP</h2>
          <p class='indent'>The Extensible Messaging and Presence Protocol (XMPP) is defined in the XMPP Core (RFC 3920) and XMPP IM (RFC 3921) specifications contributed by the Jabber Software Foundation to the Internet Standards Process, which is managed by the Internet Engineering Task Force in accordance with RFC 2026. Any protocol defined in this JEP has been developed outside the Internet Standards Process and is to be understood as an extension to XMPP rather than as an evolution, development, or modification of XMPP itself.</p>
          <h2>Conformance Terms</h2>
          <p class='indent'>The following keywords as used in this document are to be interpreted as described in RFC 2119: "MUST", "SHALL", "REQUIRED"; "MUST NOT", "SHALL NOT"; "SHOULD", "RECOMMENDED"; "SHOULD NOT", "NOT RECOMMENDED"; "MAY", "OPTIONAL".</p>
        </xsl:if>
        <!-- TABLE OF CONTENTS -->
        <p><hr /></p>
        <xsl:call-template name='processTOC' />
        <!-- JEP CONTENTS -->
        <p><hr /></p>
        <xsl:apply-templates select='/jep/section1'/>
        <!-- NOTES -->
        <p><hr /></p>
        <a name="notes"></a><h2>Notes</h2>
        <div class='indent'>
          <xsl:apply-templates select='//note' mode='endlist'/>
        </div>
        <!-- REVISION HISTORY -->
        <p><hr /></p>
        <a name="revs"></a><h2>Revision History</h2>
          <div class='indent'>
            <xsl:apply-templates select='/jep/header/revision'/>
          </div>
        <p><hr /></p>
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
    <dl>
      <xsl:apply-templates select='//section1' mode='toc'/>
      <dt><a href="#notes">Notes</a></dt>
      <dt><a href="#revs">Revision History</a></dt>
    </dl>
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
      <xsl:variable name='authornote.count' select='count(authornote)'/>
      <xsl:if test='$authornote.count &gt; 0'>
        See <a href='#authornote'>Author Note</a><br />
      </xsl:if>
      <xsl:if test='$org.count &gt; 0'>
        Organization: <xsl:value-of select='org'/><br />
      </xsl:if>
      <xsl:if test='$email.count &gt; 0'>
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
      <xsl:if test='$jid.count &gt; 0'>
        JID: 
        <a>
          <xsl:attribute name='href'>
            <xsl:text>xmpp:</xsl:text>
            <xsl:value-of select='jid' />
          </xsl:attribute>
          <xsl:value-of select='jid' />
        </a>
      </xsl:if>
    </p>
  </xsl:template>

  <xsl:template match='legal'>
    <h2>Legal Notice</h2>
    <p class='indent'><xsl:apply-templates/></p>
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
      <xsl:when test="$ns.count &gt; 0">
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
    <dt>
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
    </dt>
    <xsl:if test='$sect2.count &gt; 0'>
      <dl>
        <xsl:apply-templates select='section2' mode='toc'>
          <xsl:with-param name='prevnum' select='$num'/>
        </xsl:apply-templates>
      </dl>
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
    <dt>
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
    </dt>
    <xsl:if test='$sect3.count &gt; 0'>
      <dl>
        <xsl:apply-templates select='section3' mode='toc'>
          <xsl:with-param name='prevnum' select='$num'/>
        </xsl:apply-templates>
      </dl>
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
    <dt>
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
    </dt>
    <xsl:if test='$sect4.count &gt; 0'>
      <dl>
        <xsl:apply-templates select='section4' mode='toc'>
          <xsl:with-param name='prevnum' select='$num'/>
        </xsl:apply-templates>
      </dl>
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
    <dt>
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
    </dt>
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
      <xsl:if test='$class.count &gt; 0'>
        <xsl:attribute name='class'><xsl:value-of select='@class'/></xsl:attribute>
      </xsl:if>
      <xsl:variable name='style.count' select='count(@style)'/>
      <xsl:if test='$style.count &gt; 0'>
        <xsl:attribute name='style'><xsl:value-of select='@style'/></xsl:attribute>
      </xsl:if>
      <xsl:apply-templates/>
    </p>
  </xsl:template>

  <xsl:template match='ul'>
    <ul>
      <xsl:variable name='class.count' select='count(@class)'/>
      <xsl:if test='$class.count &gt; 0'>
        <xsl:attribute name='class'><xsl:value-of select='@class'/></xsl:attribute>
      </xsl:if>
      <xsl:variable name='style.count' select='count(@style)'/>
      <xsl:if test='$style.count &gt; 0'>
        <xsl:attribute name='style'><xsl:value-of select='@style'/></xsl:attribute>
      </xsl:if>
      <xsl:apply-templates/>
    </ul>
  </xsl:template>

  <xsl:template match='ol'>
    <ol>
      <xsl:variable name='start.count' select='count(@start)'/>
      <xsl:if test='$start.count &gt; 0'>
        <xsl:attribute name='start'><xsl:value-of select='@start'/></xsl:attribute>
      </xsl:if>
      <xsl:variable name='type.count' select='count(@type)'/>
      <xsl:if test='$type.count &gt; 0'>
        <xsl:attribute name='type'><xsl:value-of select='@type'/></xsl:attribute>
      </xsl:if>
      <xsl:variable name='class.count' select='count(@class)'/>
      <xsl:if test='$class.count &gt; 0'>
        <xsl:attribute name='class'><xsl:value-of select='@class'/></xsl:attribute>
      </xsl:if>
      <xsl:variable name='style.count' select='count(@style)'/>
      <xsl:if test='$style.count &gt; 0'>
        <xsl:attribute name='style'><xsl:value-of select='@style'/></xsl:attribute>
      </xsl:if>
      <xsl:apply-templates/>
    </ol>
  </xsl:template>

  <xsl:template match='li'>
    <li>
      <xsl:variable name='class.count' select='count(@class)'/>
      <xsl:if test='$class.count &gt; 0'>
        <xsl:attribute name='class'><xsl:value-of select='@class'/></xsl:attribute>
      </xsl:if>
      <xsl:variable name='style.count' select='count(@style)'/>
      <xsl:if test='$style.count &gt; 0'>
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
    <p class='caption'>Example <xsl:number level='any' count='example'/>.<xsl:text> </xsl:text><xsl:value-of select='@caption'/></p>
    <div class='indent'>
      <pre><xsl:apply-templates/></pre>
    </div>
  </xsl:template>

  <xsl:template match='code'>
    <p class='caption'><xsl:value-of select='@caption'/></p>
    <div class='indent'>
      <pre><xsl:apply-templates/></pre>
    </div>
  </xsl:template>

  <xsl:template match='pre'>
    <pre><xsl:apply-templates/></pre>
  </xsl:template>

  <xsl:template match='img'>
    <img>
      <xsl:attribute name='src'><xsl:value-of select='@src'/></xsl:attribute>
    </img>
  </xsl:template>

  <xsl:template match='table'>
    <p class='caption'>Table <xsl:number level='any' count='table'/>:<xsl:text> </xsl:text><xsl:value-of select='@caption'/></p>
    <table border='1' cellpadding='3' cellspacing='0'>
      <xsl:apply-templates/>
    </table>
  </xsl:template>

  <xsl:template match='tr'>
    <tr class='body'>
      <xsl:apply-templates/>
    </tr>
  </xsl:template>

  <xsl:template match='th'>
    <th>
      <xsl:attribute name='colspan'><xsl:value-of select='@colspan'/></xsl:attribute>
      <xsl:attribute name='rowspan'><xsl:value-of select='@rowspan'/></xsl:attribute>
      <xsl:apply-templates/>
    </th>
  </xsl:template>

  <xsl:template match='td'>
    <td>
      <xsl:attribute name='align'><xsl:value-of select='@align'/></xsl:attribute>
      <xsl:attribute name='colspan'><xsl:value-of select='@colspan'/></xsl:attribute>
      <xsl:attribute name='rowspan'><xsl:value-of select='@rowspan'/></xsl:attribute>
      <xsl:apply-templates/>
    </td>
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

  <xsl:template match='tt'>
    <tt>
      <xsl:apply-templates/>
    </tt>
  </xsl:template>

  <xsl:template match='em'>
    <span style='font-style: italic'>
      <xsl:apply-templates/>
    </span>
  </xsl:template>

  <xsl:template match='strong'>
    <span style='font-weight: bold'>
      <xsl:apply-templates/>
    </span>
  </xsl:template>

  <xsl:template match='cite'>
    <span style='font-weight: bold'>
      <xsl:apply-templates/>
    </span>
  </xsl:template>

<!-- PRESENTATIONAL ELEMENTS -->

  <xsl:template match='div'>
    <div>
      <xsl:variable name='class.count' select='count(@class)'/>
      <xsl:if test='$class.count &gt; 0'>
        <xsl:attribute name='class'><xsl:value-of select='@class'/></xsl:attribute>
      </xsl:if>
      <xsl:variable name='style.count' select='count(@style)'/>
      <xsl:if test='$style.count &gt; 0'>
        <xsl:attribute name='style'><xsl:value-of select='@style'/></xsl:attribute>
      </xsl:if>
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <xsl:template match='span'>
    <span>
      <xsl:variable name='class.count' select='count(@class)'/>
      <xsl:if test='$class.count &gt; 0'>
        <xsl:attribute name='class'><xsl:value-of select='@class'/></xsl:attribute>
      </xsl:if>
      <xsl:variable name='style.count' select='count(@style)'/>
      <xsl:if test='$style.count &gt; 0'>
        <xsl:attribute name='style'><xsl:value-of select='@style'/></xsl:attribute>
      </xsl:if>
      <xsl:apply-templates/>
    </span>
  </xsl:template>

<!-- END OF PRESENTATIONAL ELEMENTS -->

</xsl:stylesheet>
