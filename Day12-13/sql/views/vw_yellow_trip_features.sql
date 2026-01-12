-- Author: Lahari
-- Owner: NYC Taxi Data Engineering
-- Purpose: Create reusable trip-level features for analytics (duration, fare_per_mile, tip_pct).
-- Dependencies: nyc_taxi_datalake.curated_yellow_parquet
-- Quality expectations: Rows represent valid trips with positive fare/distance and valid timestamps.

CREATE OR REPLACE VIEW nyc_taxi_datalake.vw_yellow_trip_features AS
WITH base AS (
  SELECT
    VendorID,
    tpep_pickup_datetime,
    tpep_dropoff_datetime,
    passenger_count,
    trip_distance,
    PULocationID,
    DOLocationID,
    payment_type,
    fare_amount,
    tip_amount,
    total_amount,
    ingestion_date,
    row_key
  FROM nyc_taxi_datalake.curated_yellow_parquet
),
features AS (
  SELECT
    *,
    date_diff('minute', tpep_pickup_datetime, tpep_dropoff_datetime) AS trip_duration_mins,
    CASE WHEN trip_distance > 0 THEN fare_amount / trip_distance END AS fare_per_mile,
    CASE WHEN fare_amount > 0 THEN tip_amount / fare_amount END AS tip_pct
  FROM base
)
SELECT *
FROM features
WHERE trip_distance > 0
  AND fare_amount > 0
  AND passenger_count > 0
  AND tpep_pickup_datetime <= tpep_dropoff_datetime;

