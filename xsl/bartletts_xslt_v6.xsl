<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:html="http://www.w3.org/1999/xhtml"
    xmlns:map="http://www.w3.org/2005/xpath-functions/map"
    exclude-result-prefixes="xs"
    version="3.0">
    <xsl:output method="html" encoding="UTF-8" indent="yes"/>
    
    <!-- XPATH query 
        
        //row[gender[text()='Female'] and firstAppearance[text()='10']]
    
    -->
    
    <!-- THINGS TO DO
        
        Add Column R to meta tags   
        Fix PBs
        Split up: 1 file / person
    
    -->
    
    <!--Core Template-->
        
    <xsl:template match="root">
            <html lang="en" xml:lang="en">   
                <head>
                    <xsl:comment>Problems are listed under comments in the XSLT transformation.</xsl:comment>
                    
                    <title>Record for <xsl:value-of select="row[1]/persName/local-name(.)"/></title>
                    <!-- Change XPATH for the name of the person in splitted XSLT -->
                    
                        <xsl:apply-templates select="descendant::persName"/>
                         <xsl:apply-templates select="descendant::affiliation"/>
                         <xsl:apply-templates select="descendant::gender"/>
                        <xsl:apply-templates select="descendant::occupation"/>
                        <xsl:apply-templates select="descendant::primaryOccupation"/>
                        <xsl:apply-templates select="descendant::firstAppearance"/>                    
                        <xsl:apply-templates select="descendant::birthDate"/>
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
        <xsl:element name="{'meta'}" use-attribute-sets="persName classFeat content_A"/> 
    </xsl:template>
    
    <xsl:template match="affiliation"> 
        <!-- PB: Fix the duplicates situation: In process -->
        <xsl:for-each select="tokenize(replace(replace(.,', and ', ','),' and ',','),',')">   
            <xsl:element name="{'meta'}" use-attribute-sets="field classDesc content_B"/>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="gender[text()]"> 
        <!-- Tip: text() here should be: no blank nodes are output-->
        <!-- PB: Empty elements are outputing as empty nodes if no [text()] -->
            <xsl:for-each select=".[not(.=preceding::text())]">
                <xsl:element name="{'meta'}" use-attribute-sets="gender classDesc content_C"/>
            </xsl:for-each>
    </xsl:template>       
    
    <xsl:template match="occupation">
        <xsl:for-each select="tokenize(replace(normalize-space(replace(replace(., ', and ', ','), ' and ', ',')), ',\s+', ','), ',')">
            <!-- Replaces ", and" and "and" with "," then removes spaces with REGEX ",\s+" then splits(tokenize) on commas.-->
             <xsl:element name="{'meta'}" use-attribute-sets="occupation classFeat content_P"/> 
        </xsl:for-each>
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
            <!-- Check after HTML SPLIT if it outputs the name properly -->
            
            <!-- Define the tokens variable used in <body>-->
            
            <!-- Extract first and last places of birth in the human readable version -->            
            <xsl:variable name="tokens" select="tokenize(../birthPlace, ',\s*')" />
            
            <!-- Replace ordinal value from Edition's number with human readable version -->
            <xsl:variable name="firstAppearanceInput" select="../firstAppearance" as="xs:integer" />
            <xsl:variable name="firstAppearanceMap" as="map(xs:integer, xs:string)">
                <xsl:map>
                    <xsl:map-entry key="1" select="'the first'" />
                    <xsl:map-entry key="2" select="'the second'" />
                    <xsl:map-entry key="3" select="'the third'" />
                    <xsl:map-entry key="4" select="'the fourth'" />
                    <xsl:map-entry key="5" select="'the fifth'" />
                    <xsl:map-entry key="6" select="'the sixth'" />
                    <xsl:map-entry key="7" select="'the seventh'" />
                    <xsl:map-entry key="8" select="'the eighth'" />
                    <xsl:map-entry key="9" select="'the ninth'" />
                    <xsl:map-entry key="10" select="'the tenth'" />
                </xsl:map>
            </xsl:variable>
            
            <!-- Text displayed -->
            
            <p>Born in <xsl:value-of select="../birthYear"/> in <xsl:value-of select="concat($tokens[1], ', ', $tokens[last()])" />, <xsl:value-of select="."/> was most famous in the fields of <xsl:value-of select="../affiliation"/>. <xsl:value-of select="."/> had a number of occupations, including <xsl:value-of select="../occupation"/>. The first instance of a quotation from <xsl:value-of select="."/> shows up in the <xsl:choose>
                               <xsl:when test="map:contains($firstAppearanceMap, $firstAppearanceInput)">
                               <!-- Checks whether a key in the $firstAppearanceMap matches the content inside $firstAppearanceInput with the same xs:type.-->
                                    <xsl:value-of select="$firstAppearanceMap($firstAppearanceInput)" />
                                   <!-- And here we're asking: select the value from the map $firstAppearanceMap where the key matches the value of $firstAppearanceInput. -->
                               </xsl:when>
                             </xsl:choose> edition of Bartlett’s Familiar Quotations. Find out more about this person in <xsl:element name="{'a'}" use-attribute-sets="href">Wikidata.</xsl:element>
            </p>
            <xsl:element name="{'img'}" use-attribute-sets="src alt"/>
        </xsl:for-each>
    </xsl:template>
    
    <!--Attribute-Sets for <head>-->
    
            <!-- Names -->
    
    <xsl:attribute-set name="persName">
        <xsl:attribute name="name">name</xsl:attribute>
    </xsl:attribute-set>
    
    <xsl:attribute-set name="field">
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