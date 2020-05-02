DO $$
DECLARE
	rec record;
BEGIN
	SET pg_trgm.similarity_threshold = 0.5;

	INSERT INTO similarGtrPeople(
		personUuid1,
		personUuid2,
		simTrigram)
	SELECT
		uuid1,
		uuid2,
		GREATEST((simFirst + simSur) / 2, (simFirst + simSur + simOther) / 3)
	FROM (SELECT
			p1.personUuid                            AS uuid1,
			p2.personUuid                            AS uuid2,
			similarity(p1.firstName,  p2.firstName)  AS simFirst,
			similarity(p1.surname,    p2.surname)    AS simSur,
			similarity(p1.otherNames, p2.otherNames) AS simOther
		FROM gtrPeople p1 
		INNER JOIN gtrPeople p2 
			ON  p1.personUuid <  p2.personUuid
			AND p1.firstName  %  p2.firstName
			AND p1.surname    %  p2.surname
	) q
	ON CONFLICT (personUuid1, personUuid2) DO UPDATE SET
		simTrigram = excluded.simTrigram;
END $$; -- BEGIN
