---
subtitle: COMP3003 project proposal
date: October 23, 2019
header-includes:
	- \usepackage{gantt}
geometry: a4paper,margin=2cm
...

# Background and motivation

<!-- Introduction
What governments publish and why
Open Data vs. Open Government
-->

<!-- What governments publish and why -->
Many governments and their institutions regularly publish information due to
legal requirements of freedom of information and policies regarding open data.
The purposes of such policies are often to improve and maintain transparency in
government.  
Transparency is part of the implementation of the principle of open
government [@lathrop2010open], and is adopted in order to strengthen democracy,
regulate government behaviour, and promote government efficiency [@schauer2012].

<!-- Project's motivation -->
My motivation is to discover how existing open data and existing data publishing
platforms can used to perform specific research and reach useful conclusions.

<!-- Project's purpose -->
The purpose of this project is to exploit open government data to identify the
relationships between government funding, through grants and other investments,
and the development of businesses in various sectors.  
Data will be analysed with a variety of existing methods, including correlation
analysis, network analysis and visualisations. Finally, once the trends and
properties are derived some machine learning methods will be applied to make
predictions.

# Aims and objectives

The aim to leverage open government data about investment in research &
innovation and businesses in different development stages, to determine the
relationship between lavels of investment and the impact on businesses.


- Which small, medium, or large businesses are involved in research and
  development of specific technologies?
- Where are they receiving investment from, and what level of investment?
- How are these businesses and funding organisations linked?
- Is it possible to predict the impact of investment and likelihood of receiving
  investment?

Open government data will be used, along with business data from [The Decision
Platform](https://www.decisionplatform.io) (TDP):, a firm which uses data
analysis to support business decision making in product development and
innovation. TDP will be presented with the findings of this project to provide
feedback on how useful it could be to them.

This project will focus on data from the government of the United Kingdom,
including data from organisations that invest in research and innovation (i.e.
[UK Research and Innovation](https://www.ukri.org)).
Should data and time be available, this ecosystem will be compared against its
counterpart in the United States of America. See [Data Sources] for a collection
of potential data sources considered.

## Methodology

### Collecting and normalising data

In order to link and ultimately analyse the data, each dataset will parsed and
exported from their original format into a single database. Individual data
points will be extracted to normalise the data and enable subsequent
analysis.

Focus will be placed on datasets that are well-formatted and
machine-readable. Besides numeric and categorical data, processing text may also
be considered, using natural language processing techniques to extract data
points.

### Linking datasets

Datasets may refer to the same business or grant by different names, causing
duplicate entries in the database. In such cases similarity comparison
algorithms will be applied to automatically identify the single entity which is
being referred to. Some manual work will be performed to clean up remaining
duplicates.

### Analysing data

Research will be performed to identify tools that could be useful in analysis or
visualisation. Some time will also be spend developing software to apply
existing analysis, visualisation, and machine learning tools to the collected
data.

An initial network analysis will be performed on the linked data to identify
and visualise some interesting relationships between the entities.

A number of analysis algorithms will then be applied to explore these
relationships, including correlation analysis.
Regression machine learning techniques would be applied to create predicting
models for success and outcomes. Some methods being considered are
decision tree learning algorithms and artificial neural networks.

### Evaluating results

The outcomes of analysis and machine learning will be evaluated, and the
performance of predicting models will be tested. TDP will provide feedback on
usefulness and the potential impact it could have on their business.

# Work plan
\begin{center}
\begin{gantt}[xunitlength=1.2cm]{10}{8}
	% years
	\begin{ganttitle}
		\titleelement{2019}{3}
		\titleelement{2020}{5}
	\end{ganttitle}

	% months
	\begin{ganttitle}
		\titleelement{Oct}{1}
		\titleelement{Nov}{1}
		\titleelement{Dec}{1}

		\titleelement{Jan}{1}
		\titleelement{Feb}{1}
		\titleelement{Mar}{1}
		\titleelement{Apr}{1}
		\titleelement{May}{1}
	\end{ganttitle}

	% stages
	\ganttbar{Collecting and normalising data}{0.8}{1.2}
	\ganttbar{Linking datasets}{1.4}{1}
	\ganttmilestone{Interim report}{2.2}

	\ganttbar{Analysing data}{2.4}{3}
	\ganttcon{2.4}{3}{2.4}{5}
	\ganttbar{Evaluating results}{4.5}{2}
	\ganttmilestonecon{Dissertation submission}{6.7}

	\ganttbar{Presentation preparation}{4.5}{3}
	\ganttmilestonecon{Presentation \& demonstration}{7.5}
\end{gantt}
\end{center}

# Related resources

## Software

[WorldMap](https://worldmap.harvard.edu): An open-source platform for overlaying
data on a map, which could be used to visualise data points over different
regions.

[NodeXL](https://nodexl.com) and [Gephi](https://gephi.org) [@ICWSM09154]: graph
visualisation and analysis tools. Could be used to explore the textual
relationship between documents.

Stanford Natural Language Processor [@manning2014stanford]: A toolkit for
natural language processing. Could be used to extract data points from textual
documents, or during analysis of, e.g., grant descriptions.

## Data sources

[Data.gov.uk](https://data.gov.uk), [European Data Portal](https://europeandataportal.eu), [UK Transparency and FOI Releases](https://gov.uk/search/transparency-and-freedom-of-information-releases), [Data.gov](https://data.gov): catalogues datasets released by government institutions of the United Kingdom, European
Union, and United States of America respectively.

[The Decision Platform](https://www.decisionplatform.io): A consultancy
organisation that performs analysis on data to support business decision making.

# Related works

@shadbolt2012linked: Linking and exploring a number of datasets from
data.gov.uk. Datasets are organised into and linked through the Resource
Description Framework (RDF) format and a user interface allows
non-technical users to perform analysis.

@winkler2006overview: An overview of existing methods and research in the area
of record linkage.

@elmagarmid2006duplicate: Techniques for detecting duplicate records in a
database.

# Bibliography
