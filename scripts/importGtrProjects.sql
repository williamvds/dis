-- Run with(xmlImport,(xmlImport,
-- $ psql -U <username> -d <database> -f importGtrProjects.sql
-- Ensure the projects.xml file exists in the PostgreSQL data directory

CREATE OR REPLACE
FUNCTION ParseOrgRole(txt text)
RETURNS gtrOrgRole AS $$
BEGIN
	RETURN (CASE
		-- Project participants
		WHEN txt = 'LEAD_PARTICIPANT' THEN 'Lead'
		WHEN txt = 'PARTICIPANT'      THEN 'Participant'
		-- Project links
		WHEN txt = 'LEAD_ORG'         THEN 'Lead'
		WHEN txt = 'COLLAB_ORG'       THEN 'Collaborating'
		WHEN txt = 'FELLOW_ORG'       THEN 'Fellow'
		WHEN txt = 'PP_ORG'           THEN 'Project Partner'
		WHEN txt = 'FUNDER'           THEN 'Funder'
		WHEN txt = 'COFUND_ORG'       THEN 'Co-Funder'
		WHEN txt = 'PARTICIPANT_ORG'  THEN 'Participant'
		WHEN txt = 'STUDENT_PP_ORG'   THEN 'Student Project Partner'
		ELSE txt
	END)::gtrOrgRole;
END; $$ -- FUNCTION
LANGUAGE plpgsql IMMUTABLE;

DO $$
DECLARE
	file text := 'projects.xml';
	xmlRecords xml;
	rec record;
	nss text[][2] := array[
		array['api', 'http://gtr.rcuk.ac.uk/gtr/api'],
		array['pro', 'http://gtr.rcuk.ac.uk/gtr/api/project']
	];
BEGIN

xmlRecords := XMLPARSE(
	DOCUMENT convert_from(pg_read_binary_file(file), 'UTF8'));

CREATE TEMP TABLE IF NOT EXISTS xmlImport AS
SELECT 
	(xpath('//@api:id', x, nss))[1]::text::uuid AS uuid,
	(xpath('//@api:created', x, nss))[1]::text::date AS recorded,
	(xpath('//pro:title/text()', x, nss))[1]::text AS title,
	(xpath('//pro:status/text()', x, nss))[1]::text AS status,
	(xpath('//pro:grantCategory/text()', x, nss))[1]::text AS category,
	(xpath('//pro:leadFunder/text()', x, nss))[1]::text AS funder,
	(xpath('//pro:abstract/text()', x, nss))[1]::text AS abstract,
	(xpath('//pro:techAbstract/text()', x, nss))[1]::text AS techAbstract,
	(xpath('//pro:potentialImpact/text()', x, nss))[1]::text AS potentialImpact,
	(xpath('//api:links/api:link[@api:rel="FUND"]/@api:start', x, nss))[1]::text::date AS startDate,
	(xpath('//api:links/api:link[@api:rel="FUND"]/@api:end', x, nss))[1]::text::date AS endDate,
	(xpath('//api:links', x, nss))[1] AS links,
	(xpath('//pro:participantValues', x, nss))[1] AS participants,
	(xpath('//pro:researchSubjects', x, nss))[1] AS subjects,
	(xpath('//pro:researchTopics', x, nss))[1] AS topics
FROM unnest(xpath('//pro:projects/pro:project', xmlRecords, nss)) x;

-- Projects

INSERT INTO gtrProjects
SELECT
	uuid,
	REPLACE(title, '&amp;', '&'),
	status::gtrProjectStatus,
	-- XML entities aren't parsed, so manually convert ampersands
	REPLACE(category, '&amp;', '&'),
	funder::gtrFunder,
	abstract,
	techAbstract,
	potentialImpact,
	startDate,
	endDate,
	recorded
FROM xmlImport
ON CONFLICT (projectUuid) DO NOTHING;

-- Project organisations

INSERT INTO gtrProjectOrgs(
	projectUuid,
	orgUuid,
	role,
	cost,
	offer
)
SELECT
	proUuid,
	(xpath('//pro:organisationId/text()', x, nss))[1]::text::uuid AS orgUuid,
	ParseOrgRole((xpath('//pro:role/text()', x, nss))[1]::text) AS role,
	(xpath('//pro:projectCost/text()', x, nss))[1]::text::numeric::money AS cost,
	(xpath('//pro:grantOffer/text()', x, nss))[1]::text::numeric::money AS offer
FROM (
	SELECT
		uuid AS proUuid,
		unnest(xpath('//pro:participant', participants, nss)) AS x
	FROM xmlImport
) q
ON CONFLICT DO NOTHING;

-- Subjects

FOR rec IN
	SELECT
		proUuid,
		(xpath('//pro:id/text()', x, nss))[1]::text::uuid AS subUuid,
		(xpath('//pro:text/text()', x, nss))[1]::text AS name,
		(xpath('//pro:percentage/text()', x, nss))[1]::text::numeric AS percent
	FROM (
		SELECT
			uuid AS proUuid,
			unnest(xpath('//pro:researchSubject', subjects, nss)) x
		FROM xmlImport
	) q
LOOP
	INSERT INTO gtrSubjects VALUES(
		rec.subUuid,
		rec.name
	) ON CONFLICT DO NOTHING;

	INSERT INTO gtrProjectSubjects VALUES(
		rec.subUuid,
		rec.proUuid,
		rec.percent
	) ON CONFLICT DO NOTHING;
END LOOP;

-- Topics

FOR rec IN
	SELECT
		proUuid,
		(xpath('//pro:id/text()', x, nss))[1]::text::uuid AS topUuid,
		(xpath('//pro:text/text()', x, nss))[1]::text AS name,
		(xpath('//pro:percentage/text()', x, nss))[1]::text::numeric AS percent
	FROM (
		SELECT
			uuid AS proUuid,
			unnest(xpath('//pro:researchTopic', topics, nss)) x
		FROM xmlImport
	) q
LOOP
	INSERT INTO gtrTopics VALUES(
		rec.topUuid,
		rec.name
	) ON CONFLICT DO NOTHING;

	INSERT INTO gtrProjectTopics VALUES(
		rec.topUuid,
		rec.proUuid,
		rec.percent
	) ON CONFLICT DO NOTHING;
END LOOP;

-- Links

FOR rec IN
	SELECT
		proUuid,
		(xpath('//@api:rel', x, nss))[1]::text AS rel,
		href,
		(xpath('//@api:start', x, nss))[1]::text::date AS startDate,
		(xpath('//@api:end', x, nss))[1]::text::date AS endDate,
		(SELECT orgUuid FROM gtrOrgs
			WHERE orgUuid = substring(href, '/organisations/(.*)$')::uuid
			LIMIT 1) AS orgUuid,
		(SELECT proUuid FROM gtrProjects
			WHERE projectUuid = substring(href, '/projects/(.*)$')::uuid
			LIMIT 1) AS proUuid2
	FROM (
		SELECT
			*,
			(xpath('//@api:href', x, nss))[1]::text AS href
		FROM (
			SELECT
				uuid AS proUuid,
				unnest(xpath('//api:link', links, nss)) x
			FROM xmlImport
		) q2
	) q
LOOP
	-- Linked organisations
	IF rec.orgUuid IS NOT NULL THEN
		INSERT INTO gtrProjectOrgs VALUES(
			rec.proUuid,
			rec.orgUuid,
			ParseOrgRole(rec.rel),
			rec.startDate,
			rec.endDate,
			NULL,
			NULL
		) ON CONFLICT DO NOTHING;

	-- Related projects
	ELSIF rec.proUuid2 IS NOT NULL THEN
		INSERT INTO gtrRelatedProjects VALUES(
			rec.proUuid,
			rec.proUuid2,
			rec.rel::gtrProjectRelation,
			rec.startDate,
			rec.endDate
		) ON CONFLICT DO NOTHING;
	END IF;
END LOOP;

END$$;
