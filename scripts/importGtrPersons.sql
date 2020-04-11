-- Run with
-- $ psql -U <username> -d <database> -f importGtrPersons.sql
-- Ensure the persons.xml file exists in the PostgreSQL data directory
DO $$
DECLARE
	file text := 'persons.xml';
	xmlRecords xml;
	per record;
	link record;
	nss text[][2] := array[
		array['api', 'http://gtr.rcuk.ac.uk/gtr/api'],
		array['per', 'http://gtr.rcuk.ac.uk/gtr/api/person']
	];
BEGIN

xmlRecords := XMLPARSE(
	DOCUMENT convert_from(pg_read_binary_file(file), 'UTF8'));

DROP TABLE IF EXISTS xmlImport;
CREATE TEMP TABLE xmlImport AS
SELECT 
	(xpath('//@api:id', x, nss))[1]::text::uuid AS uuid,
	(xpath('//per:firstName/text()', x, nss))[1]::text AS firstName,
	(xpath('//per:otherNames/text()', x, nss))[1]::text AS otherNames,
	(xpath('//per:surname/text()', x, nss))[1]::text AS surname,
	(xpath('//per:email/text()', x, nss))[1]::text AS email,
	(xpath('//per:orcidId/text()', x, nss))[1]::text AS orcId,
	(xpath('//api:links/api:link[@api:rel="EMPLOYED"]/@api:href', x, nss))[1]::text AS employerLinks,
	(xpath('//api:links', x, nss))[1] AS links
FROM unnest(xpath('//per:persons/per:person', xmlRecords, nss)) x;

FOR per IN
	SELECT * FROM xmlImport
LOOP
	INSERT INTO gtrPeople VALUES(
		per.uuid,
		per.firstName,
		per.otherNames,
		per.surname,
		per.email,
		per.orcId
	) ON CONFLICT (personUuid) DO UPDATE SET
		firstName  = per.firstName,
		otherNames = per.otherNames,
		surname    = per.surname,
		email      = per.email,
		orcId      = per.orcId;

	IF per.employerLinks IS NOT NULL THEN
		INSERT INTO gtrOrgPeople VALUES(
			per.uuid,
			-- Extract organisation UUID from HREF
			substring(per.employerLinks, '/organisations/(.*)$')::uuid
		) ON CONFLICT DO NOTHING;
	END IF;

	FOR link IN
		SELECT
			(xpath('//@api:rel', x, nss))[1]::text AS rel,
			(xpath('//@api:href', x, nss))[1]::text AS href
		FROM unnest(xpath('//api:link', per.links, nss)) x
	LOOP
		IF EXISTS (SELECT projectUuid FROM gtrProjects WHERE
			projectUuid = substring(link.href, '/projects/(.*)$')::uuid)
		THEN
			INSERT INTO gtrProjectPeople VALUES(
				substring(link.href, '/projects/(.*)$')::uuid,
				per.uuid,
				(CASE
					WHEN link.rel = 'PI_PER'           THEN 'Principal Investigator'
					WHEN link.rel = 'COI_PER'          THEN 'Co-Investigator'
					WHEN link.rel = 'PM_PER'           THEN 'Project Manager'
					WHEN link.rel = 'FELLOW_PER'       THEN 'Fellow'
					WHEN link.rel = 'TGH_PER'          THEN 'Training Grant Holder'
					WHEN link.rel = 'SUPER_PER'        THEN 'Primary Supervisor'
					WHEN link.rel = 'RESERACH_COI_PER' THEN 'Researcher Co-Investigator'
					WHEN link.rel = 'RESERACH_PER'     THEN 'Researcher'
					ELSE link.rel::gtrPersonRole
				END)::gtrPersonRole
			) ON CONFLICT DO NOTHING;
		END IF;
	END LOOP;
END LOOP;

END$$;

