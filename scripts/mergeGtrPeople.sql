BEGIN;

INSERT INTO duplicateGtrPeople(
	personUuid,
	duplicateUuid
)
SELECT
	s.personUuid1 AS personUuid,
	s.personUuid2 AS duplicateUuid
FROM
	similarGtrPeople s
	INNER JOIN gtrOrgPeople op1
		ON s.personUuid1 = op1.personUuid
	INNER JOIN gtrOrgPeople op2
		ON  s.personUuid2 = op2.personUuid
	LEFT OUTER JOIN duplicateGtrOrgs d1
		ON d1.duplicateUuid = op1.orgUuid
	LEFT OUTER JOIN duplicateGtrOrgs d2
		ON d2.duplicateUuid = op2.orgUuid
WHERE
		COALESCE(d1.orgUuid, op1.orgUuid) = COALESCE(d2.orgUuid, op2.orgUuid)
	AND simTrigram >= 0.9
	AND COALESCE(s.manualResult, TRUE)
	-- Check that the first rec isn't already marked as a duplicate
	AND NOT EXISTS(SELECT *
		FROM duplicateGtrPeople
		WHERE duplicateUuid = s.personUuid1)
	AND NOT EXISTS(SELECT *
		FROM duplicateGtrPeople
		WHERE duplicateUuid = s.personUuid2)
ON CONFLICT (duplicateUuid) DO NOTHING;

INSERT INTO people(
	gtrPersonUuid,
	firstName,
	surname,
	otherNames
)
SELECT
DISTINCT ON (personUuid)
	p1.personUuid                          AS personUuid,
	COALESCE(p1.firstName,  p2.firstName)  AS firstName,
	COALESCE(p1.surname,    p2.surname)    AS surname,
	COALESCE(p1.otherNames, p2.otherNames) AS otherNames
FROM
	gtrPeople p1
	LEFT OUTER JOIN duplicateGtrPeople s
		USING (personUuid)
	LEFT OUTER JOIN gtrPeople p2
		ON p2.personUuid = s.duplicateUuid
ON CONFLICT (gtrPersonUuid) DO UPDATE SET
	firstName  = excluded.firstName,
	surname    = excluded.surname,
	otherNames = excluded.otherNames;

COMMIT;
