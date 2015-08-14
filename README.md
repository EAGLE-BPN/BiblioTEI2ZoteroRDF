# TEI bibliography to Zotero RDF
 You can export from Zotero in TEI, but you cannot upload directly a TEI bibliography to Zotero, unless you convert it to another format.
 
 This XSLT takes a TEI bibliography and turns it into Zotero RDF.
 
 It is very likely that each TEI bibliography contains some level of free text and peculiarities, so it is almost impossible that this works out of the box. 
 
 You can try though. 
 
 Simply run the tei2zoteroRDF.xsl on your bibliography in TEI and you will get as output an RDF bibliography.
 
 In the bibliography I have worked on there are only the following types, which are the ones supported:
 * Book
 * Edited book
 * Book section
 * publication in proceedings
 * Journal Article
 * unpublished manuscript
 
