# Linking and Exploring Data: Business Investment, Research and Grants

BSc Thesis at University of Nottingham, 2020

## Reproducing work

1. Install PostgreSQL & set up a database + user
	- Setup database UTF-8 encoding and the GB locale for currency:
	  `$ sudo -u postgres initdb --lc-monetary=en_GB.UTF-8 -E UTF8 -D
	  /var/lib/postgres/data`
	- Create the database: `$ sudo -u postgres createdb dis`
	- Create user with superuser privileges in order to create extensions, and
	  have full access to the database:
	  `$ sudo -u postgres createuser -U dis -s && psql -U postgres -d dis -c
	  'GRANT ALL ON DATABASE dis TO dis'`
2. Download data using `scripts/ukriDownload` Bash script
3. Copy resulting XML files into PostgreSQL data directory (e.g.
   `/var/lib/postgres/data`)
	- Just the merged `organisations.xml`, `projects.xml`, etc. is needed
	- Make sure they're readable by the user that runs PostgreSQL (usually
	  `postgres`)
4. Run the main procedure, e.g.: `psql -U dis -d dis -f scripts/main.sql` 

## Creating report

Run `make dissertation.pdf`

Dependencies:
- [pandoc](https://pandoc.org)
- [pgfgantt](https://www.ctan.org/pkg/pgfgantt)
- [pgfplots](https://www.ctan.org/pkg/pgfplots)
