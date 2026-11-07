# CareerOps PostgreSQL schema design

**Status:** Draft

The first implementation will run in the local `careerops_pg` database
with synthetic data. It will prove that CareerOps can migrate an employer
contact, preserve its tracking data, and store workflow history. A full
cutover requires a verified migration and regression test for each existing
function listed below.

## Core records

| Record | What it owns |
| --- | --- |
| Company | Company name (required), website, phone, email, address, and industry. |
| Recruiter | Recruiter name (required), company affiliation, phone, email, and general comments. |
| Position | Hiring company, role, role type, location, compensation range, and requisition ID. A position can link to multiple recruiters. |
| Contributor | A potential future employee. A contributor can exist before being linked to a position. |
| Pursuit | A tracked application or contact for a position. Holds the contact date, current stage and status, relationship status, interview and follow-up dates, reporting flag, and pursuit notes. |
| Workflow Event | One dated event for a pursuit, with its type, recorder when known, and notes. Stage and status changes also record the previous and new values. |

A recruiter's affiliated company and a position's hiring company are separate
relationships. Contact details from the legacy form need an explicit field
mapping because phone, email, and address can describe different parties.

## Existing functionality to preserve

| MySQL source | Behavior to carry forward | Verification |
| --- | --- | --- |
| `recruiter_tracker` | Contact creation, editing, search, status changes, exports, and automatic status aging when enabled. The deployed form uses `role_level` for Role and `role_category` for Role Type. | Run the contact migration test and verify search, exports, and aging. Reconcile all legacy fields, including `role_title` and `role_type`. |
| `weekly_reports`, `report_job_contacts` | Weekly report dates, submission state, and contact membership. The current report workflow requires four unique contacts and updates their reporting flags and follow-up dates. | Save a synthetic four-contact report through the app. Verify its history, membership, and contact updates. |
| `users` | Sign-in, account roles, and access rules. The deployed contact list is authenticated and its query is shared across users. | Verify sign-in and access behavior. Decide whether per-user pursuit ownership is a separate requirement. |
| `validation_runs` | Validation run records and their results. | Start and complete a run, then verify the saved result. |
| `visitor_analytics`, `analytics_heartbeat_events` | Session activity and heartbeat reporting. | Start a session, record a heartbeat, and verify telemetry. |
| `demo_refresh_history` | Demo refresh history and status. | Verify the demo refresh flow and its recorded result in the intended environment. |
| `recruiter_tracker_backup`, `recruiter_tracker_backup_20260818` | Production tables that appear to be backup copies. Their purpose and retention are open. | Confirm whether any workflow depends on them and document how they will be retained. |

## Migration traceability

Each migrated pursuit must be traceable by its source environment and
original MySQL tracker ID. PostgreSQL assigns the destination pursuit ID.
Weekly report links use that mapping to find the correct pursuit.

Production discovery found 272 report links. Of those, 206 resolved to
both a report and a tracker record, 54 referenced a missing tracker only,
and 12 referenced both a missing report and a missing tracker. Rerun the
check on the migration input. Account for each source link as a migrated
link or a documented exception with its original IDs and reason.

## Decisions before writing SQL

- Finish the field-by-field mapping from the live production schema,
  including legacy statuses and date fields.
- Decide what a historical weekly report should display after a contact
  changes or is deleted. The existing application reads current contact
  details when it opens a report.
- Define which source values can be migrated as history and which workflow
  events CareerOps will start recording after the migration.
