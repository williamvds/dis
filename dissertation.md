---
title: |
	| Linking & Exploring Open Government Data:
	| Business Investment and Grants
subtitle: COMP3003 Report
author: |
	| William Vigolo da Silva
	| BSc Hons Computer Science with Year in Industry
	| psywv@nottingham.ac.uk
	| 4279225
date: May 4, 2020
toc: true
link-citations: true
links-as-notes: true
docmentclass: article
header-includes:
	- \usepackage{
			float,
			minted,
			pgfgantt,
			pgfplots,
			rotating,
		}
	- \input{ganttExt}
	- \graphicspath{{pics/}}
	- \setminted{
			linenos,
			fontsize=\footnotesize,
			frame=lines,
			tabsize=4,
			breaklines=true
		}
	- \pgfplotsset{
			every axis/.append style={
				line width=1pt,
				minor tick num=4,
			},
		}
geometry: a4paper,margin=2cm
fontsize: 12pt
urlcolor: blue
linkcolor: blue
...

# Introduction

<!-- What governments publish and why -->
Many governments and their institutions regularly publish information due to
legal requirements of freedom of information and policies regarding open data.
The purposes of such policies are often to improve and maintain transparency in
government.

Transparency is part of the principle of open government [@lathrop2010open], and
is considered to strengthen democracy, regulate government behaviour, and
promote government efficiency [@schauer2012].  
Open government aims to encourage citizen participation in overseeing the
actions of government and their officials - a tradition that can be traced back
to ancient Greece [@von1997straight].  
This idea that data should be pro-actively published and freely available
is known as the principle of _open data_ [@openDefinition2.1]. This transfers
some of the responsibility of oversight; governments must make available
facts that could reveal misbehaviour or areas that could be improved.

Open government data often includes topics such as election statistics,
department budgets & expenditures, and information about significant individuals
within organisations. These topics are useful in identifying undesirable
behaviour like corruption and nepotism.  
Other areas such as statistics in crime, justice, and healthcare could be used
to check that a government is acting in the best interests of its citizens.

There are some unfortunate limitations in the way that governments publish open
data. They do not properly follow the principles of open data, failing to use
open formats and formats that are not machine-readable.  
This makes the data harder to use by both citizens interested in finding out
facts about their government, and by researchers looking to perform quantitative
research on the data available.

Consequentially, analysing open government data requires a few extra steps,
including:

- __Collecting__ datasets from multiple sources.
- __Cleaning__ data that is invalid or incomplete
- __Linking__ data from the different sources, i.e. combining the available
	information.

# Motivation

This project's goal is to explore the value of open data and government
transparency.  
It discovers how existing open data and existing government data publishing
platforms can used to perform specific research and produce useful findings.  

My intention is to apply the full process needed to conduct in-depth data
analysis and address the challenges that one faces while working with open data.
Outcomes of this effort will include insights into ways to improve government
publishing of open data in order to enable a range of use scenarios and
potential applications.  
The focus is on open data published by the government of
the United Kingdom.

# Related work and resources

## Papers

@shadbolt2012linked: 
Open data from the UK government was collected, migrated,
and linked into a 'semantic web'. Use of standard technologies like the Resource
Description Framework data format and Sparql query language enabled a variety of
interesting analyses and visualisations, including exploring data point
variations over regions and time.
A user interface was created that allowed less technical users to explore data
using only their spreadsheet skills.  
This paper is a valuable reference into the process needed for transforming a
collection of datasets into a database that can be analysed using data analysis
methods and to which machine learning methods can be applied.

@winkler2006overview: An overview of existing methods and research in the area
of record linkage.  
Records from different datasets need to be linked together in order for the
relationships between entities to be explored, and to provide extra information
about individual entities, such as businesses and grants.  
The methods described in the paper were helpful through the process of linking
records in the dataset, particularly in describing algorithms and heuristics for
record comparison.

@elmagarmid2006duplicate: Techniques for detecting duplicate records in a
database are explored and explained in detail.  
Among other things, duplicate records in the datasets used in this project need
to be merged in order for the data analysis to produce high quality and accurate
results. This paper provides a valuable reference for methods used during this
process, including Q-gram matching.

## Data sources

[UK Research and Innovation](https://www.ukri.org) (UKRI): A non-governmental
organisation that funds research and innovation in the UK through grants. It is
an umbrella organisation for several 'research councils' in several industries
and areas. Data on funding from each council is made publicly available through
the [Gateway to Research](https://gtr.ukri.org) database.  
This provides details on each project, organisations & individuals involved, and
catalogues research outcomes as summarised by the researchers. Relevant research
papers produced during the project are also listed.  
This is the main dataset that will be used throughout this project, as it
includes most information relevant to the intended research.

[Data.gov.uk](https://data.gov.uk), [European Data Portal](https://europeandataportal.eu), [UK Transparency and FOI Releases](https://gov.uk/search/transparency-and-freedom-of-information-releases), [Data.gov](https://data.gov):
catalogues datasets released by government institutions of the United Kingdom,
European Union, and United States of America respectively.  
These could be used to provide additional context to the UKRI dataset,
if needed. Should time allow, research data from other regions such as the
United States may be explored, in a similar manner to that of the United
Kingdom.

## Software

[PostgreSQL](https://www.postgresql.org): A database management system. As I
have prior experience with it, I intend to use it throughout this project to
manage any databases created throughout the project.

Stanford Natural Language Processor [@manning2014stanford]: A toolkit for
natural language processing. This software could be used to extract data points
from textual documents, or during analysis of grant descriptions, for example.

[WorldMap](https://worldmap.harvard.edu): An open-source platform for overlaying
data on a map, which could be used to visualise data points over different
regions.

[NodeXL](https://nodexl.com) and [Gephi](https://gephi.org) [@ICWSM09154]: graph
visualisation and analysis tools. These tools could be used to explore the
relationship between entities in collected datasets.  
Gephi supports attaching to a database management system, such as PostgreSQL.
This makes it easier to use with datasets stored in a single database, as is the
case in this project.

\newpage

# Description of work

The aim is to leverage computational techniques and open government data about
investment in research & innovation and businesses in different development
stages, to determine the relationship between levels of investment and the
impact on businesses within various sectors.  
Such analysis is of interest to companies that analyse markets, e.g. to support
business decision making. This includes [The Decision
Project](https://www.decisionplatform.io), who expressed an interest in
being involved in the project.

## Research questions

The following questions were identified as potential interesting analysis from
preliminary research and initial insights gained by exploring the available
data.

- What is the structure of the ecosystem of publically-funded research - how
  does it change over time?
- What are the significant factors that influence collaboration between
  organisations?

## Technical approach

This project explores open government data from the United Kingdom relating
to grants and investment in research and development. Specifically, it uses
the Gateway to Research database from UK Research and Innovation.

This dataset is aggregated, normalised, and linked so that all available
information can be used during the project's research. This involves
translating the schema of this dataset into a new schema which encapsulates both
existing and new data. This schema is then implemented using the PostgreSQL
database management system.

Focus is placed on applying existing data analysis and machine learning
techniques on these datasets which contain both structured and unstructured
data.  
Network analysis methods are used to identify the relationships between
entities in the datasets. Correlation analysis is performed to answer
questions based on historical data.  
Visualisations are created to show the identified relationships and other
findings.  
Machine learning methods such as decision trees and artificial neural networks
are applied to perform predictive analyses required by some research
questions. This requires identifying the most significant attributes within
the dataset that contribute best to answering the questions.  
Each method applied is evaluated to identify each performs with respect to
the accuracy or usefulness of findings or predictions. For example, a predictive
model for the popularity of a subject over time could be tested against
historical data.

\newpage

# Methodology

(1) __Data aggregation__
	(i) Datasets exported from the UKRI Gateway to Research database
	(i) Data points extracted and normalised where necessary
	(i) Design a database schema to accommodate storage of data attributes
	    and metadata
	(i) Import all records into a single relational database  
	\
	In order to link and ultimately analyse the data, each dataset was parsed
	and exported from their original format into a single database. Individual
	data points are be extracted to normalise the data, such that it can be
	stored in a relational database.  
	A database schema is needed so that records from all datasets are available
	in a single relational database. This enables relationship analysis and
	other analyses.  
	Focus was placed on data that is well-formatted and machine-readable.
	Besides numeric and categorical data, text was also processed.
\
(1) __Linking datasets__  
	(i) Discard low-quality or invalid records
	(i) Research appropriate linking & de-duplication methods
	(i) Merge duplicate records
	\
	Some records refer to non-existent entities, such as unnamed businesses
	listed as participants in research projects. These records are unusable
	for the purposes of this project, so they need to be identified and
	removed. These records are identifiable by their similar names and lack of
	other details.  
	Datasets can refer to the same business or grant by different names, causing
	duplicate entries in the database. In such cases similarity comparison
	algorithms is be applied to automatically identify the single entity which
	is being referred to. Some manual work was performed to clean up
	remaining duplicates.
\
(1) __Analysing data__  
	(i) Research and test useful tools
	(i) Perform network analysis to identify relationships
	(i) Analyse data to will to answer the desired questions
	(i) Develop software to perform analysis, visualisation, and learning
	(i) Create visualisations to show relationships and other results  
	\
	Research was performed to identify tools that could be useful in
	analysis or visualisation. Software was developed to apply existing
	analysis and visualisation tools to the collected data.
	\
	An initial network analysis was performed on the linked data to
	identify and visualise some interesting relationships between the entities.
	\
	A number of analysis algorithms were then applied to explore these
	relationships.
\
(1) __Evaluating results__  
	(i) Evaluate outcomes of analysis using metrics appropriate for each method
	(i) Make conclusions to answer the desired questions
	\
	Relationships identified through network analysis were be evaluated to
	explore how well they answer the research questions.

\newpage

# Data acquisition and preparation

## Data aggregation

The UKRI Gateway to Research (GtR) service is [available online](https://gtr.ukri.org).
The service also provides APIs that allow programmatic access to the database,
which are documented on the [Gateway to Research website](https://gtr.ukri.org./resources/api.html).  
A shell script was written that uses the GtR-2 API. As the API restricts
downloading to 100 records per query, the script downloads all available pages
into individual XML files. In order to avoid overtaxing the service, the script
pauses for some time after each page is downloaded.   
Initially developed for downloading only organisation records, once fully
functioning the script was extended to support downloading all types of records
available through the API.

For example, the first page of organisations stored in the GtR database can be
accessed at the URL
[https://gtr.ukri.org/gtr/api/organisations ](https://gtr.ukri.org/gtr/api/organisations). Though one might have to 'View page source' in an internet browser, one can see that a series of records have been returned in XML format, for example:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<ns2:organisations ...> 
	<ns2:organisation ns1:created="2020-01-28T17:07:16Z" ...>
		<ns1:links>
			<ns1:link ns1:href="https://gtr.ukri.org:443/gtr/api/projects/..."
				ns1:rel="PROJECT"/>
			<!-- More project links -->
			<ns1:link ns1:href="https://gtr.ukri.org:443/gtr/api/persons/..."
				ns1:rel="EMPLOYEE"/>
			<!-- More employee links -->
		</ns1:links>
		<ns2:name>Tsinghua University</ns2:name>
		<ns2:addresses>
			<ns1:address
				ns1:created="2020-01-28T17:07:15Z"
				ns1:id="41B25E49-A52C-46D5-A83B-8CF1723184C7">
				<ns1:line1>Tsinghua</ns1:line1>
				<ns1:line2>Hai Dian District</ns1:line2>
				<ns1:postCode>100084</ns1:postCode>
				<ns1:region>Unknown</ns1:region>
				<ns1:type>MAIN_ADDRESS</ns1:type>
			</ns1:address>
		</ns2:addresses>
	</ns2:organisation>
</ns2:organisations>
```

Downloading all records involves parsing this file to identify how many pages
of records are available, then performing a query to download each one in turn.
This process needs to be repeated for each type of record: organisations,
individuals, projects, and project outcomes.

The shell script was written in [Bourne Again Shell
(Bash)](https://www.gnu.org/software/bash) for the GNU/Linux operating system.
Additional command-line tools were used, including: xmllint from
[libxml2](http://xmlsoft.org) for XML manipulation, [GNU
Awk](https://www.gnu.org/software/gawk) for text processing, and
[curl](https://curl.haxx.se) for downloading web pages.  
Since these software packages are free, open source, and commonly used, the
research can be relatively easily reproduced and results verified. The tools
support automation of the main process downloading a series of files from the
internet.

In order to merge the downloaded XML files an auxiliary program was created.  
Each page of downloaded records is an individual XML file, with records
contained in a single wrapping XML element. As an example, pages of organisation
records are in the following structure:

```xml
<?xml version="1.0" encoding="utf8"?>
<ns0:organisations xmlns:ns0="...">
	<ns0:organisation ns1:created="...">
		<!-- Record information -->
	</ns0:organisation>
	<!-- repeat ns0:organisation -->
</ns0:organisations>
```

In order to combine the pages, the program collects the inner records, e.g.
`ns0:organisation`s, into the outer `ns0:organisations` of the first record.  
This could not be performed by the main script itself, as the XML tool being
used, xmllint, did not support this combination of records. Python was used
instead, as I am similarly familiar with it, it is cross-platform, free and
open-source, and it comes with a fully-featured library for manipulating XML
data in that manner that was needed.

The source code of the main download program is provided in the appendix section
[ukriDownload], and the auxiliary combing script in [mergeXML].

## Data importing

Aggregated data is imported into a single relational database management
system, which will enable analysis through queries composed in the Structured
Query Language (SQL).  
The schema of the database is designed to be _normalised_, such that each atomic
piece of information is stored in an individual field. This minimises data
duplication - particularly helpful when handling large databases such as in this
project - as well as enabling analysis of individual components of records.

All aggregated data is kept in the database so that it can be used
throughout the project. As a result some information is duplicated, as records
exist in both the original dataset and the cleaned dataset.
In order to differentiate between the sources of data, tables containing data
from the Gateway to Research database are prefixed with 'gtr'.
All other tables contain data formed from this project.

The design for data from the Gateway to Research database is based partially on
the contents of the GtR API manual @gtrapi2manual, which explains the contents
of the records returned by the API.  
In occasions where the manual provided inaccurate or incomplete information, the
XML schema of records and some exported records were visually inspected to
identify how best to normalise each type of record. For example, the XML schema
for individuals is available [through the REST
API](https://gtr.ukri.org/gtr/api/person).  

The final database design is visualised figure \ref{fig:erd}, with each table
and field annotated in the appendix section [Database schema manual]. It was
applied to the PostgreSQL database management system, and is implemented in the
SQL file provided in appendix section [setup.sql].

PostgreSQL has good support for importing structured XML data, though the
structure of the XML records must be mapped to the relational and normalised
structure of the database schema.  
An SQL procedure was produced for the importing of each record type:
organisations, individuals, projects, and project outcomes. These are provided
in the appendix: [importGtrOrgs.sql], [importGtrPersons.sql],
[importGtrProjects.sql], and [importGtrOutcomes.sql].

The SQL procedures extract individual data points from records through XPath
queries against the XML data @w3cXPath. Similarly to the design of the
database schema, these were developed through a combination of inspecting the
XML schema as well as some extracted records.  
Once again, visual inspection during this process resulted in additional
adjustments being made to the database design, including adding new fields to
existing tables and creating new ones where necessary, e.g. the `gtrTopics`
table.

Some difficulties encountered during the development of these procedures
included:

- Very high memory usage during importing.
  \
  The exported XML files for project records total to over 700 megabytes at the
  time they were last exported. While creating the import procedures, I found an
  that PostgreSQL would use large amount of the system's memory, dramatically
  slowing down both the system and the import process.  
  I noticed that memory usage increased dramatically each time I implemented an
  additional sub-record to be imported. For example, the list of organisations
  associated with a project is specified in the XML records for projects.
  Initially, these were extracted using an XPath query, then iterated over to
  insert each sub-record, in this case into `gtrProjectOrgs`. This iteration is
  performed using the [FOR-IN
  syntax](https://www.postgresql.org/docs/12/plpgsql-control-structures.html#PLPGSQL-RECORDS-ITERATING), which has the following structure:
  ```sql
  FOR identifier IN
	-- QUERY
  LOOP
	-- STATEMENTS
  END LOOP
  ```
  I found that each unique identifier used within a for loop resulted in greater
  memory usage.  
  My solution was to simply use a single variable for these sub-loops, when
  necessary, sacrificing some clarity in the meaning of the loop variables for
  more efficient use of memory.
  Most of the queries were instead adjusted to use a SELECT query within the
  [INSERT statement](https://www.postgresql.org/docs/current/sql-insert.html), eliminating the need for temporary variables.  
  The project importing procedure remains the most memory-intensive, but the
  PostgreSQL process peaks at just under 6 gigabytes during its execution, which
  is feasible for most computers to handle.  
  Memory usage could be further reduced by using temporary tables for
  sub-records, and additional research into minimising memory usage in
  PostgreSQL procedures.

- XML entities are not replaced automatically.
  \
  An XPath query in PostgreSQL that targets the text of an element does not
  automatically decode any entities that reside within the text.  
  XML data will normally encode specific characters as _entities_ to avoid
  conflicting with the syntax. Among these are ampersands, `&`: in XML data
  these are encoded as `&amp;`.  
  Once this was noticed, manual text replacement was added for fields where it
  was noticed.

- Money values being imported incorrectly.
  \
  Initially monetary values, such as the funding organisations provided to
  projects, were being imported by casting the text of the fields directly to
  the PostgreSQL type `money`, which can store currency values.  
  For example, an exported project record will contain a list of participating
  organisations and the value of their contribution as decimal number:
  ```xml
  <ns2:project>
	<!-- ... -->
	<ns2:participantValues>
		<ns2:participant>
		<ns2:organisationId>AAC0E6BF-AC85-4577-AA5A-2E8725FFAF7B</ns2:organisationId>
		<ns2:organisationName>Wsp UK Limited</ns2:organisationName>
		<ns2:role>LEAD_PARTICIPANT</ns2:role>
		<ns2:projectCost>100000.0</ns2:projectCost>
		<ns2:grantOffer>100000.0</ns2:grantOffer>
		</ns2:participant>
	</ns2:participantValues>
	<!-- ... -->
  </ns2:project>
  ```
  However, once these values become sufficiently large, the exported records
  will store these decimal values in scientific form, which PostgreSQL cannot
  cast to a monetary type directly. Attempting to do so results in errors such
  as:  
  `ERROR:  invalid input syntax for type money: "3.4442927E7"`  
  The solution was to cast to an intermediary type, `numeric`, before then
  casting to `money`:  
  `(xpath('//pro:projectCost/text()', x, nss))[1]::text::numeric::money AS cost`  
  instead of simply  
  `(xpath('//pro:projectCost/text()', x, nss))[1]::text::money AS cost`.

- Conflicts occurring upon repeating the import process
  \
  Testing the import procedures involved running them repeatedly to test new
  adjustments. An expected result of the primary key constraints implemented in
  the database design is that no two records may share the same primary key. As
  a result, these repeated executions would result in unique constraint
  violations.  
  In order to work around these, I used PostgreSQL's [`ON CONFLICT`
  clause](https://www.postgresql.org/docs/12/sql-insert.html#SQL-ON-CONFLICT) to
  handle these conflicts. In cases where new fields were
  added, the `DO UPDATE SET field = value` action was used to set the value of
  this new field for already existing records. These were eventually replaced
  with the `DO NOTHING` action to simply skip over already existing records.

\newpage

## Data cleaning

Data cleaning is required to  ensure that the data used during analysis is of
high quality, i.e. free of errors and sufficient for the planned analysis. The
use of low quality data negatively impacts analysis, resulting in inaccuracies
and less useful outcomes (@rahm2000data).

The Gateway to Research data is entered by researchers and individuals involved
in the grant funding process. As a result, human error can result in erroneous
data and duplicate records.  
These problems are classified as 'single-source' problems, as they occur even a
single database is being considered. The introduction of multiple databases
then introduce 'multi-source problems', such as different encodings for the
roles of organisations, or different monetary systems being used for currency
values.

In order to make the development and further steps of this project simpler, the
processes undertaken to clean data avoided removing or modifying any data
imported from the Gateway to Research database. Instead, new database tables
and/or fields were created to store information during the cleaning process, as
well as storing the outcomes of cleaning: merged records.

### Eliminating invalid records

The first step taken during data cleaning was to identify records that contain
no useful information and/or do not refer to a real entity. For example, an
[organisation record with the name
'Unknown'](https://gtr.ukri.org/organisation/39BBE949-0333-428F-864F-C3B196D3D92D)
doesn't represent a real organisation, limiting how its relationship with
other entities can be explored. Such issues exist at the _record_ scope of
problems (as categorised by Rahm), due to this problem applying to the record as
a whole.

Initial exploration of the data was undertaken, revealing a number of other
organisation and person records with the name 'Unknown' (with varying
capitalisation). By querying the database for organisation records with the name
specified as 'Unknown', I found that a dozen other records used this name,
each providing no information in the fields other than the name.  
By querying the database for most popular names used by organisation records
(`SELECT name, COUNT(name) FROM gtrOrgs GROUP BY name ORDER BY count desc;`), I
found a similar pattern with the name 'Unlisted': over 100 records used the name
(in various forms of capitalisation), each also lacking any other information.  

In order to indicate these records were not to be used during analysis, I
created a table `junkGtrOrgs`, which contains the UUIDs of such organisation
records. All records with the name 'Unknown' or 'Unlisted' were inserted into
this table.

From the name frequency analysis, I also noticed a significant number of
organisation records shared what appeared to be names of organisation
departments - 'Research', 'Economics', 'Psychology', etc.. Similarly, these
records contained other information but the name.  
An example of such a record is the [Economics Department of Queen Mary
University of London (QMUL)](https://gtr.ukri.org/organisation/3A5E126D-C175-4730-9B7B-E6D8CF447F83).
On the web portal, the associated projects for this record all indicate that
these projects are/were led by QMUL - the same is indicated by my records in
`gtrProjectOrgs`.  
I inferred that organisation entries are automatically created for organisation
departments when the 'lead organisation department' is specified for a project,
for example in an associated project:

```xml
<ns2:project ... ns1:id="86616057-4857-4DAC-A1AE-3D354EB9C34A">
	<ns1:links>
		<ns1:link
			ns1:href=".../organisations/D5337A10-AC8A-402A-8164-C5F9CC6B0140"
			ns1:rel="LEAD_ORG"
		/>
		<!-- ... -->
	</ns1:links>
	<ns2:title>The marriage premium revisited: the case of baseball</ns2:title>
	<ns2:leadOrganisationDepartment>Economics</ns2:leadOrganisationDepartment>
	<!-- ... -->
</ns2:project>
```

The only linked organisation in this project record is QMUL. However, if we
inspect organisation records for the Economics department of QMUL, we see this
project is linked.  
During the database importing process explained in [Importing
data], only the links specified in project records are imported. Hence,
organisation records which are actually departments will have no entries for
projects that they were associated with.  

These records do not refer to a real organisation entity, and are isolated
from other records due to their links not being imported, hence relationships
between these entities cannot be analysed.  
For these reasons, I decided to add organisation records with no linked projects
to the invalid records collection.

As a result, 5213 of 47822 (10.9%) organisation records were marked as invalid
records.

### Merging organisation roles enumerations

Through visual inspection, the enumerations that specify an organisation's role
in a project (in the `gtrProjectOrgs` table) appeared to some duplicates. This
is likely a result of the merging of several databases without considering
the meanings of these enumerations.  
In order to solve this, I created a new database type, `gtrOrgRole`, and added a
utility function that mapped the enumerations within the GtR database to this
new type:

| GtR enumeration    | `gtrOrgRole` mapping      |
|--------------------|---------------------------|
| `LEAD_PARTICIPANT` | `Lead`                    |
| `PARTICIPANT`      | `Participant`             |
| `LEAD_ORG`         | `Lead`                    |
| `COLLAB_ORG`       | `Collaborating`           |
| `FELLOW_ORG`       | `Fellow`                  |
| `PP_ORG`           | `Project Partner`         |
| `FUNDER`           | `Funder`                  |
| `COFUND_ORG`       | `Co-Funder`               |
| `PARTICIPANT_ORG`  | `Participant`             |
| `STUDENT_PP_ORG`   | `Student Project Partner` |

These decisions were made by investigating the GtR API documentation, manually
gauging the semantics of each enumeration, and determining which refer to the
same role.  
For example, the first two enumerations, `LEAD_PARTICIPANT` and `PARTICIPANT`
are specified to only be used by the subsidiary Innovate UK (@gtrdatadict).
Both `LEAD_PARTICIPANT` and `LEAD_ORG` both refer to "[an] organisation
receiving project funding which is accountable for ensuring that the planned
outcomes for the project are achieved...". Hence, these enumerations can be
merged into a single role.
The `PARTICIPANT` enumeration is undocumented, but since it is named almost
identically to `PARTICIPANT_ORG`, I decided that this pair were semantically
identical and thus mapped them to the same value.

Mapping is performed by `ParseOrgRole` in [importGtrProjects.sql].

## Merging duplicate records

As explored by @winkler2006overview and @elmagarmid2006duplicate there are many
existing methods for identifying duplicate records, most of which involve
comparing the similarity of text within records.

In order to track the de-duplication process, additional database tables were
created for each entity being de-duplicated.  
One set of tables stores the similarity of records: e.g., the `similarGtrOrgs`
table tracks pairs of similar organisations within the Gateway to Research
database, including metrics measuring the level of similarity, and the result of
any manual checking.  
Another set of tables stores primary keys of pairs of records that have been
determined to be duplicates of each other.  
Finally, when appropriate, another table stores records with the merged
information of all duplicates. This is the purpose of the `orgs` table, which
has all the fields that the main `gtrOrgs` table does, associated with the
primary organisation UUID. New records will merge each field from pairs of its
duplicates using the `COALESCE` function, which will take the first non-null
value. Thus, records in the `orgs` table will contain as much data as the
Gateway to Research database contains for each individual entity.

Data normalisation involves splitting data into its minimal atomic components,
and enforcing well-structured relations between entities stored in the database.
Doing so provides confidence that the stored data is free of anomalies and
always correct. One part of this process involves eliminating fields whose
values can be calculated from the values of other fields - if the record is
updated these values can become outdated, resulting in anomalous information
being stored (@lee1995justifying).  
Storing similarity metrics for pairs of records breaches this principle.
However, I believe this decision is justified for several reasons:

1. Original data needs to be maintained so that the changes made during
   data cleaning can be identified and statistics can be reported within this
   report.

2. It takes a significant amount of time to calculate these metrics:  
   As of the date of data aggregation, the Gateway to Research database
   contained just under 48,000 records of organisations, and just over 82,000
   records of people. Performing unique pairwise comparisons for each type of
   record is thus rather computationally intensive: in total, the triangle
   number of $n - 1$, (where $n$ is the number of records) comparisons must be
   made. Given 48,000 organisations, that results in $\frac{n(n-1)}{2} =
   1151976000$ comparisons.  
   Re-calculating each time these values are required would be a great
   inconvenience during the development of the project, as these values are
   required regularly during de-duplication and analysis.  
   The similarity tables instead act as a cache that can be referred back to
   when needed to speed up processes throughout the project.

3. The database is not regularly being updated:  
   Data from Gateway to Research was exported only twice during the project, and
   the project does not aim to keep up-to-date with the current state of the
   Gateway to Research database, so it is appropriate to calculate metrics once
   so that they can be reused.

Database tables were created to store pairs of similar records and potentially
useful values for each pair. `similarGtrOrgs` stores similar pairs from
`gtrOrgs`, and `similarGtrPeople` stores similar pairs from `gtrPeople`.  
For each pair in `similarGtrOrgs`, the calculated trigram similarity of the
names and addresses are stored, as well as a boolean field for the result of any
manual checking: `NULL` indicates no manual check has been performed, `TRUE`
that the pair were confirmed to be duplicates, and `FALSE` that the pair were
confirmed to be unique entities.

### Entity name analysis

Manually exploring records revealed small variations with how organisation names
were entered into the database, as expected of data entered by untrained users.  
For example, private companies incorporated as 'limited' often contain a
variation of 'Limited', 'Ltd', or 'Ltd.' in their names. The names of duplicate
records will vary in how this is specified in the name.
The same is true of 'Corporation' ('Corp.'), 'Company' ('Co.'), ampersands
('and'), and 'University' ('Uni.').  
Names sometimes included 'The', other times it was omitted - e.g. 'The
Institute of ...' would sometimes be entered as 'Institute of ...'.

Another notable feature was the significant number organisation records with
postcodes or any form of address omitted: 42.5% provided no postcode, and 32.2%
provided neither postcode nor any other part of an address.  
As addresses enable two organisations to be clearly distinguished from each
other, this means it is not possible to rely on the address information to
de-duplicate organisations.

As for records on people, another common pattern is users entering nicknames in
the place of first names, such as 'Tom' instead of 'Thomas'. This complicates
the de-duplication process, as if one record uses a nickname and the other the
full name, these will have a lower similarity metric despite both referring to
the same name.

To compensate for this, the similarity comparison metrics were adjusted to
ensure that variations of the same words are replaced with a single variation.
This resulted in comparisons of records that used these variations having a
higher trigram similarity than they did before these replacements. 

### Q-Gram matching

One approach for detecting duplicates is the q-gram matching method, which
compares the number of shared substrings of length $q$ within two bodies of
text.  
PostgreSQL has built-in support for performing this comparison through the
[pg_trgm module](https://www.postgresql.org/docs/12/pgtrgm.html). This module
performs q-gram comparison with $q$ as three, hence comparing 3-character
sequences. These are known as _trigrams_.

As an example, the word 'trigram' is broken down into the following trigrams:  
`tri`, `rig`, `igr`, `gra`, and `ram`.  
In PostgreSQL's implementation, a "string is considered to have two spaces
prefixed and one space suffixed", hence these additional trigrams are generated
(the symbol '$\texttt{\textvisiblespace}$' indicates a space):  
\texttt{\textvisiblespace\textvisiblespace t}, \texttt{\textvisiblespace tr},
and \texttt{am\textvisiblespace}.  
These additional trigrams add additional weight to the beginnings and ends of
individual words.

I chose to use this method due to existing support in the PostgreSQL database
management system, as well as its particular affinity to catching typographical
errors in data entered by users.

Compared to some other similarity comparison methods, q-grams are not as
sensitive to the order of words within a strings. This is particularly important
for data entry by users, as names or addresses of organisations may be entered
in slightly different variations.  
For example the Levenshtein distance (or edit distance) "between two strings
[...] is the minimum number of edit operations of single characters needed to
transform" one string to another. The trigram similarity of the strings "The
University of Nottingham" and "Nottingham University" is 75.9% (3sf), whereas
the Levenshtein distance is 23. A significant number of characters must be
changed to transform one string to the other, despite both strings sharing two
entire words.

Similarity was calculated and recorded through SQL procedures,
[similarGtrOrgs.sql] and [similarGtrPeople.sql].  
The calculated values for trigram similarity were stored for names of
organisations (`similarGtrOrgs.simTrigramName`) and people
(`similarGtrPeople.simTrigramName`).

An initial attempt at running these scripts involved calculating the similarity
of every pair of records, but this failed after a significant amount of time,
once it had completely filled the remaining 50GB or so available on the storage
device the database was being stored.  
In order to avoid this, I filtered pairs by requiring that they share at least
50% of trigrams in their names. This allows the
amount of data generated from this procedure to be significantly reduced, down
to 243363 from 1151976000 rows for organisations.  

An initial attempt to compute the pairwise similarity of records proved to be
computational infeasible. It required over 30 minutes and a storage space of
more than 50GB before the procedure failed due to running out of disk space.
In order to address this issue, record pairs were filtered to include
those that share at least 50% of trigrams in their names. This reduced the
amount of data generated down to 243363 from the original 1151976000 rows for
organisations.

#### Organisations

\begin{figure}[H]
	\centering
	\begin{tikzpicture}
	\begin{axis}[
		xlabel=Minimum trigram name similarity (\%),
		ylabel=Number of pairs,
		enlargelimits=0.15,
		width=\textwidth * 0.5,
	]
		\addplot+ [
			smooth,
			mark=none,
		] table [
			x=lowerBound,
			y=count,
			col sep=comma,
		] {data/orgSimDist.csv};
	\end{axis}
	\end{tikzpicture}
	\caption{Similarity distribution of similarly-named organisation records.
		Generated with \texttt{OrgSimDist} from \nameref{stats.sql}}
	\label{fig:orgsSimDist}
\end{figure}

Once all these similarity records were created for organisations, I applied an
hypothetical heuristic: assume two records are duplicates if their names share
at least 90% of trigrams. This results in 2710 or 5.6% organisations being
duplicates.  
I then chose 100 random records and manually verified whether the pair of
organisations were indeed duplicates, which was determined if one of the
following conditions held:

1. Both organisation records listed addresses, and the addresses matched
2. Both organisation records listed addresses, and there existed public records
   of a single organisation being registered at both addresses throughout its
   history (Using the [Companies House](https://beta.companieshouse.gov.uk)
   service)
3. Both organisations records worked on an identical project

If one of the records did not specify any form of address, then the pair was
skipped.

A script was created to present the user with each pair, who can then specify
the result of manual checking and update the database records accordingly.  
My reasons for choosing Python for this utility are similar to those explained
in [Aggregating Data] - Python additionally has support for performing
PostgreSQL queries through the [psycopg2 module](https://psycopg.org).  
This necessitated adding an additional field to `similarGtrOrgs` named
`manualResult`. The field is a boolean flag indicating the result of manual
checking, where a true value indicates the records refer to the same entity.
Should this field be `NULL`, this indicates no manual checking has been
performed.

The results are shown in the following plot:

\begin{figure}[H]
	\centering
	\begin{tikzpicture}
	\begin{axis}[
		symbolic x coords={Duplicate, Not duplicate, Undetermined},
		xtick=data,
		ylabel=Number of pairs,
		enlargelimits=0.15,
		ybar=5pt,
		bar width=9pt,nodes near coords,
		point meta=y,
	]
		\addplot coordinates {
			(Duplicate,     99)
			(Not duplicate, 1)
			(Undetermined,  36)
		};
	\end{axis}
	\end{tikzpicture}
	\caption{Results of manual verification of duplicate organisations whose
		names have a trigram similarity of 90\% or above}
	\label{fig:manualOrgDedupe}
\end{figure}

A significant portion number of pairs contained an organisation that had no
address specified and lacked sufficient information to determine whether the
pair were indeed duplicates. This was expected, as a significant portion of
organisation records lack address information.

However, of those pairs that both contained addresses, 99 were confirmed to
refer to the same entity, normally through sharing an identical address. A
smaller number of those were confirmed by checking the historical addresses for
a real organisation, and finding that it has previously been registered in both.
Less than 10 were determined to be duplicates through sharing similar partners
on projects, or similar topics for projects.

The single pair that was confirmed to not be a duplicate was the University of
Los Lagos (in Chile) and the University of Lagos (in Nigeria), with a trigram
name similarity of 91%.

This accuracy is acceptable enough for the purposes of this project, and so I
decided to apply the heuristic of 90% trigram similarity during the
de-duplication process, merging records where this property applies.

Additional confidence could be provided to the de-duplication of organisations
by automatically querying an API for records of these organisations, such as the
[Companies House API](https://developer.companieshouse.gov.uk/api/docs). The
addresses of records in the Gateway to Research database could be matched
against historical names and addresses automatically, similarly to the manual
process I performed.  
Data from the Companies House database could also be exported and linked with
that of the Gateway to Research database.

#### People

Trigram similarity was calculated for pairs of records on people, taking the
average trigram similarity of both the first name and surname. Where both of the
pair specified the 'other names' field, the similarity was calculated as
the average trigram similarity of the first name, surname, and other names. 

First names were filtered to replace nicknames with possible full names before
comparison, to minimise the negative impact of users providing nicknames
in the place of full names.

### Manual inspection

#### Organisations

Through manually inspecting organisation records with high name similarity, I
identified that the specified postcodes can be used to reliably identify whether
similarly named records are indeed duplicates.  
Hence, I decided to merge organisation records if the following conditions hold:

1. Neither of the pair is listed as a invalid record
1. The pair share at least 90% of trigrams in their names, or
1. The pair share at least 50% of trigrams in the names, both have specified
   postcodes, and the postcodes match

As explored in [Q-Gram matching], using a threshold of 90% in name similarity is
a rather effective heuristic, and hence I have applied it when deciding to merge
organisation records.  
Matching postcodes provides enough additional confidence that a pair of
organisation records are duplicates, hence I apply a much lower trigram
similarity threshold for merging them.  
The accuracy of the de-duplication is not paramount to the purposes of this
project, so 100% accuracy is not necessary. The number of records and proportion
of those that lack much information also makes it infeasible to complete this
process manually.

\begin{figure}[H]
	\centering
	\begin{tikzpicture}
	\begin{axis}[
		xlabel=Minimum trigram name similarity (\%),
		ylabel=Number of pairs,
		enlargelimits=0.15,
		width=\textwidth * 0.5,
	]
		\addplot+ [
			smooth,
			mark=none,
		] table [
			x=lowerBound,
			y=count,
			col sep=comma,
		] {data/orgSimDistPostcode.csv};
	\end{axis}
	\end{tikzpicture}
	\caption{Similarity distribution of similarly-named organisation records,
		who also share the same postcode. 
		Generated with \texttt{OrgSimDistPostcode} from {\nameref{stats.sql}}}
	\label{fig:orgSimDistPostcode}
\end{figure}

The [mergeGtrOrgs.sql] procedure performs the record merging, storing the
resulting records in the `orgs` table. The `COALESCE` function on each duplicate
pair's fields so that the resulting record will take all information available
on a single entity. 

As a result, 3091 of 47822 (6.5%) organisation records were marked as
duplicates.

#### People

I identified that 617 of 14456 (4.3%) of similar person records shared the
employer, which could be used as an additional heuristic in determining whether
the pair are duplicates. By linking the employers against the duplicate
organisation list in `duplicateGtrOrgs` as generated in the previous section,
this number rises to 625.  
Using this employer information in conjunction with name similarity results in
much more confidence when determining if two records indeed refer to the same
individual.

From inspecting the most similar records, I noted that despite having similar
names, most had different employers.
While it's possible for the same individual to be employed by different
organisations over time, the records lack sufficient personally-identifiable
information to reliably link them to a single real individual.

As individuals' names are significantly less unique than that of organisations,
relying on name similarity alone in de-duplication appears infeasible. Hence, I
decided that person records should only be merged if the following conditions
hold:

1. Both records list the same employer
2. The name of both records share at least 90% of trigrams

The [mergeGtrPeople.sql] procedure performs the record merging, storing the
resulting records in the `people` table. The `COALESCE` function on each
duplicate pair's fields so that the resulting record will take all information
available on a single entity. 

As a result, 499 of 82015 (0.61%) of records on people were marked as
duplicates.

### Summary

Name trigram similarity is an effective heuristic for detecting duplicate
organisations, as these tend to use more unique names to distinguish themselves.
The same is not true of people: due to the wide re-use of names within
populations, names alone cannot be used to uniquely identify a real individual.
In these cases additional contextual information must be used to ascertain
duplication, such as an individual's employer.

Using name comparison is more effective when common variations of the same words
or names are substituted for a single variation before comparison. However, this
approach is limited by the requirement of domain knowledge being applied or a
significant amount visual inspection being done.

Name comparisons are more reliable when combined with the comparison of other
information available, such as the addresses of organisations.  
4871 of 47822 (10.2%) organisation records are detected as duplicates when the 
heuristic is that they share 90% or more of trigrams in their name.
By checking whether postcodes match, this number rises to 5935 (12.4%).

Limitations to these heuristics include:

- Incomplete records: Many omitted address information, meaning solely name
  comparison could be performed.
- User error: Postcodes being specified in the incorrect field, or differing by
  a couple of characters.
- Limited amount of information: Analysing sets of organisations collaborated
  with is less reliable for records with few projects associated with them.

Public government records could be queried to search previous names and
addresses of organisations. These combinations of names and addresses could be
compared between pairs of records to provide additional information to the
de-duplication process.  
The dates that these records were created is also provided, and could be used to
identify what a particular organisation was named and what address they were
using at a certain point in time.  
This information could provide more confidence in the decisions made during the
de-duplication process.

Another possible heuristic is to compare the set of organisations that a pair of
organisations have previously collaborated with, or to compare the research
topics of projects they have been involved in.

# Data analysis and visualisations

## Grouping organisations by type

A variety of organisations exist in the database, from universities, local
councils, medical institutions, to private companies.  
Through manually exploring the dataset, I found that these can often be
identified from their names, e.g. universities will almost always have the word
"University" in their names, and many hospitals will have the word "Hospital".

I decided to create 4 groups:

- __Academic__: For academic institutions like universities, colleges, and other
  schools
- __Medical__: Medical institutions like hospitals, medical research
  institutions, and other healthcare providers
- __Private__: Privately owned corporations
- __Public__: Government bodies and publically-funded institutions

Names are the only data point used when grouping organisations, as they are
the only related information on organisations contained within the Gateway to
Research database.  
Organisation records (and records that are listed as duplicates) are searched
for particular keywords that indicate their type:

| Type     | Exemplary keywords                              |
|----------|-------------------------------------------------|
| Academic | University, College, Academy, Academic          |
| Medical  | Hospital, NHS, Medical, Health                  |
| Private  | Limited/LTD, Corporation, Company, Incorporated |
| Public   | Council, Government, Governorate                |

This type is stored as an additional field within the `orgs` table, which
contains records which have been de-duplicated and no records determined to be
invalid.  
Grouping is performed in the procedure [classifyOrgs.sql].  
After applying this procedure, 21694 of 39578 organisation records (54.8%) were
given a type.

I attempted to maximise the amount of keywords picked up by manually searching
for common abbreviations, such as LTD, LLP, and PLC for private limited
companies. The procedure also takes into account the optional period at the end
of these abbreviations, such as "Uni." for "University".  
Another issue is that of keyword overlap: e.g. is Albany Medical College a
medical institution or an academic one? Through manual research we can discover
that it is indeed an academic one, but as the procedure sets the group of
medical organisations after academic ones, these are categorised as medical.  
An improvement to this procedure could be to consider combinations of words
that appear in the outliers, ordered to prioritise these patterns over single
keywords.

As just under half of organisations are not assigned a type, it is clear that
using names alone is insufficient if the goal is to maximise the number of
organisations grouped.  
Another improvement would be to refer to a public database such as the UK's
[Companies House](https://beta.companieshouse.gov.uk) service. This could be
used to determine both the legal classification and the 'nature of business'
of an organisation, which may indicate the activities that the organisation
takes part in.
The nature of business is reported by the company themselves, and so may not be
entirely reliable: e.g., the [Nottingham University Hospitals Trust
Charity](https://beta.companieshouse.gov.uk/company/09978675) lists their nature
of business as "hospital activities" despite also being an educational
institution.  
The categories used by Companies House are provided on their website:
@companiesHouseSIC.

## East Midlands network analysis and visualisation with Gephi

[Gephi](https://gephi.org), a Java-based graph analysis tool, was used to plot the
network of organisations based in the East Midlands region or Nottingham.  
This software was chosen as it is free and open source, and so it costs nothing
to use. Documentation also suggested it was easy to use, which would enable me
to quickly get to grips with the application in order to use it in this project.
Through research I also found that it includes several features that enable
network analysis and visualisation, the possibilities of which I was keen to
apply to explore.  
Organisations were selected if they had 'East Midlands' specified as their
region, and had an active projected within the years 2002-2008.

Limiting the dataset in this manner resulted in analysis being much faster to
perform, as only 238 of 39578 organisations match these criteria. Fewer records
means less computational power is needed to manipulate the dataset in Gephi.  
While Gephi is able to load the entire dataset if the Java virtual machine is
allowed to use more system memory (e.g. by setting `_JAVA_OPTIONS="-Xms1024m
-Xmx10000m"`), adjusting the layout, filtering, or calculating statistics still
took a significant amount of time.  
I also found that limiting the dataset significantly increased the legibility of
the resulting graph, as having fewer nodes and edges means less overlap. With
all nodes and edges visible, it was impossible to distinguish individual edges
due to the massive number of them - 283197 in total. In the filtered dataset
this number is reduced to a much more manageable 940.

While Gephi supports importing data directly from a database through queries,
I encountered difficulties when attempting to use this feature with long queries
and large amounts of data.  
I instead opted to create procedures that exported the needed data to Comma
Separated Values (CSV) files, a common plaintext format, and then imported these
files manually into Gephi.

Data was exported from the database using [scripts/eastMidlandsGraphGephi.sql],
then imported into Gephi through the [import
spreadsheet](https://github.com/gephi/gephi/wiki/Import-CSV-Data) wizard.
This includes organisation records (used as the nodes) and projects that pairs
of those organisations were both involved in (used as the edges).
Organisation records were inspected for duplicates by sorting by name, and some
were manually merged within Gephi.  

### Analysis

Gephi allows some graph properties to be analysed, including the degree
distribution of nodes and (weighted) clustering coefficient.

The degree distribution shown in figure \ref{fig:midlands2002_2008Degree} is
similar to that of the network as a whole (see [Amount of research]), with the
vast majority of nodes (i.e. organisations) having a low number of connections,
indicating that they are involved in only a few collaborations.  
Frequencies drop dramatically past degree 10, and very few organisations have
the highest degrees, and these are particularly sparse within the distribution.
This supports the expectation that there are a few organisations that make up
the vast majority of research and collaboration, and that most are only involved
in a few projects.  
As the distribution is similar to that of the database as a whole, this suggests
that publically-funded research in the East Midlands region does not stand out
significantly from other regions in terms of amount of research and its
distribution.

The weighted degree distribution (where each edge is multiplied by its weight)
for the graph is shown in figure \ref{fig:midlands2002_2008WeightedDegree},
where the weight is the cost of the project between the two organisations.  
A similar pattern is shown to the degree distribution; lower values have
significantly greater frequencies, and higher costs becoming rarer as indicated
by the sparsity at higher values.  

The clustering coefficient is a measure of "the degree to which nodes tend to
cluster together" (@opsahl2009clustering), originally attempted by
@luce1949method.  
When considering a single node, its coefficient indicates how close that node's
neighbours are to being a fully-connected graph: a lower value indicates less
connection, higher indicates more. Gephi calculates this for triplets (referred
to as 'triangles') of nodes in the graph.  
Gephi was used to calculate the distribution of clustering coefficients for all
nodes in the network, with the results shown in figure
\ref{fig:midlands2002_2008Clustering}.
We can see that a large number of
triangles have a clustering coefficient of 0, and slightly fewer have a
coefficient of 1. This indicates that there are a similar number of
triplets of organisations that have collaborated with each other, as there are
those that have never collaborated with each other.
The remaining node triangles are distributed between these extremes, with
coefficients higher than 0.5 being slightly more frequent.  
These results show that most of the network is highly connected, suggesting
there are many organisations in the East Midlands that engage in research with
many other organisations in this region. There is also a significant portion
that does not: these organisations are likely involved in few projects with few
collaborators.

### Visualisation

Nodes were filtered to those with at least one connection, then Yifan Yu's
proportional graph layout algorithm (@yhugraph) was applied.
This layout algorithm clusters related nodes while minimising the amount of edge
crossing. Clustering is a result of edges causing connected vertices to attract
one another while all vertices repel each other.  
Edges were scaled according to the amount spent on projects between those
organisations.
Nodes were scaled by their (unfiltered) total number of connections, and
coloured according to their type:

- Purple: Academic
- Blue: Private
- Green: Medical
- Gray: Unknown

Nodes with no connections  were removed, minor repositioning was performed
to make the graph visualisation more compact, and some nodes were adjusted
to fix overlapping labels.

The resulting visualisation can be found in figure \ref{fig:midlands2002_2008}.

The network shows academic organisations being involved in the majority of
projects in this period & area, having many connections to other organisations
through projects. Among these are the University of Nottingham, Loughborough
University, and Loughborough College.  
Medical organisations are also heavily involved in research, including the
University Hospitals of Nottingham and Leicester. These have formed large hubs
of connected organisations, showing the amount of research and variety of
organisations they are involved in.  
A few private and other classes of organisations stand out including [PERA
Innovation](https://www.perainternational.com/about), a research association for
the manufacturing sector, and [Experian](https://www.experian.com), a credit
reporting company. Both have a significant number of connections, and spend a
lot on research.

The vast majority of organisations are connected to a single contiguous graph,
but there are a few outliers that reside in their own disjoint networks, shown
in the bottom left of the graph. These include [Sun
Chemical](https://www.sunchemical.com) who produce "printing inks, coatings and
supplies".  
This suggests these organisations are in niche industries or involved in
research that does not benefit most organisations.

## East Midlands network analysis and visualisation with NodeXL

[NodeXL](https://www.smrfoundation.org/nodexl) is an add-on for Microsoft Office
Excel by the Social Media Research Foundation, originally developed to explore
and analyse social media networks. It can be used to explore any network,
however.
NodeXL was recommended by my supervisor, who had previously used it in her
research, and kindly provided a training session on using it.  
As the University provides complimentary access to the Microsoft Office suite,
and a free version is provided, I decided to try applying it to this project.

Similarly to the Gephi network, I filtered organisations to the East Midlands
region, for the same reasons as explained in [East Midlands network with Gephi].  
Microsoft Excel performed much worse compared to Gephi when I attempted to
handle the entire dataset. The application regularly became unresponsive when
manipulating the dataset or when NodeXL was generating graphs.  
I decided to explore a different year range for projects than was explored in
the Gephi visualisation, from 2005 to 2010, so the differences in the
networks can be explored.  
This resulted in 327 nodes and 806 edges being selected for this network.

The procedure for exporting this data is provided in
[eastMidlandsGraphNodeXL.sql].

### Analysis

In the free version of NodeXL, the available analyses are greatly limited. While
it supports several algorithms Gephi also supports (such as clustering
coefficients and eigenvector centrality), these are limited to the paid version.
One available analysis available is degree distribution, which is shown in
figure \ref{fig:midlands2005_2010Degree}.  
Just as in the 2005-2008 network, the vast majority of organisations are
involved in only a few collaborations, with higher amounts of collaboration
being increasingly rare.
Degrees above 20 seem to have become rarer in the 2005-2010 time range, but the
top degree is 172 compared to 2002-2008's 114. This suggests a lower amount of
collaboration from most organisations in this later time period, but the top
organisations are involved in more.

### Visualisation

Nodes were scaled by the number of project connections they had within that time
period, and edges scaled by how much was spent by either organisation on that
project.  
I applied the Fruchterman-Reingold layout algorithm (@fruchterman1991graph),
which takes into account edges in positioning. By adjusting the configuration of
the repulsive force to 25.0 and number of iterations to 25, this resulted in
nodes with greater degrees being positioned towards the centre of the graph, and
other nodes being placed towards the periphery.  
The layout algorithm was also configured to position small networks in the
bottom-left of the graph.  
Labels were added for nodes with the highest degrees (greater than 13), and some
other ones close to the centre of the graph. Minor repositioning was performed
to reduce overlap of these labels.

Nodes were coloured according to their type:

- Dark blue: Academic
- Red: Private
- Light green: Medical
- Dark green: Unknown
- Light blue: Public

The resulting visualisation can be found in figure \ref{fig:midlands2005_2010}.

Academic and Medical institutions are shown towards the centre of the graph and
with high degrees, indicating they are heavily involved in collaborative
research, as one might expect. This pattern is also visible in the 2002-2008
network. This graph also shows that most academic organisations have higher
degrees than most, hence are involved in more collaboration.  
With the exception of PERA Innovation, all the organisations mentioned in the
analysis of the 2002-2008 network also appear as nodes with high degree in this
new graph. This suggests the remaining organisations have maintained the large
amount of research they perform, whereas PERA Innovation is less involved in
publically-funded research within the East Midlands region.

Some particularly notable edges appear near the centre of the graph and travel
downwards to the bottom.  
These both represent a project that a significant amount of money was invested
into to [develop hydrogen fuel cell
systems](https://gtr.ukri.org/projects?ref=113057), led by [Intelligent Energy
Limited](https://www.intelligent-energy.com) and partnered with Frost
Electronics Limited.

## Important factors in collaboration

### Amount of research

Organisations being involved in more publically-funded projects could imply that
they are subject experts, and perform higher-quality research than other
organisations. If this is the case, other organisations would be more interested
in collaborating with them so that they can take advantage of the outcomes of
the research.

If we explore organisations by the number of projects they are involved in, we
can see that the top organisations are involved in significantly more projects
than lower organisations. Below the 90th percentile, these organisations are
involved in less than 10 distinct projects each, whereas this number becomes
exponential past the 90th percentile:

\begin{figure}[H]
	\centering
	\begin{tikzpicture}
	\begin{axis}[
		xlabel=Percentile,
		ylabel=Projects involved in,
	]
		\addplot+ [
			mark=none,
		] table [
			x=percentile,
			y=value,
			col sep=comma,
		] {data/orgProjectPercentiles.csv};
	\end{axis}
	\end{tikzpicture}
	\caption{Percentiles for the number of projects an organisation is involved
		in, across the entire UKRI database.
		Generated with \texttt{OrgProjectPercentiles} in \nameref{stats.sql}}
	\label{fig:orgProjectPercentiles}
\end{figure}

Visualising the distribution of organisations within these percentiles shows a
similar pattern: the vast majority are involved with only one or two projects:

\pgfplotstableread[col sep=comma]{data/orgProjectPercentileDist.csv}\data
\begin{figure}[H]
	\centering
	\begin{tikzpicture}
	\begin{axis}[
		xlabel=Organisation percentile by number of projects involved in,
		ylabel=No. of organisations (cum.),
		ymin=0,
		y label style={at={(axis description cs:-0.1,.5)}},
		scaled y ticks = false,
		mark=none,
		stack plots=y,
		area style,
		legend style={
			mark=none,
		},
		legend pos=outer north east,
	]
		\draw [red] (axis cs:40,0) -- (axis cs:40,50000);
		\addplot+ table [
			x=percentile,
			y=unknown,
		] {\data} \closedcycle;
		\addlegendentry{Unknown}
		\addplot+ table [
			x=percentile,
			y=academic,
		] {\data} \closedcycle;
		\addlegendentry{Academic}
		\addplot+ table [
			x=percentile,
			y=medical,
		] {\data} \closedcycle;
		\addlegendentry{Medical}
		\addplot+ table [
			x=percentile,
			y=private,
		] {\data} \closedcycle;
		\addlegendentry{Private}
		\addplot+ table [
			x=percentile,
			y=public,
		] {\data} \closedcycle;
		\addlegendentry{Public}
	\end{axis}
	\end{tikzpicture}
	\caption{Cumulative distribution of all organisations in the UKRI database
		by percentile, ranked by the total number of projects they are involved in.
		The number of organisations are broken down by their type.
		E.g. the red vertical line indicates just under 20,000 organisations are
		ranked at the 40th percentile or below.
		Generated with \texttt{OrgProjectPercentileDist} in
		\nameref{stats.sql}}
	\label{fig:orgProjectPercentileDist}
\end{figure}

By exploring the relationship between project involvement percentiles and
collaboration, we can see that the vast majority of organisations have
collaborated with organisations of lower percentile ranks:

\pgfplotstableread[col sep=comma]{data/orgProjectPercentileCollab.csv}\data
\begin{figure}[H]
	\centering
	\begin{tikzpicture}
	\begin{axis}[
		xlabel=Organisation percentile by number of projects involved in,
		ylabel=No. of orgs. collaborated with (cum.),
		ymin=0,
		y label style={at={(axis description cs:-0.1,.5)}},
		scaled y ticks = false,
		mark=none,
		stack plots=y,
		area style,
		legend style={
			mark=none,
		},
		legend pos=outer north east,
	]
		\draw [red] (axis cs:60,0) -- (axis cs:60,50000);
		\addplot+ table [
			x=percentile,
			y=unknown,
		] {\data} \closedcycle;
		\addlegendentry{Unknown}
		\addplot+ table [
			x=percentile,
			y=academic,
		] {\data} \closedcycle;
		\addlegendentry{Academic}
		\addplot+ table [
			x=percentile,
			y=medical,
		] {\data} \closedcycle;
		\addlegendentry{Medical}
		\addplot+ table [
			x=percentile,
			y=private,
		] {\data} \closedcycle;
		\addlegendentry{Private}
		\addplot+ table [
			x=percentile,
			y=public,
		] {\data} \closedcycle;
		\addlegendentry{Public}
	\end{axis}
	\end{tikzpicture}
	\caption{Cumulative distribution of all organisations in the UKRI database,
		filtered by ones that have collaborated with at least one other
		organisation at a certain percentile.
		Organisations are ranked by the total number of projects they are
		involved in.
		E.g. the red vertical line indicates that there are just under 30,000
		organisations that have collaborated with at least one other
		organisation at or below the 60th percentile, when ranked by the number
		of projects this organisation has been involved in.
		Generated with \texttt{OrgProjectPercentileCollab} in
		\nameref{stats.sql}}
	\label{fig:orgProjectPercentileCollab}
\end{figure}

While there are a large number of organisations that have collaborated with
lower ranked organisations, we still see a sharp increase past the 90th
percentile. This indicates a similar proportion of organisations have only
collaborated with the top rank researchers, suggesting that the number of
projects one organisation has taken part in is a factor in whether
another organisation decides to collaborate with them, though not a very
important one.

### Amount of funding

I expect that the amount of funding an organisations has previously received is
a strong indicator of the likelihood that another organisations will collaborate
with them.  
Hypothetically, the UKRI would provide more funding to organisations who are the
leading experts in their area compared to those who are less reputable.
Organisations would be more interested in collaborating with experts and those
who would bring more funding to projects, as this could result in the outcomes
of the project being more valuable.

Of projects that reported any offered funding, the mean funded amount was
£471,995, with a large (population) standard deviation of £5,535,964. This
indicates that there is a great variety in the amount of funding received by
projects.

\begin{figure}[H]
	\centering
	\begin{tikzpicture}
	\begin{axis}[
		xlabel=Percentile of funding,
		ylabel=Funding (£) (cum.),
		ytick scale label code/.code={millions},
		legend style={
			mark=none,
			at={(0.5, 1.03)},
			anchor=south,
		},
	]
		\draw [red] (axis cs:80,0) -- (axis cs:80,50000);
		\addplot+ [
			smooth,
			mark=none,
		] table [
			x=percentile,
			y=value,
			col sep=comma,
		] {data/projectFundingPercentiles.csv};
		\addlegendentry{Projects}
		\addplot+ [
			smooth,
			mark=none,
		] table [
			x=percentile,
			y=value,
			col sep=comma,
		] {data/orgFundingPercentiles.csv};
		\addlegendentry{Organisations}
	\end{axis}
	\end{tikzpicture}
	\caption{Percentiles of public funding that organisations have received for
		the projects the are involved in, as well as the total funding received
		by projects.
		E.g. the red line indicates that when ranked by the amount of funding
		received, the top 20% of both organisations and projects received at
		least £300,000 in total funding.
		Generated with \texttt{ProjectFundingPercentiles} and
		\texttt{OrgFundingPercentiles} in \nameref{stats.sql}}
	\label{fig:fundingPercentiles}
\end{figure}

The percentile distribution is very similar for the total funding received by
both projects and organisations. Both curves show that the top 20% of
organisations and projects account for the vast majority of funding received
from UKRI.

\pgfplotstableread[col sep=comma]{data/orgFundingPercentileCollab.csv}\data
\begin{figure}[H]
	\centering
	\begin{tikzpicture}
	\begin{axis}[
		xlabel=Organisation percentile by total funding received,
		ylabel=No. of orgs. collaborated with (cum.),
		scaled y ticks = false,
		y label style={at={(axis description cs:-0.1,.5)}},
		mark=none,
		stack plots=y,
		area style,
		legend style={
			mark=none,
		},
		legend pos=outer north east,
	]
		\draw [red] (axis cs:40,0) -- (axis cs:40,50000);
		\addplot+ table [
			x=percentile,
			y=unknown,
		] {\data} \closedcycle;
		\addlegendentry{Unknown}
		\addplot+ table [
			x=percentile,
			y=academic,
		] {\data} \closedcycle;
		\addlegendentry{Academic}
		\addplot+ table [
			x=percentile,
			y=medical,
		] {\data} \closedcycle;
		\addlegendentry{Medical}
		\addplot+ table [
			x=percentile,
			y=private,
		] {\data} \closedcycle;
		\addlegendentry{Private}
		\addplot+ table [
			x=percentile,
			y=public,
		] {\data} \closedcycle;
		\addlegendentry{Public}
	\end{axis}
	\end{tikzpicture}
	\caption{Cumulative distribution of all organisations in the UKRI database,
		filtered by ones that have collaborated with at least one other
		organisation at a certain percentile.
		Organisations are ranked by the total amount of funding they have
		received.
		E.g. the red vertical line indicates that there are just over 10,000
		organisations that have collaborated with at least one other
		organisation at or below the 40th percentile, when ranked by the total
		amount of funding this organisation has received.
		Generated with \texttt{OrgFundingPercentileCollab} in
		\nameref{stats.sql}}
	\label{fig:orgFundingPercentileCollab}
\end{figure}

By exploring the relationship between funding percentile and the number of
organisations that have been collaborated with, one can see a rather positively
linear relationship for the majority of the percentile distribution. This
indicates that for organisations within the 20th to 90th percentile, the funding
percentile does not have much influence in the likelihood that another
organisation will collaborate with them.  
However, from the 90th percentile and above, the number of organisations
collaborated with dramatically increases in a more exponential manner. This
suggests that a significant portion of organisations in the Gateway to Research
database have only collaborated with the top 10% most funded organisations.

\begin{figure}[H]
	\centering
	\begin{tikzpicture}
	\begin{axis}[
		xlabel=Project percentile by total funding received,
		ylabel=No. of projects (cum.),
		y tick label style={
			/pgf/number format/.cd,
			fixed,
			fixed zerofill,
			precision=0,
			/tikz/.cd
		},
		scaled y ticks = false,
		y label style={at={(axis description cs:-0.1,.5)}},
	]
		\addplot+ [
			smooth,
			mark=none,
		] table [
			x=percentile,
			y=value,
			col sep=comma,
		] {data/orgFundingPercentileProjects.csv};
	\end{axis}
	\end{tikzpicture}
	\caption{Cumulative distribution of projects by percentile, across the
		entire UKRI database.
		Projects are ranked by how much total funding they received.
		Generated with \texttt{OrgFundingPercentileProjects} in
		\nameref{stats.sql}}
	\label{fig:orgFundingPercentileProjects}
\end{figure}

If we instead explore the total number of projects that involve at least one
organisation at certain funding percentiles, it is trivial to identify a strong
positive correlation between the funding percentile and number of projects these
organisations are involved in.  
A significant majority of projects involve organisations above the 90th
percentile, suggesting that these organisations are also the most prolific in
their involvement in publically-funded research.

These analyses show that organisations are more likely to have collaborated with
only the most funded organisations, and that there are many projects involving
only the most funded organisations.  
While it is impossible to prove causality from this, the results support the
theory that, when an organisation is deciding whether to collaborate with
another, the total research funding that other organisation has received is a
factor.

# Summary and Reflections

## Conclusions

- What is the structure of the ecosystem of publically-funded research - how
  does it change over time?

Through aggregate analysis and specific analysis of the East Midlands network,
a common pattern appears within the ecosystem wherein a few organisations and
projects receive the vast majority of funding from UKRI and its subsidiaries.
This pattern applies to all types of organisation, though academic and
privately-owned organisations are likelier to be among these top researchers.  
Private organisations represent the overwhelming majority of all those taking
part in this research.

Analysis of the East Midlands network reveals that the top researching
organisations form hubs of research, wherein many organisations collaborate with
solely this top organisation.  
Comparing two different time periods in this network there is not much change
within the ecosystem in terms of distribution of collaboration among the
involved organisation. However, while the top academic and medical organisations
remain at the top, the private organisations involved vary over time. This
suggests private organisations do not always maintain the amount of research
they are involved with as consistently as these other types of organisations.

- What are the significant factors that influence collaboration between
  organisations?

Further aggregate analysis revealed that organisations are more likely to
collaborate with the top organisation when ranked by either amount of funding
received or the number of projects involved.  
This suggests a relationship between these attributes and one organisation's
decision to collaborate with these top organisations, perhaps due to this
indicating the quality or value of the research they engage in.

## Contributions

The project succeeded in going through the entire process of data warehousing
and analysis for a set of open data, as originally intended.  
Research did not bring up any other works that focused entirely on UKRI's
Gateway to Research database, and explored the dataset in its entirety. Previous
research involved creating systems around such open data, including EnAKTing
(@shadbolt2012linked) and Dbpedia (@auer2007dbpedia). While this project did not
go as far as creating an entire platform for users to perform their own
analysis, I believe some useful analyses were performed and that it provides a
valuable starting point from which to create such a platform.

By applying existing computational methods to an entire dataset in this project,
I believe it provides a useful case study that supports future research that
applies the chosen methods on open datasets. This includes difficulties
encountered in applying them, methods for circumventing or alleviating these
difficulties, and a data point from which to gauge their efficacy or
usefulness.

I also believe the projects provides additional insights into possible
improvements to open data platforms that would make similar future research
easier. Details provided about de-duplication and schema merging
performed during data cleaning could be applied by these open data platforms.  
E.g. by showing similar existing records in data entry forms in order to avoid
the creation of duplicate records.
The project found overlapping semantics in the schema used by the Gateway to
Research database, which may be a result of it encapsulating data from several
subsidiary organisations. UKRI could apply these findings by reviewing the
existing schema and applying changes to reduce this overlap.  
Lack of documentation about the Gateway to Research's schema required manual
work in exploring the structure of the dataset in order to convert it into a
relational schema that could be implemented by standard relational databases.
Similarly, documentation about the contents of the database tended to be
outdated or lacking in detail. In order to support use of their database by
researchers, improving this documentation is a step that UKRI could take.

## Reflections

What the project achieved differs from the original plan, mostly due to the time
constrictions of this project.  
While the data warehousing tasks were achieved in some capacity, the originally
planned analyses had to be cut down in order for the project to be completed on
time. This includes using correlation analysis and machine learning for
predicting possible collaboration, identifying technologies being researched,
and estimating the market readiness of those technologies.

Time spent on individual tasks was typically longer than planned (with the plan
laid out in the Gantt chart below). This was both due to the allocated time
being insufficient, and due to less focus being put on the project than it
required during the earlier periods of the project.
This is main reason for reducing the amount of analysis within the project.  
Initially The Decision Project (TDP), a business consultancy, intended to have a
more active part in the project by providing additional contextual data about
organisations within their own datasets. This would have opened up more
possibilities for analysing the impact of research on businesses, but required
more work be done to incorporate these datasets into the database formed in this
project.

While I planned to perform tasks in the order specified in the [Methodology], I
found myself continually going back to adjust previously done work, such as
adjusting the schema or de-duplication procedures.
This made keeping track of the pace of the project to be difficult, resulting in
tasks and priorities continually shifting as the project progressed.  
I ceased updating the work plan shown in the Gantt chart, as well not
tracking tasks with [Taskwarrior](https://taskwarrior.org) as originally
planned - I found having to do this regularly as plans shifted both unproductive
and demoralising. Instead of setting fixed dates by which to accomplish certain
things, I would have preferred to use a more agile project management
methodology such as Kanban @ahmad2013kanban.
In such a method, the tasks that compose the project could be laid out
individually, prioritised, and their dependencies linked. This would allow the
project plan to be flexibly adjusted when tasks take a different amount of time
to complete than predicted.

I also regret not using version control software from the beginning of the
project. I believe it would've provided additional help in managing the pace of
work and could have been paired nicely with a Kanban system - where logged
changes work towards completing individual tasks.
A version control system was applied to the project very late, where most of the
benefits were in the ability to tracking changes in documentation.

\begin{figure}[H]
	\centering
	\input{gantt}
	\caption{Gannt chart visualising the work plan for the project.}
	\label{fig:workPlan}
\end{figure}

\newpage

# Bibliography

<div id="refs"></div>

\newpage

# Appendix

## ukriDownload
\inputminted{bash}{scripts/ukriDownload}

## mergeXML
\inputminted{python}{scripts/mergeXML}

## ukriXmlToCsv
\inputminted{python}{scripts/ukriXmlToCsv}

## setup.sql
\inputminted{postgresql}{scripts/setup.sql}

## importGtrOrgs.sql
\inputminted{postgresql}{scripts/importGtrOrgs.sql}

## importGtrPersons.sql
\inputminted{postgresql}{scripts/importGtrPersons.sql}

## importGtrProjects.sql
\inputminted{postgresql}{scripts/importGtrProjects.sql}

## importGtrOutcomes.sql
\inputminted{postgresql}{scripts/importGtrOutcomes.sql}

## similarGtrOrgs.sql
\inputminted{postgresql}{scripts/similarGtrOrgs.sql}

## similarGtrPeople.sql
\inputminted{postgresql}{scripts/similarGtrPeople.sql}

## stats.sql
\inputminted{postgresql}{scripts/stats.sql}

## mergeGtrOrgs.sql
\inputminted{plpgsql}{scripts/mergeGtrOrgs.sql}

## mergeGtrPeople.sql
\inputminted{plpgsql}{scripts/mergeGtrPeople.sql}

## eastMidlandsGraphGephi.sql
\inputminted{plpgsql}{scripts/eastMidlandsGraphGephi.sql}

## eastMidlandsGraphNodeXL.sql
\inputminted{plpgsql}{scripts/eastMidlandsGraphNodeXL.sql}

\newpage

## Database schema manual

An technical description of the contents of the database schema, visualised in
figure \ref{fig:erd}.

### Organisations

#### gtrOrgs

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

#### gtrRegion: The regions an organisation can be based in:

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

### Projects

#### gtrProjects

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

#### gtrGrantCategory

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

#### gtrFunder

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

#### gtrSubjects

Research subjects associated with projects.  
83 records

| Field       | Type | Description                            |
|-------------|------|----------------------------------------|
| subjectUuid | uuid | Unique identifier                      |
| name        | text | Name of subject, as specified by users |

#### gtrProjectSubjects

Subjects that particular projects are associated with.  
Percentages are specified by users, each project can be associated with multiple
research subjects.  
78270 records

| Field       | Type    | Description                                           |
|-------------|---------|-------------------------------------------------------|
| subjectUuid | uuid    | Unique identifier of subject in gtrSubjects           |
| projectUuid | uuid    | Unique identifier of project in gtrProjects           |
| percent     | numeric | Percentage of project that is related to this subject |


#### gtrTopics

Research topics associated with projects.  
610 records

| Field     | Type | Description                          |
|-----------|------|--------------------------------------|
| topicUuid | uuid | Unique identifier                    |
| name      | text | Name of topic, as specified by users |

#### gtrProjectTopics

Topics that particular projects are associated with.  
Percentages are specified by users, each project can be associated with multiple
research Topics.  
150016 records

| Field       | Type    | Description                                         |
|-------------|---------|-----------------------------------------------------|
| topicUuid   | uuid    | Unique identifier of topic in gtrTopics             |
| projectUuid | uuid    | Unique identifier of project in gtrProjects         |
| percent     | numeric | Percentage of project that is related to this topic |

### Project outcomes

The outcomess of a project as logged by users

#### gtrDisseminations

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

#### gtrCollaborations

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

#### gtrKeyFindings

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

#### gtrFurtherFundings

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

#### gtrImpactSummaries

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

#### gtrPolicyInfluences

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

#### gtrResearchMaterials

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

### Links

#### gtrOrgPeople

Organisations that people in `gtrPeople` are linked to.  
82015 records

| Field      | Type | Description                     |
|------------|------|---------------------------------|
| personUuid | uuid | UUID of person in `gtrPeople`     |
| orgUuid    | uuid | UUID of organisation in `gtrOrgs` |

#### gtrProjectPeople

Individuals working on a particular project.  
201596 records

| Field       | Type          | Description                       |
|-------------|---------------|-----------------------------------|
| projectUuid | uuid          | UUID of project in `gtrProjects`    |
| personUuid  | uuid          | UUID of person in `gtrPersonRole`   |
| role        | gtrPersonRole | Role of individual in the project |

#### gtrPersonRole

Possible roles an individual can have in a project:

- `Principal Investigator`
- `Co-Investigator`
- `Project Manager`
- `Fellow`
- `Training Grant Holder`
- `Primary Supervisor`
- `Researcher Co-Investigator`
- `Researcher`

#### gtrProjectOrgs

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

#### gtrRelatedProjects

Projects that are related to one another in some way.  
25392 records

| Field        | Type               | Description                       |
|--------------|--------------------|-----------------------------------|
| projectUuid1 | uuid               | UUID of project in `gtrProjects`    |
| projectUuid2 | uuid               | UUID of project in `gtrProjects`    |
| relation     | gtrProjectRelation | Relationship between the projects |
| startDate    | date               | Start of related (2nd) project    |
| endDate      | date               | End of related (2nd) project      |

\newpage

\begin{sidewaysfigure}
	\subsection{Database schema}
	\centering
	\includegraphics[width=\textwidth]{erd}
	\caption{Entity Relationship Diagram describing the database schema}
	\label{fig:erd}
\end{sidewaysfigure}

\begin{sidewaysfigure}
	\subsection{Database schema (Initial design)}
	\centering
	\includegraphics[width=\textwidth]{initialErd}
	\caption{Entity Relationship Diagram describing the planned database schema,
		before changes were made throughout the implementation of the project}
	\label{fig:initialErd}
\end{sidewaysfigure}

\begin{sidewaysfigure}
	\subsection{East Midlands network (2002-2008)}
	\centering
	\includegraphics[width=0.9\textwidth]{midlands2002-2008}
	\caption{Funding network for organisations in the East Midlands within the
		years 2002 to 2008}
	\label{fig:midlands2002_2008}
\end{sidewaysfigure}

\begin{figure}
	\centering
	\includegraphics[width=0.7\textwidth]{midlands2002-2008/degree.png}
	\caption{Degree distribution of the East Midlands funding network
		(2002-2008), where nodes are organisations and edges are projects
		those organisations are collaborating on.}
	\label{fig:midlands2002_2008Degree}
\end{figure}

\begin{figure}
	\centering
	\includegraphics[width=0.7\textwidth]{midlands2002-2008/weightedDegree.png}
	\caption{Weighted degree distribution of the East Midlands funding
	network (2002-2008), where nodes are organisations, edges are projects
	those organisations are collaborating on, and the weight of edges is the
	total spent on the project between both organisations.}
	\label{fig:midlands2002_2008WeightedDegree}
\end{figure}

\begin{figure}
	\centering
	\includegraphics[width=0.7\textwidth]{midlands2002-2008/clustering.png}
	\caption{Clustering coefficient distribution of the East Midlands funding
	network (2002-2008), where nodes are organisations and edges are projects
	those organisations are collaborating on.
	It shows that organisations are much more likely to only be involved in a
	few collaborations, and organisations with high amounts of collaboration
	are few and far between.}
	\label{fig:midlands2002_2008Clustering}
\end{figure}

\begin{figure}
	\centering
	\includegraphics[width=0.7\textwidth]{nodeXLDegrees}
	\caption{Degree distribution of the East Midlands funding network
	(2005-2010), where nodes are organisations and edges are projects
	those organisations are collaborating on.
	It shows that organisations are much more likely to only be involved in
	a few collaborations, and organisations with high amounts of
	collaboration are few and far between.}
	\label{fig:midlands2005_2010Degree}
\end{figure}

\begin{sidewaysfigure}
	\subsection{East Midlands network (2005-2010)}
	\centering
	\includegraphics[width=0.9\textwidth]{midlands2005-2010}
	\caption{Funding network for organisations in the East Midlands within the
		years 2005 to 2010}
	\label{fig:midlands2005_2010}
\end{sidewaysfigure}
