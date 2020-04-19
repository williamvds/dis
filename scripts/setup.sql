-- Set up the database schema
-- Execute using:
-- $ psql -U <username> -d <database> -f setup.sql

-- Provides UUID data types
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Provides similarity comparisons
CREATE EXTENSION IF NOT EXISTS "pg_trgm";

-- Provides crosstab()
CREATE EXTENSION IF NOT EXISTS "tablefunc";

-- GtR organisations
-- based on https://gtr.ukri.org/gtr/api
-- and https://gtr.ukri.org/gtr/api/organisation

DO $$ BEGIN
	CREATE TYPE gtrRegion as ENUM(
		'Channel Islands/Isle of Man',
		'East Midlands',
		'East of England',
		'London',
		'North East',
		'Northern Ireland',
		'North West',
		'Outside UK',
		'Scotland',
		'South East',
		'South West',
		'Unknown',
		'Wales',
		'West Midlands',
		'Yorkshire and The Humber'
	);
EXCEPTION
	WHEN duplicate_object THEN null;
END $$; -- BEGIN

DO $$ BEGIN
	CREATE TYPE gtrSector as ENUM(
		'Academic/University',
		'Charity/Non-profit',
		'Public',
		'Private'
	);
EXCEPTION
	WHEN duplicate_object THEN null;
END $$; -- BEGIN

CREATE TABLE IF NOT EXISTS gtrOrgs(
	orgUuid uuid PRIMARY KEY NOT NULL,
	name text not null,
	address1 text,
	address2 text,
	address3 text,
	address4 text,
	address5 text,
	postCode text,
	city text,
	region gtrRegion not null default 'Unknown',
	country text,
	recorded date
);

-- GtR projects
-- based on https://gtr.ukri.org/gtr/api/project

DO $$ BEGIN
	CREATE TYPE gtrProjectStatus as ENUM(
		'Active',
		'Closed'
	);
EXCEPTION
	WHEN duplicate_object THEN null;
END $$; -- BEGIN

DO $$ BEGIN
	CREATE TYPE gtrGrantCategory as ENUM(
		'BIS-Funded Programmes',
		'Centres',
		'Collaborative R&D',
		'CR&D Bilateral',
		'EU-Funded',
		'European Enterprise Network',
		'Fast Track',
		'Feasibility Studies',
		'Fellowship',
		'GRD Development of Prototype',
		'GRD Proof of Concept',
		'GRD Proof of Market',
		'Intramural',
		'Knowledge Transfer Network',
		'Knowledge Transfer Partnership',
		'Large Project',
		'Launchpad',
		'Legacy Department of Trade & Industry',
		'Legacy RDA Collaborative R&D',
		'Legacy RDA Grant for R&D',
		'Missions',
		'Other Grant',
		'Procurement',
		'Research Grant',
		'Small Business Research Initiative',
		'SME Support',
		'Special Interest Group',
		'Studentship',
		'Study',
		'Third Party Grant',
		'Training Grant',
		'Unknown',
		'Vouchers'
	);
EXCEPTION
	WHEN duplicate_object THEN null;
END $$; -- BEGIN

DO $$ BEGIN
	CREATE TYPE gtrFunder as ENUM(
		'AHRC',
		'BBSRC',
		'EPSRC',
		'ESRC',
		'Innovate UK',
		'MRC',
		'NC3Rs',
		'NERC',
		'STFC',
		'UKRI'
	);
EXCEPTION
	WHEN duplicate_object THEN null;
END $$; -- BEGIN

CREATE TABLE IF NOT EXISTS gtrProjects(
	projectUuid uuid PRIMARY KEY NOT NULL,
	title text not null,
	status gtrProjectStatus,
	category gtrGrantCategory,
	leadFunder gtrFunder,
	abstract text,
	techAbstract text,
	potentialImpact text,
	startDate date,
	endDate date,
	recorded date
);

CREATE TABLE IF NOT EXISTS gtrSubjects(
	subjectUuid uuid PRIMARY KEY NOT NULL,
	name text
);

CREATE TABLE IF NOT EXISTS gtrProjectSubjects(
	subjectUuid uuid REFERENCES gtrSubjects,
	projectUuid uuid REFERENCES gtrProjects,
	percent numeric,
	PRIMARY KEY (subjectUuid, projectUuid)
);

CREATE TABLE IF NOT EXISTS gtrTopics(
	topicUuid uuid PRIMARY KEY NOT NULL,
	name text
);

CREATE TABLE IF NOT EXISTS gtrProjectTopics(
	topicUuid uuid REFERENCES gtrTopics,
	projectUuid uuid REFERENCES gtrProjects,
	percent numeric,
	PRIMARY KEY (topicUuid, projectUuid)
);

-- GtR outcomes
-- based on https://gtr.ukri.org/gtr/api/outcome

CREATE TABLE IF NOT EXISTS gtrDisseminations(
	disUuid uuid PRIMARY KEY NOT NULL,
	title text,
	description text,
	form text,
	primaryAudience text,
	yearsOfDissemination text,
	results text,
	impact text,
	typeOfPresentation text,
	geographicReach text,
	partOfOfficialScheme boolean,
	supportingUrl text
);

CREATE TABLE IF NOT EXISTS gtrCollaborations(
	collabUuid uuid PRIMARY KEY NOT NULL,
	description text,
	parentOrganisation text,
	childOrganisation text,
	principalInvestigatorContribution text,
	partnerContribution text,
	startDate date,
	endDate date,
	sector gtrSector,
	country text,
	impact text,
	supportingUrl text
);

CREATE TABLE IF NOT EXISTS gtrKeyFindings(
	keyFindingUuid uuid PRIMARY KEY NOT NULL,
	description text,
	nonAcademicUses text,
	exploitationPathways text,
	sectors text,
	supportingUrl text
);

CREATE TABLE IF NOT EXISTS gtrFurtherFundings(
	furtherFundingUuid uuid PRIMARY KEY NOT NULL,
	title text,
	description text,
	narrative text,
	amount money,
	organisation text,
	department text,
	fundingId text,
	startDate date,
	endDate date,
	sector gtrSector,
	country text
);

CREATE TABLE IF NOT EXISTS gtrImpactSummaries(
	impactSummaryUuid uuid PRIMARY KEY NOT NULL,
	title text,
	description text,
	impactTypes text,
	summary text,
	beneficiaries text,
	contributionMethod text,
	sector gtrSector,
	firstYearOfImpact int
);

CREATE TABLE IF NOT EXISTS gtrPolicyInfluences(
	policyInfluenceUuid uuid PRIMARY KEY NOT NULL,
	influence text,
	type text,
	guidelineTitle text,
	impact text,
	methods text,
	areas text,
	geographicReach text,
	supportingUrl text
);

CREATE TABLE IF NOT EXISTS gtrResearchMaterials(
	researchMatUuid uuid PRIMARY KEY NOT NULL,
	title text,
	description text,
	type text,
	impact text,
	softwareDeveloped boolean,
	softwareOpenSourced boolean,
	providedToOthers boolean,
	yearFirstProvided int,
	supportingUrl text
);

-- GtR persons
-- based on https://gtr.ukri.org/gtr/api/person

CREATE TABLE IF NOT EXISTS gtrPeople(
	personUuid uuid PRIMARY KEY NOT NULL,
	firstName text,
	otherNames text,
	surname text,
	email text,
	orcId text
);

-- Similarity indices

CREATE INDEX IF NOT EXISTS gtrOrgs_name_gist ON gtrOrgs USING gist(
	name gist_trgm_ops
);

CREATE INDEX IF NOT EXISTS gtrPeople_name_gist ON gtrPeople USING gist(
	firstName gist_trgm_ops,
	surname gist_trgm_ops
);

-- GtR links

DO $$ BEGIN
	CREATE TYPE gtrPersonRole as ENUM(
		'Principal Investigator',
		'Co-Investigator',
		'Project Manager',
		'Fellow',
		'Training Grant Holder',
		'Primary Supervisor',
		-- These do not appear in the API reference, so may be deprecated
		'Researcher Co-Investigator',
		'Researcher'
	);
EXCEPTION
	WHEN duplicate_object THEN null;
END $$; -- BEGIN

DO $$ BEGIN
	CREATE TYPE gtrOrgRole as ENUM(
		'Lead',
		'Collaborating',
		'Fellow',
		'Project Partner',
		'Funder',
		'Co-Funder',
		'Participant',
		'Student Project Partner'
	);
EXCEPTION
	WHEN duplicate_object THEN null;
END $$; -- BEGIN

DO $$ BEGIN
	CREATE TYPE gtrProjectRelation as ENUM(
		 'TRANSFER',
		 'STUDENTSHIP_FROM',
		 'TRANSFER_FROM',
		 'STUDENTSHIP'
	);
EXCEPTION
	WHEN duplicate_object THEN null;
END $$; -- BEGIN

CREATE TABLE IF NOT EXISTS gtrOrgPeople(
	personUuid uuid REFERENCES gtrPeople,
	orgUuid uuid REFERENCES gtrOrgs,
	PRIMARY KEY (personUuid, orgUuid)
);

CREATE TABLE IF NOT EXISTS gtrProjectPeople(
	projectUuid uuid REFERENCES gtrProjects,
	personUuid uuid REFERENCES gtrPeople,
	role gtrPersonRole,
	PRIMARY KEY (projectUuid, personUuid, role)
);

CREATE TABLE IF NOT EXISTS gtrProjectOrgs(
	projectUuid uuid REFERENCES gtrProjects,
	orgUuid uuid REFERENCES gtrOrgs,
	role gtrOrgRole NOT NULL,
	startDate date,
	endDate date,
	cost money,
	offer money,
	PRIMARY KEY (projectUuid, orgUuid, role)
);

CREATE TABLE IF NOT EXISTS gtrRelatedProjects(
	projectUuid1 uuid REFERENCES gtrProjects,
	projectUuid2 uuid REFERENCES gtrProjects,
	relation gtrProjectRelation NOT NULL,
	startDate date,
	endDate date,
	PRIMARY KEY (projectUuid1, projectUuid2, relation)
);

-- GtR cleaning

CREATE TABLE IF NOT EXISTS junkGtrOrgs(
	orgUuid uuid REFERENCES gtrOrgs PRIMARY KEY
);

CREATE TABLE IF NOT EXISTS similarGtrOrgs(
	orgUuid1 uuid REFERENCES gtrOrgs,
	orgUuid2 uuid REFERENCES gtrOrgs,
	simTrigramName float,
	simTrigramAddress float,
	manualResult bool,
	PRIMARY KEY (orgUuid1, orgUuid2)
);

CREATE TABLE IF NOT EXISTS similarGtrPeople(
	personUuid1 uuid REFERENCES gtrPeople,
	personUuid2 uuid REFERENCES gtrPeople,
	simTrigram float,
	manualResult bool,
	PRIMARY KEY (personUuid1, personUuid2)
);

-- Merged organisations

CREATE TABLE IF NOT EXISTS duplicateGtrOrgs(
	orgUuid uuid REFERENCES gtrOrgs,
	duplicateUuid uuid UNIQUE REFERENCES gtrOrgs,
	PRIMARY KEY (orgUuid, duplicateUuid)
);

DO $$ BEGIN
	CREATE TYPE orgType as ENUM(
		'Academic',
		'Medical',
		'Private',
		'Public',
		'Unknown'
	);
EXCEPTION
	WHEN duplicate_object THEN null;
END $$; -- BEGIN

CREATE TABLE IF NOT EXISTS orgs(
	gtrOrgUuid uuid PRIMARY KEY NOT NULL,
	name text not null,
	address1 text,
	address2 text,
	address3 text,
	address4 text,
	address5 text,
	postCode text,
	city text,
	region gtrRegion NOT NULL DEFAULT 'Unknown',
	country text,
	type orgType DEFAULT 'Unknown'
);

-- Merged people

CREATE TABLE IF NOT EXISTS duplicateGtrPeople(
	personUuid uuid REFERENCES gtrPeople,
	duplicateUuid uuid UNIQUE REFERENCES gtrPeople,
	PRIMARY KEY (personUuid, duplicateUuid)
);

CREATE TABLE IF NOT EXISTS people(
	gtrPersonUuid uuid PRIMARY KEY NOT NULL,
	firstName text,
	surname text,
	otherNames text
);

-- Utility functions

-- Remove all whitespace in some text
CREATE OR REPLACE
FUNCTION STRIP(txt text)
RETURNS text AS $$
BEGIN
	RETURN regexp_replace(txt, '\s', '');
END; $$ -- FUNCTION
LANGUAGE plpgsql IMMUTABLE;

-- Generate a list of percentile fractions in the specified range
CREATE OR REPLACE
FUNCTION PERCENTILE_FRACTIONS(
	lowerBound int,
	upperBound int,
	step int DEFAULT 1
)
RETURNS numeric[] AS $$
BEGIN
	RETURN (SELECT ARRAY(
		SELECT (a.n::numeric) / 100
		FROM GENERATE_SERIES(lowerBound, upperBound, step) AS a(n)
	));
END; $$ -- FUNCTION
LANGUAGE plpgsql IMMUTABLE;

CREATE OR REPLACE FUNCTION CoalesceAll(state anyelement, new anyelement)
RETURNS anyelement
AS $$
BEGIN
	RETURN COALESCE(state, new);
END; $$ --FUNCTION
LANGUAGE plpgsql IMMUTABLE;

CREATE OR REPLACE AGGREGATE Merge(anyelement) (
	sfunc = CoalesceAll,
	stype = anyelement
);
