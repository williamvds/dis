CREATE OR REPLACE FUNCTION REPLACE_MANY(txt text, replaces text[][2])
RETURNS text AS $$
DECLARE i int;
BEGIN
	FOR i IN 1 .. array_upper(replaces, 1) LOOP
		txt := REGEXP_REPLACE(txt, replaces[i][1], replaces[i][2], 'gi');
	END LOOP;
	RETURN txt;
END;
$$ LANGUAGE plpgsql IMMUTABLE;

DO $$
DECLARE
	name_replaces text[][] := array[
		array['\yltd(\.|\y)',  'Limited'],
		array['\ycorp(\.|\y)', 'Corporation'],
		array['\yco(\.|\y)',   'Company'],
		array['\yuni(\.|\y)',  'University'],
		array['&',             'and'],
		array['The',           '']
	];
BEGIN
	SET pg_trgm.similarity_threshold = 0.9;

	INSERT INTO similarGtrOrgs(
		orgUuid1,
		orgUuid2,
		simTrigramName,
		simTrigramAddress
	)
	SELECT
		uuid1,
		uuid2,
		similarity(name1, name2) AS simName,
		similarity(addr1, addr2) AS simAddress
	FROM
		(SELECT
			o1.orgUuid AS uuid1,
			o2.orgUuid AS uuid2,
			REPLACE_MANY(o1.name, name_replaces) AS name1,
			REPLACE_MANY(o2.name, name_replaces) AS name2,
			CONCAT(o1.address1, '\n',
				   o1.address2, '\n',
				   o1.address3, '\n',
				   o1.address3, '\n',
				   o1.address5, '\n',
				   o1.postCode, '\n',
				   o1.city) AS addr1,
			CONCAT(o2.address1, '\n',
				   o2.address2, '\n',
				   o2.address3, '\n',
				   o2.address3, '\n',
				   o2.address5, '\n',
				   o2.postCode, '\n',
				   o2.city) AS addr2
			FROM gtrOrgs o1
			JOIN gtrOrgs o2
				ON  o1.orgUuid < o2.orgUuid
				AND REPLACE_MANY(o1.name, name_replaces)
				  % REPLACE_MANY(o2.name, name_replaces)
			WHERE NOT EXISTS(
				SELECT
					*
				FROM
					junkGtrOrgs
				WHERE
					orgUuid IN (o1.orgUuid, o2.orgUuid)
			)
		) q
	ON CONFLICT (orgUuid1, orgUuid2) DO UPDATE SET (
		simTrigramName,
		simTrigramAddress
	) = (
		excluded.simTrigramName,
		excluded.simTrigramAddress
	);
END $$; -- BEGIN
