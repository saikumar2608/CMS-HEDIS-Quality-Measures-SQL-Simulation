# Project 2 — CMS/HEDIS Quality Measures SQL Simulation

## Objective

Implement three industry-standard quality measures end-to-end in PostgreSQL —
from raw encounter data through denominator logic, exclusion handling, numerator
calculation, and stratified reporting outputs. Built to demonstrate readiness for
**Quality Reporting Analyst**, **HEDIS Analyst**, and **Clinical Analytics** roles.

**Platform:** PostgreSQL 18 via db\<\>fiddle  
**Data:** Synthetic — 60 members, 80+ encounters, 2 measurement years (2022 & 2023)  
**All validation checks pass:** 0 invalid numerators, 0 exclusion conflicts, 0 discrepancies across all 6 measure runs

---

## Measures Implemented

| Measure ID | Measure Name | Steward | Direction | 2022 Rate | 2023 Rate |
|---|---|---|---|---|---|
| `READMIT_30` | 30-Day All-Cause Readmission | CMS | Lower is better | 26.3% | 23.1% |
| `PDC_DM` | Medication Adherence for Diabetes (PDC ≥ 0.80) | NCQA/HEDIS | Higher is better | 50.0% | 75.0% |
| `FUH` | Follow-Up After Hospitalization for Mental Illness (7-day) | NCQA/HEDIS | Higher is better | 50.0% | 40.0% |

---

## Schema Diagram

```
member_dim (1) ──< eligibility_fact (many)
member_dim (1) ──< encounter_fact (many) ──< diagnosis_bridge (many) >── diagnosis_dim
member_dim (1) ──< pharmacy_claim_fact >── drug_dim
encounter_fact >── facility_dim
encounter_fact >── provider_dim
measure_dim (1) ──< measure_run_fact (many) ──< measure_member_result (many)
measure_rate_summary | measure_rate_by_facility | measure_rate_by_age_band | measure_trend
```

---

## Key Tables

| Table | Purpose |
|---|---|
| `member_dim` | 60 members with demographics and death date for mortality exclusions |
| `eligibility_fact` | Coverage spans; continuous enrollment criteria for all 3 measures |
| `encounter_fact` | IP, OP, ER encounters with admit/discharge, primary dx, discharge status |
| `diagnosis_bridge` | Multi-dx per encounter (primary + secondary ICD-10 codes) |
| `pharmacy_claim_fact` | Rx fills with NDC, fill date, days supply — core input for PDC |
| `drug_dim` | Drug reference with `is_antidiabetic_flag` |
| `diagnosis_dim` | ICD-10 reference with `is_mental_health_flag` for FUH cohort |
| `measure_dim` | Measure registry with full denom/numer/exclusion definitions |
| `measure_run_fact` | Audit trail per run with `parameters_json` — enterprise-grade lineage |
| `measure_member_result` | Member-level denom/numer/exclusion flags with `reason_codes` |
| `measure_rate_summary` | Final rates by measure and year |
| `measure_rate_by_facility` | Hospital-level rate stratification |
| `measure_rate_by_age_band` | Age-band stratification (18-34, 35-49, 50-64, 65+) |
| `measure_trend` | YOY rate change with direction flag (IMPROVED / DECLINED / NO CHANGE) |

---

## How to Run

1. Go to [db\<\>fiddle](https://dbfiddle.uk) → select **PostgreSQL 15**
2. Paste `sql/01_ddl.sql` into the **left (Schema) panel**
3. Paste `sql/02_synthetic_data.sql` directly below the DDL in the same left panel
4. Click **Run** — all tables populate with no errors
5. Paste `sql/03_measure_queries.sql` into the **right (Query) panel** → Run
6. Paste `sql/04_reporting_outputs.sql` into the right panel → Run

> **Validation:** The last 5 queries in `04_reporting_outputs.sql` are sanity checks.
> All return 0 errors and 0 discrepancies — confirming measure logic integrity.

---

## Measure Logic Deep Dive

### READMIT_30 — 30-Day All-Cause Readmission

```
Denominator:  IP discharges in measurement year, age 18+ at discharge,
              30-day continuous enrollment before AND after discharge

Exclusions:   discharge_status = '20' → death during stay        [EXCL_DEATH]
              discharge_status = '30' → transfer                  [EXCL_TRANSFER]
              primary_dx LIKE 'F%'    → psychiatric principal dx  [EXCL_PSYCH_DX]

Numerator:    Unplanned IP admission within 30 days of index discharge

Rate:         numerator / denominator  →  lower = better
```

**2022:** 19 eligible discharges, 11 excluded (10 psych + 1 death), 5 readmissions → **rate = 26.3%**  
**2023:** 13 eligible discharges, 5 excluded (psych), 3 readmissions → **rate = 23.1%** ↓ IMPROVED

**Why it matters clinically:** Readmissions represent failures in care transitions — inadequate
discharge planning, poor follow-up, or undertreated chronic conditions. CMS penalizes hospitals
under the Hospital Readmissions Reduction Program (HRRP). Heart failure (I50.9) drove the
majority of readmissions in this cohort — consistent with real-world patterns.

---

### PDC_DM — Medication Adherence for Diabetes

```
Denominator:  Members age 18-75, ≥2 antidiabetic fills in year,
              365-day continuous enrollment (Jan 1 – Dec 31)

Exclusions:   Enrollment gap > 45 days  [EXCL_ENROLLMENT_GAP]
              Fewer than 2 fills         [EXCL_INSUFFICIENT_FILLS]

PDC Method:   1. Expand each fill to daily coverage window via generate_series()
              2. Cap at Dec 31 to stay within measurement year
              3. GROUP BY deduplicates overlapping fill days
              4. PDC = unique covered days / 365

Numerator:    PDC ≥ 0.80

Rate:         numerator / denominator  →  higher = better
```

**2022 member-level results:**

| Member | Sex | Age | PDC | Status |
|---|---|---|---|---|
| 2004 | F | 72 | 0.986 | ADHERENT |
| 2001 | M | 64 | 0.986 | ADHERENT |
| 2006 | F | 77 | 0.901 | ADHERENT |
| 2008 | F | 47 | 0.822 | ADHERENT |
| 2002 | F | 57 | 0.740 | NON-ADHERENT |
| 2003 | M | 50 | 0.411 | NON-ADHERENT |
| 2005 | M | 42 | 0.329 | NON-ADHERENT |
| 2007 | M | 54 | 0.247 | NON-ADHERENT |

**2022 rate: 50.0%** (4/8 adherent) → **2023 rate: 75.0%** (3/4) ↑ IMPROVED

Member 2003 crossed the 0.80 threshold between years (PDC 0.41 → 0.82) — exactly the
improvement a pharmacist-led MTM program is designed to produce. Member 2007 (PDC 0.247)
is the highest-priority intervention target: 3 fills in a full year means roughly 275 days
without active medication coverage.

**Why it matters clinically:** PDC ≥ 0.80 directly feeds Medicare Star Ratings (Domains 3 & 4),
worth up to 5% of a plan's overall Star score. The HEDIS algorithm requires correct
overlap-merging of fills — implementing this with generate_series and GROUP BY deduplication
is the detail that separates analysts who understand the measure from those who write a
simpler (incorrect) sum of days_supply.

---

### FUH — Follow-Up After Hospitalization for Mental Illness (7-day)

```
Denominator:  IP discharge with principal dx in F20–F99 (ICD-10 mental health)
              Age 6+, continuous enrollment 7 days post-discharge

Exclusions:   discharge_status = '20' → death   [EXCL_DEATH]
              discharge_status = '30' → transfer [EXCL_TRANSFER]

Numerator:    Outpatient mental health visit within 7 days of discharge
              (follow-up encounter primary dx must also be on F% chapter)

Rate:         numerator / denominator  →  higher = better
```

**2022 member-level results:**

| Member | Diagnosis | Discharge | Follow-Up Status |
|---|---|---|---|
| 2021 | F32.9 Major Depression | 2022-03-15 | ✅ FOLLOW-UP MET (3 days) |
| 2022 | F31.9 Bipolar Disorder | 2022-05-27 | ✅ FOLLOW-UP MET (5 days) |
| 2023 | F20.9 Schizophrenia | 2022-06-21 | ❌ FOLLOW-UP MISSED |
| 2024 | F32.9 Major Depression | 2022-08-09 | ❌ FOLLOW-UP MISSED |
| 2025 | F41.1 Gen. Anxiety | 2022-09-25 | ✅ FOLLOW-UP MET (4 days) |
| 2026 | F31.9 Bipolar Disorder | 2022-11-06 | ❌ FOLLOW-UP MISSED |
| 2027 | F32.9 Major Depression | 2022-11-22 | ✅ FOLLOW-UP MET (4 days) |
| 2028 | F20.9 Schizophrenia | 2022-08-01 | ❌ FOLLOW-UP MISSED |
| 2029 | F41.1 Gen. Anxiety | 2022-04-19 | ✅ FOLLOW-UP MET (5 days) |
| 2030 | F32.9 Major Depression | 2022-12-12 | ❌ FOLLOW-UP MISSED |

**2022 rate: 50.0%** (5/10) → **2023 rate: 40.0%** (2/5) ↓ DECLINED

**Why it matters clinically:** Patients discharged after psychiatric hospitalization face
elevated suicide risk in the first 30 days. The 7-day follow-up window is evidence-based —
early contact is associated with a 30-50% reduction in readmission. The FUH decline
between years signals a behavioral health network gap that would trigger care management
workflow escalation in a production environment.

---

## Key Findings

**1. Readmission rate improved 3.2pp year-over-year (26.3% → 23.1%)**
Heart failure (I50.9) drove the majority of readmissions. Members 2036, 2041, and 2045
all had heart failure on both their index and readmission encounters. The improvement
suggests better post-acute follow-up in 2023, but the rate remains above the HRRP
20% benchmark target — meaning continued improvement opportunity exists.

**2. Diabetes adherence jumped 25 points (50% → 75%) — Member 2003 is the story**
Member 2003 went from PDC 0.41 in 2022 to PDC 0.82 in 2023. This mirrors the real-world
outcome of a structured outreach intervention. Contrast with Member 2007 (PDC 0.247) —
3 fills in a year, representing roughly 275 uncovered days and the highest clinical risk
in the cohort.

**3. Mental health follow-up declined (50% → 40%) — a quality alert**
Members with schizophrenia (F20.9) and bipolar disorder (F31.9) showed the highest
follow-up miss rates — consistent with real-world data showing these diagnoses correlate
with lower engagement post-discharge. In production, this triggers automated outreach
within 48 hours of discharge.

**4. 65+ members drive readmission risk — age-band stratification reveals the gap**
The 65+ band had a 30.0% readmission rate in 2022 vs 25.0% for the 50-64 band.
No readmissions occurred in members under 50, consistent with the clinical concentration
of multimorbidity (heart failure + CKD + diabetes) in older populations.

---

## Output Files (`/outputs`)

| File | Contents | Rows |
|---|---|---|
| `measure_rate_summary.csv` | Rate per measure per year — denom, excl, numer, rate | 6 |
| `measure_member_detail.csv` | Member-level flags with reason codes across all measures | 78 |
| `measure_rate_by_facility.csv` | Hospital-level rate stratification | 10 |
| `age_band_stratification.csv` | Age-band rates (18-34, 35-49, 50-64, 65+) | 19 |
| `yoy_trend.csv` | YOY rate change with IMPROVED / DECLINED / NO CHANGE flag | 6 |
| `pdc_adherence_detail.csv` | Individual member PDC scores with adherence status | 8 |
| `measure_run_audit_log.csv` | Full audit trail per run with parameters and final rates | 6 |

---

## Validation Results (all checks pass ✅)

| Check | Expected | Actual |
|---|---|---|
| `invalid_numer_without_denom` | 0 | **0** ✅ |
| `invalid_excl_and_denom` | 0 | **0** ✅ |
| Rate summary vs member-level discrepancy | 0 for all 6 measures | **0** ✅ |
| `measure_rate_rows` | 6 | **6** ✅ |
| `invalid_encounter_dates` | 0 | **0** ✅ |

---

## 2-Minute Interview Walkthrough

> *"I built three HEDIS and CMS quality measures end-to-end in PostgreSQL —
> 30-Day Readmission, PDC for Diabetes, and Follow-Up After Psychiatric Hospitalization.*
>
> *The schema separates raw encounter data from a measure execution layer.
> measure_run_fact logs every run with its parameters as JSON — full audit trail
> of exactly how each rate was produced, which is critical for HEDIS attestation
> and CMS submission environments.*
>
> *For Readmission, I implemented the CMS exclusion logic — death, transfer,
> and psychiatric primary diagnoses — and used a correlated subquery to detect
> any IP admission within 30 days of the index discharge.*
>
> *The PDC calculation was the most technically interesting piece. I used
> generate_series to expand every fill to individual covered days, then deduped
> overlapping fills with GROUP BY — exactly how NCQA specifies the algorithm.
> The payoff: Member 2003 went from PDC 0.41 to 0.82 between years, which is
> the kind of measurable improvement a pharmacist-led MTM program produces.*
>
> *All 5 validation checks return zero errors — confirming no numerator without
> denominator, no exclusion conflicts, and zero discrepancy between member-level
> and summary totals across all 6 measure runs."*

---

## Clinical Context (PharmD Perspective)

PDC is not just a claims metric — it reflects real patient behavior. Member 2007's
PDC of 0.247 (3 fills in a year) means roughly 275 days without antidiabetic medication
coverage. Clinically, that means uncontrolled blood glucose, elevated HbA1c, and
significantly increased risk of ER utilization, hospitalization, and long-term
microvascular complications including neuropathy, nephropathy, and retinopathy.

For FUH, the 7-day window is not arbitrary — it derives from evidence showing the
majority of psychiatric readmissions cluster in the first week post-discharge.
The 5 members who missed follow-up in 2022 would be the first cohort flagged
for outreach in a real-world care management workflow, with priority given to
the schizophrenia discharges given their historically lower engagement rates.

The measure_run_fact audit trail with parameters_json mirrors how enterprise
quality reporting systems work — every rate is reproducible, auditable, and
version-controlled. That pattern is what hiring managers at payers and health
systems look for when evaluating analytics candidates.

---

## Related Projects

- **[Project 1 — Claims Cohort & Medication Adherence SQL Engine](https://github.com/saikumar2608/SQL-Claims-Cohort-Medication-Adherence-SQL-Engine)**
  — Diabetic cohort identification, PDC calculation, utilization analysis, cost risk bucketing

---

## About

Built as part of a 3-project Healthcare SQL Portfolio targeting Healthcare Data Analyst
and Clinical Analytics roles. All data is 100% synthetic. Schema designed for
PostgreSQL 15; ANSI-compatible where possible.

**Topics:** `sql` `postgresql` `hedis` `quality-measures` `healthcare-analytics`
`readmission` `medication-adherence` `pdc` `clinical-analytics` `fuh`
