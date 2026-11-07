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

## Genesis

Project GoDaddy takes its name from Bob Parsons’s story. His path from
the Marine Corps through education and entrepreneurship, and his later
work supporting veterans, got me thinking about what we carry forward
from one chapter to the next.

One practice I’ve carried forward from the military is the hot-wash.
After an operation, we looked at what happened, what worked, and what
we needed to improve. I wanted to bring that same discipline to a
software project and make the evidence visible at every phase.

## Why this project exists

Moving CareerOps from MySQL to PostgreSQL gives me a practical way to
show how quality engineering works across all seven phases of the SDLC.
The question is whether existing data survives the migration and people
can still complete the workflows they rely on.

The first example is an employer contact. I’ll trace it from a StrictDoc
requirement to a manual test, compare the results on MySQL and PostgreSQL,
and use that baseline when I automate the check in GitHub Actions. After
the migration rehearsal, I’ll run a hot-wash and record what I’d change
before the next run.
