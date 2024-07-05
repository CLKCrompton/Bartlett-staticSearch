<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:crm="http://www.cidoc-crm.org/cidoc-crm/"
    xmlns:html="http://www.w3.org/1999/xhtml"
    exclude-result-prefixes="xs"
    version="2.0">
    <xsl:output method="xml" encoding="UTF-16" indent="yes"/>
        
    <xsl:template match="root">
        <html lang="en" xml:lang="en" id="lettersmap">   
            <title>Column of the <xsl:value-of select="row-0/persName[1]/local-name(.)"/></title>
                <xsl:apply-templates select="descendant::persName"/>
            
            <title>Column of the <xsl:value-of select="row-0/field[1]/local-name(.)"/></title>
                <xsl:apply-templates select="descendant::field"/>

            <title>Column of the <xsl:value-of select="row-0/gender[1]/local-name(.)"/></title>
            <title>Column of the <xsl:value-of select="row-0/birthYear[1]/local-name(.)"/></title>
            <title>Column of the <xsl:value-of select="row-0/birthPlace[1]/local-name(.)"/></title>
            <title>Column of the <xsl:value-of select="row-0/firstAppearance[1]/local-name(.)"/></title>
            <title>Column of the <xsl:value-of select="row-0/QID[1]/local-name(.)"/></title>
            <title>Column of the <xsl:value-of select="row-0/birthDate[1]/local-name(.)"/></title>
            <title>Column of the <xsl:value-of select="row-0/VIAF[1]/local-name(.)"/></title>
            <title>Column of the <xsl:value-of select="row-0/deathDate[1]/local-name(.)"/></title>
            <title>Column of the <xsl:value-of select="row-0/surname[1]/local-name(.)"/></title>
            <title>Column of the <xsl:value-of select="row-0/forename[1]/local-name(.)"/></title>
            <title>Column of the <xsl:value-of select="row-0/addName[1]/local-name(.)"/></title>
            <title>Column of the <xsl:value-of select="row-0/graphic[1]/local-name(.)"/></title>
            
        </html>        
    </xsl:template> 
   
  
    <xsl:template match="persName">
        <xsl:element name="{'meta'}">
            <xsl:value-of select="."/>
        </xsl:element>
    </xsl:template> 
    
    <xsl:template match="field">
        <xsl:for-each select="tokenize(replace(replace(.,', and ', ','),' and ',','),',')">   
            <xsl:element name="{'meta'}">
                <xsl:value-of select="normalize-space(.)"/>
            </xsl:element>
        </xsl:for-each>
    </xsl:template> 
    
</xsl:stylesheet>