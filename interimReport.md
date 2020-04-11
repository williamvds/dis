---
title: |
	| Linking & Exploring Open Government Data:
	| Business Investment and Grants
subtitle: COMP3003 Interim Report
author: |
	| William Vigolo da Silva
	| BSc Hons Computer Science with Year in Industry
	| psywv@nottingham.ac.uk
	| 4279225
date: December 9, 2019
toc: true
link-citations: true
links-as-notes: true
docmentclass: article
header-includes:
	- \usepackage{pgfgantt, rotating, float}
	- \input{ganttExt}
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
behaviour like corruption, nepotism.  
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

\newpage

# Motivation

<!-- Project's motivation -->
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
manage any databases.

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
the Gateway to Research database from UK Research and Innovation. This dataset
will be combined with data on businesses from The Decision Project.

This project will focus on data from the government of the United Kingdom,
including data from organisations that invest in research and innovation (i.e.
[UK Research and Innovation](https://www.ukri.org)).
Should data and time be available, this ecosystem will be compared against its
counterpart in the United States of America. See [Data Sources] for a collection
of potential data sources considered.

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
Machine learning methods such as decision trees and artificial neural networks
will be applied to perform predictive analyses required by some research
questions. This will require identifying the most significant attributes within
the dataset that contribute best to answering the questions.  
Visualisations will be created to show the identified relationships and other
findings.  
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
	algorithms will be applied to automatically identify the single entity which is
	being referred to. Some manual work will be performed to clean up remaining
	duplicates.
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
All collected data will be stored into a single database so that it can be
explored through a variety of queries. I aim to avoid deleting any data so
everything remains available should it be needed. As a result, the database
schema design results in some data duplication where appropriate.  
In order to differentiate between the sources of data, tables containing data
from the Gateway to Research database are prefixed with 'gtr', while tables with
data from TDP are prefixed with 'tdp'. All other tables contain data formed from
this project.  
The Entity Relationship Diagram in figure \ref{fig:erd} describes the tables
that currently exist in the database schema, including their fields and
relationships to other tables.

\newpage

## Visualisations
Some visualisations are in the process of being designed, which will display the
results of analysis.  
The following figure visualises the businesses that have invested the most in a
specific research topic:

\begin{figure}[H]
	\centering
	\includegraphics[width=0.7\textwidth]{pics/visSubjectPlayers}
	\caption{A visualisation of the companies that invest the most in a specific
	research category}
	\label{fig:visSubjectPlayers}
\end{figure}

\newpage

# Implementation

## Downloading data
A shell script was written that uses the UKRI Gateway to Research (GtR) API. As
the GtR API restricts downloading to 100 records per query, the script downloads
all available pages into individual XML files, then combines them into a single
XML file. Combining pages into a single file makes importing into a database a
simpler process.  
An auxiliary program was created to perform this combining -
see section [Combining downloaded records].

The source code of the program is provided in the appendix section
[downloadUkri].

## Merging downloaded records

In order to merge the XML files an auxiliary program was created.  
Each page of downloaded records is an individual XML file, with records
contained in a single wrapping XML element. As an example, pages of organisation
records follow a structure like the following:

```xml
<?xml version="1.0" encoding="utf8"?>
<ns0:organisations xmlns:ns0="...">
  <ns0:organisation ns1:created="...">
	<!-- Record information -->
  </ns0:organisation>

  <ns0:organisation>
  </ns0:organisation>

  <ns0:organisation>
  </ns0:organisation>
</ns0:organisations>
```

In order to combine the pages, the program collects the inner records, e.g.
`ns0:organisation`s, into a single outer `ns0:organisations`.

The source code of the program is provided in the appendix section [mergeXML].

## Converting records to CSV
It was necessary to convert the available organisation data into Comma Separated
Values (CSV) format, to provide TDP with the list of organisations this project
needs data about.  
This was performed using another Python program, enabling the names and
addresses of organisations to be exported.  
While organisations can have multiple addresses, the vast majority do not, so
the first address specified is taken to be the primary address and is the only
one provided.

The source code of the program is provided in the appendix section
[ukriXmlToCSV].

## Database schema
The design outlined in the [Database schema] section has been applied to the
PostgreSQL database management system.

The implementation is in a Structured Query Language (SQL) file, provided in
appendix section [setup.sql].

## Importing data
Once the database schema has been applied and all dataset records are available
in XML form, they need to be imported into the database.

For organisations, a similar approach as in [Converting records to CSV] is
followed - the first available address is taken, along with the specified name.  
The given ID is used as the primary key for the new record.

The implementation for importing organisation data is in a Structured Query
Language (SQL) file, provided in appendix section [importOrgs.sql].

\newpage

# Progress

## Project management

<!-- Past -->
While consistent has been performed on the project, the overall pace of the
project has slower than planned, resulting in less progress than was expected at
this point in time.

Work on linking datasets was expected to have started by this date, but only
some parts of task 2.1 has been performed. The collection of organisations that
I exported from the UKRI dataset is being used by TDP, who are linking it
against their own database of company information. As a result, less work on my
end will be needed to link records, though it will be delayed until TDP have
completed their own linking and are able to send their dataset my way.  
In the future I will keep regular contact with my collaborators at TDP in order
to avoid making assumptions about when they will be able to fulfill my requests.
As a result, the start date in my planned timeline for record linking has been
clarified, and has been extended further to the start of the new year.

The time dedicated to research was also something I underestimated. Examples of
such research included finding the precise datasets to use, developing a process
for downloading datasets automatically, and learning how to import XML datasets
into a relational database management system.  
As a result of more work in this area, plans for the project have become more
precise. The UKRI dataset has been identified as the main subject for research,
and a meeting with TDP clarified some research questions that they would be
interested in answering.

Progress was slowed down by coursework, which was previously not considered
in my proposal. There were a few weeks where parallel courseworks resulted in my
focus being drawn away from the project.  
In order to compensate for the delay, the timeline for data collection and
normalisation has been extended by a couple of weeks.
I have also made adjustments to the planned timeline to ensure that spring
examples are compensated for, as I expect progress will be much slower during
the exam period.

<!--
- bad predictions
- blockage from coursework, TDP, and needing more research
-->

<!-- Gantt timeline -->
The initial Gantt chart provided in my proposal was very high-level, including
only the major steps of data collection, record linkage, analysis, evaluation,
and some discrete documentation tasks. These tasks were shown in the context of
specific deadlines during the dissertation process.  
However, I now see that I should have properly broken down tasks into their
composite parts, as well as explicitly mentioning certain tasks.
Subtasks have been identified in the [Methodology] section of this report, which
are now included in the Gantt chart. Some additional tasks have also been added,
including writing this interim report and other documentation, performing
research into methods & tools, and creating designs for the database.

I've now amended the Gantt chart with these tasks. The chart also has corrected
the timeline of work that has been performed.  
There is still much overlap between the subtasks of the major steps, as I expect 
many of these tasks will be done in parallel. For example, while researching
potential tools for analysis I will be testing them on the available data to
find some interesting relationships.

From now on, I plan to use a task management tool,
[Taskwarrior](https://taskwarrior.org), to
automatically prioritise and track my work on the project. By using it regularly
it will ensure that the rate of progress is maintained over time, and that
planned deadlines are kept to.

## Contributions and reflections

Overall, I am happy with the direction that the project is taking; my plans have
developed since the proposal stage, becoming more precise after further research
into available data and a conversation with TDP about what they hope this
project can provide them.  
This has inspired greater confidence in the belief that the goals of this
project are achievable and valuable. The project has good potential to be both
commercially useful for TDP, and succeed in my original goal to explore how open
government data can be used in research.

As explored in the [Project management] section, I am currently unhappy with the
pace of progress of project. In hindsight, I should have started working on the
initial stages of the project sooner, and kept up a consistent pace -
the planned timeline has already been adjusted to account for this.  
This project is my first practical experience in the area of data mining,
analysis, and machine learning; as a result, it is difficult to accurately judge
how long each stage will take to research and apply.  
Another factor not considered during the initial planning stage was the
imbalance in the workload between the autumn and spring semesters: 70 credits
in the autumn semester means I have to dedicate more time to tasks other than my
dissertation. Therefore, I expect the pace to pick up during the spring
semester.  
Should I find it difficult to keep to deadlines for multiple tasks in the
project, I will reduce the scope of the project so that key deadlines can be
met. Conversely, should I find myself with additional time after completing all
planned work, I may explore additional analyses or datasets.

\newpage

# Work plan
\input{gantt}

\newpage 

# Bibliography

<div id="refs"></div>

\newpage

# Appendix

## Database schema

\begin{sidewaysfigure}
	\centering
	\includegraphics[width=\textwidth]{erd}
	\caption{Entity Relationship Diagram describing the database schema}
	\label{fig:erd}
\end{sidewaysfigure}

\newpage

## downloadUkri

```bash
#!/usr/bin/env bash
URL='https://gtr.ukri.org/gtr/api/'
PAUSE=4
NUM_PAGES_XPATH='string(/*/@*[local-name()="totalPages"])'
OUTPUT='.'

# Parse options: https://stackoverflow.com/a/14203146
TYPES=()
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
	-o|--output)
		OUTPUT="$2"
		shift 2;;
	-u|--url)
		URL="$2"
		shift 2;;
	-p|--pause)
		PAUSE="$2"
		shift 2;;
	-x|--pages-xpath)
		NUM_PAGES_XPATH="$2"
		shift 2;;
	*)
		TYPES+=("$1")
		shift;;
esac
done

set -- "${TYPES[@]}"

if [ "${#TYPES[@]}" == 0 ]; then
	echo "No record types specified"
	exit 1
fi

for typ in "$TYPES"; do
	case "$typ" in
		c*)  recordType='classifications';;
		or*) recordType='organisations';;
		ou*) recordType='outcomes';;
		pe*) recordType='persons';;
		pr*) recordType='projects';;
		pu*) recordType='publications';;
		*) (>&2 echo "Unknown record type '$typ' - skipping"); continue;;
	esac

	url="$URL$recordType"
	mkdir -p "$OUTPUT/$recordType"

	function getPageURL {
		echo "$url?p=$1&s=100"
	}

	function getPageFile {
		echo "$OUTPUT/$recordType/$(printf '%04d' "$1").xml"
	}

	function xmlCount {
		awk '{s+=$1} END {print s}' <(xmllint --xpath 'count(/*/*)' $*)
	}

	file1="$(getPageFile 1)"
	curl "$(getPageURL 1)" -so "$file1"
	numPages=$(xmllint --xpath "$NUM_PAGES_XPATH" "$file1")

	echo "Total pages: $numPages"

	for i in $(seq 2 $numPages); do
		file="$(getPageFile $i)"
		[ -f "$file" ] && continue
		sleep "$PAUSE"
		echo "Downloading page $i of $numPages"
		curl "$(getPageURL $i)" -so "$file"
		[ $? ] || break
	done

	merged="$OUTPUT/$recordType.xml"
	pages="$OUTPUT/$recordType/*.xml"
	if ! [ -f "$merged" ] || \
	   ! [ "$(xmlCount "$merged")" = "$(xmlCount "$pages")" ]; then
		echo "Merging into a single file..."
		./mergeXML "$pages" >"$merged"
	else
		echo "Merged file contains all records: $merged"
	fi
done
```

## mergeXML

```python
#!/usr/bin/env python
# Adapted from https://stackoverflow.com/questions/9004135
import sys

from xml.etree import ElementTree

def run(files):
	first = None

	for filename in files:
		data = ElementTree.parse(filename).getroot()

		if first is None:
			first = data
		else:
			first.extend(data)

	if first is not None:
		print(ElementTree.tostring(first, encoding='utf8').decode('utf-8'))

if __name__ == "__main__":
	run(sys.argv[1:])
```

## ukriXmlToCsv
```python
#!/usr/bin/env python3
'''Convert a UKRI XML dataset to CSV.
Expected format is:
<records>
    <record></record>
    ...
</records>

Children of records will be flattened, with only the first sub-child being kept.
'''

import argparse, csv, re, io, sys, os, xml.etree.ElementTree as ET
from typing import List, Optional
import os.path as path

usage_example = '''example: \
    ukriXmlToCsv \
        --fields name line1 line2 line3 line4 line5 postCode country \
        --output . \
        organisations.xml'''

parser = argparse.ArgumentParser(
    description='Convert UKRI XML record collections to CSV',
    epilog=usage_example)
parser.add_argument('--fields', '-f',
    nargs='+', metavar='pattern', action='extend', type=str,
    help='patterns of fields to include in the output')
parser.add_argument('--output', '-o',
    default='.',
    help='output directory for the converted files')
parser.add_argument('files',
    metavar='file', nargs='+',
    help='XML files to convert')

args = parser.parse_args()

os.makedirs(args.output, exist_ok=True)

def strip_namespace(field_tag: str) -> str:
    '''Remove the namespace from a field's tag'''
    i = field_tag.find('}')
    if i >= 0:
        field_tag = field_tag[i + 1:]
    return field_tag

def match_field_name(field: ET.Element) -> Optional[str]:
    '''Return whether a field with a specific tag should be filtered, according
    to the ignored field filters'''
    field_name = strip_namespace(field.tag)
    for pattern in args.fields:
        if re.match(pattern, field_name):
            return pattern
    return None

def filter_fields(fields: List[ET.Element]):
    return list(filter(lambda f: match_field_name(f) != None, fields))

def xml_to_csv(fname: str) -> str:
    output = io.StringIO()
    tree = ET.parse(fname, parser=ET.XMLParser(encoding='utf-8'))

    writer = csv.DictWriter(output, fieldnames=args.fields, delimiter=',')
    writer.writeheader()

    for record in tree.getroot():
        record_dict: dict[(str, str)] = dict()
        fields = filter_fields(list(record))

        # Flatten fields
        for field in record:
            children = list(field)
            if children:
                if len(children) > 1:
                    print('Warning: more than one child in flattened field ' \
                          f"{field.tag}", file=sys.stderr)
                fields.extend(filter_fields(field[0]))

        for field in fields:
            field_name = match_field_name(field)
            if field_name:
                record_dict[field_name] = field.text.strip()

        writer.writerow(record_dict)

    return output.getvalue()

for f in args.files:
    csv = xml_to_csv(f)
    csv_name = path.join(args.output,
        path.splitext(path.basename(f))[0] + '.csv')

    with open(csv_name, 'w', encoding='utf-8') as out:
        out.write(csv)
```

## setup.sql
```sql
-- Run with
-- $ psql -U <username> -d <database> -a -f setup.sql

-- Enable uuid type extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

DO $$ BEGIN
	CREATE TYPE gtrRegion as ENUM(
		'Unknown',
		'Outside UK',
		'East Midlands',
		'North West',
		'Wales',
		'Scotland',
		'Northern Ireland');
EXCEPTION
	WHEN duplicate_object THEN null;
END $$;

-- based on https://gtr.ukri.org/gtr/api
-- and https://gtr.ukri.org/gtr/api/organisation
CREATE TABLE IF NOT EXISTS gtrOrgs(
	orgUuid uuid primary key not null,
	name text not null,
	address1 text,
	address2 text,
	address3 text,
	address4 text,
	address5 text,
	postCode text,
	city text,
	region gtrRegion not null,
	country text);

-- based on https://gtr.ukri.org/gtr/api/project
CREATE TABLE IF NOT EXISTS gtrProject(
	projectUuid uuid primary key not null,
	title text not null,
	status text,
	category text,
	leadFunder text,
	abstract text,
	techAbstract text,
	potentialImpact text,
	start date,
	end date);
```
## importOrgs.sql

```sql
-- Run with
-- $ psql -U <username> -d <database> -a -f setup.sql
-- Ensure the organisations.xml file exists in the PostgreSQL data directory
DO $$
DECLARE
	xmlRecords xml;
	org record;
	nss text[][2] := array[
		array['api', 'http://gtr.rcuk.ac.uk/gtr/api'],
		array['org', 'http://gtr.rcuk.ac.uk/gtr/api/organisation']
	];
BEGIN

xmlRecords := XMLPARSE(
	DOCUMENT convert_from(pg_read_binary_file('organisations.xml'), 'UTF8'));

DROP TABLE IF EXISTS xmlImport;
CREATE TEMP TABLE xmlImport AS
SELECT 
	uuid((xpath('//@api:id', x, nss))[1]::text) AS uuid,
	(xpath('//org:name/text()', x, nss))[1]::text AS name,
	(xpath('//org:addresses[1]/api:address/api:line1/text()',    x, nss))[1]::text AS line1,
	(xpath('//org:addresses[1]/api:address/api:line2/text()',    x, nss))[1]::text AS line2,
	(xpath('//org:addresses[1]/api:address/api:line3/text()',    x, nss))[1]::text AS line3,
	(xpath('//org:addresses[1]/api:address/api:line4/text()',    x, nss))[1]::text AS line4,
	(xpath('//org:addresses[1]/api:address/api:line5/text()',    x, nss))[1]::text AS line5,
	(xpath('//org:addresses[1]/api:address/api:postCode/text()', x, nss))[1]::text AS postCode,
	(xpath('//org:addresses[1]/api:address/api:city/text()',     x, nss))[1]::text AS city,
	(xpath('//org:addresses[1]/api:address/api:region/text()',   x, nss))[1]::text AS region,
	(xpath('//org:addresses[1]/api:address/api:country/text()',  x, nss))[1]::text AS country
FROM unnest(xpath('//org:organisations/*', xmlRecords, nss)) x;

FOR org IN
	SELECT * FROM xmlImport
LOOP
	INSERT INTO gtrOrgs VALUES(
		org.uuid,
		org.name,
		org.line1,
		org.line2,
		org.line3,
		org.line4,
		org.line5,
		org.postCode,
		org.city,
		org.region,
		org.country
	);
END LOOP;

END$$;

DROP TABLE xmlImport;
```
