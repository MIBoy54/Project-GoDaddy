BEGIN;

CREATE TABLE migration.tracker_pursuit_map (
    source_environment text NOT NULL,
    legacy_tracker_id integer NOT NULL,
    pursuit_id bigint NOT NULL REFERENCES careerops.pursuits (id),

    PRIMARY KEY (source_environment, legacy_tracker_id),
    FOREIGN KEY (source_environment, legacy_tracker_id)
        REFERENCES migration.legacy_tracker_rows
            (source_environment, legacy_tracker_id)
);

COMMIT;
