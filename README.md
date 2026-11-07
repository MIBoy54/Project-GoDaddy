# Project GoDaddy

Project GoDaddy demonstrates quality engineering across the seven phases of
the SDLC by migrating CareerOps from MySQL to PostgreSQL.

## First verification workflow

Verify that an existing employer contact retains its ID, status, dates, and
notes during migration, and can still be edited, saved, and reopened.

- [Migration requirement — REQ-MIG-001](requirements/migration.sdoc)
- [Manual test — TC-CONTACT-001](requirements/docs/manual-tests/TC-CONTACT-001.md)

Run the manual test against the MySQL baseline and the migrated PostgreSQL
staging environment using the same synthetic contact. Record the results
for each environment before automating the workflow in GitHub Actions.
