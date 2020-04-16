-- Perform and export statistical analyses on the dataset
-- Execute using:
-- $ psql -U <username> -d <database> -f setup.sql

-- Utility types
DO $$ BEGIN
	CREATE TYPE PercentileInt AS (
		percentile int,
		academic bigint,
		medical bigint,
		public bigint,
		private bigint,
		unknown bigint
	);
EXCEPTION
	WHEN duplicate_object THEN null;
END $$; -- BEGIN

-- Similarity distributions of organisations
CREATE OR REPLACE
FUNCTION OrgSimDist(
	lowerBound int default 50,
	step int default 2
)
RETURNS TABLE("lowerBound" int, "count" bigint) AS $$
DECLARE
BEGIN
	RETURN QUERY
	SELECT
		*,
		(SELECT
			COUNT(*)
		FROM similarGtrOrgs
		WHERE simTrigramName >= (q.bound::float/100))
	FROM (
		SELECT * FROM GENERATE_SERIES(lowerBound, 100, step) AS bound
	) q;
END; $$ -- FUNCTION
LANGUAGE plpgsql;

\copy (SELECT * FROM OrgSimDist()) TO data/orgSimDist.csv (FORMAT CSV, HEADER)

-- Similarity distributions of organisations with the same postcode
CREATE OR REPLACE
FUNCTION OrgSimDistPostcode(
	lowerBound int default 50,
	step int default 2
)
RETURNS TABLE("lowerBound" int, "count" bigint) AS $$
DECLARE
BEGIN
	RETURN QUERY
	SELECT
		*,
		(SELECT
			COUNT(*)
		FROM similarGtrOrgs s
			INNER JOIN gtrOrgs o1
				ON s.orgUuid1 = o1.orgUuid
			INNER JOIN gtrOrgs o2
				ON s.orgUuid2 = o2.orgUuid
		WHERE
				simTrigramName >= (q.bound::float/100)
			AND o1.postcode IS NOT NULL
			AND STRIP(o1.postcode) = STRIP(o2.postcode))
	FROM (
		SELECT * FROM generate_series(lowerBound, 100, step) AS bound
	) q;
END; $$ -- FUNCTION
LANGUAGE plpgsql;

\copy (SELECT * FROM OrgSimDistPostcode()) TO data/orgSimDistPostcode.csv (FORMAT CSV, HEADER)

CREATE OR REPLACE
FUNCTION ProjectFundingPercentiles(
	lowerBound int DEFAULT 1,
	upperBound int DEFAULT 99
)
RETURNS TABLE("percentile" int, "value" numeric) AS $$
DECLARE
	fractions numeric[] := PERCENTILE_FRACTIONS(lowerBound, upperBound);
BEGIN
	RETURN QUERY
	SELECT
		ROUND(fraction * 100)::int,
		ROUND(result::numeric, 2)
	FROM (
		SELECT
			unnest(fractions) AS fraction,
			unnest(
				(SELECT PERCENTILE_CONT(fractions) WITHIN GROUP (ORDER BY sum)
				FROM (
					SELECT
						SUM(COALESCE(offer::numeric, 0))
					FROM gtrProjectOrgs po
					WHERE offer > 0::money
					GROUP BY po.projectUuid
				) q)
			) AS result
	) q;
END; $$ -- FUNCTION
LANGUAGE plpgsql;

\copy (SELECT * FROM ProjectFundingPercentiles()) TO data/projectFundingPercentiles.csv (FORMAT CSV, HEADER)

-- Percentiles for total number of projects organisations are involved in
CREATE OR REPLACE
FUNCTION OrgProjectPercentiles(
	lowerBound int DEFAULT 1,
	upperBound int DEFAULT 99
)
RETURNS TABLE("percentile" int, "value" double precision) AS $$
DECLARE
	fractions numeric[] := PERCENTILE_FRACTIONS(lowerBound, upperBound);
BEGIN
	RETURN QUERY
	SELECT
		ROUND(fraction * 100)::int,
		result
	FROM (
		SELECT
			unnest(fractions) AS fraction,
			unnest(
				(SELECT PERCENTILE_CONT(fractions) WITHIN GROUP (ORDER BY count)
				FROM (
					SELECT
						COUNT(*)
					FROM gtrProjectOrgs po
					LEFT OUTER JOIN duplicateGtrOrgs d
						ON d.duplicateUuid = po.orgUuid
					GROUP BY COALESCE(d.orgUuid, po.orgUuid)
				) q)
			) AS result
	) q;
END; $$ -- FUNCTION
LANGUAGE plpgsql;

\copy (SELECT * FROM OrgProjectPercentiles()) TO data/orgProjectPercentiles.csv (FORMAT CSV, HEADER)

-- Organisations' percentiles in total projects involved in
CREATE TEMP TABLE IF NOT EXISTS orgProjectPercentiles AS
SELECT
	q.orgUuid,
	q.duplicateUuid,
	PERCENT_RANK() OVER (ORDER BY count) AS rank
FROM (
	SELECT
		COALESCE(d.orgUuid, po.orgUuid) AS orgUuid,
		po.orgUuid AS duplicateUuid,
		COUNT(*)
	FROM
		gtrProjectOrgs po
		LEFT OUTER JOIN duplicateGtrOrgs d
			ON d.duplicateUuid = po.orgUuid
	GROUP BY COALESCE(d.orgUuid, po.orgUuid), po.orgUuid
) q;

-- Percentile distributions for organisations, by number of projects involved
-- with
CREATE OR REPLACE
FUNCTION OrgProjectPercentileDist(
	lowerBound int DEFAULT 0,
	upperBound int DEFAULT 100
)
RETURNS TABLE("percentile" int, "value" bigint) AS $$
DECLARE
	fractions numeric[] := PERCENTILE_FRACTIONS(lowerBound, upperBound);
BEGIN
	RETURN QUERY
	SELECT
		ROUND(fractions.upperBound * 100)::int,
		(SELECT
			COUNT(*)
		FROM (
			SELECT
				COUNT(*)
			FROM
				orgProjectPercentiles
			WHERE
				rank <= fractions.upperBound
			GROUP BY orgUuid
		) q
		WHERE count > 0
		) AS result
	FROM unnest(fractions) AS fractions(upperBound);
END; $$ -- FUNCTION
LANGUAGE plpgsql;

\copy (SELECT * FROM OrgProjectPercentileDist()) TO data/orgProjectPercentileDist.csv (FORMAT CSV, HEADER)

-- Percentage of organisations who collaborated with at least one other
-- organisation within project count percentile ranges
CREATE OR REPLACE
FUNCTION OrgProjectPercentileCollab(
	lowerBound int DEFAULT 0,
	upperBound int DEFAULT 100
)
RETURNS TABLE("percentile" int, "value" bigint) AS $$
DECLARE
	fractions numeric[] := PERCENTILE_FRACTIONS(lowerBound, upperBound);
BEGIN
	CREATE TEMP TABLE IF NOT EXISTS pairedOrgProjects AS
	SELECT
		COALESCE(d1.orgUuid, o1.orgUuid) AS orgUuid1,
		o2.orgUuid AS orgUuid2,
		rank
	FROM
		-- First organisation
		gtrOrgs o1
		LEFT OUTER JOIN duplicateGtrOrgs d1
			ON d1.duplicateUuid = o1.orgUuid
		-- Second organisation
		INNER JOIN orgProjectPercentiles o2
			ON o2.orgUuid <> o1.orgUuid
		-- Projects both organisations are involved in
		INNER JOIN gtrProjectOrgs po1
			ON po1.orgUuid IN (d1.orgUuid, o1.orgUuid)
		INNER JOIN gtrProjectOrgs po2
			ON  po2.projectUuid = po1.projectUuid
			AND po2.orgUuid = o2.orgUuid;

	RETURN QUERY
	SELECT
		ROUND(fractions.upperBound * 100)::int,
		(SELECT
			COUNT(*)
		FROM (
			SELECT
				COUNT(*)
			FROM
				pairedOrgProjects
			WHERE
				rank <= fractions.upperBound
			GROUP BY orgUuid1
		) q
		WHERE count > 0
		) AS result
	FROM unnest(fractions) AS fractions(upperBound);
END; $$ -- FUNCTION
LANGUAGE plpgsql;

\copy (SELECT * FROM OrgProjectPercentileCollab()) TO data/orgProjectPercentileCollab.csv (FORMAT CSV, HEADER)

-- Percentiles for funding received by organisations
CREATE OR REPLACE
FUNCTION OrgFundingPercentiles(
	lowerBound int DEFAULT 1,
	upperBound int DEFAULT 99
)
RETURNS TABLE("percentile" int, "value" numeric) AS $$
DECLARE
	fractions numeric[] := PERCENTILE_FRACTIONS(lowerBound, upperBound);
BEGIN
	RETURN QUERY
	SELECT
		ROUND(fraction * 100)::int,
		ROUND(result::numeric, 2)
	FROM (
		SELECT
			unnest(fractions) AS fraction,
			unnest(
				(SELECT PERCENTILE_CONT(fractions) WITHIN GROUP (ORDER BY sum)
				FROM (
					SELECT
						SUM(COALESCE(offer::numeric, 0))
					FROM gtrProjectOrgs po
					LEFT OUTER JOIN duplicateGtrOrgs d
						ON d.duplicateUuid = po.orgUuid
					WHERE offer > 0::money
					GROUP BY COALESCE(d.orgUuid, po.orgUuid)
				) q)
			) AS result
	) q;
END; $$ -- FUNCTION
LANGUAGE plpgsql;

\copy (SELECT * FROM OrgFundingPercentiles()) TO data/orgFundingPercentiles.csv (FORMAT CSV, HEADER)

-- Organisations' percentiles in total funding received
CREATE TEMP TABLE IF NOT EXISTS orgFundingPercentiles AS
SELECT
	q.orgUuid,
	q.duplicateUuid,
	PERCENT_RANK() OVER (ORDER BY sum) AS rank
FROM (
	SELECT
		COALESCE(d.orgUuid, po.orgUuid) AS orgUuid,
		po.orgUuid AS duplicateUuid,
		SUM(COALESCE(offer::numeric, 0))
	FROM
		gtrProjectOrgs po
		LEFT OUTER JOIN duplicateGtrOrgs d
			ON d.duplicateUuid = po.orgUuid
	WHERE offer > 0::money
	GROUP BY COALESCE(d.orgUuid, po.orgUuid), po.orgUuid
) q;

-- Number of organisations who collaborated with at least one other
-- organisation within funding percentile ranges
CREATE OR REPLACE
FUNCTION OrgFundingPercentileCollab(
	lowerBound int DEFAULT 0,
	upperBound int DEFAULT 100
)
RETURNS SETOF PercentileInt AS $$
DECLARE
	fractions numeric[] := PERCENTILE_FRACTIONS(lowerBound, upperBound);
	fraction numeric;
BEGIN
	CREATE TEMP TABLE IF NOT EXISTS pairedOrgFunding AS
	SELECT
		COALESCE(d1.orgUuid, o1.orgUuid) AS orgUuid1,
		oo1.type AS type,
		o2.orgUuid AS orgUuid2,
		rank
	FROM
		-- First organisation
		gtrOrgs o1
		LEFT OUTER JOIN duplicateGtrOrgs d1
			ON d1.duplicateUuid = o1.orgUuid
		LEFT OUTER JOIN orgs oo1
			ON oo1.gtrOrgUuid IN (d1.orgUuid, o1.orgUuid)
		-- Second organisation
		INNER JOIN orgFundingPercentiles o2
			ON o2.orgUuid <> o1.orgUuid
		-- Projects both organisations are involved in
		INNER JOIN gtrProjectOrgs po1
			ON po1.orgUuid IN (d1.orgUuid, o1.orgUuid)
		INNER JOIN gtrProjectOrgs po2
			ON  po2.projectUuid = po1.projectUuid
			AND po2.orgUuid = o2.orgUuid;

	DROP TABLE IF EXISTS res;
	CREATE TEMP TABLE IF NOT EXISTS res OF PercentileInt;

	FOREACH fraction in ARRAY fractions LOOP
		INSERT INTO res
		SELECT
			*
		FROM crosstab('
			SELECT
				ROUND('||fraction||' * 100)::int,
				type,
				COUNT(*)
			FROM (
				SELECT
					COALESCE(type, ''Unknown'') AS type,
					COUNT(*)
				FROM
					pairedOrgFunding
				WHERE
					rank <= '||fraction||'
				GROUP BY orgUuid1, type
				ORDER BY 1, 2
			) q
			WHERE count > 0
			GROUP BY type
			',
			'VALUES
				(''Academic''::orgType),
				(''Medical''),
				(''Public''),
				(''Private''),
				(''Unknown'')'
		) AS ct (
			fraction numeric,
			academic bigint,
			medical bigint,
			public bigint,
			private bigint,
			unknown bigint
		);
	END LOOP;

	RETURN QUERY SELECT * FROM res;
END; $$ -- FUNCTION
LANGUAGE plpgsql;

\copy (SELECT * FROM OrgFundingPercentileCollab()) TO data/orgFundingPercentileCollab.csv (FORMAT CSV, HEADER)

-- Percentile distributions for organisations, by total amount of funding
-- received
CREATE OR REPLACE
FUNCTION OrgFundingPercentileProjects(
	lowerBound int DEFAULT 0,
	upperBound int DEFAULT 100
)
RETURNS TABLE("percentile" int, "value" bigint) AS $$
DECLARE
	fractions numeric[] := PERCENTILE_FRACTIONS(lowerBound, upperBound);
BEGIN
	CREATE TEMP TABLE IF NOT EXISTS projectPairedRanks AS
	SELECT
		projectUuid,
		rank
	FROM
		orgFundingPercentiles o
		INNER JOIN gtrProjectOrgs po
			ON po.orgUuid IN (o.orgUuid, o.duplicateUuid);

	RETURN QUERY
	SELECT
		ROUND(fractions.upperBound * 100)::int,
		(SELECT
			COUNT(*)
		FROM (
			SELECT
				COUNT(*)
			FROM
				projectPairedRanks
			WHERE
				rank <= fractions.upperBound
			GROUP BY projectUuid
		) q
		WHERE count > 0
		) AS result
	FROM unnest(fractions) AS fractions(upperBound);
END; $$ -- FUNCTION
LANGUAGE plpgsql;

\copy (SELECT * FROM OrgFundingPercentileProjects()) TO data/orgFundingPercentileProjects.csv (FORMAT CSV, HEADER)
