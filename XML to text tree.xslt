<?xml version="1.0" encoding="UTF-8" ?>
<xsl:transform version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"  xmlns:gml="http://www.opengis.net/gml/3.2" xmlns:xlink="http://www.w3.org/1999/xlink">
    
    <xsl:mode use-accumulators="#all"/>
    
    <xsl:output method="text"/>
    
    <xsl:accumulator name="indentLevel" as="xs:string" initial-value="string('')">
        <xsl:accumulator-rule match="node()[count(./child::*) > 0]" phase="start" select="concat($value,string('  '))"/>
        <xsl:accumulator-rule match="node()[count(./child::*) > 0]" phase="end" select="substring($value, 1, string-length($value)-2)"/>
    </xsl:accumulator>
    
    <xsl:template match="/*[node()]">
      <xsl:apply-templates select="." mode="detect"/>
    </xsl:template>
    
    
    
    <xsl:template match="*" mode="detect">
    <xsl:variable name="myIndentLevel" select="accumulator-after('indentLevel')"/>
        <xsl:choose>
            <xsl:when test="count(./child::*) > 0">
                <xsl:text xml:space="preserve">
</xsl:text>
                <xsl:value-of select="$myIndentLevel"/>
                <xsl:value-of select="replace(name(),'aixm:','')"/>
                <xsl:apply-templates select="." mode="obj-content" />
            </xsl:when>
            <xsl:when test="count(./child::*) = 0">
                <xsl:text xml:space="preserve">
</xsl:text>
                <xsl:value-of select="$myIndentLevel"/>
                <xsl:value-of select="replace(name(),'aixm:','')"/>
                <xsl:text xml:space="preserve"> = </xsl:text>
                <xsl:choose>
                    <xsl:when test="name()='gml:posList'">
                        <xsl:apply-templates select="normalize-space(text())"/>                        
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates select="."/>
                    </xsl:otherwise>
                </xsl:choose> 
                <xsl:apply-templates select="@*" mode="attr" />
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="*" mode="obj-content">
        <xsl:apply-templates select="@*" mode="attr" />
        <xsl:apply-templates select="./*" mode="detect" />
    </xsl:template>
    
    <xsl:template match="@*" mode="attr">
        <xsl:if test="name()='uom' or name()='xlink:href'">
        <xsl:text xml:space="preserve"> </xsl:text><xsl:value-of select="."/>
        </xsl:if>
    </xsl:template>
        
</xsl:transform>
