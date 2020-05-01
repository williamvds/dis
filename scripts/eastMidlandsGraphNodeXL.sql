DROP TABLE IF EXISTS edges;
CREATE TEMP TABLE edges AS
SELECT
	o1.gtrOrgUuid AS source,
	o1.name AS sourceName,
	o1.region AS sourceRegion,
	o1.city AS sourceCity,
	o1.country AS sourceCountry,
	o1.type AS sourceType,
	po1.role AS sourceRole,
	po1.offer::numeric::int AS offer,
	po1.cost::numeric::int AS cost,

	o2.gtrOrgUuid AS target,
	o2.name AS targetName,
	o2.region AS targetRegion,
	o2.city AS targetCity,
	o2.country AS targetCountry,
	o2.type AS targetType,

	p.projectUuid AS projectUuid,
	p.startDate AS startDate,
	p.endDate AS endDate
FROM
	-- First organisation
	orgs o1
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
	INNER JOIN orgs o2
		ON o2.gtrOrgUuid IN (d2.orgUuid, po2.orgUuid)

	-- Shared project
	INNER JOIN gtrProjects p
		ON p.projectUuid = po1.projectUuid
WHERE
	p.startDate >= '1/1/2010'
	AND (p.endDate IS NULL
	OR p.endDate > '1/1/2015')
	AND o1.region = 'East Midlands'
	AND o2.region = 'East Midlands';

\copy (SELECT * FROM edges) TO data/eastMidlandsGraphNodeXL.csv (FORMAT CSV, HEADER)
