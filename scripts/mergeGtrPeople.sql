BEGIN;

INSERT INTO duplicateGtrPeople(
	personUuid,
	duplicateUuid
)
SELECT
	LEAST(s.personUuid1, s.personUuid2) AS personUuid,
	GREATEST(s.personUuid1, s.personUuid2) AS duplicateUuid
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
		WHERE duplicateUuid IN (s.personUuid1, s.personUuid2))
GROUP BY
	LEAST(   s.personUuid1, s.personUuid2),
	GREATEST(s.personUuid1, s.personUuid2)
ON CONFLICT (duplicateUuid) DO NOTHING;

INSERT INTO people(
	gtrPersonUuid,
	firstName,
	surname,
	otherNames
)
SELECT
	LEAST(p1.personUuid, d.personUuid, d.duplicateUuid) AS personUuid,
	MERGE(firstName)                                    AS firstName,
	MERGE(surname)                                      AS surname,
	MERGE(otherNames)                                   AS otherNames
FROM
	gtrPeople p1
	LEFT OUTER JOIN duplicateGtrPeople d
		ON p1.personUuid IN (d.personUuid, d.duplicateUuid)
GROUP BY
	LEAST(p1.personUuid, d.personUuid, d.duplicateUuid)
ON CONFLICT (gtrPersonUuid) DO UPDATE SET
	firstName  = excluded.firstName,
	surname    = excluded.surname,
	otherNames = excluded.otherNames;

COMMIT;
