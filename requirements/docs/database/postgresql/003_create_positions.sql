BEGIN;

CREATE TABLE careerops.positions (
    id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    company_id bigint REFERENCES careerops.companies (id),
    role text,
    role_type text,
    location text,
    compensation_range text,
    requisition_id text
);

CREATE TABLE careerops.position_recruiters (
    position_id bigint NOT NULL REFERENCES careerops.positions (id),
    recruiter_id bigint NOT NULL REFERENCES careerops.recruiters (id),

    PRIMARY KEY (position_id, recruiter_id)
);

COMMIT;
