# Project GoDaddy

Project GoDaddy is a CareerOps proof of concept for applying quality engineering
across all seven phases of the software development lifecycle.

## Genesis

Project GoDaddy grew out of improvements I made to CareerOps. While working on
the employer contact workflow, I saw that company, recruiter, and position
details were being managed together even though they change independently.
A company can have several open positions, and a recruiter can support several
searches. I also wanted to track people who could become future employees
before there was a specific opening for them.

The project name draws on Bob Parsons’s story, from his service in the Marine
Corps through education, entrepreneurship, and his later work supporting
veterans. One practice I’ve carried forward from my own military service is
the hot-wash. After an operation, we reviewed what happened, what worked, and
what we needed to improve. I’ll use that practice after the migration rehearsal
and record what I’d change before the next run.

## Why this project exists

I’m using the move from MySQL to PostgreSQL to normalize the CareerOps data
model. The project will show how I verify that existing records and history
survive the migration, that the employer contact workflow still works, and
that related records can be maintained independently.

## What each record owns

| Record | What belongs there |
| --- | --- |
| **Companies** | Company name, website, industry, and other organization details. |
| **Recruiters** | Recruiter name, contact information, and affiliation. A recruiter can be linked to multiple positions. |
| **Positions** | Hiring company, role title, job posting, work arrangement, and advertised compensation. Application status and interview history belong to the application tracking record. |
| **Contributors** | People who could become future employees, their skills or interests, and relationship notes. A contributor can be tracked before being linked to a position. |

## Requirements and verification

GitHub is the source of truth for Project GoDaddy. The migration requirements
live in [`requirements/migration.sdoc`](requirements/migration.sdoc) and can
be edited directly in GitHub. [StrictDoc](https://strictdoc-project.github.io/)
is the separate tool we’ll use to validate the requirements and generate
traceability reports. Later, GitHub Actions can run StrictDoc automatically.

- **[REQ-MIG-001 — Preserve existing records and history](requirements/migration.sdoc).**
  Trace each legacy tracker record to its migrated record and verify that its
  status, dates, and notes carry forward.
- **REQ-NORM-001 — Separate company, recruiter, position, and contributor data.**
  Maintain each record independently and link records where a relationship
  exists. This requirement is planned for StrictDoc.

### First migration test

Run [TC-CONTACT-001](requirements/docs/manual-tests/TC-CONTACT-001.md) against
the MySQL baseline and the migrated PostgreSQL staging environment using the
same synthetic employer contact. Compare its original values, then edit, save,
and reopen it. Record both manual results before automating the check in
GitHub Actions.

### First normalization test

Create one synthetic company, two positions, and one recruiter who supports
both. Change the company website once and verify that both positions show
the updated website and that each application retains its own status and
interview history. Then create a contributor without assigning them to a
position.
