BEGIN;

INSERT INTO junkGtrOrgs(
	orgUuid
)
SELECT
	orgUuid
FROM
	gtrOrgs
WHERE name ~* '^unknown*|^unlisted*'
ON CONFLICT DO NOTHING;

INSERT INTO duplicateGtrOrgs(
	orgUuid,
	duplicateUuid
)
SELECT
	LEAST(o1.orgUuid, o2.orgUuid) AS orgUuid,
	GREATEST(o1.orgUuid, o2.orgUuid) AS duplicateUuid
FROM
	similarGtrOrgs s
	INNER JOIN gtrOrgs o1
		ON s.orgUuid1 = o1.orgUuid
	INNER JOIN gtrOrgs o2
		ON s.orgUuid2 = o2.orgUuid
WHERE
		simTrigramName >= 0.9
	AND COALESCE(manualResult, TRUE)
	OR  (simTrigramName >= 0.5
		AND o1.postCode IS NOT NULL
		AND strip(o1.postcode) = strip(o2.postcode))
	-- Check that the first rec isn't already marked as a duplicate
	AND NOT EXISTS(SELECT *
		FROM duplicateGtrOrgs
		WHERE duplicateUuid IN (o1.orgUuid, o2.orgUuid))
	AND NOT EXISTS(SELECT *
		FROM junkGtrOrgs
		WHERE orgUuid IN (o1.orgUuid, o2.orgUuid))
GROUP BY
	LEAST(   o1.orgUuid, o2.orgUuid),
	GREATEST(o1.orgUuid, o2.orgUuid)
ON CONFLICT (duplicateUuid) DO NOTHING;

INSERT INTO orgs(
	gtrOrgUuid,
	name,
	address1,
	address2,
	address3,
	address4,
	address5,
	postCode,
	city,
	region,
	country
)
SELECT
DISTINCT ON (orgUuid)
	LEAST(o.orgUuid, d.orgUuid, d.duplicateUuid) AS orgUuid,
	MERGE(name)                                  AS name,
	MERGE(address1)                              AS address1,
	MERGE(address2)                              AS address2,
	MERGE(address3)                              AS address3,
	MERGE(address4)                              AS address4,
	MERGE(address5)                              AS address5,
	MERGE(postCode)                              AS postCode,
	MERGE(city)                                  AS city,
	COALESCE(MERGE(NULLIF(region, 'Unknown')),
		'Unknown')                               AS region,
	MERGE(country)                               AS country
FROM
	gtrOrgs o
	LEFT OUTER JOIN duplicateGtrOrgs d
		ON o.orgUuid IN (d.orgUuid, d.duplicateUuid)
WHERE
	NOT EXISTS(SELECT *
		FROM junkGtrOrgs
		WHERE orgUuid IN (o.orgUuid, d.orgUuid, d.duplicateUuid))
GROUP BY
	LEAST(o.orgUuid, d.orgUuid, d.duplicateUuid)
ON CONFLICT (gtrOrgUuid) DO UPDATE SET
	name     = excluded.name,
	address1 = excluded.address1,
	address2 = excluded.address2,
	address3 = excluded.address3,
	address4 = excluded.address4,
	address5 = excluded.address5,
	postCode = excluded.postCode,
	city     = excluded.city,
	region   = excluded.region,
	country  = excluded.country;

COMMIT;
