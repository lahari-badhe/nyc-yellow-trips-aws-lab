-- Author: Lahari
-- Owner: NYC Taxi Data Engineering
-- Purpose: Compute daily curated data quality metrics (bad_rows, bad_ratio) for monitoring.
-- Dependencies: nyc_taxi_datalake.curated_yellow_parquet, nyc_taxi_datalake.taxi_zone_lookup
-- Quality expectations: bad_ratio should stay within agreed thresholds.

WITH zones AS (
  SELECT CAST(locationid AS integer) AS locationid
  FROM nyc_taxi_datalake.taxi_zone_lookup
),
base AS (
  SELECT *
  FROM nyc_taxi_datalake.curated_yellow_parquet
),
bad AS (
  SELECT *
  FROM base
  WHERE trip_distance IS NULL
     OR fare_amount IS NULL
     OR trip_distance <= 0
     OR fare_amount <= 0
     OR passenger_count <= 0
     OR tpep_pickup_datetime > tpep_dropoff_datetime
     OR PULocationID NOT IN (SELECT locationid FROM zones)
     OR DOLocationID NOT IN (SELECT locationid FROM zones)
)
SELECT
  b.ingestion_date,
  COUNT(*) AS total_rows,
  (SELECT COUNT(*) FROM bad WHERE bad.ingestion_date = b.ingestion_date) AS bad_rows,
  CAST((SELECT COUNT(*) FROM bad WHERE bad.ingestion_date = b.ingestion_date) AS double) / NULLIF(COUNT(*), 0) AS bad_ratio
FROM base b
GROUP BY b.ingestion_date
ORDER BY b.ingestion_date DESC;

