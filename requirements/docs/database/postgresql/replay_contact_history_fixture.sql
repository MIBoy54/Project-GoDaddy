BEGIN;

-- Populate migration.legacy_tracker_rows with the JSON captured from MySQL
-- before running this script. Use source_environment railway_qa and ID 1001.
WITH source AS (
    SELECT source_row AS data
    FROM migration.legacy_tracker_rows AS s
    WHERE s.source_environment = 'railway_qa'
      AND s.legacy_tracker_id = 1001
      AND NOT EXISTS (
          SELECT 1 FROM migration.tracker_pursuit_map AS m
          WHERE m.source_environment = s.source_environment
            AND m.legacy_tracker_id = s.legacy_tracker_id
      )
),
company AS (
    INSERT INTO careerops.companies (name)
    SELECT data ->> 'company' FROM source RETURNING id
),
recruiter AS (
    INSERT INTO careerops.recruiters (name, company_id)
    SELECT data ->> 'recruiter_name', company.id
    FROM source CROSS JOIN company RETURNING id
),
position AS (
    INSERT INTO careerops.positions (company_id, role, role_type)
    SELECT company.id, data ->> 'role_level', data ->> 'role_category'
    FROM source CROSS JOIN company RETURNING id
),
pursuit AS (
    INSERT INTO careerops.pursuits (
        position_id, recruiter_id, date_contacted, hiring_stage,
        position_status, follow_up_date, notes
    )
    SELECT position.id, recruiter.id, (data ->> 'date_contacted')::date,
           data ->> 'hiring_stage', data ->> 'position_status',
           (data ->> 'follow_up_date')::date, data ->> 'notes'
    FROM source CROSS JOIN position CROSS JOIN recruiter
    RETURNING id
),
events AS (
    INSERT INTO careerops.workflow_events (
        pursuit_id, event_date, event_type, recorded_by,
        previous_value, new_value, notes
    )
    SELECT pursuit.id, (event.data ->> 'event_date')::date,
           event.data ->> 'event_type', event.data ->> 'recorded_by',
           event.data ->> 'previous_value', event.data ->> 'new_value',
           event.data ->> 'notes'
    FROM pursuit CROSS JOIN source
    CROSS JOIN LATERAL jsonb_array_elements(source.data -> 'workflow_events')
        WITH ORDINALITY AS event(data, ordinal)
    ORDER BY event.ordinal
)
INSERT INTO migration.tracker_pursuit_map
    (source_environment, legacy_tracker_id, pursuit_id)
SELECT 'railway_qa', 1001, id FROM pursuit;

COMMIT;
