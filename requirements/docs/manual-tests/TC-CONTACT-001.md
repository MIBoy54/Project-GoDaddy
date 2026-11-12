# TC-CONTACT-001 — Verify employer contact after migration

- **Requirements:** [REQ-MIG-001](../../migration.sdoc) and [REQ-NOTE-001](../../migration.sdoc)
- **MySQL baseline result:** PASS (steps 1–2)
- **Local PostgreSQL GUI save/reopen:** PASS (later QA snapshot)
- **Local PostgreSQL history fixture result:** PASS

- **Record:** QA tracker `1` → PostgreSQL pursuit `3`
- **Actual result:** The edited note persisted after reloading the page
  and reopening the contact. The contact date, hiring stage, and position
  status matched the values shown before the edit.
  
## Setup

### MySQL QA baseline

Use a synthetic employer contact in MySQL QA (`careerops_qa`). Capture the
migration input before making the test edit so the local PostgreSQL rehearsal
can start with the same original values. Record the exact browser URL used to open the
contact. The QA app entry point is [CareerOps QA](https://qa.democareerops-platform.com/).

### Local PostgreSQL rehearsal

1. Use the `codex/postgres-contact-rehearsal` checkout of `careerops-platform`
   with Node.js and the project dependencies installed. Run the launcher from
   that checkout, where `package.json` defines `start:postgres-contact`.
2. Start local PostgreSQL and verify that the replay database
   `careerops_pg_replay` contains the migrated synthetic fixture. The source
   environment is `railway_qa`, legacy tracker ID is `1`, and the recorded
   replay maps it to pursuit `3`. Verify exactly one mapping before editing.
3. Verify the PostgreSQL login in pgAdmin using the same IPv4 address and port
   as the launcher. This run used `postgres` at `127.0.0.1:5432`. In that
   connection's Query Tool, run
   `SELECT current_database(), session_user, inet_server_addr(), inet_server_port();`
   and confirm the database, role, address, and port.
4. In PowerShell, change to the rehearsal checkout and run the following in
   the same window. Enter the local PostgreSQL role password at the prompt.

   ```powershell
   $env:CAREEROPS_POSTGRES_USER = 'postgres'
   $env:CAREEROPS_POSTGRES_PORT = '5432'
   $env:CAREEROPS_POSTGRES_PASSWORD = [System.Net.NetworkCredential]::new('', (Read-Host 'Local PostgreSQL password' -AsSecureString)).Password
   npm.cmd run start:postgres-contact
   ```

5. Wait for the launcher to print `CareerOps PostgreSQL contact rehearsal` and
   leave PowerShell open. Use [http://127.0.0.1:3100/](http://127.0.0.1:3100/)
   as the local browser validation URL. Select **Test Company (QA tracker 1)**
   and click **Open contact**. Capture the record before the edit and again
   after saving, reloading the page, and reopening it. Compare the date,
   hiring stage, and position status across both captures. Use read-only
   database evidence to compare workflow history.

### Local history fixture

1. Run the [synthetic MySQL fixture](../database/mysql/contact_history_fixture.sql)
   and save its `source_row` JSON as the baseline for tracker `1001`. This is
   authored test data with two workflow events and a scheduled follow-up.
2. Create a fresh local PostgreSQL database named `careerops_pg_history_replay`.
   Apply PostgreSQL schema scripts `001` through `005` in numerical order.
3. In pgAdmin, paste the captured JSON between the `$fixture$` delimiters and run
   the insert below. Then run the [replay script](../database/postgresql/replay_contact_history_fixture.sql).

   ```sql
   INSERT INTO migration.legacy_tracker_rows
       (source_environment, legacy_tracker_id, source_row)
   VALUES ('railway_qa', 1001, $fixture$PASTE_CAPTURED_JSON_HERE$fixture$::jsonb);
   ```

4. Stop any prior rehearsal listener on port `3100`. In the rehearsal checkout,
   set `$env:CAREEROPS_POSTGRES_DATABASE = 'careerops_pg_history_replay'` before
   starting the launcher. This setting is available in rehearsal commit `b14c8a7`.
5. Open **Mendelssohn History Fixture (QA tracker 1001)** at the
   [local validation URL](http://127.0.0.1:3100/). Run the [verification SQL](../database/postgresql/verify_contact_history_fixture.sql)
   before editing and after reopening. Compare the first result to the MySQL
   JSON and the second to the first. Save both results and the browser captures.

## Test steps

Steps 1–2 describe the MySQL QA contact check. For tracker 1001, capture the synthetic baseline with the fixture query above, then run steps 3–4.

| Step | Action | Expected result |
| --- | --- | --- |
| 1 | Open the contact in MySQL. Record its original tracker ID, stage, status, dates (including the scheduled follow-up), notes, and workflow history in event order. Use a read-only query for the ID if the UI does not display it. | The original record and its values are captured as the baseline. |
| 2 | In MySQL, make a known change to the contact notes. Save, close, and reopen the contact. | The updated notes persist. The status and dates still match the baseline. |
| 3 | After migration, open the contact in the local PostgreSQL rehearsal before editing it. Use the migration mapping and read-only SQL to compare the captured fields and ordered workflow events, including dates, types, recorders, previous and new values, and notes. | The original ID traces to one migrated tracking record. Its pre-edit status, dates, notes, and existing workflow history match the captured baseline. |
| 4 | Edit only the note in the local PostgreSQL rehearsal. Save, reload, and reopen the contact. Compare the reopened record and its workflow history with the pre-edit evidence. | The edited note persists. Stage, status, dates (including the scheduled follow-up), and all pre-existing workflow events match the pre-edit values. |

## Local PostgreSQL rehearsal evidence (2026-11-12)

The local save-and-reopen check passed at [http://127.0.0.1:3100/](http://127.0.0.1:3100/).
QA tracker `1` (pursuit `3`) reopened with
`Test Note Updated2 - PostgreSQL | TC-CONTACT-001 replay check`.
The form showed contact date `2026-11-07`, hiring stage `Applied`, and
position status `Awaiting Decision` before and after the edit.
A read-only PostgreSQL query returned one mapping from QA tracker `1` to
pursuit `3` and zero matching workflow events. The event history from the
corresponding MySQL QA snapshot is pending verification. Scheduled follow-up
preservation is also unverified for tracker `1`.

- [Edited note before saving](TC-CONTACT-001-2026-11-12-postgresql-note-edited.png)
- [PostgreSQL save confirmation](TC-CONTACT-001-2026-11-12-postgresql-save-confirmed.png)
- [Contact reopened with the saved note](TC-CONTACT-001-2026-11-12-postgresql-reopened.png)

## Local PostgreSQL history fixture evidence

**Result: PASS.** The authored fixture query ran on local MySQL DEV
(`careerops_dev`). The migration and browser check ran against an isolated
local PostgreSQL database using rehearsal launcher commit `b14c8a7`.
The run used [http://127.0.0.1:13100/](http://127.0.0.1:13100/).

Tracker `1001` mapped to pursuit `1`. The PostgreSQL record matched the
captured source values for contact date, hiring stage, position status,
follow-up date, notes, and both ordered workflow events. After saving and
reopening, the browser displayed the edited note. The database comparison
confirmed the note was the only change among the verified fields.

- [Before editing](TC-CONTACT-001-history-before.png)
- [Reopened contact](TC-CONTACT-001-history-reopened.png)
- [MySQL baseline and PostgreSQL results before and after the edit](TC-CONTACT-001-history-results.json)

## MySQL baseline evidence

- **Original MySQL tracker ID:** `1`
- **Step 2 actual result:** PASS. The updated note persisted after reopening
  and was confirmed in QA MySQL.
- **Observation:** The form displayed `QA Engineer`, while MySQL `role_title`
  was `NULL`. The source of the displayed role is pending verification.

  - **Field mapping verified for tracker `1`:** The displayed Role (`QA Engineer`)
  is stored in `role_level`, and the displayed Role Type (`Individual
  Contributor`) is stored in `role_category`. Both `role_title` and

  `role_type` are NULL on this row.

![Step 1 — Original note before editing](TC-Contact-001-mysql-before-edit%20changes.png)
![Step 2 — Updated note after reopening](TC-Contact-001-mysql-after-reopen.png)
<img width="761" height="593" alt="TC-Contact-001-step24-Pass" src="https://github.com/user-attachments/assets/45ebe425-74fa-4674-8796-24a83b6af58a" />
<img width="761" height="593" alt="TC-CONTACT-001" src="https://github.com/user-attachments/assets/268a7c18-74bd-4621-9cd0-6cf6b6549a90" />
<img width="953" height="878" alt="PostgreSQL_Contact" src="https://github.com/user-attachments/assets/f2d7fd40-02af-4317-b2aa-2822fcb70733" />
<img width="948" height="878" alt="PostgreSQL_Contact_Updated" src="https://github.com/user-attachments/assets/eba1978c-b81b-4a45-be04-5dc290670e28" />
<img width="947" height="877" alt="PostgreSQL_Contact_Reload" src="https://github.com/user-attachments/assets/4a82c5e1-24e5-41f6-9d28-be95bba58418" />




