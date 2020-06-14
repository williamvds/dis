-- Run with
-- $ psql -U <username> -d <database> -f importGtrOutcomes.sql
-- Ensure the outcomes.xml file exists in the PostgreSQL data directory
DO $$
DECLARE
	file text := 'outcomes.xml';
	xmlRecords xml;
	outcome record;
	nss text[][2] := array[
		array['api', 'http://gtr.rcuk.ac.uk/gtr/api'],
		array['out', 'http://gtr.rcuk.ac.uk/gtr/api/project/outcome']
	];
BEGIN

xmlRecords := XMLPARSE(
	DOCUMENT convert_from(pg_read_binary_file(file), 'UTF8'));

-- Disseminations

DROP TABLE IF EXISTS xmlImport;
CREATE TEMP TABLE xmlImport AS
SELECT 
	(xpath('//@api:id', x, nss))[1]::text AS uuid,
	(xpath('//out:title/text()', x, nss))[1]::text AS title,
	(xpath('//out:description/text()', x, nss))[1]::text AS description,
	(xpath('//out:form/text()', x, nss))[1]::text AS form,
	(xpath('//out:primaryAudience/text()', x, nss))[1]::text AS primaryAudience,
	(xpath('//out:yearsOfDissemination/text()', x, nss))[1]::text AS yearsOfDissemination,
	(xpath('//out:results/text()', x, nss))[1]::text AS results,
	(xpath('//out:impact/text()', x, nss))[1]::text AS impact,
	(xpath('//out:typeOfPresentation/text()', x, nss))[1]::text AS typeOfPresentation,
	(xpath('//out:geographicReach/text()', x, nss))[1]::text AS geographicReach,
	(xpath('//out:partOfOfficialScheme/text()', x, nss))[1]::text AS partOfOfficialScheme,
	(xpath('//out:supportingUrl/text()', x, nss))[1]::text AS supportingUrl
FROM unnest(xpath('//out:outcomes/out:dissemination', xmlRecords, nss)) x;

FOR outcome IN
	SELECT * FROM xmlImport
LOOP
	INSERT INTO gtrDisseminations VALUES(
		outcome.uuid::uuid,
		outcome.title,
		outcome.description,
		outcome.form,
		outcome.primaryAudience,
		outcome.yearsOfDissemination,
		outcome.results,
		outcome.impact,
		outcome.typeOfPresentation,
		outcome.geographicReach,
		bool(outcome.partOfOfficialScheme),
		outcome.supportingUrl
	) ON CONFLICT DO NOTHING;
END LOOP;

-- Collaborations

DROP TABLE IF EXISTS xmlImport;
CREATE TEMP TABLE xmlImport AS
SELECT 
	(xpath('//@api:id', x, nss))[1]::text AS uuid,
	(xpath('//out:description/text()', x, nss))[1]::text AS description,
	(xpath('//out:parentOrganisation/text()', x, nss))[1]::text AS parentOrganisation,
	(xpath('//out:childOrganisation/text()', x, nss))[1]::text AS childOrganisation,
	(xpath('//out:principalInvestigatorContribution/text()', x, nss))[1]::text AS principalInvestigatorContribution,
	(xpath('//out:partnerContribution/text()', x, nss))[1]::text AS partnerContribution,
	(xpath('//out:start/text()', x, nss))[1]::text AS startDate,
	(xpath('//out:end/text()', x, nss))[1]::text AS endDate,
	(xpath('//out:sector/text()', x, nss))[1]::text AS sector,
	(xpath('//out:country/text()', x, nss))[1]::text AS country,
	(xpath('//out:impact/text()', x, nss))[1]::text AS impact,
	(xpath('//out:supportingUrl/text()', x, nss))[1]::text AS supportingUrl
FROM unnest(xpath('//out:outcomes/out:collaboration', xmlRecords, nss)) x;

FOR outcome IN
	SELECT * FROM xmlImport
LOOP
	INSERT INTO gtrCollaborations VALUES(
		outcome.uuid::uuid,
		outcome.description,
		outcome.parentOrganisation,
		outcome.childOrganisation,
		outcome.principalInvestigatorContribution,
		outcome.partnerContribution,
		date(outcome.startDate),
		date(outcome.endDate),
		outcome.sector::gtrSector,
		outcome.country,
		outcome.impact,
		outcome.supportingUrl
	) ON CONFLICT DO NOTHING;
END LOOP;

-- Key findings

DROP TABLE IF EXISTS xmlImport;
CREATE TEMP TABLE xmlImport AS
SELECT 
	(xpath('//@api:id', x, nss))[1]::text AS uuid,
	(xpath('//out:description/text()', x, nss))[1]::text AS description,
	(xpath('//out:nonAcademicUses/text()', x, nss))[1]::text AS nonAcademicUses,
	(xpath('//out:exploitationPathways/text()', x, nss))[1]::text AS exploitationPathways,
	(xpath('//out:sectors/text()', x, nss))[1]::text AS sectors,
	(xpath('//out:supportingUrl/text()', x, nss))[1]::text AS supportingUrl
FROM unnest(xpath('//out:outcomes/out:keyFinding', xmlRecords, nss)) x;

FOR outcome IN
	SELECT * FROM xmlImport
LOOP
	INSERT INTO gtrKeyFindings VALUES(
		uuid(outcome.uuid),
		outcome.description,
		outcome.nonAcademicUses,
		outcome.exploitationPathways,
		outcome.sectors,
		outcome.supportingUrl
	) ON CONFLICT DO NOTHING;
END LOOP;

-- Further fundings

DROP TABLE IF EXISTS xmlImport;
CREATE TEMP TABLE xmlImport AS
SELECT 
	(xpath('//@api:id', x, nss))[1]::text AS uuid,
	(xpath('//out:title/text()', x, nss))[1]::text AS title,
	(xpath('//out:description/text()', x, nss))[1]::text AS description,
	(xpath('//out:narrative/text()', x, nss))[1]::text AS narrative,
	(xpath('//out:amount/@api:amount', x, nss))[1]::text AS amount,
	(xpath('//out:organisation/text()', x, nss))[1]::text AS organisation,
	(xpath('//out:department/text()', x, nss))[1]::text AS department,
	(xpath('//out:fundingId/text()', x, nss))[1]::text AS fundingId,
	(xpath('//out:start/text()', x, nss))[1]::text AS startDate,
	(xpath('//out:end/text()', x, nss))[1]::text AS endDate,
	(xpath('//out:sector/text()', x, nss))[1]::text AS sector,
	(xpath('//out:country/text()', x, nss))[1]::text AS country
FROM unnest(xpath('//out:outcomes/out:furtherFunding', xmlRecords, nss)) x;

FOR outcome IN
	SELECT * FROM xmlImport
LOOP
	INSERT INTO gtrFurtherFundings VALUES(
		uuid(outcome.uuid),
		outcome.title,
		outcome.description,
		outcome.narrative,
		money(outcome.amount),
		outcome.organisation,
		outcome.department,
		outcome.fundingId,
		date(outcome.startDate),
		date(outcome.endDate),
		outcome.sector::gtrSector,
		outcome.country
	) ON CONFLICT DO NOTHING;
END LOOP;

-- Impact summaries

DROP TABLE IF EXISTS xmlImport;
CREATE TEMP TABLE xmlImport AS
SELECT 
	(xpath('//@api:id', x, nss))[1]::text AS uuid,
	(xpath('//out:title/text()', x, nss))[1]::text AS title,
	(xpath('//out:description/text()', x, nss))[1]::text AS description,
	(xpath('//out:impactTypes/text()', x, nss))[1]::text AS impactTypes,
	(xpath('//out:summary/text()', x, nss))[1]::text AS summary,
	(xpath('//out:beneficiaries/text()', x, nss))[1]::text AS beneficiaries,
	(xpath('//out:contributionMethod/text()', x, nss))[1]::text AS contributionMethod,
	(xpath('//out:sector/text()', x, nss))[1]::text AS sector,
	(xpath('//out:firstYearOfImpact/text()', x, nss))[1]::text AS firstYearOfImpact
FROM unnest(xpath('//out:outcomes/out:impactSummary', xmlRecords, nss)) x;

FOR outcome IN
	SELECT * FROM xmlImport
LOOP
	INSERT INTO gtrImpactSummaries VALUES(
		outcome.uuid::uuid,
		outcome.title,
		outcome.description,
		outcome.impactTypes,
		outcome.summary,
		outcome.beneficiaries,
		outcome.contributionMethod,
		outcome.sector::gtrSector,
		outcome.firstYearOfImpact::int
	) ON CONFLICT DO NOTHING;
END LOOP;

-- Policy influences

DROP TABLE IF EXISTS xmlImport;
CREATE TEMP TABLE xmlImport AS
SELECT 
	(xpath('//@api:id', x, nss))[1]::text AS uuid,
	(xpath('//out:influence/text()', x, nss))[1]::text AS influence,
	(xpath('//out:type/text()', x, nss))[1]::text AS type,
	(xpath('//out:guidelineTitle/text()', x, nss))[1]::text AS guidelineTitle,
	(xpath('//out:impact/text()', x, nss))[1]::text AS impact,
	(xpath('//out:methods/text()', x, nss))[1]::text AS methods,
	(xpath('//out:areas/text()', x, nss))[1]::text AS areas,
	(xpath('//out:geographicReach/text()', x, nss))[1]::text AS geographicReach,
	(xpath('//out:supportingUrl/text()', x, nss))[1]::text AS supportingUrl
FROM unnest(xpath('//out:outcomes/out:policyInfluence', xmlRecords, nss)) x;

FOR outcome IN
	SELECT * FROM xmlImport
LOOP
	INSERT INTO gtrPolicyInfluences VALUES(
		outcome.uuid::uuid,
		outcome.influence,
		outcome.type,
		outcome.guidelineTitle,
		outcome.impact,
		outcome.methods,
		outcome.areas,
		outcome.geographicReach,
		outcome.supportingUrl
	) ON CONFLICT DO NOTHING;
END LOOP;

-- Research materials

DROP TABLE IF EXISTS xmlImport;
CREATE TEMP TABLE xmlImport AS
SELECT 
	(xpath('//@api:id', x, nss))[1]::text AS uuid,
	(xpath('//out:title/text()', x, nss))[1]::text AS title,
	(xpath('//out:description/text()', x, nss))[1]::text AS description,
	(xpath('//out:type/text()', x, nss))[1]::text AS type,
	(xpath('//out:impact/text()', x, nss))[1]::text AS impact,
	(xpath('//out:softwareDeveloped/text()', x, nss))[1]::text AS softwareDeveloped,
	(xpath('//out:softwareOpenSourced/text()', x, nss))[1]::text AS softwareOpenSourced,
	(xpath('//out:providedToOthers/text()', x, nss))[1]::text AS providedToOthers,
	(xpath('//out:yearFirstProvided/text()', x, nss))[1]::text AS yearFirstProvided,
	(xpath('//out:supportingUrl/text()', x, nss))[1]::text AS supportingUrl
FROM unnest(xpath('//out:outcomes/out:researchMaterials', xmlRecords, nss)) x;

FOR outcome IN
	SELECT * FROM xmlImport
LOOP
	INSERT INTO gtrResearchMaterials VALUES(
		outcome.uuid::uuid,
		outcome.title,
		outcome.description,
		outcome.type,
		outcome.impact,
		bool(outcome.softwareDeveloped),
		bool(outcome.softwareOpenSourced),
		bool(outcome.providedToOthers),
		outcome.yearFirstProvided::int,
		outcome.supportingUrl
	) ON CONFLICT DO NOTHING;
END LOOP;
END$$; -- BEGIN

DROP TABLE IF EXISTS xmlImport;
