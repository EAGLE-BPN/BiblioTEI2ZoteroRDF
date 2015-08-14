<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:t="http://www.tei-c.org/ns/1.0" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:z="http://www.zotero.org/namespaces/export#" xmlns:dc="http://purl.org/dc/elements/1.1/"
	xmlns:foaf="http://xmlns.com/foaf/0.1/" xmlns:bib="http://purl.org/net/biblio#"
	xmlns:dcterms="http://purl.org/dc/terms/" xmlns:vcard="http://nwalsh.com/rdf/vCard#"
	xmlns:prism="http://prismstandard.org/namespaces/1.2/basic/" version="2.0">
	<xsl:template name="bookpart">
		<bib:bookSection>
			<!--id in zotero ?? attributed by the system?-->
			<xsl:attribute name="rdf:about">
				<xsl:value-of select="@xml:id"/>
			</xsl:attribute>

			<z:itemType>
				<xsl:text>bookSection</xsl:text>
			</z:itemType>

			<!--series-->

			<xsl:if test="t:title[@level = 's']">
				<dcterms:isPartOf>
					<bib:Series>
						<dc:title>
							<xsl:value-of select="normalize-space(t:title[@level = 's'][1])"/>
							<!--check!-->
						</dc:title>
						<dc:identifier>
							<xsl:value-of
								select="normalize-space(t:title[@level = 's'][1]/following-sibling::t:biblScope[@unit = 'issue'][1])"
							/>
						</dc:identifier>
					</bib:Series>
				</dcterms:isPartOf>
			</xsl:if>
			<xsl:if test="t:title[@level = 's'][2]">
				<dcterms:isPartOf>
					<bib:Series>
						<dc:title>
							<xsl:value-of select="normalize-space(t:title[@level = 's'][2])"/>
							<!--check!-->
						</dc:title>
						<dc:identifier>
							<xsl:value-of
								select="normalize-space(t:title[@level = 's'][2]/following-sibling::t:biblScope[@unit = 'issue'])"/>
						</dc:identifier>
					</bib:Series>
				</dcterms:isPartOf>
			</xsl:if>
			<!--publisher-->
			<dc:publisher>
				<foaf:Organization>
					<vcard:adr>
						<vcard:Address>
							<!--place of publication-->
							<vcard:locality>
								<xsl:value-of select="normalize-space(t:pubPlace[1])"/>
								<!-- check!-->
							</vcard:locality>
						</vcard:Address>
					</vcard:adr>
					<!--publisher name-->
					<foaf:name>
						<xsl:value-of select="normalize-space(t:publisher)"/>
					</foaf:name>
				</foaf:Organization>
			</dc:publisher>
			<bib:authors>
				<rdf:Seq>
					
						<!--authors-->
						<xsl:for-each select="t:author">
							<rdf:li><foaf:Person>
								<!--stupid process, assumes the format is always "M. Rossi" -->
								<foaf:surname>
									<xsl:value-of select="normalize-space(t:name[@type = 'surname'])"/>
								</foaf:surname>
								<foaf:givenname>
									<xsl:value-of select="substring-after(normalize-space(.), ', ')"/>
								</foaf:givenname>
							</foaf:Person></rdf:li>
						</xsl:for-each>
					
				</rdf:Seq>
			</bib:authors>
			<!--editors-->

			<bib:editors>
				<rdf:Seq>
					<xsl:for-each select="t:editor">
					<rdf:li><foaf:Person>
							<foaf:surname>
								<xsl:value-of select="normalize-space(t:name[@type = 'surname'])"/>
							</foaf:surname>
							<foaf:givenname>
								
								<xsl:choose>
									<xsl:when test="contains(., ', ')">
										<xsl:value-of
											select="replace(substring-after(normalize-space(.), ', '), '\(eds.\)', '')"
										/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of
											select="replace(substring-before(normalize-space(.), ' '), '\(eds.\)', '')"
										/>
									</xsl:otherwise>
								</xsl:choose>
							</foaf:givenname>
						</foaf:Person>
					</rdf:li>
					</xsl:for-each>
				</rdf:Seq>
			</bib:editors>

			<xsl:if test="t:title[@level = 'm']">
				<dcterms:isPartOf>
					<bib:Book>
						<dc:title>
							<xsl:value-of select="normalize-space(t:title[@level = 'm'])"/>
						</dc:title>
					</bib:Book>
				</dcterms:isPartOf>
			</xsl:if>
			<!--tags-->
			<dc:subject>
				<xsl:value-of select="@xml:id"/>
			</dc:subject>
			<!--title-->
			<dc:title>
					<xsl:value-of select="normalize-space(t:title[@level = 'a'][1])"/>
			</dc:title>
			<xsl:if test="t:title[@level = 'a'][2]">
				<dc:title>
						<xsl:value-of select="normalize-space(t:title[@level = 'a'][2])"/>
				</dc:title>
			</xsl:if>
			<!--journaltitle-->
			<xsl:if test="t:title[@level = 'j']">
				<dcterms:isPartOf>
					<bib:Journal>
						<dc:title>
							<xsl:value-of select="normalize-space(replace(t:title[@level = 'j'], '\(\w+\)', ''))"/>
						</dc:title>
						<prism:volume>
							<xsl:value-of
								select="normalize-space(t:title[@level = 'j']/following-sibling::t:biblScope[@unit = 'issue'][1])"/>
							<!--check-->
						</prism:volume>
					</bib:Journal>
				</dcterms:isPartOf>
				<xsl:analyze-string select="normalize-space(t:title[@level = 'j'])" regex="\((\w+)\)">
					<xsl:matching-substring>
						<z:shortTitle>
							<xsl:value-of select="regex-group(1)"/>
						</z:shortTitle>
					</xsl:matching-substring>
				</xsl:analyze-string>
			</xsl:if>

			<!--date-->
			<xsl:for-each select="t:date">
				<dc:date>
					<xsl:value-of select="normalize-space(.)"/>
				</dc:date>
			</xsl:for-each>
			<!--pages-->
			<bib:pages>
				<xsl:value-of select="normalize-space(t:biblScope[@unit = 'pp'][1])"/>
				<!--in one case in IGCyr biblio there are two page ranges, the contribution pointed at is in fact a part of an article-->
			</bib:pages>
			<!--number of volumes-->
			<xsl:if test="contains(., 'vols.')">
				<z:numberOfVolumes>
					<xsl:analyze-string select="." regex="\s(\d+)\s(vols\.)">
						<xsl:matching-substring>
							<xsl:value-of select="regex-group(1)"/>
						</xsl:matching-substring>
					</xsl:analyze-string>
				</z:numberOfVolumes>
			</xsl:if>
			<!--notes-->
			<xsl:if test="t:note">
				<bib:Memo>
					<rdf:value>
						<xsl:value-of select="normalize-space(replace(t:note, ':', ''))"/>
					</rdf:value>
				</bib:Memo>
			</xsl:if>
		</bib:bookSection>
	</xsl:template>


</xsl:stylesheet>
