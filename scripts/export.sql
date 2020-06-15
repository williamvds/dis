DROP TABLE IF EXISTS dedupedOrgProjects;
CREATE TEMP TABLE IF NOT EXISTS dedupedOrgProjects AS
SELECT
	COALESCE(d.orgUuid, o.orgUuid) AS orgUuid,
	po.projectUuid,
	po.role,
	po.startDate,
	po.endDate,
	po.cost::numeric::int,
	po.offer::numeric::int
FROM
	gtrOrgs o
	LEFT OUTER JOIN duplicateGtrOrgs d
		ON d.duplicateUuid = o.orgUuid
	INNER JOIN gtrProjectOrgs po
		ON po.orgUuid = o.orgUuid;

\copy (SELECT * FROM orgs) to data/orgs.csv (FORMAT CSV, HEADER)
\copy (SELECT * FROM gtrProjects) to data/projects.csv (FORMAT CSV, HEADER)
\copy (SELECT * FROM dedupedOrgProjects) to data/orgProjectsLinks.csv (FORMAT CSV, HEADER)
