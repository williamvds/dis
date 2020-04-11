-- Pairs of orgs who collabed, how much first was offered
SELECT
	o1.orgUuid, o1.name, o2.orgUuid, o2.name, projectUuid, offer
FROM
	gtrProjectOrgs po
	NATURAL JOIN gtrOrgs o1
	INNER JOIN gtrOrgs o2
		ON  o1.orgUuid <> o2.orgUuid
		AND EXISTS (
			SELECT o2.orgUuid FROM gtrProjectOrgs
			WHERE orgUuid = o2.orgUuid
			AND   projectUuid = po.projectUuid)
ORDER BY offer DESC
LIMIT 10;

\copy (SELECT
	orgUuid as id,
	name as label,
	COUNT(SELECT * FROM gtrOrgPeople WHERE orgUuid = id) AS employees,
	SUM(SELECT cost FROM gtrProjectOrgs WHERE orgUuid = id) AS costs
FROM
	gtrOrgPeople)
TO /tmp/orgs.csv (FORMAT CSV, HEADER)

\copy (SELECT
	po1.orgUuid AS source,
	po2.orgUuid AS target,
	COUNT(*) AS weight,
	SUM(po1.cost  + po2.cost)::numeric::int AS costs,
	SUM(po1.offer + po2.cost)::numeric::int AS offers
FROM
	gtrProjectOrgs po1
	INNER JOIN gtrProjectOrgs po2
		ON  po1.orgUuid <> po2.orgUuid
		AND po1.projectUuid = po2.projectUuid
GROUP BY po1.orgUuid, po2.orgUuid)
TO /tmp/orgsLinks.csv (FORMAT CSV, HEADER);

\copy (SELECT
	rp.projectUuid1 AS source,
	rp.projectUuid2 AS target,
	COUNT(SELECT * WHERE EXISTS ) AS weight,
	SUM(po1.cost  + po2.cost)::numeric::int AS costs,
	SUM(po1.offer + po2.cost)::numeric::int AS offers
FROM
	gtrRelatedProjects rp
	INNER JOIN gtrProjectOrgs po1
		ON po1.projectUuid = rp.projectUuid1
	INNER JOIN gtrProjectOrgs po2
		ON po2.projectUuid = rp.projectUuid2
GROUP BY rp.projectUuid1, rp.projectUuid2)
TO /tmp/orgs.csv (FORMAT CSV, HEADER);

SELECT
	po1.projectUuid AS project,
	po1.orgUuid AS source,
	po2.orgUuid AS target,
	po1.cost,
	po1.offer
FROM
	gtrProjectOrgs po1
	INNER JOIN gtrProjectOrgs po2
		ON  po1.orgUuid     <> po2.orgUuid
		AND po1.projectUuid =  po2.projectUuid
WHERE po1.offer IS NOT NULL
ORDER BY po1.offer DESC;

\copy (SELECT
	po1.projectUuid AS project_id,
	p.title AS project_title,
	po1.orgUuid AS source_id,
	o1.name AS source_name,
	po2.orgUuid AS target_id,
	o2.name AS target_name,
	po1.cost::numeric,
	po1.offer::numeric,
	p.startdate AS start_date,
	p.endDate AS end_date
FROM
(gtrProjectOrgs po1 NATURAL JOIN gtrOrgs o1)
INNER JOIN (gtrProjectOrgs po2 NATURAL JOIN gtrOrgs o2)
	ON  po1.orgUuid < po2.orgUuid
	AND po1.projectUuid = po2.projectUuid
INNER JOIN gtrProjects p
	ON p.projectUuid = po1.projectUuid
WHERE po1.offer is not null
ORDER BY po1.offer DESC) TO /tmp/orgProjectLinks.csv (FORMAT CSV, HEADER);

-- Number of pairs of orgs collabing on same project that are in the same region:
SELECT COUNT(*) FROM gtrprojectorgs po1
INNER JOIN gtrProjectOrgs po2 ON po1.projectUuid = po2.projectUuid INNER JOIN gtrOrgs o1
ON po1.orgUuid = o1.orgUuid
INNER JOIN gtrOrgs o2
ON po2.orgUuid = o2.orgUuid
WHERE
o1.region = o2.region;

-- Most popular regions
SELECT o1.region, COUNT(o1.region) FROM gtrprojectorgs po1
INNER JOIN gtrProjectOrgs po2 ON po1.projectUuid = po2.projectUuid INNER JOIN gtrOrgs o1
ON po1.orgUuid = o1.orgUuid
INNER JOIN gtrOrgs o2
ON po2.orgUuid = o2.orgUuid
WHERE
o1.region = o2.region;

-- Pairs of collaborators that have previously collaborated
SELECT
	*
FROM
	(gtrProjectOrgs po1 NATURAL JOIN gtrOrgs o1)
	INNER JOIN (gtrProjectOrgs po2 NATURAL JOIN gtrOrgs o2)
	ON  po1.orgUuid <> po2.orgUuid
	AND po1.projectUuid = po2.projectUuid
WHERE EXISTS(
	SELECT * FROM po1
	WHERE
		po1.projectUuid <> po2.projectUuid
	AND po1.orgUuid = o2.orgUuid)
AND EXISTS(
	SELECT * FROM po2
	WHERE
		po2.projectUuid <> po1.projectUuid
	AND po2.orgUuid = o1.orgUuid);

-- Top fundees
SELECT
	SUM(sum)::numeric
FROM (
	SELECT
		name, SUM(offer)
	FROM
		gtrProjectOrgs po
		NATURAL JOIN gtrOrgs o
	WHERE offer IS NOT NULL
	GROUP BY o.orgUuid, o.name
	ORDER BY sum DESC
	LIMIT 100
) q;

-- Top researchers
SELECT
	SUM(count)::numeric
FROM (
	SELECT
		name, COUNT(*)
	FROM
		gtrProjectOrgs po
		NATURAL JOIN gtrOrgs o
	GROUP BY o.orgUuid, o.name
	ORDER BY count DESC
	LIMIT 100
) q;

-- Pairs of project orgs with duplicate elimination

\copy (SELECT
		/* Project */
		p.projectUuid AS project_id,
		p.title AS project_title,
		p.startDate AS project_start,
		p.endDate AS project_end,
		/* Link */
		po.cost::numeric AS cost,
		po.offer::numeric AS offer,
		/* Organisation */
		o.gtrOrgUuid AS org_id,
		o.name AS org_name,
		o.region AS org_region,
		po.role AS org_role
	FROM
		gtrProjectOrgs po
		NATURAL JOIN gtrProjects p
			ON p.projectUuid = po.projectUuid
		LEFT OUTER JOIN duplicateGtrOrgs d
			ON d.duplicateUuid = po.orgUuid
		INNER JOIN orgs o
			ON o.gtrOrgUuid = COALESCE(d.orgUuid, po.orgUuid)
	WHERE
		po.offer IS NOT NULL
	)
TO /tmp/projectOrgs.csv (FORMAT CSV, HEADER)
