
INSERT INTO facility_dim VALUES
(1, 'Metro General Hospital',      'Dallas',       'TX', 'ACUTE'),
(2, 'Riverside Medical Center',    'Houston',      'TX', 'ACUTE'),
(3, 'Lakeside Community Hospital', 'Austin',       'TX', 'ACUTE'),
(4, 'Northside Psychiatric Center','Dallas',       'TX', 'PSYCH'),
(5, 'Eastview SNF',                'San Antonio',  'TX', 'SNF'),
(6, 'Central Outpatient Clinic',   'Dallas',       'TX', 'OP_CLINIC');

INSERT INTO provider_dim VALUES
(101, '1234567890', 'Dr. Emily Nguyen',    'Internal Medicine',     1),
(102, '2345678901', 'Dr. James Carter',    'Cardiology',            1),
(103, '3456789012', 'Dr. Priya Sharma',    'Psychiatry',            4),
(104, '4567890123', 'Dr. Marcus Johnson',  'Emergency Medicine',    2),
(105, '5678901234', 'Dr. Sofia Martinez',  'Hospitalist',           3),
(106, '6789012345', 'Dr. Arun Patel',      'Endocrinology',         6);

INSERT INTO drug_dim VALUES
('00006013131', 'Metformin',          'Glucophage',  'Antidiabetic', TRUE),
('00006013132', 'Glipizide',          'Glucotrol',   'Antidiabetic', TRUE),
('00006013133', 'Sitagliptin',        'Januvia',     'Antidiabetic', TRUE),
('00006013134', 'Empagliflozin',      'Jardiance',   'Antidiabetic', TRUE),
('00006013135', 'Insulin Glargine',   'Lantus',      'Antidiabetic', TRUE),
('00006099901', 'Lisinopril',         'Prinivil',    'ACE Inhibitor',FALSE),
('00006099902', 'Atorvastatin',       'Lipitor',     'Statin',        FALSE);

INSERT INTO diagnosis_dim VALUES
('E11',    'Type 2 diabetes mellitus',                              TRUE,  FALSE, FALSE),
('E11.9',  'Type 2 diabetes without complications',                  TRUE,  FALSE, FALSE),
('E11.65', 'Type 2 diabetes with hyperglycemia',                    TRUE,  FALSE, FALSE),
('E10.9',  'Type 1 diabetes without complications',                  TRUE,  FALSE, FALSE),
('F20.9',  'Schizophrenia, unspecified',                            FALSE, TRUE,  FALSE),
('F31.9',  'Bipolar disorder, unspecified',                         FALSE, TRUE,  FALSE),
('F32.9',  'Major depressive disorder, unspecified',                FALSE, TRUE,  FALSE),
('F41.1',  'Generalized anxiety disorder',                          FALSE, TRUE,  FALSE),
('I10',    'Essential hypertension',                                FALSE, FALSE, TRUE),
('I50.9',  'Heart failure, unspecified',                            FALSE, FALSE, FALSE),
('J18.9',  'Pneumonia, unspecified',                                FALSE, FALSE, FALSE),
('N18.3',  'Chronic kidney disease, stage 3',                       FALSE, FALSE, FALSE),
('Z00.00', 'Encounter for general adult medical examination',        FALSE, FALSE, FALSE),
('Z87.891','Personal history of nicotine dependence',               FALSE, FALSE, FALSE),
('S72.001','Fracture of unspecified part of neck of femur',         FALSE, FALSE, FALSE);

-- Measure registry
INSERT INTO measure_dim VALUES
('READMIT_30_2022', '30-Day All-Cause Readmission', 2022,
 'Counts unplanned IP readmissions within 30 days of discharge for members 18+ with continuous enrollment.',
 'CMS',
 'IP discharges Jan–Dec 2022, member age 18+, 30-day pre/post continuous enrollment.',
 'Unplanned IP admission within 30 days of index discharge.',
 'Death during stay, transfer, planned readmission, psychiatric principal dx on index.'),

('READMIT_30_2023', '30-Day All-Cause Readmission', 2023,
 'Counts unplanned IP readmissions within 30 days of discharge for members 18+ with continuous enrollment.',
 'CMS',
 'IP discharges Jan–Dec 2023, member age 18+, 30-day pre/post continuous enrollment.',
 'Unplanned IP admission within 30 days of index discharge.',
 'Death during stay, transfer, planned readmission, psychiatric principal dx on index.'),

('PDC_DM_2022', 'Medication Adherence for Diabetes (PDC)', 2022,
 'Proportion of Days Covered for antidiabetic medications. PDC >= 0.80 = adherent.',
 'NCQA/HEDIS',
 'Members 18-75 with antidiabetic fills and 365-day continuous enrollment in 2022.',
 'PDC >= 0.80 across all antidiabetic drug classes.',
 'Gestational diabetes, frailty exclusions, hospice enrollment.'),

('PDC_DM_2023', 'Medication Adherence for Diabetes (PDC)', 2023,
 'Proportion of Days Covered for antidiabetic medications. PDC >= 0.80 = adherent.',
 'NCQA/HEDIS',
 'Members 18-75 with antidiabetic fills and 365-day continuous enrollment in 2023.',
 'PDC >= 0.80 across all antidiabetic drug classes.',
 'Gestational diabetes, frailty exclusions, hospice enrollment.'),

('FUH_2022', 'Follow-Up After Hospitalization for Mental Illness (7-day)', 2022,
 'Members 6+ discharged from IP mental health stay who had follow-up within 7 days.',
 'NCQA/HEDIS',
 'IP mental health discharge (F20-F99 principal dx), age 6+, continuous enrollment.',
 'Outpatient or OP mental health follow-up visit within 7 days of discharge.',
 'Death during stay, discharge to long-term care, AMA discharge.'),

('FUH_2023', 'Follow-Up After Hospitalization for Mental Illness (7-day)', 2023,
 'Members 6+ discharged from IP mental health stay who had follow-up within 7 days.',
 'NCQA/HEDIS',
 'IP mental health discharge (F20-F99 principal dx), age 6+, continuous enrollment.',
 'Outpatient or OP mental health follow-up visit within 7 days of discharge.',
 'Death during stay, discharge to long-term care, AMA discharge.');

-- ---------------------------------------------------------------------------
-- MEMBERS (60 members with varied demographics)
-- ---------------------------------------------------------------------------

INSERT INTO member_dim (member_id, dob, sex, zip3, state, race_ethnicity, death_dt, source_system) VALUES
-- Diabetic cohort (will qualify for PDC_DM) — 20 members
(2001,'1958-03-14','M','750','TX','White',            NULL,'SYNTHETIC'),
(2002,'1965-07-22','F','770','TX','Hispanic',          NULL,'SYNTHETIC'),
(2003,'1972-11-05','M','787','TX','Black',             NULL,'SYNTHETIC'),
(2004,'1950-01-30','F','750','TX','White',             NULL,'SYNTHETIC'),
(2005,'1980-06-18','M','770','TX','Asian',             NULL,'SYNTHETIC'),
(2006,'1945-09-12','F','752','TX','White',             NULL,'SYNTHETIC'),
(2007,'1968-04-25','M','787','TX','Hispanic',          NULL,'SYNTHETIC'),
(2008,'1975-12-08','F','750','TX','Black',             NULL,'SYNTHETIC'),
(2009,'1962-08-17','M','770','TX','White',             NULL,'SYNTHETIC'),
(2010,'1955-02-28','F','787','TX','Hispanic',          NULL,'SYNTHETIC'),
(2011,'1978-05-11','M','752','TX','Black',             NULL,'SYNTHETIC'),
(2012,'1960-10-03','F','750','TX','White',             NULL,'SYNTHETIC'),
(2013,'1948-07-19','M','770','TX','Asian',             NULL,'SYNTHETIC'),
(2014,'1970-03-27','F','787','TX','Hispanic',          NULL,'SYNTHETIC'),
(2015,'1983-01-15','M','750','TX','White',             NULL,'SYNTHETIC'),
(2016,'1957-11-22','F','770','TX','Black',             NULL,'SYNTHETIC'),
(2017,'1973-06-09','M','787','TX','White',             NULL,'SYNTHETIC'),
(2018,'1952-08-31','F','752','TX','Hispanic',          NULL,'SYNTHETIC'),
(2019,'1966-04-14','M','750','TX','White',             NULL,'SYNTHETIC'),
(2020,'1979-09-26','F','770','TX','Black',             NULL,'SYNTHETIC'),
-- Mental health cohort (will qualify for FUH) — 15 members
(2021,'1990-02-14','M','750','TX','White',             NULL,'SYNTHETIC'),
(2022,'1985-07-08','F','770','TX','Hispanic',          NULL,'SYNTHETIC'),
(2023,'1978-11-23','M','787','TX','Black',             NULL,'SYNTHETIC'),
(2024,'1992-04-17','F','752','TX','White',             NULL,'SYNTHETIC'),
(2025,'1988-09-30','M','750','TX','Asian',             NULL,'SYNTHETIC'),
(2026,'1975-01-05','F','770','TX','Hispanic',          NULL,'SYNTHETIC'),
(2027,'1982-06-19','M','787','TX','White',             NULL,'SYNTHETIC'),
(2028,'1995-03-11','F','750','TX','Black',             NULL,'SYNTHETIC'),
(2029,'1970-10-28','M','770','TX','White',             NULL,'SYNTHETIC'),
(2030,'1987-08-04','F','787','TX','Hispanic',          NULL,'SYNTHETIC'),
(2031,'1993-05-22','M','752','TX','White',             NULL,'SYNTHETIC'),
(2032,'1980-12-16','F','750','TX','Black',             NULL,'SYNTHETIC'),
(2033,'1976-07-03','M','770','TX','White',             NULL,'SYNTHETIC'),
(2034,'1989-02-27','F','787','TX','Asian',             NULL,'SYNTHETIC'),
(2035,'1983-11-09','M','750','TX','Hispanic',          NULL,'SYNTHETIC'),
-- General IP cohort (readmission candidates) — 15 members
(2036,'1955-04-18','M','770','TX','White',             NULL,'SYNTHETIC'),
(2037,'1948-08-25','F','787','TX','Hispanic',          NULL,'SYNTHETIC'),
(2038,'1961-01-12','M','752','TX','Black',             NULL,'SYNTHETIC'),
(2039,'1952-06-07','F','750','TX','White',             NULL,'SYNTHETIC'),
(2040,'1967-11-30','M','770','TX','Hispanic',          NULL,'SYNTHETIC'),
(2041,'1943-03-22','F','787','TX','White',             NULL,'SYNTHETIC'),
(2042,'1958-09-14','M','752','TX','Black',             NULL,'SYNTHETIC'),
(2043,'1972-07-01','F','750','TX','White',             NULL,'SYNTHETIC'),
(2044,'1964-02-18','M','770','TX','Asian',             NULL,'SYNTHETIC'),
(2045,'1950-10-05','F','787','TX','Hispanic',          NULL,'SYNTHETIC'),
(2046,'1969-05-27','M','752','TX','White',   '2022-09-15','SYNTHETIC'), -- died 2022
(2047,'1956-01-09','F','750','TX','Black',             NULL,'SYNTHETIC'),
(2048,'1973-08-20','M','770','TX','White',             NULL,'SYNTHETIC'),
(2049,'1960-04-11','F','787','TX','Hispanic',          NULL,'SYNTHETIC'),
(2050,'1945-12-03','M','752','TX','White',             NULL,'SYNTHETIC'),
-- Mixed / overlap members — 10 members
(2051,'1963-06-15','F','750','TX','Black',             NULL,'SYNTHETIC'),
(2052,'1971-02-28','M','770','TX','White',             NULL,'SYNTHETIC'),
(2053,'1984-09-07','F','787','TX','Hispanic',          NULL,'SYNTHETIC'),
(2054,'1957-04-21','M','752','TX','White',             NULL,'SYNTHETIC'),
(2055,'1968-11-14','F','750','TX','Asian',             NULL,'SYNTHETIC'),
(2056,'1977-07-30','M','770','TX','Black',             NULL,'SYNTHETIC'),
(2057,'1991-03-19','F','787','TX','White',             NULL,'SYNTHETIC'),
(2058,'1953-10-02','M','752','TX','Hispanic',          NULL,'SYNTHETIC'),
(2059,'1986-08-11','F','750','TX','White',             NULL,'SYNTHETIC'),
(2060,'1974-01-24','M','770','TX','Black',             NULL,'SYNTHETIC');

-- ---------------------------------------------------------------------------
-- ELIGIBILITY (continuous coverage, with a few gaps for edge cases)
-- ---------------------------------------------------------------------------

-- Full-year 2022 and 2023 coverage for most members
INSERT INTO eligibility_fact (eligibility_id, member_id, cov_start_dt, cov_end_dt, product_line, plan_type, load_batch_id, load_dt)
SELECT
    2000 + member_id AS eligibility_id,
    member_id,
    '2022-01-01'::DATE,
    '2022-12-31'::DATE,
    CASE WHEN member_id BETWEEN 2001 AND 2020 THEN 'Commercial'
         WHEN member_id BETWEEN 2021 AND 2035 THEN 'Medicaid'
         ELSE 'Medicare' END,
    CASE WHEN member_id % 3 = 0 THEN 'HMO' ELSE 'PPO' END,
    'BATCH_2022_01',
    NOW()
FROM member_dim
WHERE member_id BETWEEN 2001 AND 2060;

INSERT INTO eligibility_fact (eligibility_id, member_id, cov_start_dt, cov_end_dt, product_line, plan_type, load_batch_id, load_dt)
SELECT
    4000 + member_id AS eligibility_id,
    member_id,
    '2023-01-01'::DATE,
    '2023-12-31'::DATE,
    CASE WHEN member_id BETWEEN 2001 AND 2020 THEN 'Commercial'
         WHEN member_id BETWEEN 2021 AND 2035 THEN 'Medicaid'
         ELSE 'Medicare' END,
    CASE WHEN member_id % 3 = 0 THEN 'HMO' ELSE 'PPO' END,
    'BATCH_2023_01',
    NOW()
FROM member_dim
WHERE member_id BETWEEN 2001 AND 2060
  AND member_id != 2046; -- member died 2022, no 2023 coverage

-- Eligibility gap: members 2053 and 2057 have gap in mid-2022 (tests exclusion logic)
DELETE FROM eligibility_fact WHERE eligibility_id = 6053;
INSERT INTO eligibility_fact VALUES(6053, 2053,'2022-01-01','2022-05-31','Commercial','PPO','BATCH_2022_GAP',NOW());
INSERT INTO eligibility_fact VALUES(6153, 2053,'2022-08-01','2022-12-31','Commercial','PPO','BATCH_2022_GAP',NOW());

-- ---------------------------------------------------------------------------
-- ENCOUNTERS — IP/ER/OP
-- ---------------------------------------------------------------------------

-- === INPATIENT — General Medical (readmission candidates) ===
-- Columns: encounter_id, member_id, facility_id, provider_id, enc_type,
--          admit_dt, discharge_dt, primary_dx, drg_code,
--          paid_amt, allowed_amt, discharge_status,
--          source_system, load_batch_id, load_dt   (15 columns)
INSERT INTO encounter_fact
    (encounter_id, member_id, facility_id, provider_id, enc_type,
     admit_dt, discharge_dt, primary_dx, drg_code,
     paid_amt, allowed_amt, discharge_status,
     source_system, load_batch_id, load_dt)
VALUES
-- 2022 index admissions for readmission measure
(3001,2036,1,101,'IP','2022-02-10','2022-02-15','J18.9',NULL,4500.00,3800.00,'01','SYNTHETIC','BATCH_2022',NOW()),
(3002,2037,1,101,'IP','2022-03-05','2022-03-10','I50.9',NULL,6200.00,5100.00,'01','SYNTHETIC','BATCH_2022',NOW()),
(3003,2038,1,102,'IP','2022-04-18','2022-04-22','E11.65',NULL,3800.00,3200.00,'01','SYNTHETIC','BATCH_2022',NOW()),
(3004,2039,2,101,'IP','2022-05-08','2022-05-14','N18.3',NULL,5500.00,4700.00,'01','SYNTHETIC','BATCH_2022',NOW()),
(3005,2040,1,105,'IP','2022-06-01','2022-06-06','J18.9',NULL,4100.00,3500.00,'01','SYNTHETIC','BATCH_2022',NOW()),
(3006,2041,1,101,'IP','2022-07-15','2022-07-20','I50.9',NULL,7800.00,6500.00,'01','SYNTHETIC','BATCH_2022',NOW()),
(3007,2042,3,105,'IP','2022-08-03','2022-08-08','E11.9',NULL,3200.00,2800.00,'01','SYNTHETIC','BATCH_2022',NOW()),
(3008,2043,1,101,'IP','2022-09-12','2022-09-17','N18.3',NULL,4900.00,4100.00,'01','SYNTHETIC','BATCH_2022',NOW()),
(3009,2044,2,102,'IP','2022-10-22','2022-10-27','I50.9',NULL,6100.00,5200.00,'01','SYNTHETIC','BATCH_2022',NOW()),
(3010,2045,1,101,'IP','2022-11-08','2022-11-13','J18.9',NULL,3700.00,3100.00,'01','SYNTHETIC','BATCH_2022',NOW()),
-- Member 2046 — died during stay (tests death exclusion, discharge_status='20')
(3011,2046,1,101,'IP','2022-07-20','2022-07-28','I50.9',NULL,9200.00,7800.00,'20','SYNTHETIC','BATCH_2022',NOW()),
(3012,2047,3,101,'IP','2022-04-05','2022-04-10','J18.9',NULL,4300.00,3600.00,'01','SYNTHETIC','BATCH_2022',NOW()),
(3013,2048,1,102,'IP','2022-08-14','2022-08-19','E11.9',NULL,3500.00,2900.00,'01','SYNTHETIC','BATCH_2022',NOW()),
(3014,2049,2,101,'IP','2022-10-01','2022-10-06','N18.3',NULL,5100.00,4300.00,'01','SYNTHETIC','BATCH_2022',NOW()),
(3015,2050,1,101,'IP','2022-11-20','2022-11-25','I50.9',NULL,7200.00,6000.00,'01','SYNTHETIC','BATCH_2022',NOW()),

-- 2022 READMISSIONS (within 30 days of index discharge)
(3016,2036,1,101,'IP','2022-02-25','2022-03-01','J18.9',NULL,4200.00,3500.00,'01','SYNTHETIC','BATCH_2022',NOW()), -- 10 days after 2/15 ✓
(3017,2038,1,102,'IP','2022-05-10','2022-05-14','E11.65',NULL,3900.00,3300.00,'01','SYNTHETIC','BATCH_2022',NOW()), -- 18 days after 4/22 ✓
(3018,2041,1,101,'IP','2022-08-05','2022-08-10','I50.9',NULL,6800.00,5700.00,'01','SYNTHETIC','BATCH_2022',NOW()), -- 16 days after 7/20 ✓
(3019,2044,2,102,'IP','2022-11-15','2022-11-20','I50.9',NULL,5900.00,5000.00,'01','SYNTHETIC','BATCH_2022',NOW()), -- 19 days after 10/27 ✓
(3020,2050,1,101,'IP','2022-12-05','2022-12-09','I50.9',NULL,6500.00,5500.00,'01','SYNTHETIC','BATCH_2022',NOW()), -- 10 days after 11/25 ✓

-- 2023 index admissions
(3101,2036,1,101,'IP','2023-01-15','2023-01-20','I50.9',NULL,5200.00,4400.00,'01','SYNTHETIC','BATCH_2023',NOW()),
(3102,2037,1,101,'IP','2023-02-28','2023-03-04','J18.9',NULL,4100.00,3500.00,'01','SYNTHETIC','BATCH_2023',NOW()),
(3103,2039,2,101,'IP','2023-04-10','2023-04-15','N18.3',NULL,5600.00,4700.00,'01','SYNTHETIC','BATCH_2023',NOW()),
(3104,2040,1,105,'IP','2023-06-18','2023-06-23','J18.9',NULL,3900.00,3300.00,'01','SYNTHETIC','BATCH_2023',NOW()),
(3105,2042,3,105,'IP','2023-07-04','2023-07-09','E11.9',NULL,3400.00,2900.00,'01','SYNTHETIC','BATCH_2023',NOW()),
(3106,2043,1,101,'IP','2023-08-22','2023-08-27','N18.3',NULL,4800.00,4000.00,'01','SYNTHETIC','BATCH_2023',NOW()),
(3107,2045,1,101,'IP','2023-09-14','2023-09-19','I50.9',NULL,6900.00,5800.00,'01','SYNTHETIC','BATCH_2023',NOW()),
(3108,2047,3,101,'IP','2023-03-20','2023-03-25','J18.9',NULL,4400.00,3700.00,'01','SYNTHETIC','BATCH_2023',NOW()),
(3109,2048,1,102,'IP','2023-10-05','2023-10-10','E11.9',NULL,3600.00,3000.00,'01','SYNTHETIC','BATCH_2023',NOW()),
(3110,2049,2,101,'IP','2023-11-12','2023-11-17','N18.3',NULL,5300.00,4400.00,'01','SYNTHETIC','BATCH_2023',NOW()),

-- 2023 READMISSIONS (within 30 days)
(3116,2036,1,101,'IP','2023-02-02','2023-02-06','I50.9',NULL,4800.00,4100.00,'01','SYNTHETIC','BATCH_2023',NOW()), -- 13 days after 1/20 ✓
(3117,2040,1,105,'IP','2023-07-10','2023-07-14','J18.9',NULL,3700.00,3200.00,'01','SYNTHETIC','BATCH_2023',NOW()), -- 17 days after 6/23 ✓
(3118,2045,1,101,'IP','2023-10-03','2023-10-07','I50.9',NULL,6300.00,5300.00,'01','SYNTHETIC','BATCH_2023',NOW()), -- 14 days after 9/19 ✓

-- === INPATIENT MENTAL HEALTH (FUH measure) ===
(4001,2021,4,103,'IP','2022-03-08','2022-03-15','F32.9',NULL,8500.00,7200.00,'01','SYNTHETIC','BATCH_2022',NOW()),
(4002,2022,4,103,'IP','2022-05-20','2022-05-27','F31.9',NULL,9100.00,7700.00,'01','SYNTHETIC','BATCH_2022',NOW()),
(4003,2023,4,103,'IP','2022-06-14','2022-06-21','F20.9',NULL,9400.00,7900.00,'01','SYNTHETIC','BATCH_2022',NOW()),
(4004,2024,4,103,'IP','2022-08-02','2022-08-09','F32.9',NULL,8200.00,6900.00,'01','SYNTHETIC','BATCH_2022',NOW()),
(4005,2025,4,103,'IP','2022-09-18','2022-09-25','F41.1',NULL,7800.00,6600.00,'01','SYNTHETIC','BATCH_2022',NOW()),
(4006,2026,4,103,'IP','2022-10-30','2022-11-06','F31.9',NULL,8900.00,7500.00,'01','SYNTHETIC','BATCH_2022',NOW()),
(4007,2027,4,103,'IP','2022-11-15','2022-11-22','F32.9',NULL,8000.00,6800.00,'01','SYNTHETIC','BATCH_2022',NOW()),
(4008,2028,4,103,'IP','2022-07-25','2022-08-01','F20.9',NULL,9600.00,8100.00,'01','SYNTHETIC','BATCH_2022',NOW()),
(4009,2029,4,103,'IP','2022-04-12','2022-04-19','F41.1',NULL,7600.00,6400.00,'01','SYNTHETIC','BATCH_2022',NOW()),
(4010,2030,4,103,'IP','2022-12-05','2022-12-12','F32.9',NULL,8300.00,7000.00,'01','SYNTHETIC','BATCH_2022',NOW()),

(4101,2021,4,103,'IP','2023-04-10','2023-04-17','F32.9',NULL,8700.00,7400.00,'01','SYNTHETIC','BATCH_2023',NOW()),
(4102,2022,4,103,'IP','2023-06-22','2023-06-29','F31.9',NULL,9200.00,7800.00,'01','SYNTHETIC','BATCH_2023',NOW()),
(4103,2023,4,103,'IP','2023-08-14','2023-08-21','F20.9',NULL,9500.00,8000.00,'01','SYNTHETIC','BATCH_2023',NOW()),
(4104,2024,4,103,'IP','2023-10-05','2023-10-12','F32.9',NULL,8400.00,7100.00,'01','SYNTHETIC','BATCH_2023',NOW()),
(4105,2025,4,103,'IP','2023-11-18','2023-11-25','F41.1',NULL,7900.00,6700.00,'01','SYNTHETIC','BATCH_2023',NOW()),

-- === ER VISITS (various members) ===
(5001,2001,1,104,'ER','2022-03-20',NULL,'E11.65',NULL,1800.00,1500.00,NULL,'SYNTHETIC','BATCH_2022',NOW()),
(5002,2004,2,104,'ER','2022-06-15',NULL,'I10',   NULL,1600.00,1300.00,NULL,'SYNTHETIC','BATCH_2022',NOW()),
(5003,2007,2,104,'ER','2022-09-08',NULL,'E11.9', NULL,1900.00,1600.00,NULL,'SYNTHETIC','BATCH_2022',NOW()),
(5004,2010,1,104,'ER','2022-11-02',NULL,'E11.65',NULL,2100.00,1750.00,NULL,'SYNTHETIC','BATCH_2022',NOW()),
(5005,2021,2,104,'ER','2022-02-01',NULL,'F32.9', NULL,2400.00,2000.00,NULL,'SYNTHETIC','BATCH_2022',NOW()),
(5006,2036,1,104,'ER','2022-01-20',NULL,'I50.9', NULL,2800.00,2300.00,NULL,'SYNTHETIC','BATCH_2022',NOW()),
(5007,2043,1,104,'ER','2023-07-05',NULL,'N18.3', NULL,1900.00,1600.00,NULL,'SYNTHETIC','BATCH_2023',NOW()),
(5008,2002,3,104,'ER','2023-04-12',NULL,'E11.9', NULL,1700.00,1400.00,NULL,'SYNTHETIC','BATCH_2023',NOW()),

-- === OUTPATIENT FOLLOW-UP (critical for FUH numerator) ===
-- FUH: Members who DID get follow-up within 7 days (numerator = 1)
(6001,2021,6,103,'OP','2022-03-18',NULL,'F32.9',NULL,350.00,280.00,NULL,'SYNTHETIC','BATCH_2022',NOW()), -- 3 days after 3/15 ✓
(6002,2022,6,103,'OP','2022-06-01',NULL,'F31.9',NULL,350.00,280.00,NULL,'SYNTHETIC','BATCH_2022',NOW()), -- 5 days after 5/27 ✓
(6003,2025,6,103,'OP','2022-09-29',NULL,'F41.1',NULL,350.00,280.00,NULL,'SYNTHETIC','BATCH_2022',NOW()), -- 4 days after 9/25 ✓
(6004,2027,6,103,'OP','2022-11-26',NULL,'F32.9',NULL,350.00,280.00,NULL,'SYNTHETIC','BATCH_2022',NOW()), -- 4 days after 11/22 ✓
(6005,2029,6,103,'OP','2022-04-24',NULL,'F41.1',NULL,350.00,280.00,NULL,'SYNTHETIC','BATCH_2022',NOW()), -- 5 days after 4/19 ✓
(6006,2021,6,103,'OP','2023-04-22',NULL,'F32.9',NULL,350.00,280.00,NULL,'SYNTHETIC','BATCH_2023',NOW()), -- 5 days after 4/17 ✓
(6007,2024,6,103,'OP','2023-10-17',NULL,'F32.9',NULL,350.00,280.00,NULL,'SYNTHETIC','BATCH_2023',NOW()); -- 5 days after 10/12 ✓
-- Members 2023, 2024, 2026, 2028, 2030 did NOT get follow-up within 7 days in 2022 (numerator = 0)

-- ---------------------------------------------------------------------------
-- DIAGNOSIS BRIDGE — secondary diagnoses
-- ---------------------------------------------------------------------------

INSERT INTO diagnosis_bridge VALUES
(3001,1,'J18.9'),(3001,2,'I10'),
(3002,1,'I50.9'),(3002,2,'E11.9'),(3002,3,'N18.3'),
(3003,1,'E11.65'),(3003,2,'I10'),
(3004,1,'N18.3'),(3004,2,'I10'),
(3005,1,'J18.9'),
(3006,1,'I50.9'),(3006,2,'E11.9'),(3006,3,'I10'),
(3007,1,'E11.9'),(3007,2,'I10'),
(3008,1,'N18.3'),(3008,2,'E11.9'),
(3009,1,'I50.9'),(3009,2,'I10'),
(3010,1,'J18.9'),
(3011,1,'I50.9'),(3011,2,'E11.9'),(3011,3,'N18.3'),
(3012,1,'J18.9'),(3012,2,'I10'),
(3013,1,'E11.9'),
(3014,1,'N18.3'),(3014,2,'E11.9'),
(3015,1,'I50.9'),(3015,2,'I10'),
(4001,1,'F32.9'),(4002,1,'F31.9'),(4003,1,'F20.9'),
(4004,1,'F32.9'),(4005,1,'F41.1'),(4006,1,'F31.9'),
(4007,1,'F32.9'),(4008,1,'F20.9'),(4009,1,'F41.1'),
(4010,1,'F32.9');

-- ---------------------------------------------------------------------------
-- PHARMACY CLAIMS — Antidiabetic fills (PDC_DM measure)
-- Members 2001–2020 are diabetic. PDC ~0.80+ for most, <0.80 for some.
-- ---------------------------------------------------------------------------

INSERT INTO pharmacy_claim_fact (rx_claim_id, member_id, ndc, fill_dt, days_supply, quantity, paid_amt, allowed_amt, source_system, load_batch_id, load_dt) VALUES
-- Member 2001 — high adherence (PDC ~0.95) — fills every ~30 days
(7001,2001,'00006013131','2022-01-05',30,60,12.00,10.00,'SYNTHETIC','BATCH_RX_2022',NOW()),
(7002,2001,'00006013131','2022-02-04',30,60,12.00,10.00,'SYNTHETIC','BATCH_RX_2022',NOW()),
(7003,2001,'00006013131','2022-03-06',30,60,12.00,10.00,'SYNTHETIC','BATCH_RX_2022',NOW()),
(7004,2001,'00006013131','2022-04-05',30,60,12.00,10.00,'SYNTHETIC','BATCH_RX_2022',NOW()),
(7005,2001,'00006013131','2022-05-05',30,60,12.00,10.00,'SYNTHETIC','BATCH_RX_2022',NOW()),
(7006,2001,'00006013131','2022-06-04',30,60,12.00,10.00,'SYNTHETIC','BATCH_RX_2022',NOW()),
(7007,2001,'00006013131','2022-07-04',30,60,12.00,10.00,'SYNTHETIC','BATCH_RX_2022',NOW()),
(7008,2001,'00006013131','2022-08-03',30,60,12.00,10.00,'SYNTHETIC','BATCH_RX_2022',NOW()),
(7009,2001,'00006013131','2022-09-02',30,60,12.00,10.00,'SYNTHETIC','BATCH_RX_2022',NOW()),
(7010,2001,'00006013131','2022-10-02',30,60,12.00,10.00,'SYNTHETIC','BATCH_RX_2022',NOW()),
(7011,2001,'00006013131','2022-11-01',30,60,12.00,10.00,'SYNTHETIC','BATCH_RX_2022',NOW()),
(7012,2001,'00006013131','2022-12-01',30,60,12.00,10.00,'SYNTHETIC','BATCH_RX_2022',NOW()),

-- Member 2002 — moderate adherence (PDC ~0.82)
(7021,2002,'00006013132','2022-01-10',30,60,45.00,38.00,'SYNTHETIC','BATCH_RX_2022',NOW()),
(7022,2002,'00006013132','2022-02-15',30,60,45.00,38.00,'SYNTHETIC','BATCH_RX_2022',NOW()),
(7023,2002,'00006013132','2022-03-22',30,60,45.00,38.00,'SYNTHETIC','BATCH_RX_2022',NOW()),
(7024,2002,'00006013132','2022-05-01',30,60,45.00,38.00,'SYNTHETIC','BATCH_RX_2022',NOW()),
(7025,2002,'00006013132','2022-06-10',30,60,45.00,38.00,'SYNTHETIC','BATCH_RX_2022',NOW()),
(7026,2002,'00006013132','2022-07-20',30,60,45.00,38.00,'SYNTHETIC','BATCH_RX_2022',NOW()),
(7027,2002,'00006013132','2022-09-05',30,60,45.00,38.00,'SYNTHETIC','BATCH_RX_2022',NOW()),
(7028,2002,'00006013132','2022-10-10',30,60,45.00,38.00,'SYNTHETIC','BATCH_RX_2022',NOW()),
(7029,2002,'00006013132','2022-11-15',30,60,45.00,38.00,'SYNTHETIC','BATCH_RX_2022',NOW()),

-- Member 2003 — NON-ADHERENT (PDC ~0.55) — big gaps mid-year
(7031,2003,'00006013133','2022-01-08',30,30,210.00,185.00,'SYNTHETIC','BATCH_RX_2022',NOW()),
(7032,2003,'00006013133','2022-02-12',30,30,210.00,185.00,'SYNTHETIC','BATCH_RX_2022',NOW()),
(7033,2003,'00006013133','2022-03-15',30,30,210.00,185.00,'SYNTHETIC','BATCH_RX_2022',NOW()),
(7034,2003,'00006013133','2022-07-10',30,30,210.00,185.00,'SYNTHETIC','BATCH_RX_2022',NOW()),
(7035,2003,'00006013133','2022-08-14',30,30,210.00,185.00,'SYNTHETIC','BATCH_RX_2022',NOW()),

-- Member 2004 — 90-day supply fills — high adherence (PDC ~0.99)
(7041,2004,'00006013134','2022-01-03',90,180,320.00,290.00,'SYNTHETIC','BATCH_RX_2022',NOW()),
(7042,2004,'00006013134','2022-04-03',90,180,320.00,290.00,'SYNTHETIC','BATCH_RX_2022',NOW()),
(7043,2004,'00006013134','2022-07-02',90,180,320.00,290.00,'SYNTHETIC','BATCH_RX_2022',NOW()),
(7044,2004,'00006013134','2022-10-01',90,180,320.00,290.00,'SYNTHETIC','BATCH_RX_2022',NOW()),

-- Member 2005 — NON-ADHERENT (PDC ~0.33) — only 4 fills, long gaps
(7051,2005,'00006013131','2022-01-15',30,60,12.00,10.00,'SYNTHETIC','BATCH_RX_2022',NOW()),
(7052,2005,'00006013131','2022-03-01',30,60,12.00,10.00,'SYNTHETIC','BATCH_RX_2022',NOW()),
(7053,2005,'00006013131','2022-07-20',30,60,12.00,10.00,'SYNTHETIC','BATCH_RX_2022',NOW()),
(7054,2005,'00006013131','2022-10-05',30,60,12.00,10.00,'SYNTHETIC','BATCH_RX_2022',NOW()),

-- Member 2006 — Insulin (high cost/adherence) PDC ~0.90
(7061,2006,'00006013135','2022-01-01',30,10,185.00,165.00,'SYNTHETIC','BATCH_RX_2022',NOW()),
(7062,2006,'00006013135','2022-01-30',30,10,185.00,165.00,'SYNTHETIC','BATCH_RX_2022',NOW()),
(7063,2006,'00006013135','2022-03-01',30,10,185.00,165.00,'SYNTHETIC','BATCH_RX_2022',NOW()),
(7064,2006,'00006013135','2022-03-31',30,10,185.00,165.00,'SYNTHETIC','BATCH_RX_2022',NOW()),
(7065,2006,'00006013135','2022-04-30',30,10,185.00,165.00,'SYNTHETIC','BATCH_RX_2022',NOW()),
(7066,2006,'00006013135','2022-05-30',30,10,185.00,165.00,'SYNTHETIC','BATCH_RX_2022',NOW()),
(7067,2006,'00006013135','2022-07-05',30,10,185.00,165.00,'SYNTHETIC','BATCH_RX_2022',NOW()),
(7068,2006,'00006013135','2022-08-04',30,10,185.00,165.00,'SYNTHETIC','BATCH_RX_2022',NOW()),
(7069,2006,'00006013135','2022-09-03',30,10,185.00,165.00,'SYNTHETIC','BATCH_RX_2022',NOW()),
(7070,2006,'00006013135','2022-10-03',30,10,185.00,165.00,'SYNTHETIC','BATCH_RX_2022',NOW()),
(7071,2006,'00006013135','2022-11-02',30,10,185.00,165.00,'SYNTHETIC','BATCH_RX_2022',NOW()),

-- Member 2007 — NON-ADHERENT (PDC ~0.25) — only 3 fills
(7081,2007,'00006013132','2022-02-10',30,60,45.00,38.00,'SYNTHETIC','BATCH_RX_2022',NOW()),
(7082,2007,'00006013132','2022-06-15',30,60,45.00,38.00,'SYNTHETIC','BATCH_RX_2022',NOW()),
(7083,2007,'00006013132','2022-11-01',30,60,45.00,38.00,'SYNTHETIC','BATCH_RX_2022',NOW()),

-- Member 2008 — good adherence (PDC ~0.88)
(7091,2008,'00006013131','2022-01-12',30,60,12.00,10.00,'SYNTHETIC','BATCH_RX_2022',NOW()),
(7092,2008,'00006013131','2022-02-11',30,60,12.00,10.00,'SYNTHETIC','BATCH_RX_2022',NOW()),
(7093,2008,'00006013131','2022-03-13',30,60,12.00,10.00,'SYNTHETIC','BATCH_RX_2022',NOW()),
(7094,2008,'00006013131','2022-04-12',30,60,12.00,10.00,'SYNTHETIC','BATCH_RX_2022',NOW()),
(7095,2008,'00006013131','2022-05-20',30,60,12.00,10.00,'SYNTHETIC','BATCH_RX_2022',NOW()),
(7096,2008,'00006013131','2022-07-01',30,60,12.00,10.00,'SYNTHETIC','BATCH_RX_2022',NOW()),
(7097,2008,'00006013131','2022-07-31',30,60,12.00,10.00,'SYNTHETIC','BATCH_RX_2022',NOW()),
(7098,2008,'00006013131','2022-08-30',30,60,12.00,10.00,'SYNTHETIC','BATCH_RX_2022',NOW()),
(7099,2008,'00006013131','2022-09-29',30,60,12.00,10.00,'SYNTHETIC','BATCH_RX_2022',NOW()),
(7100,2008,'00006013131','2022-10-29',30,60,12.00,10.00,'SYNTHETIC','BATCH_RX_2022',NOW()),

-- 2023 pharmacy fills (subset of members for year 2 comparison)
(8001,2001,'00006013131','2023-01-04',30,60,12.00,10.00,'SYNTHETIC','BATCH_RX_2023',NOW()),
(8002,2001,'00006013131','2023-02-03',30,60,12.00,10.00,'SYNTHETIC','BATCH_RX_2023',NOW()),
(8003,2001,'00006013131','2023-03-05',30,60,12.00,10.00,'SYNTHETIC','BATCH_RX_2023',NOW()),
(8004,2001,'00006013131','2023-04-04',30,60,12.00,10.00,'SYNTHETIC','BATCH_RX_2023',NOW()),
(8005,2001,'00006013131','2023-05-04',30,60,12.00,10.00,'SYNTHETIC','BATCH_RX_2023',NOW()),
(8006,2001,'00006013131','2023-06-03',30,60,12.00,10.00,'SYNTHETIC','BATCH_RX_2023',NOW()),
(8007,2001,'00006013131','2023-07-03',30,60,12.00,10.00,'SYNTHETIC','BATCH_RX_2023',NOW()),
(8008,2001,'00006013131','2023-08-02',30,60,12.00,10.00,'SYNTHETIC','BATCH_RX_2023',NOW()),
(8009,2001,'00006013131','2023-09-01',30,60,12.00,10.00,'SYNTHETIC','BATCH_RX_2023',NOW()),
(8010,2001,'00006013131','2023-10-01',30,60,12.00,10.00,'SYNTHETIC','BATCH_RX_2023',NOW()),
(8011,2001,'00006013131','2023-10-31',30,60,12.00,10.00,'SYNTHETIC','BATCH_RX_2023',NOW()),
(8012,2001,'00006013131','2023-11-30',30,60,12.00,10.00,'SYNTHETIC','BATCH_RX_2023',NOW()),
-- Member 2003 improved in 2023 (crosses 0.80 threshold)
(8021,2003,'00006013133','2023-01-10',30,30,210.00,185.00,'SYNTHETIC','BATCH_RX_2023',NOW()),
(8022,2003,'00006013133','2023-02-09',30,30,210.00,185.00,'SYNTHETIC','BATCH_RX_2023',NOW()),
(8023,2003,'00006013133','2023-03-11',30,30,210.00,185.00,'SYNTHETIC','BATCH_RX_2023',NOW()),
(8024,2003,'00006013133','2023-04-10',30,30,210.00,185.00,'SYNTHETIC','BATCH_RX_2023',NOW()),
(8025,2003,'00006013133','2023-05-10',30,30,210.00,185.00,'SYNTHETIC','BATCH_RX_2023',NOW()),
(8026,2003,'00006013133','2023-06-09',30,30,210.00,185.00,'SYNTHETIC','BATCH_RX_2023',NOW()),
(8027,2003,'00006013133','2023-07-09',30,30,210.00,185.00,'SYNTHETIC','BATCH_RX_2023',NOW()),
(8028,2003,'00006013133','2023-08-08',30,30,210.00,185.00,'SYNTHETIC','BATCH_RX_2023',NOW()),
(8029,2003,'00006013133','2023-09-07',30,30,210.00,185.00,'SYNTHETIC','BATCH_RX_2023',NOW()),
(8030,2003,'00006013133','2023-10-07',30,30,210.00,185.00,'SYNTHETIC','BATCH_RX_2023',NOW()),
-- Member 2005 still non-adherent in 2023
(8041,2005,'00006013131','2023-02-01',30,60,12.00,10.00,'SYNTHETIC','BATCH_RX_2023',NOW()),
(8042,2005,'00006013131','2023-05-10',30,60,12.00,10.00,'SYNTHETIC','BATCH_RX_2023',NOW()),
(8043,2005,'00006013131','2023-09-20',30,60,12.00,10.00,'SYNTHETIC','BATCH_RX_2023',NOW()),
-- Member 2004 — 2023 fills
(8051,2004,'00006013134','2023-01-02',90,180,320.00,290.00,'SYNTHETIC','BATCH_RX_2023',NOW()),
(8052,2004,'00006013134','2023-04-02',90,180,320.00,290.00,'SYNTHETIC','BATCH_RX_2023',NOW()),
(8053,2004,'00006013134','2023-07-01',90,180,320.00,290.00,'SYNTHETIC','BATCH_RX_2023',NOW()),
(8054,2004,'00006013134','2023-09-29',90,180,320.00,290.00,'SYNTHETIC','BATCH_RX_2023',NOW());

