# Day 12–13: Advanced SQL Transformations with Governance & Version Control (Athena)

## Objective
Implement reusable SQL transformations and Data Quality (DQ) validations on top of the NYC Taxi curated layer using Athena. Store SQL scripts in Git with governance metadata, and support analytics-ready outputs.

---

## Architecture Context (NYC Taxi Project)
- Curated data stored in S3 (Parquet, partitioned by ingestion_date)
- Athena used as the SQL transformation + validation engine
- Master data: taxi_zone_lookup (dimension/master table)
- Pipeline: S3 event → Step Functions → Glue ETL → Register Partition → Athena SQL (manual now, automatable later)

---

## Why Athena (not RDS)
Athena is serverless and queries curated Parquet directly from S3 without copying data into a database. This reduces operational overhead and cost while supporting analytics and validation. RDS is suited for transactional applications and frequent updates, which is not required for this data lake analytics use case.

---

## SQL Governance Metadata Standard
Each SQL script includes:
- Author: who wrote it
- Owner: business/engineering owner for logic
- Purpose: business question solved
- Dependencies: input tables/views
- Quality expectations: what correctness is guaranteed

---

## Repository Structure (Version Control)
sql/
  views/
  transformations/
  tests/
docs/

All SQL scripts are committed to GitHub with version history for audit and reproducibility.

---

## Day 12 Deliverables: Transformations (Modular SQL)

### 1) View: Trip Features
File:
- sql/views/vw_yellow_trip_features.sql

Outcome:
- Creates reusable view with engineered fields:
  - trip_duration_mins
  - fare_per_mile
  - tip_pct
- Filters invalid records (fare/distance/passenger/timestamps)

Business value:
- Makes metrics and reports consistent and reusable.

How to run:
- Copy SQL file into Athena and execute

Validation query:
```sql
SELECT * FROM nyc_taxi_datalake.vw_yellow_trip_features LIMIT 10;

View: Zone Enriched Trips

File:

sql/views/vw_yellow_zone_enriched.sql

Outcome:

Joins trips with master zone lookup to add readable zone/borough names

Business value:

Converts IDs into understandable geography for dashboards.

How to run:

Copy SQL file into Athena and execute

Validation query:

SELECT pu_zone, COUNT(*) 
FROM nyc_taxi_datalake.vw_yellow_zone_enriched
GROUP BY pu_zone
ORDER BY COUNT(*) DESC
LIMIT 10;

3) Materialized Dataset (CTAS): Daily Zone Summary

File:

sql/transformations/ctas_yellow_daily_zone_summary.sql

Outcome:

Creates physical summary table stored as Parquet in S3

Aggregates trips and averages by pickup zone and ingestion_date

Business value:

Faster dashboard queries, reduced repeat computation, optimized scan cost.

How to run:

Copy SQL file into Athena and execute

Validation queries:

SHOW TABLES IN nyc_taxi_datalake;

SELECT * 
FROM nyc_taxi_datalake.yellow_daily_zone_summary
LIMIT 10;

Day 13 Deliverables: SQL Data Quality (DQ) Tests
4) Test: Bad Value Detection

File:

sql/tests/test_bad_values.sql

Outcome:

Detects invalid values (negative fare/distance, passenger_count <= 0, bad timestamps)

Expected:

0 rows in curated layer

How to run:

-- run file in Athena

5) Test: Orphan Location Checks

File:

sql/tests/test_orphan_locations.sql

Outcome:

Detects pickup/dropoff IDs not found in master taxi_zone_lookup

Expected:

0 rows in curated (or minimal if master data changed)

How to run:

-- run file in Athena

6) DQ Monitoring: Metrics Summary

File:

sql/tests/dq_metrics_summary.sql

Outcome:

Computes DQ health metrics per ingestion_date:

total_rows

bad_rows

bad_ratio

Business value:

Monitoring + alert thresholds (PASS/WARN/FAIL) can be automated.

How to run:

-- run file in Athena

Execution Order in Athena

sql/views/vw_yellow_trip_features.sql

sql/views/vw_yellow_zone_enriched.sql

sql/transformations/ctas_yellow_daily_zone_summary.sql

sql/tests/test_bad_values.sql

sql/tests/test_orphan_locations.sql

sql/tests/dq_metrics_summary.sql
