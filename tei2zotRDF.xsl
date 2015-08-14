<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:t="http://www.tei-c.org/ns/1.0" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:z="http://www.zotero.org/namespaces/export#" xmlns:dc="http://purl.org/dc/elements/1.1/"
	xmlns:foaf="http://xmlns.com/foaf/0.1/" xmlns:bib="http://purl.org/net/biblio#"
	xmlns:dcterms="http://purl.org/dc/terms/" xmlns:vcard="http://nwalsh.com/rdf/vCard#"
	xmlns:prism="http://prismstandard.org/namespaces/1.2/basic/" version="2.0">


	<xsl:output method="xml" indent="yes"/>

	<!--namespaces-->
	<xsl:template match="/">
		<rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
			xmlns:z="http://www.zotero.org/namespaces/export#" xmlns:dc="http://purl.org/dc/elements/1.1/"
			xmlns:foaf="http://xmlns.com/foaf/0.1/" xmlns:bib="http://purl.org/net/biblio#"
			xmlns:prism="http://prismstandard.org/namespaces/1.2/basic/">
			<xsl:call-template name="teiHeader"/>
			<xsl:call-template name="item"/>
			<xsl:comment><xsl:text>File generated with tei2zotRDF, a xslt transformation which takes as input TEI P5 bibliography and returns Zotero RDF</xsl:text></xsl:comment>
		</rdf:RDF>
	</xsl:template>

	<!--header-->
	<xsl:template name="teiHeader">
		<xsl:comment>
			<xsl:value-of select="normalize-space(t:teiHeader)"/>
		</xsl:comment>
	</xsl:template>

	<!--bibliographic item-->
	<xsl:template name="item">
		<xsl:for-each select="//t:listBibl/t:bibl">

			<!--item type
better guess can be made?
-->
			<xsl:choose>
<!--if there a monographic title and not an editor, then it is a book. to distinguishi it from special issues of journals, which also have a monographic title, a normal book should not have pages.-->
				<xsl:when test="t:title[@level = 'm'] and not(t:editor) and not(t:biblScope[@unit='pp'])">
					<xsl:call-template name="book"/>
				</xsl:when>

<!--some edited volumes might be there in their own right. they might have editors instaed of authors-->
				<xsl:when test="t:title[@level = 'm'] and not(t:author) and not(t:biblScope[@unit='pp'])">
					<xsl:call-template name="editedbook"/>
				</xsl:when>

<!--if there is a monographic title and an editor, then there should be also an author and an analitic title, it is therefore a contribution into a book, a book part-->
				<xsl:when test="t:title[@level = 'a'] and t:title[@level = 'm'] and t:editor">
					<xsl:call-template name="bookpart"/>
				</xsl:when>
				
				<xsl:when test="t:title[@level = 'a'] and t:title[@level = 'm']">
					<xsl:comment>check item type below, very loose match!</xsl:comment>
					<xsl:call-template name="bookpart"/>
				</xsl:when>
<!--if there is a journal title and there is no editor, than is a contribution into a journal, cases in which a special number of a journal is dedicated to a monographic book with a series of contribution should fall in the previous selection. Journal articles have a and j titles. special issues might have also s titles  -->
				<xsl:when test="t:title[@level = 'j'] and not(t:editor)">
					<xsl:call-template name="article"/>
				</xsl:when>
<!--conference proceedings have an editor, contain usually the title of the conference and a monographic title-->
				
				<xsl:when test="t:title[@level = 'm'] and t:editor and contains(t:title[@level='m'], 'atti')">
					<xsl:call-template name="proceedings"/>
				</xsl:when>
<!--unpublished works-->
<xsl:when test="t:title[@level ='u']">
	<xsl:call-template name="manuscriptnote"/>
</xsl:when>
				<xsl:otherwise>

					<xsl:call-template name="book"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
	</xsl:template>

<xsl:include href="article.xsl"/>
<xsl:include href="bookpart.xsl"/>
<xsl:include href="proc.xsl"/>
	<xsl:include href="book.xsl"/>
	<xsl:include href="editedbook.xsl"/>
<xsl:include href="manuscript.xsl"/>

</xsl:stylesheet>
