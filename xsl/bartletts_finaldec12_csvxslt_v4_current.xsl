<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:html="http://www.w3.org/1999/xhtml"
    exclude-result-prefixes="xs"
    version="3.0">
    <xsl:output method="html" encoding="UTF-8" indent="yes"/>
    
    <!--Core Template-->
        
    <xsl:template match="root">
        
            <html lang="en" xml:lang="en" id="lettersmap">   
                <head>
                    <xsl:comment>Problems are listed under comments in the XSLT transformation.</xsl:comment>
                    <!-- PB: Something about the output is unclear, 
                        for now, everything is sorted by category within different
                        <title>s for human readability-->
                    <title>Column of the <xsl:value-of select="row[1]/persName/local-name(.)"/></title>
                        <xsl:apply-templates select="descendant::persName"/>
                
                     <title>Column of the <xsl:value-of select="row[1]/affiliation/local-name(.)"/></title>
                         <xsl:apply-templates select="descendant::affiliation"/>
         
                     <title>Column of the <xsl:value-of select="row[1]/gender/local-name(.)"/></title>
                         <xsl:apply-templates select="descendant::gender"/>
                     
                     <title>Column of the <xsl:value-of select="row[1]/birthPlace/local-name(.)"/></title>
                         <xsl:apply-templates select="descendant::birthPlace"/>
                    
                    <title>Column of the <xsl:value-of select="row[1]/occupation/local-name(.)"/></title>
                        <xsl:apply-templates select="descendant::occupation"/>
                    
                    <title>Column of the <xsl:value-of select="row[1]/primaryOccupation/local-name(.)"/></title>
                        <xsl:apply-templates select="descendant::primaryOccupation"/>
                     
                     <title>Column of the <xsl:value-of select="row[1]/firstAppearance/local-name(.)"/></title>
                        <xsl:apply-templates select="descendant::firstAppearance"/>
                    
                     <title>Column of the <xsl:value-of select="row[1]/birthDate/local-name(.)"/></title>
                        <xsl:apply-templates select="descendant::birthDate"/>
                    
                     <title>Column of the <xsl:value-of select="row[1]/deathDate/local-name(.)"/></title>
                        <xsl:apply-templates select="descendant::deathDate"/>
                       
                     <link rel="stylesheet" type="text/css" href="../css/style.css"/>
                </head>
                <body>
                    <ul id="header"> <!-- we'll need a menu here -->
                        <li>
                            <a href="toc.html"></a>
                        </li>
                        <li>
                            <a href=""></a>
                        </li>
                        <li class="right">
                            <a href="search.html"></a>
                        </li>
                    </ul>
                    <xsl:apply-templates select="row"/>
                </body>
            </html>
    </xsl:template>
    
    <!--Calling <head>-->
    
    <xsl:template match="persName"> 
        <!-- PB: Do we want the names somewhere? -->
        <xsl:element name="{'meta'}" use-attribute-sets="persName content_A"/> 
    </xsl:template>
    
    <xsl:template match="affiliation"> 
        <!-- PB: Fix the duplicates situation: In process -->
        <xsl:for-each select="tokenize(replace(replace(.,', and ', ','),' and ',','),',')">   
            <xsl:element name="{'meta'}" use-attribute-sets="name classDesc content_B"/>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="gender[text()]"> 
        <!-- Tip: text() here should be: no blank nodes are output-->
        <!-- PB: Empty elements are outputing as empty nodes if no [text()] -->
            <xsl:for-each select=".[not(.=preceding::text())]">
                <xsl:element name="{'meta'}" use-attribute-sets="gender classDesc content_C"/>
            </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="birthPlace[text()]"> 
        <!-- PB: is it really birthPlace? HTML template is not clear-->
        <!-- PB: Make this a literal string all together cleared of commas and ands-->
        <xsl:element name="{'meta'}" use-attribute-sets="birthPlace classFeat content_E"/> 
    </xsl:template>
    
    <xsl:template match="occupation">
        <!-- PB: Once <affiliation> duplicates are sorted, solution might apply here -->
        <xsl:element name="{'meta'}" use-attribute-sets="occupation classFeat content_P"/> 
    </xsl:template>
    
    <xsl:template match="primaryOccupation[text()]">
        <xsl:element name="{'meta'}" use-attribute-sets="occupationPrimary classDesc content_Q"/>
    </xsl:template>
    
    <xsl:template match="firstAppearance">
        <xsl:element name="{'meta'}" use-attribute-sets="firstAppearance classDesc content_F"/> 
    </xsl:template>
    
    <xsl:template match="birthDate[text()]">
        <xsl:element name="{'meta'}" use-attribute-sets="birthDate classDate content_H"/> 
    </xsl:template>
    
    <xsl:template match="deathDate[text()]">
        <xsl:element name="{'meta'}" use-attribute-sets="deathDate classDate content_K"/> 
    </xsl:template>
    
    <!-- Calling <body>-->
    
    <xsl:template match="row">
        <xsl:for-each select="persName">
            <h1>Record for <xsl:value-of select="."/></h1>
            
            <p>Born in <xsl:value-of select="../birthYear"/> in <xsl:value-of select="../birthPlace"/><xsl:comment>item-1-and2-from-commma-separated-cell-content(firstitem-adnlast-e.ge-towns-and-city)</xsl:comment> in <xsl:value-of select="../birthDate"/> <xsl:comment>cast-as-human-readable-date</xsl:comment>, <xsl:value-of select="."/> was most famous in the fields of <xsl:value-of select="../affiliation"/>. <xsl:value-of select="."/> had a number of occupations, including <xsl:value-of select="../occupation"/>. A quotation from <xsl:value-of select="."/> first shows up in the <xsl:value-of select="../firstAppearance"/><xsl:comment>cast-as-human-readable(e.g. first, fifth, twelfth)</xsl:comment> edition of Bartlett’s familiar quotations. Find out more about this person in <xsl:element name="{'a'}" use-attribute-sets="href">Wikidata.</xsl:element></p>
            <xsl:element name="{'img'}" use-attribute-sets="src alt"/>
        </xsl:for-each>        
    </xsl:template>
    
    <!--Attribute-Sets for <head>-->
    
            <!-- Names -->
    
    <xsl:attribute-set name="persName">
        <xsl:attribute name="name">persName</xsl:attribute>
    </xsl:attribute-set>
    
    <xsl:attribute-set name="name">
        <xsl:attribute name="name">field</xsl:attribute>
    </xsl:attribute-set>
    
    <xsl:attribute-set name="gender">
        <xsl:attribute name="name">gender</xsl:attribute>
    </xsl:attribute-set>
    
    <xsl:attribute-set name="birthPlace">
        <xsl:attribute name="name">birthPlace</xsl:attribute>
    </xsl:attribute-set>
    
    <xsl:attribute-set name="occupation">
        <xsl:attribute name="name">occupation</xsl:attribute>
    </xsl:attribute-set>
    
    <xsl:attribute-set name="occupationPrimary">
        <xsl:attribute name="name">occupationPrimary</xsl:attribute>
    </xsl:attribute-set>
    
    <xsl:attribute-set name="firstAppearance">
        <xsl:attribute name="name">firstAppearance</xsl:attribute>
    </xsl:attribute-set>
    
    <xsl:attribute-set name="birthDate">
        <xsl:attribute name="name">birthDate</xsl:attribute>
    </xsl:attribute-set>
    
    <xsl:attribute-set name="deathDate">
        <xsl:attribute name="name">deathDate</xsl:attribute>
    </xsl:attribute-set>
    
            <!-- Classes -->
    
    <xsl:attribute-set name="classDesc">
        <xsl:attribute name="class">staticSearch_desc</xsl:attribute>
    </xsl:attribute-set>
    
    <xsl:attribute-set name="classFeat">
        <xsl:attribute name="class">staticSearch_feat</xsl:attribute>
    </xsl:attribute-set>
    
    <xsl:attribute-set name="classDate">
        <xsl:attribute name="class">staticSearch_date</xsl:attribute>
    </xsl:attribute-set>
    
            <!-- Contents as placeholders for now -->
    
    <xsl:attribute-set name="content_A">
        <xsl:attribute name="content">
            <xsl:value-of select="."/>
        </xsl:attribute>
    </xsl:attribute-set>
    
    <xsl:attribute-set name="content_B">
        <xsl:attribute name="content">
            <xsl:value-of select="normalize-space(.)"/>
        </xsl:attribute>
    </xsl:attribute-set>
    
    <xsl:attribute-set name="content_C">
        <xsl:attribute name="content">
            <xsl:value-of select="."/>
        </xsl:attribute>
    </xsl:attribute-set>
    
    <xsl:attribute-set name="content_E">
        <xsl:attribute name="content">
            <xsl:value-of select="."/>
        </xsl:attribute>
    </xsl:attribute-set>
    
    <xsl:attribute-set name="content_F">
        <xsl:attribute name="content">
            <xsl:value-of select="."/>
        </xsl:attribute>
    </xsl:attribute-set>
    
    <xsl:attribute-set name="content_H">
        <xsl:attribute name="content">
            <xsl:value-of select="."/>
        </xsl:attribute>
    </xsl:attribute-set>
    
    <xsl:attribute-set name="content_K">
        <xsl:attribute name="content">
            <xsl:value-of select="."/></xsl:attribute>
    </xsl:attribute-set>
    
    <xsl:attribute-set name="content_P">
        <xsl:attribute name="content">
            <xsl:value-of select="."/>
        </xsl:attribute>
    </xsl:attribute-set>
    
    <xsl:attribute-set name="content_Q">
        <xsl:attribute name="content">
            <xsl:value-of select="."/>
        </xsl:attribute>
    </xsl:attribute-set>
    
    <!-- Attribute-sets for <body> -->
    
        <!-- Wikidata Links -->
    
    <xsl:attribute-set name="href">
        <xsl:attribute name="href">
            <xsl:value-of select="concat('https://www.wikidata.org/wiki/Special:EntityData/',../QID)"/>
        </xsl:attribute>
    </xsl:attribute-set>
    
        <!-- Image Links -->
    
    <xsl:attribute-set name="src">
        <xsl:attribute name="src">
            <xsl:value-of select="../graphic"/>
            <!-- PB: Links to images are broken, see Teams-->
            <!-- PB: Outputs blank node if empty-->
        </xsl:attribute>
    </xsl:attribute-set>
    
    <xsl:attribute-set name="alt">
        <xsl:attribute name="alt">image</xsl:attribute>
    </xsl:attribute-set>
</xsl:stylesheet>