<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/XSL/Format">
  <xsl:template match="/">
    <root>
      <layout-master-set>
        <simple-page-master master-name="cover">
          <region-body margin-left="1in" margin-right="1in" margin-top="2.5in" margin-bottom="1in"/>
        </simple-page-master>
        <!--<simple-page-master master-name="doc_info">
          <region-body margin-left="1in" margin-top="1in" margin-right="1in" margin-bottom="1in"/>
        </simple-page-master>
        <simple-page-master master-name="toc_page">
          <region-body margin-left="1in" margin-top="1in" margin-right="1in" margin-bottom="1in"/>
        </simple-page-master>-->
        <simple-page-master master-name="std_page">
          <region-body margin-left="1in" margin-top="1in" margin-right="1in" margin-bottom="1in"/>
          <region-before extent="1in" display-align="after"/>
          <region-after extent="1in" display-align="before"/>
        </simple-page-master>
        <page-sequence-master master-name="jep_sequence">
          <single-page-master-reference master-reference="cover"/>
          <!--<single-page-master-reference master-reference="doc_info"/>
          <single-page-master-reference master-reference="toc_page"/>-->
          <repeatable-page-master-reference master-reference="std_page"/>
        </page-sequence-master>
      </layout-master-set>
      <page-sequence master-reference="jep_sequence">
        <flow flow-name="xsl-region-body" font-family="serif" color="black" font-size="10pt">
          <block space-before="1.5in" text-align="right" font-family="sans-serif" font-size="18pt">
            JEP-<xsl:value-of select="/jep/header/number"/>
          </block>
          <block text-align="right" font-family="sans-serif" font-size="18pt">
            <xsl:value-of select="/jep/header/title"/>
          </block>
          <!--</flow>
      </page-sequence>
      <page-sequence master-reference="doc_info">
        <flow flow-name="xsl-region-body" font-family="serif" font-size="10pt" color="black">-->
          <block font-family="sans-serif" font-size="14pt" space-after=".5em" break-before="page">Document Information</block>
          <block font-size="12pt" font-weight="bold">Document Author(s)</block>
          <block>
            <inline font-weight="bold">Name: </inline>
            <inline>
              <xsl:value-of select="/jep/header/author/firstname"/>
              <xsl:value-of select="/jep/header/author/surname"/>
            </inline>
          </block>
          <block>
            <inline font-weight="bold">Email: </inline>
            <inline>
              <xsl:value-of select="/jep/header/author/email"/>
            </inline>
          </block>
          <block space-after=".5em">
            <inline font-weight="bold">JID: </inline>
            <inline>
              <xsl:value-of select="/jep/header/author/jid"/>
            </inline>
          </block>
          <block font-size="12pt" font-weight="bold">Abstract</block>
          <block space-after=".5em">
            <xsl:value-of select="/jep/header/abstract"/>
          </block>
          <block font-size="12pt" font-weight="bold">Document Status</block>
          <block space-after=".5em">
            <xsl:value-of select="/jep/header/status"/>
          </block>
          <block font-size="12pt" font-weight="bold">Dependencies/References</block>
          <block space-after=".5em">
            <xsl:value-of select="/jep/header/dependencies"/>
          </block>
          <block font-size="12pt" font-weight="bold">Legal Notice</block>
          <block space-after=".5em">
            <xsl:value-of select="/jep/header/legal"/>
          </block>
          <block font-size="12pt" font-weight="bold" space-after=".5em">Revision History</block>
          <table table-layout="fixed" border-width=".25pt" border-color="black" border-style="solid">
            <table-column text-align="center" column-width=".625in" column-number="1"/>
            <table-column text-align="center" column-width=".75in" column-number="2"/>
            <table-column text-align="center" column-width=".5in" column-number="3"/>
            <table-column column-width="4.125in" column-number="4"/>
            <table-body>
              <table-row background-color="black" color="white" font-weight="bold">
                <table-cell padding="3pt">
                  <block>Version</block>
                </table-cell>
                <table-cell padding="3pt">
                  <block>Date</block>
                </table-cell>
                <table-cell padding="3pt">
                  <block>Initials</block>
                </table-cell>
                <table-cell padding="3pt">
                  <block>Comment</block>
                </table-cell>
              </table-row>
              <xsl:apply-templates select="/jep/header"/>
            </table-body>
          </table>
          <!--</flow>
      </page-sequence>
      <page-sequence master-reference="toc_page" force-page-count="no-force" format="i">
        <flow flow-name="xsl-region-body" font-family="serif" font-size="10pt" color="black">-->
          <xsl:call-template name="processTOC"/>
        </flow>
      </page-sequence>
      <page-sequence master-reference="std_page" initial-page-number="1">
        <!--<static-content flow-name="xsl-region-before" margin-top=".5in">
                    <block margin-left="1in" margin-right="1in" text-align-last="justify" font-size="9pt" font-family="sans-serif" color="silver">
                        <xsl:value-of select="/jep/header/customer"/>
                        <leader leader-pattern="space"/>
                    Requirements Proposal
                    </block>
                    <block margin-left="1in" margin-right="1in" padding-bottom="10pt" border-after-color="black" border-after-width=".25pt" border-after-style="solid" text-align-last="justify" font-size="9pt" font-family="sans-serif" color="silver">
                        <xsl:value-of select="/jep/header/title"/>
                        <leader leader-pattern="space"/>
                        <xsl:value-of select="/jep/header/revision[last()]/date"/>
                    </block>
                </static-content>-->
        <static-content flow-name="xsl-region-after">
          <block margin-left="1in" margin-right="1in" padding-top="10pt" border-before-color="black" border-before-width=".125pt" border-before-style="solid" text-align-last="justify" font-size="8pt" font-family="sans-serif" color="black">
                        IJEP-<xsl:value-of select="/jep/header/number"/>:<xsl:text> </xsl:text>
            <xsl:value-of select="/jep/header/title"/>
            <leader leader-pattern="space"/>
                        Page <page-number/> of <page-number-citation ref-id="lastpage"/>
          </block>
        </static-content>
        <flow flow-name="xsl-region-body" font-family="serif" font-size="10pt" color="black">
          <xsl:apply-templates select="/jep/section1"/>
          <block font-family="sans-serif" font-size="12pt" color="black" space-before=".5em" space-after=".5em">Notes:</block>
          <xsl:apply-templates select="//note" mode="endlist"/>
          <block id="lastpage"/>
        </flow>
      </page-sequence>
    </root>
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
  <xsl:template name="processTOC">
    <block font-family="sans-serif" font-size="14pt" space-after=".5em" break-before="page">Table of Contents</block>
    <xsl:apply-templates select="//section1" mode="toc"/>
  </xsl:template>
  <xsl:template match="/jep/header/revision">
    <table-row>
      <table-cell padding="3pt">
        <block>
          <xsl:value-of select="version"/>
        </block>
      </table-cell>
      <table-cell padding="3pt">
        <block>
          <xsl:value-of select="date"/>
        </block>
      </table-cell>
      <table-cell padding="3pt">
        <block>
          <xsl:value-of select="initials"/>
        </block>
      </table-cell>
      <table-cell padding="3pt">
        <block>
          <xsl:value-of select="remark"/>
        </block>
      </table-cell>
    </table-row>
  </xsl:template>
  <xsl:template match="section1" mode="toc">
    <xsl:variable name="oid">
      <xsl:call-template name="object.id"/>
    </xsl:variable>
    <xsl:variable name="num">
      <xsl:number level="multiple" count="section1"/>
      <xsl:text>.</xsl:text>
    </xsl:variable>
    <xsl:variable name="sect2.count" select="count(section2)"/>
    <xsl:value-of select="$num"/>
    <xsl:text>  </xsl:text>
    <block text-align-last="justify" font-variant="small-caps">
      <xsl:value-of select="$num"/>
      <xsl:value-of select="@topic"/>
      <xsl:text> </xsl:text>
      <leader leader-pattern="rule" space-end=".125in"/>
      <xsl:text>   </xsl:text>
      <page-number-citation ref-id="sect-{$oid}"/>
    </block>
    <xsl:if test="$sect2.count &gt; 0">
      <xsl:apply-templates select="section2" mode="toc">
        <xsl:with-param name="prevnum" select="$num"/>
      </xsl:apply-templates>
    </xsl:if>
  </xsl:template>
  <xsl:template match="section1">
    <xsl:variable name="oid">
      <xsl:call-template name="object.id"/>
    </xsl:variable>
    <xsl:variable name="num">
      <xsl:number level="multiple" count="section1"/>
      <xsl:text>.</xsl:text>
    </xsl:variable>
    <!--<xsl:number level="single" count="section1"/>-->
    <block id="sect-{$oid}" font-family="sans-serif" font-size="14pt" space-after="1em" space-before="1em" font-weight="bold">
      <xsl:value-of select="$num"/>
      <xsl:text> </xsl:text>
      <xsl:value-of select="@topic"/>
    </block>
    <xsl:apply-templates/>
  </xsl:template>
  <xsl:template match="section2" mode="toc">
    <xsl:param name="prevnum" select='""'/>
    <xsl:variable name="oid">
      <xsl:call-template name="object.id"/>
    </xsl:variable>
    <xsl:variable name="num">
      <xsl:value-of select="$prevnum"/>
      <xsl:number level="multiple" count="section2"/>
      <xsl:text>.</xsl:text>
    </xsl:variable>
    <xsl:variable name="sect3.count" select="count(section3)"/>
    <block text-align-last="justify" margin-left="1em">
      <xsl:value-of select="$num"/>
      <xsl:text> </xsl:text>
      <xsl:value-of select="@topic"/>
      <xsl:text> </xsl:text>
      <leader leader-pattern="rule" space-end=".125in"/>
      <xsl:text>   </xsl:text>
      <page-number-citation ref-id="sect-{$oid}"/>
    </block>
    <xsl:if test="$sect3.count &gt; 0">
      <xsl:apply-templates select="section3" mode="toc">
        <xsl:with-param name="prevnum" select="$num"/>
      </xsl:apply-templates>
    </xsl:if>
  </xsl:template>
  <xsl:template match="section2">
    <xsl:param name="prevnum" select='""'/>
    <xsl:variable name="oid">
      <xsl:call-template name="object.id"/>
    </xsl:variable>
    <xsl:variable name="num">
      <xsl:number level="single" count="section1"/>.<xsl:number level="multiple" count="section2"/>
      <xsl:text>.</xsl:text>
    </xsl:variable>
    <xsl:variable name="sect3.count" select="count(section3)"/>
    <block id="sect-{$oid}" font-weight="bold" font-family="sans-serif">
      <xsl:value-of select="$num"/>
      <xsl:text> </xsl:text>
      <xsl:value-of select="@topic"/>
    </block>
    <xsl:apply-templates/>
  </xsl:template>
  <xsl:template match="section3" mode="toc">
    <xsl:param name="prevnum" select='""'/>
    <xsl:variable name="oid">
      <xsl:call-template name="object.id"/>
    </xsl:variable>
    <xsl:variable name="num">
      <xsl:value-of select="$prevnum"/>
      <xsl:number level="multiple" count="section3"/>
      <xsl:text>.</xsl:text>
    </xsl:variable>
    <block text-align-last="justify" margin-left="1em">
      <xsl:value-of select="$num"/>
      <xsl:text> </xsl:text>
      <xsl:value-of select="@topic"/>
      <xsl:text> </xsl:text>
      <leader leader-pattern="rule" space-end=".125in"/>
      <xsl:text>   </xsl:text>
      <page-number-citation ref-id="sect-{$oid}"/>
    </block>
  </xsl:template>
  <xsl:template match="section3">
    <xsl:variable name="oid">
      <xsl:call-template name="object.id"/>
    </xsl:variable>
    <block id="sect-{$oid}" margin-left=".5em">
      <xsl:if test="../../@type='functional-spec'">FR-<xsl:number level="single" count="section2"/>.<xsl:number level="single" count="section3"/>
      </xsl:if>
      <xsl:if test="../../@type='supp-spec'">SS-<xsl:number level="single" count="section2"/>.<xsl:number level="single" count="section3"/>
      </xsl:if>
      <xsl:text> </xsl:text>
      <xsl:value-of select="@topic"/>
      <xsl:apply-templates/>
    </block>
  </xsl:template>
  <xsl:template match="p">
    <block space-before=".5em" space-after=".5em">
      <xsl:apply-templates/>
    </block>
  </xsl:template>
  <xsl:template match="code">
    <block space-after="1em" margin-bottom="1em" margin-left="1em" font-family="monospace" font-size="8pt" font-weight="normal" white-space-collapse="false" keep-together.within-page="always">
      <xsl:value-of select="."/>
    </block>
  </xsl:template>
  <xsl:template match="example">
    <table table-layout="fixed" width="100%" space-after="1em">
      <table-column column-width="proportional-column-width(1)"/>
      <table-body>
        <table-row keep-with-next="always">
          <table-cell>
            <block margin-left=".5em" space-after=".5em" space-before=".5em" font-weight="600" font-size="9pt">
        Example <xsl:number level="any" count="example"/>.<xsl:text> </xsl:text>
              <xsl:value-of select="@caption"/>
            </block>
          </table-cell>
        </table-row>
        <table-row>
          <table-cell>
            <block margin-left="1em" font-family="monospace" font-size="8pt" font-weight="normal" white-space-collapse="false" keep-together.within-page="always">
              <xsl:value-of select="."/>
            </block>
          </table-cell>
        </table-row>
      </table-body>
    </table>
  </xsl:template>
  <xsl:template match="note">
    <xsl:variable name="notenum">
      <xsl:number level="any" count="note"/>
    </xsl:variable>
    <xsl:variable name="oid">
      <xsl:call-template name="object.id"/>
    </xsl:variable>
    <inline>[<basic-link color="blue" font-weight="bold" internal-destination="nt-{$oid}">
        <xsl:value-of select="$notenum"/>
      </basic-link>]</inline>
  </xsl:template>
  <xsl:template match="note" mode="endlist">
    <xsl:variable name="oid">
      <xsl:call-template name="object.id"/>
    </xsl:variable>
    <block id="nt-{$oid}" margin=".5em" font-size="8pt">
      <xsl:value-of select="position()"/>. <xsl:apply-templates/>
    </block>
  </xsl:template>
  <xsl:template match="link">
    <basic-link external-destination="{@url}" text-decoration="underline" color="blue">
      <xsl:apply-templates/>
    </basic-link>
  </xsl:template>
  <xsl:template match="strong">
    <inline font-weight="bold">
      <xsl:apply-templates/>
    </inline>
  </xsl:template>
  <xsl:template match="em">
    <inline font-style="italic">
      <xsl:apply-templates/>
    </inline>
  </xsl:template>
  <xsl:template match="ul">
    <list-block provisional-distance-between-starts="10pt" provisional-label-separation="3pt" space-after=".5em" space-start="1em" margin-left="1em">
      <xsl:apply-templates select="li" mode="ul"/>
    </list-block>
  </xsl:template>
  <xsl:template match="ol">
    <list-block provisional-distance-between-starts="10pt" provisional-label-separation="3pt" space-after=".5em" space-start="1em" margin-left="1em">
      <xsl:apply-templates select="li" mode="ol"/>
    </list-block>
  </xsl:template>
  <xsl:template match="li" mode="ul">
    <list-item>
      <list-item-label end-indent="label-end()">
        <block>&#x2022;</block>
      </list-item-label>
      <list-item-body start-indent="body-start()">
        <block>
          <xsl:value-of select="."/>
        </block>
      </list-item-body>
    </list-item>
  </xsl:template>
  <xsl:template match="li" mode="ol">
    <xsl:variable name="num">
      <xsl:number level="multiple" count="li"/>
    </xsl:variable>
    <list-item>
      <list-item-label end-indent="label-end()">
        <block>
          <xsl:value-of select="$num"/>.</block>
      </list-item-label>
      <list-item-body start-indent="body-start()">
        <block>
          <xsl:value-of select="."/>
        </block>
      </list-item-body>
    </list-item>
  </xsl:template>
</xsl:stylesheet>
