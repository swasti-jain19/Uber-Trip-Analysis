-- 4.1 Trips by hour of day -- 

SELECT 
    EXTRACT(HOUR FROM pickup_time )+1 AS hour_of_day,
    COUNT(*) AS trip_count
FROM trip_details
GROUP BY hour_of_day
ORDER BY hour_of_day;

-- 4.2 Trips by day of week -- 

SELECT 
    EXTRACT(DOW FROM pickup_time) AS day_of_week,
    COUNT(*) AS trip_count
FROM trip_details
GROUP BY day_of_week
ORDER BY day_of_week;

-- or --

SELECT 
    TO_CHAR(pickup_time, 'Day') AS day_name,
    COUNT(*) AS trip_count
FROM trip_details
GROUP BY day_name
ORDER BY trip_count DESC;

-- City-wise Avg Fare (Window Function) --

WITH trip_durations AS (
    SELECT 
        EXTRACT(DATE FROM pickup_time) AS trip_date,
        EXTRACT(MINUTE FROM pickup_time) -  EXTRACT(MINUTE FROM dropoff_time) AS duration_minutes
    FROM trip_details
)
SELECT 
    l.City,
    t.fare_amount,
    ROUND(AVG(t.fare_amount) OVER (PARTITION BY l.City),2) AS city_avg_fare
FROM trip_details t
JOIN location l ON t.PULocationID = l.LocationID
ORDER BY city_avg_fare, t.fare_amount DESC;


-- Time Gap Between Trips (Lag Function) --

SELECT 
    trip_id,
    pickup_time,
    LAG(dropoff_time) OVER (ORDER BY pickup_time) AS previous_drop,
    pickup_time - LAG(dropoff_time) OVER (ORDER BY pickup_time) AS gap_between_trips
FROM trip_details