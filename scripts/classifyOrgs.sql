BEGIN;

UPDATE orgs
SET type = 'Academic'
WHERE name ~* '\y(uni(versity|\.?)|college|academ(y|ic))\y';

WITH matches AS (
	SELECT
		COALESCE(d.orgUuid, o.orgUuid) AS orgUuid
	FROM
		gtrOrgs o
		LEFT OUTER JOIN duplicateGtrOrgs d
			ON o.orgUuid IN (d.orgUuid, d.duplicateUuid)
	WHERE
		name ~* '\yhospitals?\y'
)
UPDATE orgs o
SET type = 'Medical'
WHERE EXISTS(
	SELECT FROM matches m
	WHERE m.orgUuid = o.gtrOrgUuid
);

WITH matches AS (
	SELECT
		COALESCE(d.orgUuid, o.orgUuid) AS orgUuid
	FROM
		gtrOrgs o
		LEFT OUTER JOIN duplicateGtrOrgs d
			ON o.orgUuid IN (d.orgUuid, d.duplicateUuid)
	WHERE
		name ~* '\y((ltd|llc|plc|gmbh|inc|corp|co)\.?|limited|enterprises?|corporation|company)\y'
)
UPDATE orgs o
SET type = 'Private'
WHERE EXISTS(
	SELECT FROM matches m
	WHERE m.orgUuid = o.gtrOrgUuid
);

UPDATE orgs
SET type = 'Public'
WHERE name ~* '\y(government|governorate|council)\y';

COMMIT;
