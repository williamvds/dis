DO $$
DECLARE
	rec record;
	namePattern text := '^unknown*|^unlisted*';
BEGIN
	FOR rec IN
		SELECT
			orgUuid
		FROM
			gtrOrgs o
		WHERE
				name ~* namePattern
	LOOP
		INSERT INTO junkGtrOrgs VALUES (
			rec.orgUuid
		) ON CONFLICT DO NOTHING;
	END LOOP;
END $$; -- BEGIN
