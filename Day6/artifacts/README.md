# Day 6 – Phase 4: Delta Lake on AWS Glue (NYC Taxi)

## Objective
Convert raw NYC Taxi data into Delta Lake format using AWS Glue and demonstrate
auditability through Delta time travel.

---

## What Was Implemented

### ✔ Delta Lake Conversion
- Raw Parquet data stored in S3 was converted into Delta Lake format.
- Delta transaction logs (`_delta_log`) were generated in S3.

### ✔ Time Travel (Audit Trail)
- Multiple Delta versions were created using overwrite + append.
- Historical versions were queried using `versionAsOf`.

### ✔ AWS Glue Execution
- Job executed on AWS Glue 5.0 (Spark 3.5).
- Delta Lake enabled using Glue job parameters.
- Spark session verified with Delta extensions and catalog.

---

## Glue Job Configuration (Critical)
The following Glue job parameters were required:





--datalake-formats = delta
--conf spark.sql.extensions=io.delta.sql.DeltaSparkSessionExtension
--conf spark.sql.catalog.spark_catalog=org.apache.spark.sql.delta.catalog.DeltaCatalog




Without these parameters, Delta operations fail in Glue.

---

## Proof Artifacts
All screenshots are available in the `proofs/` folder:

- Glue job successful run
- Delta `_delta_log` in S3 (transaction history)
- Spark configuration proof
- Time travel count comparison

---

## Challenges Encountered

### ❌ Delta without Spark configuration
- Delta Lake does not work by default in Glue.
- Explicit Spark extensions and catalog configuration are mandatory.

### ❌ Catalog-based Delta tables
- Using `CREATE TABLE USING DELTA` with Glue Catalog caused multiple failures.
- Path-based Delta (`.save("s3://...")`) is more stable in Glue.

### ❌ Iceberg experiments
- Iceberg required additional catalog setup and caused bootstrap errors.
- Delta Lake was more practical for this lab scope.

---

## Final Outcome
Delta Lake was successfully implemented in AWS Glue with:
- ACID-compliant storage
- Versioned audit trail
- Real-world constraints documented

This phase satisfies all Day-6 requirements for modern data lake storage.

