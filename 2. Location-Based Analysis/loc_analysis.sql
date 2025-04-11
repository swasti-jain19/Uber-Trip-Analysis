-- 2.1 Top 10 pickup locations --
SELECT 
    l.Location, l.City, COUNT(*) AS pickup_count
FROM trip_details t
JOIN location l ON t.PULocationID = l.LocationID
GROUP BY l.Location, l.City
ORDER BY pickup_count DESC
LIMIT 10;


-- 2.2 Top 10 drop-off locations --
SELECT 
    l.Location, l.City, COUNT(*) AS dropoff_count
FROM trip_details t
JOIN location l ON t.DOLocationID = l.LocationID
GROUP BY l.Location, l.City
ORDER BY dropoff_count DESC
LIMIT 10;


-- 2.3 Most frequent pickup-dropoff combinations --
SELECT 
    pl.Location AS pickup_location,
    dl.Location AS dropoff_location,
    COUNT(*) AS trip_count
FROM trip_details t
JOIN location pl ON t.PULocationID = pl.LocationID
JOIN location dl ON t.DOLocationID = dl.LocationID
GROUP BY pickup_location, dropoff_location
ORDER BY trip_count DESC
LIMIT 10;


-- 2.4 Average fare per city (by pickup location) -- 

SELECT 
    l.City,
    ROUND(AVG(fare_amount + "surge_fee"),2) AS avg_fare
FROM trip_details t
JOIN location l ON t.PULocationID = l.LocationID
GROUP BY l.City
ORDER BY avg_fare DESC;


-- Peak Hour by City --

WITH ranked_hours AS (
    SELECT 
        l.City,
        EXTRACT(HOUR FROM pickup_time) AS hour,
        COUNT(*) AS trip_count,
        ROW_NUMBER() OVER (PARTITION BY l.City ORDER BY COUNT(*) DESC) AS rn
    FROM trip_details t
    JOIN location l ON t.PULocationID = l.LocationID
    GROUP BY l.City, hour
)
SELECT 
    City, hour, trip_count
FROM ranked_hours
WHERE rn = 1
ORDER BY trip_count DESC;


-- Trip Count per Day per City --

SELECT 
    l.City,
    CAST(pickup_time AS DATE) AS trip_date,
    COUNT(*) AS trip_count
FROM trip_details t
JOIN location l ON t.PULocationID = l.LocationID
GROUP BY l.City, trip_date
ORDER BY trip_date, trip_count DESC;

-- Top City Each Day by Trip Count --
WITH ranked_trips AS (
    SELECT 
        l.City,
        "pickup_time"::date AS trip_date,
        COUNT(*) AS trip_count,
        ROW_NUMBER() OVER (PARTITION BY "pickup_time"::date ORDER BY COUNT(*) DESC) AS rn
    FROM trip_details t
    JOIN location l ON t.PULocationID = l.LocationID
    GROUP BY l.City, trip_date
)
SELECT 
    trip_date,
    City,
    trip_count
FROM ranked_trips
WHERE rn = 1
ORDER BY trip_date;
