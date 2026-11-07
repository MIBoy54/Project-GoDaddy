BEGIN;

WITH fixture AS (
    SELECT source_environment, legacy_tracker_id, source_row
    FROM migration.legacy_tracker_rows
    WHERE source_environment = 'local_fixture'
      AND legacy_tracker_id = 1
),
pursuit AS (
    INSERT INTO careerops.pursuits (date_contacted, notes)
    SELECT (source_row ->> 'date_contacted')::date,
           source_row ->> 'notes'
    FROM fixture
    RETURNING id
),
tracker_map AS (
    INSERT INTO migration.tracker_pursuit_map
        (source_environment, legacy_tracker_id, pursuit_id)
    SELECT f.source_environment, f.legacy_tracker_id, p.id
    FROM fixture AS f
    CROSS JOIN pursuit AS p
    RETURNING source_environment, legacy_tracker_id, pursuit_id
),
report AS (
    INSERT INTO careerops.weekly_reports
        (week_start, week_end, source_environment, legacy_report_id)
    SELECT DATE '2026-11-02', DATE '2026-11-08', source_environment, 10
    FROM tracker_map
    RETURNING id, source_environment
),
report_link AS (
    INSERT INTO careerops.report_pursuits
        (report_id, pursuit_id, source_environment, legacy_report_contact_id)
    SELECT r.id, m.pursuit_id, m.source_environment, 101
    FROM report AS r
    JOIN tracker_map AS m USING (source_environment)
    RETURNING report_id, pursuit_id, legacy_report_contact_id
)
SELECT m.legacy_tracker_id, l.pursuit_id,
       l.report_id, l.legacy_report_contact_id
FROM report_link AS l
JOIN tracker_map AS m ON m.pursuit_id = l.pursuit_id;
