-- 3.1 Total revenue (with surge) --

SELECT 
    SUM(fare_amount + "surge_fee") AS total_revenue
FROM trip_details;


-- 3.2 Average fare per trip --

SELECT 
    ROUND(AVG(fare_amount),2) AS avg_fare_without_surge,
    ROUND(AVG(fare_amount + "surge_fee"),2) AS avg_fare_with_surge
FROM trip_details;

-- 3.3 Top revenue-generating locations --

SELECT 
    l.Location,
    SUM(fare_amount + "surge_fee") AS revenue
FROM trip_details t
JOIN location l ON t.PULocationID = l.LocationID
GROUP BY l.Location
ORDER BY revenue DESC
LIMIT 10;

-- 3.4 Most used payment type --

SELECT 
    Payment_type,
    COUNT(*) AS count
FROM trip_details
GROUP BY Payment_type
ORDER BY count DESC;


-- 3.5 Average surge fee --

SELECT 
    ROUND(AVG("surge_fee"),2) AS avg_surge_fee
FROM trip_details;

-- Daily Revenue & Total Trips --

SELECT 
    CAST(pickup_time AS DATE) AS trip_date,
    COUNT(*) AS total_trips,
    SUM(fare_amount + "surge_fee") AS daily_revenue
FROM trip_details
GROUP BY trip_date
ORDER BY trip_date;

-- Running Total Revenue (Window Function) --

WITH daily_revenue AS (
    SELECT 
        "pickup_time"::date AS trip_date,
        SUM(fare_amount + "surge_fee") AS daily_revenue
    FROM trip_details
    GROUP BY trip_date
)
SELECT 
    trip_date,
    daily_revenue,
    SUM(daily_revenue) OVER (ORDER BY trip_date) AS running_total_revenue
FROM daily_revenue
ORDER BY trip_date;


-- Surge Fee Impact (as % of revenue) --

SELECT 
    SUM(surge_fee) AS total_surge,
    SUM(fare_amount + surge_fee) AS total_revenue,
    ROUND(SUM(surge_fee) / SUM(fare_amount + surge_fee) * 100, 2) || '%' AS surge_percent
FROM trip_details;
