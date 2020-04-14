BEGIN;

UPDATE orgs
SET type = 'Academic'
WHERE name ~* '\y(uni(versity|\.?)|college|academ(y|ic))\y';

UPDATE orgs
SET type = 'Medical'
WHERE name ~* '\yhospitals?\y';

UPDATE orgs
SET type = 'Private'
WHERE name ~* '\y((ltd|llc|plc|gmbh|inc|corp|co)\.?|limited|enterprises?|corporation|company)\y';

UPDATE orgs
SET type = 'Public'
WHERE name ~* '\y(government|governorate|council)\y';

COMMIT;
