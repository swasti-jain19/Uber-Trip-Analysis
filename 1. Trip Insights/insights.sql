-- 1.1 Total number of trips --

SELECT COUNT(*) AS total_trips
FROM trip_details; 

-- 1.2 Average and maximum trip distance -- 
SELECT  
    ROUND(AVG(trip_distance)::numeric, 2) AS avg_distance,  -- AVG(trip_distance) → double precision so we explicitly cast--
    MAX(trip_distance) AS max_distance
FROM trip_details;

-- 1.3 Average trip duration (in minutes) --
SELECT 
    ROUND(AVG(EXTRACT(EPOCH FROM "dropoff_time" - "pickup_time") / 60), 2) AS avg_trip_duration_mins
FROM trip_details;

-- 1.4 Average passengers per trip -- 
SELECT 
    ROUND(AVG(passenger_count)) AS avg_passenger_count
FROM trip_details;


-- 1.5 Trips with 1 passenger vs shared -- 
SELECT 
    CASE 
        WHEN passenger_count = 1 THEN 'Solo Ride'
        ELSE 'Shared Ride'
    END AS ride_type,
    COUNT(*) AS trip_count
FROM trip_details
GROUP BY ride_type;


-- Longest Trips by Distance -- 

SELECT 
	trip_id, 
	trip_distance ,  
	pl.Location AS pickup,
    dl.Location AS dropoff
FROM trip_details t
join location pl on t.PULocationID = pl.LocationID
JOIN location dl ON t.DOLocationID = dl.LocationID
ORDER BY trip_distance DESC
LIMIT 5;


-- Longest trips by duration --

SELECT 
	trip_id, 
	ROUND(EXTRACT(EPOCH FROM "dropoff_time" - "pickup_time") / 60,2) AS trip_duration,
	pl.Location AS pickup,
    dl.Location AS dropoff
FROM trip_details t
join location pl on t.PULocationID = pl.LocationID
JOIN location dl ON t.DOLocationID = dl.LocationID
ORDER BY trip_duration DESC
LIMIT 5;

-- Fare per Kilometer (for detecting expensive short trips) --

SELECT 
    trip_id, 
    ROUND(((fare_amount + "surge_fee") / NULLIF(trip_distance, 0))::numeric, 2) AS fare_per_km
FROM trip_details
ORDER BY fare_per_km DESC
LIMIT 5;

-- Inefficient Trips (low distance, high duration) --

SELECT 
	trip_id, 
    ROUND(EXTRACT(EPOCH FROM dropoff_time - pickup_time) / 60,2) AS duration_minutes
FROM trip_details
WHERE trip_distance < 2
AND  ROUND(EXTRACT(EPOCH FROM dropoff_time - pickup_time) / 60,2) > 20
ORDER BY duration_minutes DESC;


-- Repeat Routes (Same Pickup & Dropoff) --

SELECT 
    pl.Location AS pickup_location,
    dl.Location AS dropoff_location,
    COUNT(*) AS frequency
FROM trip_details t
JOIN location pl ON t.PULocationID = pl.LocationID
JOIN location dl ON t.DOLocationID = dl.LocationID
WHERE t.PULocationID = t.DOLocationID
GROUP BY pickup_location, dropoff_location
ORDER BY frequency DESC;


-- Payment Type Breakdown by Vehicle --

SELECT 
    Vehicle,
    Payment_type,
    COUNT(*) AS usage_count
FROM trip_details
GROUP BY Vehicle, Payment_type
ORDER BY Vehicle, usage_count DESC;
