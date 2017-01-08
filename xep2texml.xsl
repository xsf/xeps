<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:str="http://xsltsl.org/string">
<!--
  * Copyright (c) 2008 - 2010, Tobias Markmann
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
  * modification, are permitted provided that the following conditions are met:
  *     * Redistributions of source code must retain the above copyright
  *       notice, this list of conditions and the following disclaimer.
  *     * Redistributions in binary form must reproduce the above copyright
  *       notice, this list of conditions and the following disclaimer in the
  *       documentation and/or other materials provided with the distribution.
  *     * Neither the name of the <organization> nor the
  *       names of its contributors may be used to endorse or promote products
  *       derived from this software without specific prior written permission.
  *
  * THIS SOFTWARE IS PROVIDED BY TOBIAS MARKMANN ''AS IS'' AND ANY
  * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  * DISCLAIMED. IN NO EVENT SHALL TOBIAS MARKMANN BE LIABLE FOR ANY
  * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
  * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
  * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

  Thanks to the XSLT Standard Library http://xsltsl.sourceforge.net/.
-->

<!--<xsl:include href="xsltsl/string.xsl"/>-->
<xsl:import href="http://xsltsl.sourceforge.net/modules/stdlib.xsl"/>

<!-- Create a variable named $maxXEPVersiom containing the MAX version -->
<xsl:variable name="maxXEPVersion">
  <xsl:value-of select='/xep/header/revision[position()=1]/version'/>
</xsl:variable>

<!-- Create a variable named $maxXEPDate containing the MAX date -->
<xsl:variable name="maxXEPDate">
  <xsl:for-each select="/xep/header/revision">
    <xsl:sort select="date" data-type="text" order="descending" />
      <xsl:if test="position() = 1">
        <xsl:value-of select="date" />
      </xsl:if>
  </xsl:for-each>
</xsl:variable>

<!-- Format URLs for the front page. Putting too long URLs in the footnotes. -->
<xsl:template name="formatURL">
  <xsl:param name="url"/>
  <xsl:choose>
    <xsl:when test="string-length($url) > 80">
      <cmd name="thanks"><parm><cmd name="url"><parm><xsl:value-of select="$url"/></parm></cmd></parm></cmd> \hspace{0.5 cm}
    </xsl:when>
    <xsl:otherwise>
      <cmd name="url"><parm><xsl:value-of select="$url"/></parm></cmd> \\
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- convert "document": create header and continue -->
<xsl:template match="xep">
  <TeXML>
    <!-- create header -->
    <TeXML escape="0">
%!TEX TS-program = xelatex
%!TEX encoding = UTF-8 Unicode
\documentclass[DIV=10]{scrartcl}
\KOMAoptions{paper=a4}

\usepackage[
  pdftitle={XEP-<xsl:value-of select="/xep/header/number"/>: <xsl:value-of select="/xep/header/title"/>},
  pdfauthor={XMPP Standards Foundation},
  pdfcreator={XEP2PDF},
  pdfproducer={XEP2PDF},
  breaklinks = true,
  unicode,
  pagebackref,
  xetex]{hyperref}

% break URLs at more places
\renewcommand{\UrlBreaks}{\do\/\do\a\do\b\do\c\do\d\do\e\do\f\do\g\do\h\do\i\do\j\do\k\do\l\do\m\do\n\do\o\do\p\do\q\do\r\do\s\do\t\do\u\do\v\do\w\do\x\do\y\do\z\do\A\do\B\do\C\do\D\do\E\do\F\do\G\do\H\do\I\do\J\do\K\do\L\do\M\do\N\do\O\do\P\do\Q\do\R\do\S\do\T\do\U\do\V\do\W\do\X\do\Y\do\Z\do\0\do\1}

\usepackage{xcolor}
\usepackage{graphicx}
\usepackage{fancyhdr}
\usepackage{tabu}
\usepackage{longtable}
\usepackage{listings}
\usepackage{varwidth}
\usepackage{titling}
\usepackage{titletoc}
\usepackage{float}
\usepackage{adjustbox}
<xsl:if test="glossary">\usepackage[toc,nonumberlist]{glossaries}</xsl:if>

\usepackage{hyphenat}

\hypersetup{colorlinks, linkcolor=blue, anchorcolor=blue, urlcolor=blue}


\usepackage{fontspec,xltxtra,xunicode}
\defaultfontfeatures{Mapping=tex-text}
\setromanfont[Ligatures={Common}]{Gentium Basic}
\setsansfont[Scale=MatchLowercase]{Gentium Basic}
\setmonofont[Scale=MatchLowercase]{Inconsolata}

\setkomafont{descriptionlabel}{\normalfont\bfseries}

\usepackage[english]{babel}

\pagestyle{fancy}
\fancyfoot{}
\fancyhead{}
%% page numbering

\newcommand{\XEPNumber}[0]{<xsl:value-of select="/xep/header/number"/>}
\newcommand{\XEPVersion}[0]{<xsl:value-of select="$maxXEPVersion"/>}

\newcolumntype{L}{>{\raggedright\arraybackslash}X}

\fancyhead[L,L]{\includegraphics[totalheight=10pt]{xmpp.pdf} \slshape \leftmark}
\fancyfoot[C,C]{\thepage}

\pretitle{
\begin{figure*}[h]
\begin{center}
\includegraphics[totalheight=7.5cm]{xmpp-text.pdf}
\end{center}
\end{figure*}
\begin{center}\LARGE
}

<xsl:if test="glossary">\makeglossaries</xsl:if>
\sloppy
    </TeXML>

    <cmd name="title" nl2="1">
      <parm>XEP-<cmd name="XEPNumber" />: <xsl:value-of select="/xep/header/title"/></parm>
    </cmd>
    <cmd name="author">
      <parm><TeXML escape="0">
      <xsl:for-each select='/xep/header/author'><xsl:value-of select="firstname"/><xsl:text> </xsl:text><xsl:value-of select="surname"/> \\
      <xsl:if test="email"><xsl:call-template name="formatURL"><xsl:with-param name="url">mailto:<xsl:value-of select="email"/></xsl:with-param></xsl:call-template></xsl:if>
      <xsl:if test="jid"><xsl:call-template name="formatURL"><xsl:with-param name="url">xmpp:<xsl:value-of select="jid"/></xsl:with-param></xsl:call-template></xsl:if>
      <xsl:if test="uri"><xsl:call-template name="formatURL"><xsl:with-param name="url"><xsl:value-of select="uri"/></xsl:with-param></xsl:call-template></xsl:if> <xsl:if test='position() != last()'> \and </xsl:if>
      </xsl:for-each>
      </TeXML></parm>
    </cmd>
    <cmd name="date">
        <parm><TeXML escape="0"><xsl:value-of select="$maxXEPDate"/>\\ Version <xsl:value-of select="$maxXEPVersion"/></TeXML></parm>
    </cmd>
    <!-- process content -->
    <env name="document">
      <TeXML escape="0">
        <cmd name="lstset">
          <parm>language=XML,
            breaklines=true,
            emptylines=5,
            frame=single,
            rulecolor=\color{black},
            basicstyle=\ttfamily\small\color{darkgray},
            keywordstyle=\color{cyan},
            stringstyle=\color{blue},
            tagstyle=\color{purple},
            markfirstintag=true
          </parm>
        </cmd>
      </TeXML>
      <cmd name="KOMAoptions"><parm>DIV=24</parm></cmd>
      <cmd name="pagestyle"><parm>empty</parm></cmd>
      <cmd name="maketitle" />
      <cmd name="thispagestyle"><parm>empty</parm></cmd>
      <env name="center">
      <env name="tabular"><parm>ccc</parm>
      <TeXML escape="0">
      <cmd name="textbf"><parm>Status</parm></cmd> &amp; <cmd name="textbf"><parm>Type</parm></cmd> &amp; <cmd name="textbf"><parm>Short Name</parm></cmd> \\
        <xsl:value-of select="/xep/header/status"/> &amp; <xsl:value-of select="/xep/header/type"/> &amp; <TeXML escape="1"><xsl:value-of select="/xep/header/shortname"/></TeXML>
      </TeXML>
      </env>
      </env>
      <env name="abstract">
        <xsl:value-of select="/xep/header/abstract"/>
      </env>
      <cmd name="newpage" nl2="1"/>
      <TeXML escape="0">
            \fancyhead[L,L]{\includegraphics[totalheight=10pt]{xmpp.pdf} \slshape \leftmark}
            \fancyfoot[C,C]{\thepage}
        </TeXML>
      <cmd name="KOMAoptions"><parm>DIV=10</parm></cmd>
      <cmd name="section*" nl2="1"><parm>Legal</parm></cmd>
      <xsl:apply-templates select="/xep/header/legal" />
      <cmd name="newpage" nl2="1"/>
      <cmd name="tableofcontents" nl2="1"/>
      <cmd name="newpage" nl2="1"/>
      <cmd name="pagestyle" nl2="1"><parm>fancy</parm></cmd>
      <cmd name="setcounter" nl2="1"><parm>page</parm><parm>1</parm></cmd>
      <xsl:apply-templates/>
      <xsl:if test="glossary"><cmd name="glsaddall"/></xsl:if>
      <xsl:if test="glossary"><cmd name="printglossaries"/></xsl:if>
    </env>
  </TeXML>
</xsl:template>

<!-- for legal crap -->
<xsl:template match="copyright">
  <cmd name="subsection*" nl2="1"><parm>Copyright</parm></cmd>
  <group><cmd name="small" />
  <xsl:apply-templates/>
  </group>
</xsl:template>

<xsl:template match="permissions">
  <cmd name="subsection*" nl2="1"><parm>Permissions</parm></cmd>
  <group><cmd name="small" />
  <xsl:apply-templates/>
  </group>
</xsl:template>

<xsl:template match="warranty">
  <cmd name="subsection*" nl2="1"><parm>Warranty</parm></cmd>
  <group><cmd name="small" />
  <xsl:apply-templates/>
  </group>
</xsl:template>

<xsl:template match="liability">
  <cmd name="subsection*"><parm>Liability</parm></cmd>
  <group><cmd name="small" />
  <xsl:apply-templates/>
  </group>
</xsl:template>

<xsl:template match="conformance">
  <cmd name="subsection*"><parm>Conformance</parm></cmd>
  <group><cmd name="small" />
  <xsl:apply-templates/>
  </group>
</xsl:template>


<xsl:template match="header">
</xsl:template>
  

<!-- table -->
<xsl:template match='table'>
  <TeXML escape="0">
    <env name="center">
    <env name='longtabu'>
      <parm><xsl:for-each select='tr[1]/th | tr[1]/td'><xsl:if test="position() = 1">l</xsl:if><xsl:if test='position() != last() and position() > 1'>X</xsl:if><xsl:if test='position() = last()'>X</xsl:if></xsl:for-each></parm>
      <xsl:for-each select='tr'>
        <xsl:for-each select='td | th'><xsl:if test='position() > 1'> &amp; </xsl:if><TeXML escape="1"><xsl:value-of select='.'/></TeXML><xsl:if test='position() = last()'> \\</xsl:if></xsl:for-each>
        <xsl:if test="position() = 1">
          \hline
          \hline
          \endhead
        </xsl:if>
      </xsl:for-each>
    </env>
  </env>
</TeXML>
</xsl:template>
  

<!-- link -->  
<xsl:template match="span">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="link">
  <xsl:variable name="isHTTP">
    <xsl:call-template name="str:string-match">
      <xsl:with-param name="text"><xsl:value-of select="text()"/></xsl:with-param>
      <xsl:with-param name="pattern">*http*</xsl:with-param>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="isInternal">
    <xsl:call-template name="str:string-match">
      <xsl:with-param name="text"><xsl:value-of select="@url"/></xsl:with-param>
      <xsl:with-param name="pattern">#*</xsl:with-param>
    </xsl:call-template>
  </xsl:variable>
  <xsl:if test="$isInternal = 0">
    <cmd name="href">
      <parm>
        <TeXML escape="0"><xsl:value-of select='@url'/></TeXML>
      </parm>
      <parm>
      <xsl:if test="$isHTTP = 1">
        <cmd name="url"><parm><xsl:apply-templates/></parm></cmd>
      </xsl:if>
      <xsl:if test="$isHTTP = 0">
        <xsl:apply-templates/>
      </xsl:if>
      </parm>
    </cmd>
  </xsl:if>
  <xsl:if test="$isInternal = 1">
    <cmd name="hyperref">
      <opt><TeXML escape="0"><xsl:value-of select='@url'/></TeXML></opt>
      <parm><xsl:apply-templates/></parm>
    </cmd>
    <!--<TeXML escape="0"> { </TeXML><cmd name="footnotesize" /><cmd name="pageref"><parm><TeXML escape="0"><xsl:value-of select='@url'/></TeXML></parm></cmd><TeXML escape="0"> } </TeXML>-->
  </xsl:if>
</xsl:template>
  
<!-- note -->
<xsl:template match="note">
  <cmd name="footnote"><parm><xsl:apply-templates/></parm></cmd>
</xsl:template>

<!-- em -->
<xsl:template match="em">
  <cmd name="emph"><parm><xsl:apply-templates/></parm></cmd>
</xsl:template>

<!-- strong -->
<xsl:template match="strong">
  <cmd name="textbf"><parm><xsl:apply-templates/></parm></cmd>
</xsl:template>

<!-- sub -->
<xsl:template match="sub">
  <math><cmd name="textsuperscript"><parm><xsl:apply-templates/></parm></cmd></math>
</xsl:template>

<!-- span[@class='super'] -->
<xsl:template match="span[@class='super']">
  <math><spec cat="sup"/><spec cat="bg"/><xsl:apply-templates/><spec cat="eg"/></math>
</xsl:template>


<!-- p -->
<xsl:template match="p">  
  <xsl:apply-templates/><TeXML escape="0" emptylines="1"><xsl:text>\\
  
  </xsl:text></TeXML>
</xsl:template>  

<!-- li -->
<xsl:template match="li">
  <TeXML escape="1" emptylines="1">
  <cmd name="item" /> <xsl:apply-templates/><xsl:text>

  </xsl:text>
  </TeXML>
</xsl:template>

<!-- ul -->
<xsl:template match="ul">
  <env name="itemize">
    <xsl:apply-templates/>
  </env>
</xsl:template>

<!-- ol -->
<xsl:template match="ol">
  <env name="enumerate">
    <xsl:apply-templates/>
  </env>
</xsl:template>

<!-- dl -->
<xsl:template match="dl">
  <env name="description">
    <xsl:apply-templates/>
  </env>
</xsl:template>

<!-- di -->
<xsl:template match="di">
  <TeXML escape="1" emptylines="1">
  <cmd name="item"><opt><xsl:value-of select="./dt" /></opt></cmd>
  <xsl:text>
  </xsl:text>
  <xsl:value-of select="./dd" />
  </TeXML>
</xsl:template>

<!-- example -->
<xsl:template match="example">
    <env name="lstlisting">
      <opt>caption=<group><TeXML escape="1"><xsl:value-of select="@caption"/></TeXML></group></opt>
      <TeXML escape="0" emptylines="1">
      <xsl:apply-templates />
      </TeXML>
    </env>
</xsl:template>

<xsl:template match="br">
  <!--<cmd name="newline" gr="0"/>-->

</xsl:template>

<!-- code -->
<xsl:template match="code">
  <xsl:if test='@class = "inline"'>
    <cmd name='path'><parm><TeXML escape="0"><xsl:value-of select="."/></TeXML></parm></cmd>
  </xsl:if>
  <xsl:if test='not(@class)'>
    <env name="lstlisting">
    <TeXML escape="0" emptylines="1" ligatures="1">
      <xsl:value-of select="."/>
    </TeXML>
    </env>
  </xsl:if>
</xsl:template>

<!-- img -->
<xsl:template match="img">
  <env name="figure"><opt>H</opt>
    <cmd name="centering" />
    <cmd name="adjustimage"><parm><TeXML escape="0">max size={.9\textwidth}{.9\textheight}</TeXML></parm><parm>inlineimage-<xsl:value-of select="/xep/header/number" />-<xsl:value-of select="count(preceding::img)" /></parm></cmd>
  </env>
</xsl:template>

<!-- section3 -->
<xsl:template match="section3">
  <cmd name="subsubsection" nl2="1">
    <parm><xsl:text></xsl:text><xsl:value-of select="@topic"/></parm>
  </cmd>
  <cmd name="label">
    <parm><TeXML escape="0"><xsl:value-of select="@anchor" /></TeXML></parm>
  </cmd>
  <xsl:apply-templates />
</xsl:template>

<!-- section2 -->
<xsl:template match="section2">
  <cmd name="subsection" nl2="1">
    <parm><xsl:text></xsl:text><xsl:value-of select="@topic"/></parm>
  </cmd>
  <cmd name="label">
    <parm><TeXML escape="0"><xsl:value-of select="@anchor" /></TeXML></parm>
  </cmd>
  <xsl:apply-templates />
</xsl:template>

<!-- section1 -->
<xsl:template match="section1">
  <cmd name="section" nl2="1">
    <parm><xsl:text></xsl:text><xsl:value-of select="@topic"/></parm>
  </cmd>
  <cmd name="label" nl2="1">
    <parm><TeXML escape="0"><xsl:value-of select="@anchor" /></TeXML></parm>
  </cmd>
  <xsl:apply-templates />
</xsl:template>

<!-- glossary -->
<xsl:template match="glossary">
  <xsl:apply-templates select="dl" mode="glossary"/>
</xsl:template>

<xsl:template match="dl" mode="glossary">
  <xsl:apply-templates select="di" mode="glossary"/>
</xsl:template>

<xsl:template match="di" mode="glossary">
  <TeXML escape="1" emptylines="1">
    <cmd name="newglossaryentry">
      <parm><xsl:value-of select="./dt" /></parm>
      <parm>
          name=<xsl:value-of select="./dt" />,
          description=<group><xsl:value-of select="./dd" /></group>
      </parm>
    </cmd>
  </TeXML>
</xsl:template>

</xsl:stylesheet>
