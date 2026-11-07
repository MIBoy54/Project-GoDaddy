# CareerOps PostgreSQL schema design

**Status:** Draft

This design supports the CareerOps migration from MySQL to PostgreSQL.
The first implementation will run in the local `careerops_pg` database
with synthetic data.

## Core records

| Record | What it owns |
| --- | --- |
| Company | Required name, website, phone, email, address, and industry. |
| Recruiter | Required name, company affiliation, phone, email, and comments. |
| Position | Hiring company, role, role type, and location. A position can be linked to multiple recruiters. |
| Contributor | A person who could become a future employee. A contributor can exist before being linked to a position. |
| Pursuit | A tracked application or contact for a position. Holds the current stage, status, next follow-up date, and pursuit notes. |
| Workflow Event | An event for one pursuit. Holds the event date, type, recorder when known, notes, and previous and new values for stage or status changes. |

## Migration traceability

Each migrated pursuit must be traceable by its source environment and
original MySQL tracker ID. PostgreSQL assigns its own pursuit ID.
Weekly report links use the mapping to find the correct pursuit.

## Items to verify before writing SQL

- Confirm how CareerOps records ownership of each pursuit.
- Check which legacy fields supply Role and Role Type across records.
- Document how valid weekly report links and unresolved links will be
  handled in the PostgreSQL rehearsal.
