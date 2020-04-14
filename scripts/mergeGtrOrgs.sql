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
	o1.orgUuid AS orgUuid,
	o2.orgUuid AS duplicateUuid
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
		WHERE duplicateUuid = o1.orgUuid)
	AND NOT EXISTS(SELECT *
		FROM duplicateGtrOrgs
		WHERE duplicateUuid = o2.orgUuid)
	AND NOT EXISTS(SELECT *
		FROM junkGtrOrgs
		WHERE orgUuid IN (o1.orgUuid, o2.orgUuid))
ORDER BY o1.recorded DESC
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
	o1.orgUuid                                          AS orgUuid,
	COALESCE(o1.name,                      o2.name)     AS name,
	COALESCE(o1.address1,                  o2.address1) AS address1,
	COALESCE(o1.address2,                  o2.address2) AS address2,
	COALESCE(o1.address3,                  o2.address3) AS address3,
	COALESCE(o1.address4,                  o2.address4) AS address4,
	COALESCE(o1.address5,                  o2.address5) AS address5,
	COALESCE(o1.postCode,                  o2.postCode) AS postCode,
	COALESCE(o1.city,                      o2.city)     AS city,
	COALESCE(NULLIF(o1.region, 'Unknown'), o2.region,
		'Unknown')                                      AS region,
	COALESCE(o1.country,                   o2.country)  AS country
FROM
	gtrOrgs o1
	LEFT OUTER JOIN duplicateGtrOrgs s
		USING (orgUuid)
	LEFT OUTER JOIN gtrOrgs o2
		ON s.duplicateUuid = o2.orgUuid
WHERE
	NOT EXISTS(SELECT *
		FROM junkGtrOrgs
		WHERE orgUuid = o1.orgUuid)
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
