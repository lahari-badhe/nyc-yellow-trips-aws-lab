-- Author: Lahari
-- Owner: NYC Taxi Data Engineering
-- Purpose: Detect invalid numeric values and timestamp ordering issues in curated data.
-- Dependencies: nyc_taxi_datalake.curated_yellow_parquet
-- Quality expectations: Expected 0 rows in curated layer.

SELECT
  ingestion_date,
  row_key,
  trip_distance,
  fare_amount,
  passenger_count,
  tpep_pickup_datetime,
  tpep_dropoff_datetime
FROM nyc_taxi_datalake.curated_yellow_parquet
WHERE trip_distance IS NULL
   OR fare_amount IS NULL
   OR trip_distance <= 0
   OR fare_amount <= 0
   OR passenger_count <= 0
   OR tpep_pickup_datetime > tpep_dropoff_datetime;

