CREATE TEMP TABLE IF NOT EXISTS nodes AS
SELECT
	gtrOrgUuid AS id,
	name AS label,
	*
FROM
	orgs o
WHERE
	CONCAT(
		name, ' ',
		address1, ' ',
		address2, ' ',
		address3, ' ',
		address4) ~* '\ynottingham(shire)?\y'
	OR region = 'East Midlands'
	OR postcode ~* '^ng';

\copy (SELECT * FROM nodes) TO data/eastMidlandsGraphGephiNodes.csv (FORMAT CSV, HEADER)

CREATE TEMP TABLE IF NOT EXISTS orgsMidlandsEdges AS
SELECT
	po1.projectUuid AS projectUuid,
	o1.gtrOrgUuid AS source,
	GREATEST(po1.offer::numeric::int, po1.cost::numeric::int, 1) AS weight,
	 AS cost,

	o2.gtrOrgUuid AS target,
	p.title AS label,
	p.startDate AS startDate,
	p.endDate AS endDate
FROM
	-- First organisation
	nodes o1
	LEFT OUTER JOIN duplicateGtrOrgs d1
		ON d1.orgUuid = o1.gtrOrgUuid
	INNER JOIN gtrProjectOrgs po1
		ON po1.orgUuid IN (o1.gtrOrgUuid, d1.duplicateUuid)

	-- Second organisation
	INNER JOIN gtrProjectOrgs po2
		ON po2.orgUuid NOT IN (o1.gtrOrgUuid, d1.duplicateUuid)
		AND po2.projectUuid = po1.projectUuid
	LEFT OUTER JOIN duplicateGtrOrgs d2
		ON po2.orgUuid IN (d2.orgUuid, d2.duplicateUuid)
	INNER JOIN nodes o2
		ON o2.gtrOrgUuid IN (d2.orgUuid, po2.orgUuid)

	-- Shared project
	INNER JOIN gtrProjects p
		ON p.projectUuid = po1.projectUuid;

\copy (SELECT * FROM edges) TO data/eastMidlandsGraphGephiEdges.csv (FORMAT CSV, HEADER)
