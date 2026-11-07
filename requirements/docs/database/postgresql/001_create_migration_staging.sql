BEGIN;

CREATE SCHEMA IF NOT EXISTS migration;

CREATE TABLE migration.legacy_tracker_rows (
    source_environment text NOT NULL,
    legacy_tracker_id integer NOT NULL,
    source_row jsonb NOT NULL,
    imported_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (source_environment, legacy_tracker_id),
    CHECK (jsonb_typeof(source_row) = 'object')
);

COMMIT;
