BEGIN;

CREATE TABLE careerops.weekly_reports (
    id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    week_start date,
    week_end date,
    submitted boolean,
    submitted_at timestamptz,
    source_environment text,
    legacy_report_id integer,

    UNIQUE (source_environment, legacy_report_id),
    CHECK ((source_environment IS NULL) = (legacy_report_id IS NULL))
);

CREATE TABLE careerops.report_pursuits (
    report_id bigint NOT NULL REFERENCES careerops.weekly_reports (id),
    pursuit_id bigint NOT NULL REFERENCES careerops.pursuits (id),
    linked_at timestamptz,
    source_environment text,
    legacy_report_contact_id integer,

    PRIMARY KEY (report_id, pursuit_id),
    UNIQUE (source_environment, legacy_report_contact_id),
    CHECK ((source_environment IS NULL) = (legacy_report_contact_id IS NULL))
);

CREATE TABLE migration.report_link_exceptions (
    source_environment text NOT NULL,
    legacy_report_contact_id integer NOT NULL,
    legacy_report_id integer NOT NULL,
    legacy_tracker_id integer NOT NULL,
    reason text NOT NULL CHECK (reason IN (
        'missing_report',
        'missing_tracker',
        'missing_report_and_tracker',
        'duplicate_link'
    )),

    PRIMARY KEY (source_environment, legacy_report_contact_id)
);

COMMIT;
