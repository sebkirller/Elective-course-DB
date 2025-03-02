USE Partikkels_F2018;
GO
-- create table with one column of type of XML. 
CREATE TABLE UTMNew(
 Id int IDENTITY(1,1) PRIMARY KEY,
 UTMXml xml, 
);
GO
--Drop Table UTMNew;
-- insert XML data to data base

INSERT INTO UTMNew(UTMXml)
SELECT * FROM OPENROWSET(BULK 'C:\Users\SebastianR�nnovPeter\Desktop\DB mandatory 2\Data\UTM.xml', SINGLE_BLOB) AS x;

-- Select all data
SELECT * FROM UTMNew;

 -- Reads the XML text provided as input, parses the text by using the MSXML parser (Msxmlsql.dll), 
 -- and provides the parsed document in a state ready for consumption. 
 -- This parsed document is a tree representation of the various nodes in 
 -- the XML document: elements, attributes, text, comments, and so on.

 DECLARE @x xml
SELECT @x=UTMXml FROM UTMNew
DECLARE @hdoc int -- keep the reference to handler
EXEC sp_xml_preparedocument @hdoc OUTPUT, @x -- system extended stored procedure

SELECT * INTO UTM_Table FROM OPENXML (@hdoc, '/DocumentElement/Data', 2)
WITH(
     GeometriId int,
     UTMX int,
     UTMY int,
     UTMZone int
     )

EXEC sp_xml_removedocument @hdoc

SELECT COUNT(*) FROM UTM_Table;