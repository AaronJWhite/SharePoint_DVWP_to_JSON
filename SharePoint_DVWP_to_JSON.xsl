<XSL>
  <xsl:stylesheet version="1.0" exclude-result-prefixes="xsl ddwrt2 ddwrt"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:ddwrt2="urn:frontpage:internal"
xmlns:ddwrt="http://schemas.microsoft.com/WebParts/v2/DataView/runtime" >
 
  <xsl:output method="text" encoding="UTF-8" indent="no" omit-xml-declaration="yes" />
 
  <xsl:variable name="STRING_DELIM" select="'&quot;'" />
 
 
  <!-- create a key for every element in the document using its name -->
  <xsl:key name="names" match="*" use="concat(generate-id(..),'/',name())"/>
 
  <!-- start with the root element -->
  <xsl:template match="/">
    <!-- first element needs brackets around it as template does not do that -->
    <xsl:text>{ </xsl:text>
    <!-- call the template for elements using one unique name at a time -->
    <xsl:apply-templates select="*[generate-id(.) = generate-id(key('names', concat(generate-id(..),'/',name()))[1])]" >
      <xsl:sort select="name()"/>
    </xsl:apply-templates>
    <xsl:text> }</xsl:text>
  </xsl:template>
 
  <!-- this template handles elements -->
  <xsl:template match="*">
    <!-- count the number of elements with the same name -->
    <xsl:variable name="kctr" select="count(key('names', concat(generate-id(..),'/',name())))"/>
    <!-- iterate through by sets of elements with same name -->
    <xsl:for-each select="key('names', concat(generate-id(..),'/',name()))">
      <!-- deal with the element name and start of multiple element block -->
      <xsl:choose>
        <xsl:when test="($kctr &gt; 1) and (position() = 1)">
            <xsl:text>"</xsl:text>
          <xsl:value-of select="name()"/>
            <xsl:text>" : [ </xsl:text>
        </xsl:when>
        <xsl:when test="$kctr = 1">
            <xsl:text>"</xsl:text>
          <xsl:value-of select="name()"/>
            <xsl:text>" : </xsl:text>
        </xsl:when>
      </xsl:choose>
      <!-- count number of elements, text nodes and attribute nodes -->
      <xsl:variable name="nctr" select="count(*|text()|@*)"/>
      <xsl:choose>
        <xsl:when test="$nctr = 0">
          <!-- no contents at all -->
            <xsl:text>null</xsl:text>
        </xsl:when>
        <xsl:otherwise>
            <xsl:variable name="ctr" select="count(*)"/>
            <xsl:variable name="tctr" select="count(text())"/>
            <xsl:variable name="actr" select="count(@*)"/>
          <!-- there will be contents so start an object -->
            <xsl:text>{ </xsl:text>
          <!-- handle attribute nodes -->
            <xsl:if test="$actr &gt; 0">
            <xsl:apply-templates select="@*"/>
              <xsl:if test="($tctr &gt; 0) or ($ctr &gt; 0)">
                  <xsl:text>, </xsl:text>
            </xsl:if>
          </xsl:if>
          <!-- call template for child elements one unique name at a time -->
            <xsl:if test="$ctr &gt; 0">
            <xsl:apply-templates select="*[generate-id(.) = generate-id(key('names', concat(generate-id(..),'/',name()))[1])]">
                <xsl:sort select="name()"/>
            </xsl:apply-templates>
              <xsl:if test="$tctr &gt; 0">
                  <xsl:text>, </xsl:text>
            </xsl:if>
          </xsl:if>
          <!-- handle text nodes -->
            <xsl:choose>
              <xsl:when test="$tctr = 1">
                  <xsl:text>"$" : </xsl:text>
              <xsl:apply-templates select="text()"/>
            </xsl:when>
              <xsl:when test="$tctr &gt; 1">
                  <xsl:text>"$" : [ </xsl:text>
              <xsl:apply-templates select="text()"/>
                  <xsl:text> ]</xsl:text>
            </xsl:when>
            </xsl:choose>
            <xsl:text> }</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
      <!-- special processing if we are in multiple element block -->
      <xsl:if test="$kctr &gt; 1">
        <xsl:choose>
            <xsl:when test="position() = last()">
              <xsl:text> ]</xsl:text>
          </xsl:when>
            <xsl:otherwise>
              <xsl:text>, </xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:if>
    </xsl:for-each>
    <xsl:if test="position() != last()">
      <xsl:text>, </xsl:text>
    </xsl:if>
  </xsl:template>
 
  <!-- this template handle text nodes -->
  <xsl:template match="text()">
    <xsl:variable name="t" select="." />
    <xsl:choose>
      <!-- test to see if it is a number -->
    <xsl:when test="string(number($t)) != 'NaN'">
    <xsl:choose>
        <xsl:when test="string-length(translate(string($t),'0','')) != 0">
          <xsl:value-of select="$t"/>
        </xsl:when>
        <xsl:otherwise>
         <xsl:if test="string($t) = '0'">
          <xsl:value-of select="$t"/>
         </xsl:if>
          <xsl:if test="string($t) != '0'">
           <xsl:value-of select="$STRING_DELIM" />
           <xsl:value-of select="$t"/>
           <xsl:value-of select="$STRING_DELIM" />
         </xsl:if>
        </xsl:otherwise>
    </xsl:choose>

      </xsl:when>
      <!-- deal with any case booleans -->
      <xsl:when test="translate($t, 'TRUE', 'true') = 'true'">
        <xsl:text>true</xsl:text>
      </xsl:when>
      <xsl:when test="translate($t, 'FALSE', 'false') = 'false'">
        <xsl:text>false</xsl:text>
      </xsl:when>
      <!-- must be text -->
      <xsl:otherwise>
        <xsl:call-template name="escape-string">
          <xsl:with-param name="value" select="." />
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:if test="position() != last()">
      <xsl:text>, </xsl:text>
    </xsl:if>
  </xsl:template>
 
  <!-- this template handles attribute nodes -->
  <xsl:template match="@*">
    <!-- attach prefix to attribute names -->
    <xsl:text>"@</xsl:text>
     
    <!-- escape . in attribute name -->
    <xsl:call-template name="string-replace">
      <xsl:with-param name="value" select="name()" />
      <xsl:with-param name="find" select="'.'" />
      <xsl:with-param name="replace" select="'-'" />
    </xsl:call-template>
     
    <xsl:text>" : </xsl:text>
    <xsl:variable name="t" select="." />
    <xsl:choose>
      <xsl:when test="string(number($t)) != 'NaN'">
       <xsl:choose>
        <xsl:when test="string-length(translate(string($t),'0','')) != 0">
          <xsl:value-of select="$t"/>
        </xsl:when>
        <xsl:otherwise>
         <xsl:if test="string($t) = '0'">
          <xsl:value-of select="$t"/>
         </xsl:if>
          <xsl:if test="string($t) != '0'">
           <xsl:value-of select="$STRING_DELIM" />
           <xsl:value-of select="$t"/>
           <xsl:value-of select="$STRING_DELIM" />
         </xsl:if>
        </xsl:otherwise>
    </xsl:choose>

      </xsl:when>
      <xsl:when test="translate($t, 'TRUE', 'true') = 'true'">
        <xsl:text>true</xsl:text>
      </xsl:when>
      <xsl:when test="translate($t, 'FALSE', 'false') = 'false'">
        <xsl:text>false</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="escape-string">
          <xsl:with-param name="value" select="." />
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:if test="position() != last()">
      <xsl:text>, </xsl:text>
    </xsl:if>
  </xsl:template>
 
  <!-- escape-string: quotes and escapes -->
  <xsl:template name="escape-string">
    <xsl:param name="value" />
 
    <xsl:value-of select="$STRING_DELIM" />
 
    <xsl:if test="string-length($value) &gt; 0">
      <xsl:variable name="escaped-whacks">
        <!-- escape backslashes -->
        <xsl:call-template name="string-replace">
          <xsl:with-param name="value" select="$value" />
          <xsl:with-param name="find" select="'\'" />
          <xsl:with-param name="replace" select="'\\'" />
        </xsl:call-template>
      </xsl:variable>
 
      <xsl:variable name="escaped-LF">
        <!-- escape line feeds -->
        <xsl:call-template name="string-replace">
          <xsl:with-param name="value" select="$escaped-whacks" />
          <xsl:with-param name="find" select="'&#x0A;'" />
          <xsl:with-param name="replace" select="'\n'" />
        </xsl:call-template>
      </xsl:variable>
 
      <xsl:variable name="escaped-CR">
        <!-- escape carriage returns -->
        <xsl:call-template name="string-replace">
          <xsl:with-param name="value" select="$escaped-LF" />
          <xsl:with-param name="find" select="'&#x0D;'" />
          <xsl:with-param name="replace" select="'\r'" />
        </xsl:call-template>
      </xsl:variable>
 
      <xsl:variable name="escaped-tabs">
        <!-- escape tabs -->
        <xsl:call-template name="string-replace">
          <xsl:with-param name="value" select="$escaped-CR" />
          <xsl:with-param name="find" select="'&#x09;'" />
          <xsl:with-param name="replace" select="'\t'" />
        </xsl:call-template>
      </xsl:variable>
 
      <!-- escape quotes -->
      <xsl:call-template name="string-replace">
        <xsl:with-param name="value" select="$escaped-tabs" />
        <xsl:with-param name="find" select="'&quot;'" />
        <xsl:with-param name="replace" select="'\&quot;'" />
      </xsl:call-template>
    </xsl:if>

    <xsl:value-of select="$STRING_DELIM" />
  </xsl:template>
 
  <!-- string-replace: replaces occurances of one string with another -->
  <xsl:template name="string-replace">
    <xsl:param name="value" />
    <xsl:param name="find" />
    <xsl:param name="replace" />
 
    <xsl:choose>
      <xsl:when test="contains($value,$find)">
        <!-- replace and call recursively on next -->
        <xsl:value-of select="substring-before($value,$find)" disable-output-escaping="yes" />
        <xsl:value-of select="$replace" disable-output-escaping="yes" />
        <xsl:call-template name="string-replace">
          <xsl:with-param name="value" select="substring-after($value,$find)" />
          <xsl:with-param name="find" select="$find" />
          <xsl:with-param name="replace" select="$replace" />
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <!-- no replacement necessary -->
        <xsl:value-of select="$value" disable-output-escaping="yes" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
  </XSL>