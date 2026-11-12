-- Capture this result before and after the browser note edit.
SELECT m.legacy_tracker_id, p.id AS pursuit_id, p.date_contacted,
       p.hiring_stage, p.position_status, p.follow_up_date, p.notes,
       COALESCE(
           jsonb_agg(
               jsonb_build_object(
                   'event_date', e.event_date, 'event_type', e.event_type,
                   'recorded_by', e.recorded_by, 'previous_value', e.previous_value,
                   'new_value', e.new_value, 'notes', e.notes
               ) ORDER BY e.event_date, e.id
           ) FILTER (WHERE e.id IS NOT NULL), '[]'::jsonb
       ) AS workflow_events
FROM migration.tracker_pursuit_map AS m
JOIN careerops.pursuits AS p ON p.id = m.pursuit_id
LEFT JOIN careerops.workflow_events AS e ON e.pursuit_id = p.id
WHERE m.source_environment = 'railway_qa' AND m.legacy_tracker_id = 1001
GROUP BY m.legacy_tracker_id, p.id;
