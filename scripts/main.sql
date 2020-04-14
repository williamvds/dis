-- Schema setup
\i scripts/setup.sql

-- Data importing
\i scripts/importGtrOrgs.sql
\i scripts/importGtrProjects.sql
\i scripts/importGtrOutcomes.sql
\i scripts/importGtrPersons.sql

-- Merging & classifying orgs
\i scripts/similarGtrOrgs.sql
\i scripts/mergeGtrOrgs.sql
\i scripts/classifyOrgs.sql

-- Merging people
\i scripts/similarGtrPeople.sql
\i scripts/mergeGtrPeople.sql

-- Final statistics
\i scripts/stats.sql
