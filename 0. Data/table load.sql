CREATE TABLE Trip_Details (
    trip_id INT PRIMARY KEY AUTO_INCREMENT,
    pickup_time DATETIME,
    dropoff_time DATETIME,
    passenger_count INT,
    trip_distance FLOAT,
    PULocationID INT,
    DOLocationID INT,
    fare_amount DECIMAL(10,2),
    surge_fee DECIMAL(10,2),
    vehicle VARCHAR(50),
    payment_type VARCHAR(50)
	FOREIGN KEY (PULocationID) REFERENCES Location(LocationID),
    FOREIGN KEY (DOLocationID) REFERENCES Location(LocationID)
);


CREATE TABLE Location (
    LocationID INT PRIMARY KEY,
    Location VARCHAR(100),
    City VARCHAR(100)
);