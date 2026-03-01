
-- Platform: PostgreSQL 18 (db<>fiddle)
-- Author: Sai Kumar
-- Description: Full schema for 3 HEDIS/CMS quality measures:
--   1. 30-Day All-Cause Readmission (READMIT_30)
--   2. Medication Adherence for Diabetes (PDC_DM)
--   3. Follow-Up After Hospitalization for Mental Illness (FUH)
-- =============================================================================

-- ---------------------------------------------------------------------------
-- DIMENSION TABLES
-- ---------------------------------------------------------------------------

-- Member demographics
CREATE TABLE member_dim (
    member_id       BIGINT PRIMARY KEY,
    dob             DATE        NOT NULL,
    sex             CHAR(1)     NOT NULL CHECK (sex IN ('M','F','U')),
    zip3            CHAR(3),
    state           CHAR(2),
    race_ethnicity  VARCHAR(50),   -- Hispanic, White, Black, Asian, Other
    death_dt        DATE,          -- NULL if alive; used for mortality exclusions
    source_system   VARCHAR(50)  NOT NULL DEFAULT 'SYNTHETIC',
    load_dt         TIMESTAMP    NOT NULL DEFAULT NOW()
);

-- Facility / hospital reference
CREATE TABLE facility_dim (
    facility_id     BIGINT PRIMARY KEY,
    facility_name   VARCHAR(100) NOT NULL,
    city            VARCHAR(60),
    state           CHAR(2),
    facility_type   VARCHAR(50)  NOT NULL  -- ACUTE, SNF, PSYCH, OP_CLINIC
);

-- Provider reference
CREATE TABLE provider_dim (
    provider_id     BIGINT PRIMARY KEY,
    npi             CHAR(10),
    provider_name   VARCHAR(100),
    specialty       VARCHAR(80),
    facility_id     BIGINT REFERENCES facility_dim(facility_id)
);

-- Drug reference (reused from Project 1 pattern)
CREATE TABLE drug_dim (
    ndc                  CHAR(11) PRIMARY KEY,
    generic_name         VARCHAR(100),
    brand_name           VARCHAR(100),
    therapeutic_class    VARCHAR(80),
    is_antidiabetic_flag BOOLEAN NOT NULL DEFAULT FALSE
);

-- Diagnosis reference
CREATE TABLE diagnosis_dim (
    icd10           VARCHAR(10) PRIMARY KEY,
    dx_desc         VARCHAR(200),
    is_diabetes_flag    BOOLEAN NOT NULL DEFAULT FALSE,
    is_mental_health_flag BOOLEAN NOT NULL DEFAULT FALSE,  -- F20-F99 range
    is_htn_flag         BOOLEAN NOT NULL DEFAULT FALSE
);

-- Measure registry — one row per measure per year
CREATE TABLE measure_dim (
    measure_id          VARCHAR(20) PRIMARY KEY,  -- READMIT_30, PDC_DM, FUH
    measure_name        VARCHAR(100) NOT NULL,
    measurement_year    SMALLINT     NOT NULL,
    description         TEXT,
    steward             VARCHAR(50),              -- CMS, NCQA/HEDIS
    denominator_def     TEXT,
    numerator_def       TEXT,
    exclusion_def       TEXT
);

-- ---------------------------------------------------------------------------
-- ELIGIBILITY
-- ---------------------------------------------------------------------------

CREATE TABLE eligibility_fact (
    eligibility_id  BIGINT PRIMARY KEY,
    member_id       BIGINT       NOT NULL REFERENCES member_dim(member_id),
    cov_start_dt    DATE         NOT NULL,
    cov_end_dt      DATE         NOT NULL,
    product_line    VARCHAR(30)  NOT NULL,  -- Medicare, Medicaid, Commercial
    plan_type       VARCHAR(20),            -- HMO, PPO, etc.
    load_batch_id   VARCHAR(40),
    load_dt         TIMESTAMP    NOT NULL DEFAULT NOW(),
    CONSTRAINT elig_dates_chk CHECK (cov_end_dt >= cov_start_dt)
);

-- ---------------------------------------------------------------------------
-- ENCOUNTER / CLAIMS FACTS
-- ---------------------------------------------------------------------------

-- Inpatient, OP, ER encounters (claim-based stays)
CREATE TABLE encounter_fact (
    encounter_id    BIGINT PRIMARY KEY,
    member_id       BIGINT       NOT NULL REFERENCES member_dim(member_id),
    facility_id     BIGINT       REFERENCES facility_dim(facility_id),
    provider_id     BIGINT       REFERENCES provider_dim(provider_id),
    enc_type        VARCHAR(10)  NOT NULL CHECK (enc_type IN ('IP','OP','ER','PROF')),
    admit_dt        DATE,
    discharge_dt    DATE,
    primary_dx      VARCHAR(10)  REFERENCES diagnosis_dim(icd10),
    drg_code        VARCHAR(10),           -- MS-DRG for IP
    paid_amt        NUMERIC(12,2),
    allowed_amt     NUMERIC(12,2),
    discharge_status VARCHAR(10),          -- 01=routine, 20=expired, 30=transfer
    source_system   VARCHAR(50)  NOT NULL DEFAULT 'SYNTHETIC',
    load_batch_id   VARCHAR(40),
    load_dt         TIMESTAMP    NOT NULL DEFAULT NOW()
);

-- Diagnosis bridge — multiple diagnoses per encounter
CREATE TABLE diagnosis_bridge (
    encounter_id    BIGINT       NOT NULL REFERENCES encounter_fact(encounter_id),
    dx_seq          SMALLINT     NOT NULL,   -- 1=primary, 2..n=secondary
    icd10           VARCHAR(10)  NOT NULL REFERENCES diagnosis_dim(icd10),
    PRIMARY KEY (encounter_id, dx_seq)
);

-- Pharmacy claims (for PDC_DM measure)
CREATE TABLE pharmacy_claim_fact (
    rx_claim_id     BIGINT PRIMARY KEY,
    member_id       BIGINT       NOT NULL REFERENCES member_dim(member_id),
    ndc             CHAR(11)     REFERENCES drug_dim(ndc),
    fill_dt         DATE         NOT NULL,
    days_supply     SMALLINT     NOT NULL CHECK (days_supply > 0),
    quantity        NUMERIC(10,3),
    paid_amt        NUMERIC(10,2),
    allowed_amt     NUMERIC(10,2),
    source_system   VARCHAR(50)  NOT NULL DEFAULT 'SYNTHETIC',
    load_batch_id   VARCHAR(40),
    load_dt         TIMESTAMP    NOT NULL DEFAULT NOW()
);

-- ---------------------------------------------------------------------------
-- MEASURE EXECUTION TRACKING (audit trail)
-- ---------------------------------------------------------------------------

-- Each time measure logic is run, log it here
CREATE TABLE measure_run_fact (
    run_id          BIGINT PRIMARY KEY,
    measure_id      VARCHAR(20)  NOT NULL REFERENCES measure_dim(measure_id),
    run_dt          TIMESTAMP    NOT NULL DEFAULT NOW(),
    parameters_json TEXT,        -- JSON: lookback windows, exclusion toggles, etc.
    code_version    VARCHAR(30)  NOT NULL DEFAULT 'v1.0.0',
    run_by          VARCHAR(80)  NOT NULL DEFAULT 'saikumar',
    row_count_denom INT,
    row_count_numer INT,
    rate            NUMERIC(6,4)
);

-- Member-level measure results (one row per member per run)
CREATE TABLE measure_member_result (
    result_id           BIGINT PRIMARY KEY,
    run_id              BIGINT       NOT NULL REFERENCES measure_run_fact(run_id),
    member_id           BIGINT       NOT NULL REFERENCES member_dim(member_id),
    denominator_flag    SMALLINT     NOT NULL DEFAULT 0 CHECK (denominator_flag IN (0,1)),
    numerator_flag      SMALLINT     NOT NULL DEFAULT 0 CHECK (numerator_flag IN (0,1)),
    exclusion_flag      SMALLINT     NOT NULL DEFAULT 0 CHECK (exclusion_flag IN (0,1)),
    reason_codes        TEXT,        -- pipe-delimited: DENOM_MET|EXCL_DEATH|NUMER_MET
    index_event_dt      DATE,        -- anchor date (discharge, index fill, etc.)
    measurement_year    SMALLINT     NOT NULL
);

-- ---------------------------------------------------------------------------
-- DERIVED / OUTPUT TABLES (pre-built for GitHub outputs)
-- ---------------------------------------------------------------------------

CREATE TABLE measure_rate_summary (
    measure_id          VARCHAR(20)  NOT NULL,
    measurement_year    SMALLINT     NOT NULL,
    denom_count         INT,
    excl_count          INT,
    numer_count         INT,
    rate                NUMERIC(6,4),
    run_dt              TIMESTAMP    NOT NULL DEFAULT NOW(),
    PRIMARY KEY (measure_id, measurement_year)
);

CREATE TABLE measure_rate_by_facility (
    measure_id          VARCHAR(20)  NOT NULL,
    measurement_year    SMALLINT     NOT NULL,
    facility_id         BIGINT       REFERENCES facility_dim(facility_id),
    denom_count         INT,
    numer_count         INT,
    rate                NUMERIC(6,4),
    PRIMARY KEY (measure_id, measurement_year, facility_id)
);

CREATE TABLE measure_rate_by_age_band (
    measure_id          VARCHAR(20)  NOT NULL,
    measurement_year    SMALLINT     NOT NULL,
    age_band            VARCHAR(20)  NOT NULL,   -- 18-34, 35-49, 50-64, 65+
    denom_count         INT,
    numer_count         INT,
    rate                NUMERIC(6,4),
    PRIMARY KEY (measure_id, measurement_year, age_band)
);

-- Year-over-year trending view-ready table
CREATE TABLE measure_trend (
    measure_id          VARCHAR(20)  NOT NULL,
    measurement_year    SMALLINT     NOT NULL,
    rate                NUMERIC(6,4),
    denom_count         INT,
    numer_count         INT,
    yoy_rate_change     NUMERIC(6,4),   -- current year rate minus prior year rate
    PRIMARY KEY (measure_id, measurement_year)
);

-- ---------------------------------------------------------------------------
-- INDEXES (performance + query plan hygiene)
-- ---------------------------------------------------------------------------

CREATE INDEX idx_elig_member       ON eligibility_fact(member_id);
CREATE INDEX idx_elig_dates        ON eligibility_fact(cov_start_dt, cov_end_dt);
CREATE INDEX idx_enc_member        ON encounter_fact(member_id);
CREATE INDEX idx_enc_type_admit    ON encounter_fact(enc_type, admit_dt);
CREATE INDEX idx_enc_discharge     ON encounter_fact(discharge_dt);
CREATE INDEX idx_dx_bridge_enc     ON diagnosis_bridge(encounter_id);
CREATE INDEX idx_dx_bridge_icd     ON diagnosis_bridge(icd10);
CREATE INDEX idx_rx_member_fill    ON pharmacy_claim_fact(member_id, fill_dt);
CREATE INDEX idx_mmr_run_member    ON measure_member_result(run_id, member_id);
CREATE INDEX idx_mmr_year          ON measure_member_result(measurement_year);

-- =============================================================================
-- END OF DDL
-- =============================================================================
