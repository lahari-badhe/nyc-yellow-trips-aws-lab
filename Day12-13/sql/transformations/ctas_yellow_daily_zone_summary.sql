-- Author: Lahari
-- Owner: NYC Taxi Data Engineering
-- Purpose: Materialize a daily pickup-zone summary dataset in Parquet for faster repeated analytics.
-- Dependencies: nyc_taxi_datalake.vw_yellow_zone_enriched
-- Quality expectations: Dataset contains aggregated metrics partitioned by ingestion_date.

CREATE TABLE nyc_taxi_datalake.yellow_daily_zone_summary
WITH (
  format = 'PARQUET',
  external_location = 's3://nyc-taxi-datalake-lahari/analytics/yellow_daily_zone_summary/',
  partitioned_by = ARRAY['ingestion_date']
) AS
SELECT
  pu_zone,
  COUNT(*) AS trip_cnt,
  AVG(trip_distance) AS avg_trip_distance,
  AVG(fare_amount) AS avg_fare_amount,
  AVG(tip_amount) AS avg_tip_amount,
  AVG(tip_pct) AS avg_tip_pct,
  AVG(trip_duration_mins) AS avg_trip_duration_mins,
  ingestion_date
FROM nyc_taxi_datalake.vw_yellow_zone_enriched
GROUP BY pu_zone, ingestion_date;

