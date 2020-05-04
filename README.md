# Linking and Exploring Data: Business Investment, Research and Grants

BSc Thesis at University of Nottingham, 2020

## Reproducing work

1. Install PostgreSQL & set up a database + user
2. Download data using `scripts/ukriDownload` Bash script
3. Copy resulting XML files into PostgreSQL data directory (e.g.
   `/var/lib/postgres/data`)
	- Just the merged `organisations.xml`, `projects.xml`, etc. is needed
	- Make sure they're readable by the user that runs PostgreSQL (usually
	  `postgres`)
4. Run the main procedure, e.g.: `psql -U user -d database -f scripts/main.sql` 

## Creating report

Run `make dissertation.pdf`

Dependencies:
- [pandoc](https://pandoc.org)
- [pgfgantt](https://www.ctan.org/pkg/pgfgantt)
- [pgfplots](https://www.ctan.org/pkg/pgfplots)
