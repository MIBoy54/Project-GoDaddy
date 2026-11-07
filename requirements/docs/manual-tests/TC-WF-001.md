# TC-WF-001 — Verify pursuit workflow history

- **Requirement:** [REQ-WF-001](../../migration.sdoc)
- **Environment:** PostgreSQL staging
- **Result:** Not run

| Step | Action | Expected result |
| --- | --- | --- |
| 1 | Create a synthetic pursuit and record an application. | The timeline shows the application event with its date, event type, and recorder. |
| 2 | Change the stage from Applied to Recruiter Screen. | The current stage is Recruiter Screen. The timeline shows the previous and new stages. |
| 3 | Record a recruiter interview with a note, then schedule a follow-up. | The interview and follow-up appear in chronological order. The interview note is visible, and the next follow-up date matches the date entered. |
| 4 | Change the pursuit status from In Progress to Rejected. | The current status is Rejected. The timeline shows both the previous and new statuses. |
| 5 | Close and reopen the pursuit. | The current stage and status, all timeline events, and the interview note still appear. |
| 6 | Open a second pursuit for the same company. | Its timeline contains only events recorded for that pursuit. |
