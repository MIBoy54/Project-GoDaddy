INSERT INTO migration.legacy_tracker_rows
    (source_environment, legacy_tracker_id, source_row)
VALUES (
    'local_fixture',
    1,
    '{
        "id": 1,
        "company": "Example QA Company",
        "recruiter_name": "Test Recruiter",
        "role_level": "QA Engineer",
        "role_category": "Individual Contributor",
        "role_title": null,
        "date_contacted": "2026-11-07",
        "notes": "Test Note"
    }'::jsonb
)
ON CONFLICT (source_environment, legacy_tracker_id) DO NOTHING;
