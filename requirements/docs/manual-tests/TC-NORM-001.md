# TC-NORM-001 — Verify normalized CareerOps records

- **Requirement:** [REQ-NORM-001](../../migration.sdoc)
- **Environment:** PostgreSQL staging
- **Result:** Not run

| Step | Action | Expected result |
| --- | --- | --- |
| 1 | Create one synthetic company, two positions at that company, and one recruiter who supports both positions. | Both positions show the same company and recruiter. |
| 2 | Create a pursuit for each position. Give each pursuit a different status and add a different workflow event to each. | Each pursuit shows its own status and workflow history. |
| 3 | Update the company website once. Reopen both positions and their pursuits. | Both positions show the new website. Each pursuit still shows its original status and workflow history. |
| 4 | Create a contributor without assigning a position. Save and reopen the contributor. | The contributor is saved and can be reopened with no position assigned. |
