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
some of the responsibility of oversight - governments must make available
facts that could reveal misbehaviour or areas that could be improved.

Open government data often includes topics such as election statistics,
department budgets & expenditures, and significant individuals within
organisations. These topics are useful in identifying undesirable
behaviour like corruption and nepotism.  
Other areas such as statistics in crime, justice, and healthcare could be used
to check that a government is acting in the best interests of its citizens.

There are some unfortunate limitations in the way that governments publish open
data that don't properly follow the principles of open data, including not using
open formats and providing data in a manner which is not machine-readable.  
This makes the data harder to use by both inquisitive citizens who are
interested in finding out facts about their government, and by researchers
looking to perform quantitative research on the data available.

Consequentially, analysing open government data requires a few extra steps,
including:

- __Collecting__ datasets from multiple sources.
- __Cleaning__ data that is, e.g. sparse or invalid.
- __Linking__ data from the different sources, combining the available
	information.

# Motivation

This project's goal is to explore the value of open data and government
transparency.  
To achieve this, the project will discover how existing open data and existing
government data publishing platforms can used to perform specific research and
produce useful findings.  

My intention is to go through the entire process needed to a achieve this to
perform first-hand the steps necessary for research and the difficulties that
one faces in such data analysis projects.  
I believe that the current ways in which governments publish open data to be
lacking, such that potential applications of open data are being inhibited.  
The focus will be on open data published by the government of the United
Kingdom, and I hope to identify the areas where the UK's open data practices are
lacking to be able to suggest potential improvements to them.

# Related works and resources

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
The methods described in the paper will be useful when linking records in the
datasets I collect.

@elmagarmid2006duplicate: Techniques for detecting duplicate records in a
database are explored and explained in detail.  
Among other things, duplicate records in the datasets used will need to be
merged in order for the data analysis to produce high quality and accurate
results. This paper is a useful reference for methods that I could use to
perform this.

## Data sources

[UK Research and Innovation](https://www.ukri.org) (UKRI): A non-governmental
organisation that funds research and innovation in the UK through grants. It is
an umbrella organisation for several 'research councils' in several industries
and areas. Data on funding is made publicly available through the [Gateway to
Research](https://gtr.ukri.org) database. This provides details on each project,
organisations & individuals involved, and catalogues research outcomes as
summarised by the researchers. Relevant research papers produced during the
project are also listed.  
This is the main dataset that will be used throughout this project, as it
includes most information relevant to the intended research.

[The Decision Platform](https://www.decisionplatform.io) (TDP): A consultancy
organisation that performs analysis on data to support business decision making.
TDP have agreed to collaborate in this project, and are willing to provide the
data they have available on the businesses mentioned in the UKRI dataset.  
The data provided should nicely complement the UKRI dataset, which only provides
the names and addresses of organisations. Having extra context will help produce
more useful analysis into the impact of research on businesses.  
TDP are also keen to explore the potential value of information regarding
government funding, in particular identifying the level of development of
certain technologies and how close they are to market release.

[Data.gov.uk](https://data.gov.uk), [European Data Portal](https://europeandataportal.eu), [UK Transparency and FOI Releases](https://gov.uk/search/transparency-and-freedom-of-information-releases), [Data.gov](https://data.gov):
catalogues datasets released by government institutions of the United Kingdom,
European Union, and United States of America respectively.  
These could be used to provide additional context to the UKRI and TDP datasets,
if needed. Should time allow, research data from other regions such as the
United States may be explored, in a similar manner to the that of the United
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

The aim to leverage open government data about investment in research &
innovation and businesses in different development stages, to determine the
relationship between levels of investment and the impact on businesses within
various sectors.

## Research questions

The following questions were identified as being of particular interest to The
Decision Project, or as potential interesting analysis from preliminary research
and initial insights gained by exploring the available data.

- Which businesses are involved in research and development of specific
  technologies? Which are the up-and-coming players?
- What are the significant factors that influence collaboration between
  organisations?
- Is it possible to predict the change in popularity of certain research
  subjects over time?
- Is it possible to predict how close technologies are to reaching the market?

The Decision Project will be presented with the findings of this project to
provide feedback on how they could apply the collected data and findings to
their business.

## Technical description

This project will explore open government data from the United Kingdom relating
to grants and investment in research and development. Specifically, it will use
the Gateway to Research database from UK Research and Innovation.  
This dataset will be combined with data on businesses from The Decision Project,
which provides information such as financial performance.

These datasets will be aggregated, normalised, and linked so that all available
information can be used during the project's research. This will involve
translating the schema of these datasets into a single schema, which will be
implemented using the PostgreSQL database management system.

Focus will be placed on applying existing data analysis and machine
learning techniques on these datasets which contain both structured and
unstructured data.  
Network analysis methods will be used to identify the relationships between
entities in the datasets. Correlation analysis will be performed to answer
questions based on historical data.  
Visualisations will be created to show the identified relationships and other
findings.  
Machine learning methods such as decision trees and artificial neural networks
will be applied to perform predictive analyses required by some research
questions. This will require identifying the most significant attributes within
the dataset that contribute best to answering the questions.  
Each method applied will be evaluated to identify each performs with respect to
the accuracy or usefulness of findings or predictions. For example, a predictive
model for the popularity of a subject over time could be tested against
historical data.

\newpage

# Methodology

(1) __Data aggregation__
	(i) Datasets will be exported from the UKRI Gateway to Research database
	(i) Data points will be extracted and normalised where necessary
	(i) A database schema will be designed
	(i) Records will be imported into a single relational database  
	\
	In order to link and ultimately analyse the data, each dataset will parsed
	and exported from their original format into a single database. Individual
	data points will be extracted to normalise the data, such that it can be
	stored in a relational database.  
	A database schema will need to be designed so that records from all datasets
	are available in a single relational database. This will enable relationship
	analysis and other future analyses.  
	Focus will be placed on data that is well-formatted and machine-readable.
	Besides numeric and categorical data, processing text may also be
	considered, using natural language processing techniques to extract data
	points.
\
(1) __Linking datasets__  
	(i) Low-quality or invalid records will be discarded
	(i) Duplicate records will be merged
	(i) Research into appropriate linking methods will be performed
	(i) Records that refer to the same entity will be linked or merged  
	\
	Some records refer to non-existent entities, such as unnamed businesses
	listed as participants in research projects. These records are unusable
	for the purposes of this project, so they will need to be identified and
	removed. These records are identifiable by their similar names and lack of
	other details.  
	Datasets may refer to the same business or grant by different names, causing
	duplicate entries in the database. In such cases similarity comparison
	algorithms will be applied to automatically identify the single entity which
	is being referred to. Some manual work will be performed to clean up
	remaining duplicates.
\
(1) __Analysing data__  
	(i) Useful tools will be researched and tested
	(i) Network analysis will be used to identify relationships
	(i) Analysis will be performed to answer the desired questions
	(i) Machine learning will be applied to perform predictions
	(i) Software will be developed to perform analysis, visualisation, and
	learning
	(i) Visualisations will be created to show relationships and other results  
	\
	Research will be performed to identify tools that could be useful in
	analysis or visualisation. Some time will also be spend developing software
	to apply existing analysis, visualisation, and machine learning tools to the
	collected data.
	\
	An initial network analysis will be performed on the linked data to identify
	and visualise some interesting relationships between the entities.
	\
	A number of analysis algorithms will then be applied to explore these
	relationships, including correlation analysis.
	Regression machine learning techniques would be applied to create predicting
	models for success and outcomes. Some methods being considered are
	decision tree learning algorithms and artificial neural networks.
\
(1) __Evaluating results__  
	(i) Outcomes of analysis will be evaluated
	(i) The accuracy of machine learning models will be tested and evaluated
	(i) Conclusions will be made to answer the desired questions
	(i) TDP will be presented with results and provide feedback  
	\
	Relationships identified through network analysis will be evaluated to
	explore how well they answer the research questions. Machine learning
	analyses performed will be tested to identify their accuracy from the
	available data, and different algorithms used to perform the same analysis,
	e.g. how well one can be used to predict collaboration between two parties.  
	TDP will provide feedback on usefulness and the potential impact the
	findings could have on their business.

# Design

## Database

Aggregated data will be imported into a single relational database management
system, which will enable analysis through queries composed in the Structured
Query Language (SQL).  
The schema of the database is designed to be _normalised_, such that each atomic
piece of information is stored in an individual field. This minimises data
duplication - particularly helpful when handling large databases such as in this
project - as well as enabling analysis of individual components of records.

All aggregated data will be kept in the database so that it can be used
throughout the project. As a result some information may be duplicated, as
records can be duplicated within and between data sources.  
In order to differentiate between the sources of data, tables containing data
from the Gateway to Research database are prefixed with 'gtr'.
All other tables contain data formed from this project.

The design for data from the Gateway to Research database is based partially on
the contents of the GtR API manual [@gtrapi2manual], which explains the contents
of the records returned by the API.  
In occasions where the manual provided inaccurate or incomplete information, the
XML schema of records and some exported records were visually inspected to
identify how best to normalise each type of record. For example, the XML schema
for individuals is available [through the REST
API](https://gtr.ukri.org/gtr/api/person).  

The Entity Relationship Diagram in figure \ref{fig:erd} describes the tables
that exist in the database schema, including their fields and relationships to
other tables.

\newpage

# Implementation

## Aggregating data

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
<ns2:organisations xmlns:ns1="http://gtr.rcuk.ac.uk/gtr/api" xmlns:ns6="http://gtr.rcuk.ac.uk/gtr/api/project/outcome" xmlns:ns5="http://gtr.rcuk.ac.uk/gtr/api/project" xmlns:ns3="http://gtr.rcuk.ac.uk/gtr/api/fund" xmlns:ns4="http://gtr.rcuk.ac.uk/gtr/api/person" xmlns:ns2="http://gtr.rcuk.ac.uk/gtr/api/organisation" ns1:page="1" ns1:size="20" ns1:totalPages="2425" ns1:totalSize="48487">
	<ns2:organisation ns1:created="2020-01-28T17:07:16Z" ns1:href="https://gtr.ukri.org:443/gtr/api/organisations/D446F3B8-D9C3-4B5B-82CA-07608A3C27A9" ns1:id="D446F3B8-D9C3-4B5B-82CA-07608A3C27A9">
		<ns1:links>
			<ns1:link ns1:href="https://gtr.ukri.org:443/gtr/api/projects/0332EDF4-D2F1-4889-BE74-F28BCADC90F5"
				ns1:rel="PROJECT"/>
			<!-- More project links -->
			<ns1:link ns1:href="https://gtr.ukri.org:443/gtr/api/persons/88AC732B-1650-42A1-B4B5-82E7BD395962"
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
(Bash)](https://www.gnu.org/software/bash) for the GNU/Linux operating system as I am familiar with both and use them extensively on my personal computers.  
Additional command-line tools were used, including: xmllint from
[libxml2](http://xmlsoft.org) for XML manipulation, [GNU
Awk](https://www.gnu.org/software/gawk) for text processing, and
[curl](https://curl.haxx.se) for downloading web pages.  
All this software is free, open source, and fairly popular, meaning that
anyone who wishes to reproduce or extend this research may do so easily. These
tools were chosen as they easily enable the automation of the main process of
experting data: downloading a series of files from the internet.

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

## Importing data

The final database design is visualised figure \ref{fig:erd}, and
was applied to the PostgreSQL database management system. The implementation of
the schema is in a SQL file provided in appendix section [setup.sql].

Adjustments were made to the original design (shown in figure
\ref{fig:initialErd}) after more in-depth analysis of the contents of the GtR
database. This resulted in additional tables being
created, such as `gtrTopics`, `gtrProjectSubjects`, and `gtrDisseminations`.

PostgreSQL has good support for importing structured XML data, though the
structure of the XML records must be mapped to the relational and normalised
structure of the database schema.  
An SQL procedure was produced for the importing of each record type:
organisations, individuals, projects, and project outcomes. These are provided
in the appendix: [importGtrOrgs.sql], [importGtrPersons.sql],
[importGtrProjects.sql], and [importGtrOutcomes.sql].

The SQL procedures extract individual data points from records through XPath
queries against the XML data. Similarly to the design of the database schema,
these were developed through a combination of inspecting the XML schema as well
as some extracted records.  
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

<!-- TODO: reference to details about XPath -->

\newpage

## Cleaning data

Data cleaning is an important step that precedes data analysis: it ensures that
the data used during analysis is of high quality, including being free of errors
and that records contain the information that is needed for them to be analysed.
The use of low quality data negatively impacts the results of its analysis,
resulting in less useful outcomes (@rahm2000data).

The Gateway to Research database is a collection of databases maintained by
subsidiaries of UKRI, as well as UKRI's own database. It thus contains
information entered by researchers and other individuals involved in the grant
funding process.  
As a result, human error can result in erroneous data being
entered, or duplicate records being created for entities that already have a
record in the database. These problems are classified as 'single-source'
problems, as they occur even a single database is being considered.  
The introduction of multiple databases then introduce 'multi-source problems',
such as different encodings for the roles of organisations, or different
monetary systems being used for currency values.

In order to make the development and further steps of this project simpler, the
processes undertaken to clean data avoided removing or modifying any data
imported from the Gateway to Research database. Instead, new database tables
and/or fields were created to store information during the cleaning process, as
well as storing the outcomes of cleaning: merged records.

### Eliminating junk records

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
to the junk records collection.

As a result, 5213 of 47822 (10.9%) organisation records were marked as junk
records.

### Organisation roles

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

As explored by (@winkler2006overview) there are many existing methods for
identifying duplicate records, most of which involve comparing the similarity of
text within records.

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

### Preliminary analysis

Visual exploration of data revealed small variations with how organisation names
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

My first attempt in running these scripts involved calculating the similarity of
every pair of records, but this failed after a significant amount of time, once
it had completely filled the remaining 50GB or so available on the storage
device the database was being stored.  
In order to avoid this, I filtered pairs by requiring that they share at least
50% of trigrams in their names. This allows the
amount of data generated from this procedure to be significantly reduced, down
to 243363 from 1151976000 rows for organisations.  

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

1. Neither of the pair is listed as a junk record
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
The same is not true of people, due to the popularity and wide re-use of names
within populations.

Using name comparison is more effective when common variations of the same words
or names are substituted for a single variation before comparison. However, this
approach is limited by the requirement of domain knowledge being applied or a
significant amount visual inspection being done.

Name comparisons are more reliable when combined with the comparison of other
information available, such as the addresses of organisations, or people's
employers.

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

## Visualisations

### East Midlands network with Gephi

I used [Gephi](https://gephi.org), a graph analysis tool, to plot the network of
organisations based in the East Midlands region or Nottingham.  
This software was chosen as it is free and open source, and so it costs nothing
to use. Documentation also suggested it was easy to use, which would enable me
to quickly get to grips with the application in order to use it in this project.
Through research I also found that it includes several features that enable
network analysis and visualisation, the possibilities of which I was keen to
apply to explore.  
Organisations were selected if they had 'East Midlands' specified as their
region.

In the graph, nodes represent organisations, and edges represent projects that
both organisations were involved in.  
Data was exported from the database using [scripts/eastMidlandsGraphGephi.sql],
then imported into Gephi through the [import
spreadsheet](https://github.com/gephi/gephi/wiki/Import-CSV-Data) wizard.
This includes organisation records (used as the nodes) and projects that pairs
of those organisations were both involved in (used as the edges).
Organisation records were inspected for duplicates by sorting by name, and some
were manually merged within Gephi.  
In order to make the network explorable through different periods of time, the
start and end date of projects were merged to create the interval during which
the edges apply.

Edges were filtered to projects that were active within the years 2002-2008,
then Yifan Yu's propertional graph layout algorithm (@yhugraph) was applied.
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

While Gephi supports importing data directly from a database through queries,
I encountered difficulties when attempting to use this feature with long queries
and large amounts of data.  
I instead opted to create procedures that exported the needed data to Comma
Separated Values (CSV) files, a common plaintext format, and then imported these
files manually into Gephi.

### East Midlands network with NodeXL

[NodeXL](https://www.smrfoundation.org/nodexl) is an add-on for Microsoft Office
Excel by the Social Media Research Foundation, originally developed to explore
and analyse social media networks. It can be used to explore any network,
however.
NodeXL was recommended by my supervisor, who had previously used it in her
research, and kindly provided a training session on using it.  
As the University provides complimentary access to the Microsoft Office suite,
and a free version is provided, I decided to try applying it to this project.

Similarly to the Gephi network, I filtered organisations to the East Midlands
region, so that the network is of a more manageable size. I decided to explore a
different year range for projects, from 2005 to 2010 instead. As a result, the
differences in the networks can be explored.

The procedure for exporting this data is provided in
[eastMidlandsGraphNodeXL.sql].

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

## Analysis

### Important factors in collaboration

<!--
Analyse key factors that affect likelihood of collaboration
- physical location
- previous collaboration (individuals or organisation)
- pedigree of organisation (cost or amount of previous research)
-->

#### Amount of research

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

#### Amount of funding

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

## Contributions and Reflections

## Project Management

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

\begin{sidewaysfigure}
	\subsection{East Midlands network (2005-2010)}
	\centering
	\includegraphics[width=0.9\textwidth]{midlands2005-2010}
	\caption{Funding network for organisations in the East Midlands within the
		years 2005 to 2010}
	\label{fig:midlands2005_2010}
\end{sidewaysfigure}
