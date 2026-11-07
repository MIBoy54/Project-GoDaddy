BEGIN;

CREATE TABLE careerops.pursuits (
    id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    position_id bigint REFERENCES careerops.positions (id),
    recruiter_id bigint REFERENCES careerops.recruiters (id),
    date_contacted date,
    hiring_stage text,
    position_status text,
    legacy_status text,
    relationship_status text,
    stage_entered_at timestamptz,
    interview_date date,
    follow_up_date date,
    reported_to_unemployment text,
    notes text
);

CREATE TABLE careerops.workflow_events (
    id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    pursuit_id bigint NOT NULL REFERENCES careerops.pursuits (id),
    event_date date NOT NULL,
    event_type text NOT NULL CHECK (btrim(event_type) <> ''),
    recorded_by text,
    previous_value text,
    new_value text,
    notes text
);

CREATE INDEX workflow_events_timeline_idx
    ON careerops.workflow_events (pursuit_id, event_date, id);

COMMIT;
