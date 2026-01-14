-- Author: Lahari
-- Owner: NYC Taxi Data Engineering
-- Purpose: Identify trips with pickup/dropoff IDs missing in taxi_zone_lookup master data.
-- Dependencies: nyc_taxi_datalake.curated_yellow_parquet, nyc_taxi_datalake.taxi_zone_lookup
-- Quality expectations: Expected 0 orphan rows in curated layer.

WITH zones AS (
  SELECT CAST(locationid AS integer) AS locationid
  FROM nyc_taxi_datalake.taxi_zone_lookup
),
t AS (
  SELECT
    ingestion_date,
    row_key,
    PULocationID,
    DOLocationID
  FROM nyc_taxi_datalake.curated_yellow_parquet
)
SELECT *
FROM t
WHERE PULocationID NOT IN (SELECT locationid FROM zones)
   OR DOLocationID NOT IN (SELECT locationid FROM zones);

