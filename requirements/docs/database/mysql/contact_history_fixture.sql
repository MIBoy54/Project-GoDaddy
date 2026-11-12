-- Run on the MySQL QA connection. This synthetic baseline is authored
-- for the rehearsal and is independent of existing QA tracker records.
SELECT JSON_OBJECT(
    'id', 1001,
    'company', 'Mendelssohn History Fixture',
    'recruiter_name', 'Test Recruiter',
    'role_level', 'QA Engineer',
    'role_category', 'Individual Contributor',
    'date_contacted', '2026-11-07',
    'hiring_stage', 'Recruiter Screen',
    'position_status', 'Awaiting Decision',
    'follow_up_date', '2026-11-16',
    'notes', 'Synthetic migration baseline',
    'workflow_events', JSON_ARRAY(
        JSON_OBJECT(
            'event_date', '2026-11-07', 'event_type', 'application',
            'recorded_by', 'QA Fixture', 'previous_value', NULL,
            'new_value', 'Applied', 'notes', 'Application recorded'
        ),
        JSON_OBJECT(
            'event_date', '2026-11-09', 'event_type', 'stage_change',
            'recorded_by', 'QA Fixture', 'previous_value', 'Applied',
            'new_value', 'Recruiter Screen', 'notes', 'Screen scheduled'
        )
    )
) AS source_row;
