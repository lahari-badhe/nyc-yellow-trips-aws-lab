-- Author: Lahari
-- Owner: NYC Taxi Data Engineering
-- Purpose: Enrich curated trips with pickup and dropoff zone names for reporting and business analytics.
-- Dependencies: nyc_taxi_datalake.vw_yellow_trip_features, nyc_taxi_datalake.taxi_zone_lookup
-- Quality expectations: Zone enrichment should resolve most IDs. Any null zones indicate orphan master-data references.

CREATE OR REPLACE VIEW nyc_taxi_datalake.vw_yellow_zone_enriched AS
WITH trips AS (
  SELECT * FROM nyc_taxi_datalake.vw_yellow_trip_features
),
zones AS (
  SELECT
    CAST(locationid AS integer) AS locationid,
    borough,
    zone,
    service_zone
  FROM nyc_taxi_datalake.taxi_zone_lookup
)
SELECT
  t.*,
  zp.borough AS pu_borough,
  zp.zone AS pu_zone,
  zd.borough AS do_borough,
  zd.zone AS do_zone
FROM trips t
LEFT JOIN zones zp ON t.PULocationID = zp.locationid
LEFT JOIN zones zd ON t.DOLocationID = zd.locationid;

