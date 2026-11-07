BEGIN;

CREATE TABLE careerops.contributors (
    id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name text NOT NULL CHECK (btrim(name) <> ''),
    skills_and_interests text,
    relationship_notes text
);

CREATE TABLE careerops.contributor_positions (
    contributor_id bigint NOT NULL REFERENCES careerops.contributors (id),
    position_id bigint NOT NULL REFERENCES careerops.positions (id),

    PRIMARY KEY (contributor_id, position_id)
);

COMMIT;
