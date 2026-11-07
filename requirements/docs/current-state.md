The production check reconciles all 272 report-to-contact links. 206 have both referenced records. The other 66 have a missing tracker record, and 12 of those 66 also have a missing weekly report.

|Production finding | Link rows |
| --- | --- |
|Both records exist	| 206 |
|Tracker record missing, report exists| 54 |
|Both records missing | 12 |
|Report missing, tracker record exists|	0 |
|Total | 272 |

## Clean PostgreSQL replay — PASS

Applied schema scripts 001–007 to a fresh `careerops_pg_replay` database.
Verified 10 CareerOps tables and 3 migration tables. Loaded the synthetic
tracker fixture and ran `verify_tracker_report_link.sql`.

Legacy tracker `1` mapped to PostgreSQL pursuit `1`. Legacy report link
`101` connected report `1` to that pursuit. The test transaction was
rolled back after capturing the result.

<img width="361" height="535" alt="download" src="https://github.com/user-attachments/assets/69e31250-8c1c-4add-8ad7-62970541e417" />
<img width="699" height="576" alt="download" src="https://github.com/user-attachments/assets/62c2b933-af19-4dde-82cb-7d2e10c16497" />
