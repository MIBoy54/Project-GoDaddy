BEGIN;

CREATE SCHEMA IF NOT EXISTS careerops;

CREATE TABLE careerops.companies (
    id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name text NOT NULL CHECK (btrim(name) <> ''),
    website text,
    phone text,
    email text,
    address text,
    industry text
);

CREATE TABLE careerops.recruiters (
    id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    company_id bigint REFERENCES careerops.companies (id),
    name text NOT NULL CHECK (btrim(name) <> ''),
    phone text,
    email text,
    comments text
);

COMMIT;
