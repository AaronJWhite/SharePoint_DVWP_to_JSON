<Xsl>
  <xsl:stylesheet xmlns:x="http://www.w3.org/2001/XMLSchema" xmlns:d="http://schemas.microsoft.com/sharepoint/dsp" version="1.0" exclude-result-prefixes="xsl msxsl ddwrt" xmlns:ddwrt="http://schemas.microsoft.com/WebParts/v2/DataView/runtime" xmlns:asp="http://schemas.microsoft.com/ASPNET/20" xmlns:__designer="http://schemas.microsoft.com/WebParts/v2/DataView/designer" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:SharePoint="Microsoft.SharePoint.WebControls" xmlns:ddwrt2="urn:frontpage:internal">
    <xsl:output method="html" indent="no"/>
    <xsl:decimal-format NaN=""/>
            <xsl:param name="dvt_apos">&apos;</xsl:param>
            <xsl:param name="ManualRefresh"></xsl:param>
            <xsl:param name="ListID">{185BFF41-D19A-4B77-AD3D-9ED96ED8C12E}</xsl:param>
    <xsl:param name="PageName" />
    <xsl:param name="upper">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:param>
    <xsl:param name="lower">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:param>
            <xsl:variable name="dvt_1_automode">0</xsl:variable>
            
            <xsl:template match="/" xmlns:x="http://www.w3.org/2001/XMLSchema" xmlns:d="http://schemas.microsoft.com/sharepoint/dsp" xmlns:asp="http://schemas.microsoft.com/ASPNET/20" xmlns:__designer="http://schemas.microsoft.com/WebParts/v2/DataView/designer" xmlns:SharePoint="Microsoft.SharePoint.WebControls">
            <ul id="mainNav">
                <xsl:call-template name="dvt_1"/>
            </ul>
            <span class="sa-clear"></span>
          </xsl:template>
            
            <xsl:template name="dvt_1">
              <xsl:variable name="dvt_StyleName">Table</xsl:variable>
              <xsl:variable name="Rows" select="/dsQueryResponse/Rows/Row"/>
              <xsl:variable name="dvt_RowCount" select="count($Rows)"/>
              <xsl:variable name="RowLimit" select="6" />
              <xsl:variable name="IsEmpty" select="$dvt_RowCount = 0 or $RowLimit = 0" />
                          
              <xsl:call-template name="dvt_1.body">
              <xsl:with-param name="Rows" select="$Rows"/>
              <xsl:with-param name="FirstRow" select="1" />
              <xsl:with-param name="LastRow" select="$dvt_RowCount" />
            </xsl:call-template>
                          
            </xsl:template>
            <xsl:template name="dvt_1.body">
              <xsl:param name="Rows"/>
              <xsl:param name="FirstRow" />
              <xsl:param name="LastRow" />
              <xsl:for-each select="$Rows">
                <xsl:variable name="dvt_KeepItemsTogether" select="false()" />
                <xsl:variable name="dvt_HideGroupDetail" select="false()" />
                <xsl:if test="(position() &gt;= $FirstRow and position() &lt;= $LastRow) or $dvt_KeepItemsTogether">
                  <xsl:if test="not($dvt_HideGroupDetail)" ddwrt:cf_ignore="1">
                    <xsl:call-template name="dvt_1.rowview">
                      <xsl:with-param name="LastRow" select="$LastRow" />
                    </xsl:call-template>
                  </xsl:if>
                </xsl:if>
              </xsl:for-each>
    </xsl:template>
    <xsl:template name="dvt_1.rowview">
      <xsl:param name="LastRow" />
    <xsl:variable name="lower">abcdefghijklmnopqrstuvwxyz</xsl:variable>
    <xsl:variable name="upper">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>
            
            <li>
              <a href="{@PageUrl}">
                <xsl:choose>
                <xsl:when test="position() = $LastRow and translate($PageName, $upper, $lower) != translate(@PageUrl, $upper, $lower)">
                  <xsl:attribute name="class">navButton navLast</xsl:attribute> 
                </xsl:when>
                <xsl:when test="position() = $LastRow and translate($PageName, $upper, $lower) = translate(@PageUrl, $upper, $lower)">
                  <xsl:attribute name="class">navButton navButtonSelect navLast </xsl:attribute> 
                </xsl:when>
                <xsl:when test="position() != $LastRow and translate($PageName, $upper, $lower) = translate(@PageUrl, $upper, $lower)">
                  <xsl:attribute name="class">navButton navButtonSelect</xsl:attribute> 
                </xsl:when>
                <xsl:when test="contains(translate($PageName, $upper, $lower), 'technicalresources.aspx') and contains(translate(@PageUrl, $upper, $lower), 'topics.aspx')">
                <!-- special case for techresource pages -->
                  <xsl:attribute name="class">navButton navButtonSelect</xsl:attribute> 
                </xsl:when>

                <xsl:otherwise>
                  <xsl:attribute name="class">navButton</xsl:attribute> 
                </xsl:otherwise>
                </xsl:choose>
              <xsl:value-of select="@Title"/>
              </a>
              <span class="sa-clearRight"></span>
            </li>
    </xsl:template>  
  </xsl:stylesheet>
</Xsl>