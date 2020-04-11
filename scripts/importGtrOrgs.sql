-- Run with
-- $ psql -U <username> -d <database> -f importGtrOrgs.sql
-- Ensure the organisations.xml file exists in the PostgreSQL data directory
DO $$
DECLARE
	file text = 'organisations.xml';
	xmlRecords xml;
	org record;
	nss text[][2] := array[
		array['api', 'http://gtr.rcuk.ac.uk/gtr/api'],
		array['org', 'http://gtr.rcuk.ac.uk/gtr/api/organisation']
	];
BEGIN

xmlRecords := XMLPARSE(
	DOCUMENT convert_from(pg_read_binary_file(file), 'UTF8'));

DROP TABLE IF EXISTS xmlImport;
CREATE TEMP TABLE xmlImport AS
SELECT 
	(xpath('//@api:id', x, nss))[1]::text AS uuid,
	(xpath('//@api:created', x, nss))[1]::text::date AS recorded,
	(xpath('//org:name/text()', x, nss))[1]::text AS name,
	(xpath('//org:addresses[1]/api:address/api:line1/text()',    x, nss))[1]::text AS line1,
	(xpath('//org:addresses[1]/api:address/api:line2/text()',    x, nss))[1]::text AS line2,
	(xpath('//org:addresses[1]/api:address/api:line3/text()',    x, nss))[1]::text AS line3,
	(xpath('//org:addresses[1]/api:address/api:line4/text()',    x, nss))[1]::text AS line4,
	(xpath('//org:addresses[1]/api:address/api:line5/text()',    x, nss))[1]::text AS line5,
	(xpath('//org:addresses[1]/api:address/api:postCode/text()', x, nss))[1]::text AS postCode,
	(xpath('//org:addresses[1]/api:address/api:city/text()',     x, nss))[1]::text AS city,
	(xpath('//org:addresses[1]/api:address/api:region/text()',   x, nss))[1]::text AS region,
	(xpath('//org:addresses[1]/api:address/api:country/text()',  x, nss))[1]::text AS country
FROM unnest(xpath('//org:organisations/org:organisation', xmlRecords, nss)) x;

FOR org IN
	SELECT * FROM xmlImport
LOOP
	INSERT INTO gtrOrgs VALUES(
		uuid(org.uuid),
		replace(org.name, '&amp;', '&'),
		org.line1,
		org.line2,
		org.line3,
		org.line4,
		org.line5,
		org.postCode,
		org.city,
		COALESCE(gtrRegion(org.region), gtrRegion('Unknown')),
		org.country,
		org.recorded
	) ON CONFLICT DO UPDATE SET
		recorded = org.recorded;
END LOOP;

END$$;

DROP TABLE IF EXISTS xmlImport;
