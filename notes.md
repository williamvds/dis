# Aggregation

## Exporting

### GtR
- [Gateway to Research API](https://gtr.ukri.org)
- Parameters
	- `q`: query search term
	- `p`: page number
	- `s`: size of page, 10-100
	- `f`: fields

[scripts/ukriDownload] automates process of downloading in bulk, supports all
available types, adding a reasonable delay in between requests.

[scripts/mergeXML] combines these XML files into a single collection.

[scripts/ukriXmlToCsv] used to convert collections to CSV for usage by TDP.

## Database design

Design image created in draw.io.

Schema implemented in [scripts/setup.sql].

### GtR

1. Inspect schema, e.g. https://gtr.ukri.org/gtr/api/project
	- May require appending `view-source:` to the beginning of the URL
2. Create table structure that follows schema, adjust types as necessary
3. Add additional database attributes as necessary
4. Run setup script: `$ psql -U <username> -d <database> -a -f setup.sql`

## Importing

### GtR

1. Research how to import XML files into PostgreSQL databases
	- https://stackoverflow.com/a/33211885
2. Inspect schema, or XML file to identify its structure
	- Use `xmllint` to make visual inspection easier:
	  `$ xmllint --format $file -`
3. Create series of XPath queries for each field
	- Used to create a temporary table mapping the XML collection
4. Iterate temporary table and insert each row into the real table
	- Use casting as necessary to return the correct type
5. Copy XML collection to `/var/lib/postgres/data/`
	- All files referenced must be relative to this directory
6. Run import script: `$ psql -U <username> -d <database> -a -f <file>.sql`

- Some relationships aren't provided in the manual:
	1. Import keeping original `rel` values
	2. Find records of unknown types
	3. Check https://gtr.ukri.org for the display name

# Linking

## Cleaning

- PostgreSQL similarity comparison
	- https://stackoverflow.com/questions/11249635
	- https://dba.stackexchange.com/questions/103821
	- https://www.postgresql.org/docs/9.1/pgtrgm.html


# Analysis

## Identifying topics (technologies)

- Separate keywords within fields in topics and subjects
- Cluster related words by how often they coincide in a certain project
- Index score for current popularity
	- More recent projects results in greater score
- Research existing keyword vocab/jargon mappings

Outcomes:
- Graph of related terms
- Hierarchy of related terms, grouped under a technology
- Relationships between projects and terms
- Ability to search projects and money connected to a subject
	- Visualise popularity/funding over time

## Factors in collaboration

- Money: total amount received through history, average funding per project
- Prestige: total number of projects
- Outcomes: awards, commercialisation, intellectual property
- Physical proximity: region and country
- Historical ties: individuals/organisations shared between projects, legal
  agreements

Outcomes:
- Probability analysis for each factor: what is the chance that a randomly
  chosen pair of organisations share these factors?

## Market-readiness

- Model maturity cycle of technologies
- Use groupings of technologies from first analysis
- Search abstracts and findings for keywords
- Manually pick projects to search for indicators of maturity

## Predicting popularity

- Analyse individual technologies' popularity over time
- Apply some general popularity curves based on current data

# Documentation

## Dissertation

Use `listings` or `minted` to insert the contents of scripts:  
https://en.wikibooks.org/wiki/LaTeX/Source_Code_Listings

# Meetings

## 2019/10/18
### Data sources
EPSRC, Innovate UK, SBIR

List Sectors
https://gow.epsrc.ukri.org

Application driven Topological Data Analysis
https://gow.epsrc.ukri.org

Innovate UK
https://www.gov.uk

Find open data - data.gov.uk
https://data.gov.uk

Transparency and freedom of information releases
https://www.gov.uk

SBIR.gov
https://www.sbir.gov
## 2019-11-13
- discuss initial TDP presentation
- slideshow
	- timeline
	- goals
	- introduce UKRI, what the datasets look like
		- outcomes
		- individuals
		- companies
	- state what I plan to do with analysis
- visualisation
	- histograms
	- geo-maps
- business dataset
	- innovation trajectory
- network analysis
	- snap library stanford
- pipeline
	- data schema
	- applying indexing - explore performance of options
- starts writing subsections of thesis

- analysis
	- connections within topics
	- analysis within time blocks
	- collaborations with specific universities and businesses in different regions
		- does proximity matter?
	- predict
		- compare different date ranges
	- top companies in research over time
	- hype curve/cycle

# Worklog

## 2019/11/11
- Data collection from [EPSRC](https://gow.epsrc.ukri.org)
	- [EPSRC Visualisations](https://epsrc.ukri.org/research/ourportfolio/vop/)
	- [UKRI Gateway to Research API](https://gtr.ukri.org/resources/GtR-2-API-v1.7.1.pdf)

- Research exploring data with Gephi
	- Can use PostgreSQL backend
- [Importing XML data to PostgreSQL](https://stackoverflow.com/questions/19007884)

		- pick 3 techs, show support or dispute hype curve

## 2019/11/19
- importing data into PostgreSQL

## 2020/03/02
- NodeXL
	- find meanings of cost and offer
