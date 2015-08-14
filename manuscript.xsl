<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:t="http://www.tei-c.org/ns/1.0" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:z="http://www.zotero.org/namespaces/export#" xmlns:dc="http://purl.org/dc/elements/1.1/"
	xmlns:foaf="http://xmlns.com/foaf/0.1/" xmlns:bib="http://purl.org/net/biblio#"
	xmlns:dcterms="http://purl.org/dc/terms/" xmlns:vcard="http://nwalsh.com/rdf/vCard#"
	xmlns:prism="http://prismstandard.org/namespaces/1.2/basic/" version="2.0">
	<xsl:template name="manuscriptnote">
		<bib:Manuscript>
			<xsl:attribute name="rdf:about">
				<xsl:value-of select="@xml:id"/>
			</xsl:attribute>
			
			<z:itemType>
				<xsl:text>manuscript</xsl:text>
			</z:itemType>
			<dc:title>
				<xsl:value-of select="normalize-space(t:title[@level = 'u'])"/>
			</dc:title>
			<bib:authors>
				<rdf:Seq>
					<rdf:li>
						<!--authors-->
						<xsl:for-each select="t:author">
							<foaf:Person>
								<foaf:surname>
									<xsl:value-of select="normalize-space(t:name[@type = 'surname'])"/>
								</foaf:surname>
								<foaf:givenname>
									<xsl:value-of select="substring-after(normalize-space(.), ', ')"/>
								</foaf:givenname>
							</foaf:Person>
						</xsl:for-each>
					</rdf:li>
				</rdf:Seq>
			</bib:authors>
			<!--tags-->
			<dc:subject>
				<xsl:value-of select="@xml:id"/>
			</dc:subject>
			<xsl:if test="t:note">
				<bib:Memo>
					<rdf:value>
						<xsl:value-of select="normalize-space(replace(t:note, ':', ''))"/>
					</rdf:value>
				</bib:Memo>
			</xsl:if>
		</bib:Manuscript>
	</xsl:template>
</xsl:stylesheet>