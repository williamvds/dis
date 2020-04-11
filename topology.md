---
geometry: a4paper,margin=2cm
fontsize: 12pt
urlcolor: blue
linkcolor: blue
...

# Organisations
## gtrOrgs

Organisations stored in the Gateway to Research (GtR) database.  
47822 records

| Field    | Type      | Description                                        |
|----------|-----------|----------------------------------------------------|
| orgUuid  | UUID      | Unique identifier                                  |
| name     | text      | Name of organisation                               |
| address1 | text      | Address line 1                                     |
| address2 | text      | Address line 2                                     |
| address3 | text      | Address line 3                                     |
| address4 | text      | Address line 4                                     |
| address5 | text      | Address line 5                                     |
| postCode | text      | Post code                                          |
| city     | text      | City organisation is based in                      |
| region   | gtrRegion | Region organisation is based in                    |
| country  | text      | Country organisation is based in                   |
| recorded | date      | Date this record was created (in the GtR database) |

## gtrRegion: The regions an organisation can be based in:

- `Channel Islands/Isle of Man`
- `East Midlands`
- `East of England`
- `London`
- `North East`
- `Northern Ireland`
- `North West`
- `Scotland`
- `South East`
- `South West`
- `Wales`
- `West Midlands`
- `Yorkshire and The Humber`
- `Outside UK`
- `Unknown`

# Projects

## gtrProjects

Projects stored in the Gateway to Research (GtR) database.  
97277 records

| Field           | Type             | Description                                                                            |
|-----------------|------------------|----------------------------------------------------------------------------------------|
| projectUuid     | uuid             | Unique identifier                                                                      |
| title           | text             | Title of project                                                                       |
| status          | gtrProjectStatus | Current status of project: 'Active' or 'Closed'                                        |
| category        | gtrGrantCategory | Category of project                                                                    |
| leadFunder      | gtrFunder        | The main UKRI (sub)organisation providing the majority of the funding for this project |
| abstract        | text             | Abstract text summarising the project's background and goals                           |
| techAbstract    | text             | Technical summary of research being undertaken                                         |
| potentialImpact | text             | Planned impact that will result from the project                                       |
| startDate       | date             | Date of the beginning of project funding                                               |
| endDate         | date             | Date of the end of project funding                                                     |
| recorded        | date             | Date this record was created (in the GtR database)                                     |

## gtrGrantCategory

Categories that projects can be contained within

- `BIS-Funded Programmes`
- `Centres`
- `Collaborative R&D`
- `CR&D Bilateral`
- `EU-Funded`
- `European Enterprise Network`
- `Fast Track`
- `Feasibility Studies`
- `Fellowship`
- `GRD Development of Prototype`
- `GRD Proof of Concept`
- `GRD Proof of Market`
- `Intramural`
- `Knowledge Transfer Network`
- `Knowledge Transfer Partnership`
- `Large Project`
- `Launchpad`
- `Legacy Department of Trade & Industry`
- `Legacy RDA Collaborative R&D`
- `Legacy RDA Grant for R&D`
- `Missions`
- `Other Grant`
- `Procurement`
- `Research Grant`
- `Small Business Research Initiative`
- `SME Support`
- `Special Interest Group`
- `Studentship`
- `Study`
- `Third Party Grant`
- `Training Grant`
- `Unknown`
- `Vouchers`

## gtrFunder

UKRI, or sub-organisations of UKRI, that provide funding

- `UKRI`
- `AHRC`
- `BBSRC`
- `EPSRC`
- `ESRC`
- `Innovate UK`
- `MRC`
- `NC3Rs`
- `NERC`
- `STFC`

## gtrSubjects

Research subjects associated with projects.  
83 records

| Field       | Type | Description                            |
|-------------|------|----------------------------------------|
| subjectUuid | uuid | Unique identifier                      |
| name        | text | Name of subject, as specified by users |

## gtrProjectSubjects

Subjects that particular projects are associated with.  
Percentages are specified by users, each project can be associated with multiple
research subjects.  
78270 records

| Field       | Type    | Description                                           |
|-------------|---------|-------------------------------------------------------|
| subjectUuid | uuid    | Unique identifier of subject in gtrSubjects           |
| projectUuid | uuid    | Unique identifier of project in gtrProjects           |
| percent     | numeric | Percentage of project that is related to this subject |


## gtrTopics

Research topics associated with projects.  
610 records

| Field     | Type | Description                          |
|-----------|------|--------------------------------------|
| topicUuid | uuid | Unique identifier                    |
| name      | text | Name of topic, as specified by users |

## gtrProjectTopics

Topics that particular projects are associated with.  
Percentages are specified by users, each project can be associated with multiple
research Topics.  
150016 records

| Field       | Type    | Description                                         |
|-------------|---------|-----------------------------------------------------|
| topicUuid   | uuid    | Unique identifier of topic in gtrTopics             |
| projectUuid | uuid    | Unique identifier of project in gtrProjects         |
| percent     | numeric | Percentage of project that is related to this topic |

# Project outcomes

The outcomess of a project as logged by users

## gtrDisseminations

Disseminations published as a result of a project.  
58 records.

| Field                | Type    | Description                                                              |
|----------------------|---------|--------------------------------------------------------------------------|
| disUuid              | uuid    | Unique identifier                                                        |
| title                | text    | Title                                                                    |
| description          | text    | Description of the contents                                              |
| form                 | text    | The form of publishing, e.g. presentations, conferences, newsletter      |
| primaryAudience      | text    | Audience this dissemination is targeted at, e.g.  policymakers, students |
| yearsOfDissemination | text    | Comma-separated list of years it was active                              |
| results              | text    | Description of the results of publishing (unused)                        |
| impact               | text    | Descriptions of the outcomes of publishing                               |
| typeOfPresentation   | text    | Type of presentation (mostly unused)                                     |
| geographicReach      | text    | Local, Regional, National, or International                              |
| partOfOfficialScheme | boolean | Whether engagement activity is part of an official scheme                |
| supportingUrl        | text    | URLs for accessing supporting material                                   |

## gtrCollaborations

Further collaborations that formed as a result of a project.  
8 records

| Field                             | Type      | Description                                                     |
|-----------------------------------|-----------|-----------------------------------------------------------------|
| collabUuid                        | uuid      | Unique identifier                                               |
| description                       | text      | Description of collaboration                                    |
| parentOrganisation                | text      | Parent organisation of collaboration partner                    |
| childOrganisation                 | text      | Child organisation of collaboration partner                     |
| principalInvestigatorContribution | text      | Benefits provided to new collaborator by principal investigator |
| partnerContribution               | text      | Benefits provided to principal investigator by new collaborator |
| startDate                         | date      | Date collaboration began                                        |
| endDate                           | date      | Date collaboration ended                                        |
| sector                            | gtrSector | Sector of collaborating organisation                            |
| country                           | text      | Country collaborator is based in                                |
| impact                            | text      | Resulting impact of the collaboration                           |
| supportingUrl                     | text      | URLs for accessing supporting material                          |

## gtrKeyFindings

Key findings from a project.
1 record

| Field                | Type | Description                               |
|----------------------|------|-------------------------------------------|
| keyFindingUuid       | uuid | Unique identifier                         |
| description          | text | Description of findings                   |
| nonAcademicUses      | text | Non-academic applications of findings     |
| exploitationPathways | text | Possible further research and development |
| sectors              | text | Sectors that findings could be applied to |
| supportingUrl        | text | URLs for accessing supporting material    |

## gtrFurtherFundings

Further project funding after the initial funding period expired.  
9 records

| Field              | Type      | Description                                            |
|--------------------|-----------|--------------------------------------------------------|
| furtherFundingUuid | uuid      | Unique identifier                                      |
| title              | text      | Tile of grant/funding received (unused)                |
| description        | text      | Description of further funding received                |
| narrative          | text      | Reasoning for further funding (unused)                 |
| amount             | money     | Amount of funding received                             |
| organisation       | text      | Organisation providing funding                         |
| department         | text      | Department of organisation providing funding           |
| fundingId          | text      | External reference identifier for the funding received |
| startDate          | date      | Start of funding period                                |
| endDate            | date      | End of funding period                                  |
| sector             | gtrSector | Sector of organisation providing funding               |
| country            | text      | Country of organisation providing funding              |

## gtrImpactSummaries

Further project funding after the initial funding period expired.  
5 records

| Field              | Type | Description                                                                |
|--------------------|------|----------------------------------------------------------------------------|
| impactSummaryUuid  | uuid | Unique identifier                                                          |
| title              | text | Unused                                                                     |
| description        | text | Description of impact                                                      |
| impactTypes        | text | Unused                                                                     |
| summary            | text | Unused                                                                     |
| beneficiaries      | text | Unused                                                                     |
| contributionMethod | text | Unused                                                                     |
| sector             | text | Comma-delimited list of areas affected, e.g. 'Healthcare', 'Manufacturing' |
| firstYearOfImpact  | int  | Year that the impact took effect                                           |

## gtrPolicyInfluences

Any influence on an organisation/government's policy as a result of a project.  
5 records

| Field               | Type | Description                                                 |
|---------------------|------|-------------------------------------------------------------|
| policyInfluenceUuid | uuid | Unique identifier                                           |
| influence           | text | Description of influence, e.g. committee influenced         |
| type                | text | Form of incluence, e.g. membership of a guideline committee |
| guidelineTitle      | text | Unused                                                      |
| impact              | text | Unused                                                      |
| methods             | text | Unused                                                      |
| areas               | text | Unused                                                      |
| geographicReach     | text | Region influenced, e.g. 'National', 'Europe'                |
| supportingUrl       | text | URLs for accessing supporting material                      |

## gtrResearchMaterials

Research material published as a result of a project.  
0 records

| Field               | Type    | Description                                     |
|---------------------|---------|-------------------------------------------------|
| researchMatUuid     | uuid    | Unique identifier                               |
| title               | text    | Title                                           |
| description         | text    | Description                                     |
| type                | text    | Type                                            |
| impact              | text    | Impact from releasing                           |
| softwareDeveloped   | boolean | Whether software was developed                  |
| softwareOpenSourced | boolean | Whether software was open-sourced               |
| providedToOthers    | boolean | Whether material was provided to other entities |
| yearFirstProvided   | int     | First year research material was provided       |
| supportingUrl       | text    | URLs for accessing supporting material          |

# Links

## gtrOrgPeople

Organisations that people in `gtrPeople` are linked to.  
82015 records

| Field      | Type | Description                     |
|------------|------|---------------------------------|
| personUuid | uuid | UUID of person in `gtrPeople`     |
| orgUuid    | uuid | UUID of organisation in `gtrOrgs` |

## gtrProjectPeople

Individuals working on a particular project.  
201596 records

| Field       | Type          | Description                       |
|-------------|---------------|-----------------------------------|
| projectUuid | uuid          | UUID of project in `gtrProjects`    |
| personUuid  | uuid          | UUID of person in `gtrPersonRole`   |
| role        | gtrPersonRole | Role of individual in the project |

## gtrPersonRole

Possible roles an individual can have in a project:

- `Principal Investigator`
- `Co-Investigator`
- `Project Manager`
- `Fellow`
- `Training Grant Holder`
- `Primary Supervisor`
- `Researcher Co-Investigator`
- `Researcher`

## gtrProjectOrgs

Organisations working on a particular project.  
283527 records

| Field       | Type       | Description                                               |
|-------------|------------|-----------------------------------------------------------|
| projectUuid | uuid       | UUID of project in `gtrProjects`                            |
| orgUuid     | uuid       | UUID of project in `gtrOrgs`                                |
| role        | gtrOrgRole | Role of organisation in the project                       |
| startDate   | date       | Start of collaboration period                             |
| endDate     | date       | End of collaboration period                               |
| cost        | money      | Total funds spent by this organisation on the project     |
| offer       | money      | Total funding offered by the funder to this organisations |

## gtrRelatedProjects

Projects that are related to one another in some way.  
25392 records

| Field        | Type               | Description                       |
|--------------|--------------------|-----------------------------------|
| projectUuid1 | uuid               | UUID of project in `gtrProjects`    |
| projectUuid2 | uuid               | UUID of project in `gtrProjects`    |
| relation     | gtrProjectRelation | Relationship between the projects |
| startDate    | date               | Start of related (2nd) project    |
| endDate      | date               | End of related (2nd) project      |

