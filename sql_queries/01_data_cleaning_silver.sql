-- ============================================================================
-- FILE: 01_data_cleaning_silver.sql
-- DESKRIPSI: Cleaning untuk datasets utama untuk dibuat silver layer.
-- ============================================================================
CREATE OR REPLACE TABLE `uber-506405.uber_dataset.silver_uber` AS
SELECT 
    `Date` AS `date`,
    `Time` AS `time`,
    REPLACE(`Booking ID`, '"', '') AS booking_id,
    `Booking Status` AS booking_status,
    REPLACE(`Customer ID`, '"', '') AS customer_id,
    `Vehicle Type` AS vehicle_type,
    `Pickup Location` AS pickup_location,
    `Drop Location` AS drop_location,
    SAFE_CAST(NULLIF(`Avg VTAT`, 'null') AS FLOAT64) AS avg_vtat,
    SAFE_CAST(NULLIF(`Avg CTAT`, 'null') AS FLOAT64) AS avg_ctat,
    CASE WHEN `Cancelled Rides by Customer` = '1' THEN 1 ELSE 0 END AS cancel_rd_cust,
    NULLIF(`Reason for cancelling by Customer`, 'null') AS reason_cust,
    CASE WHEN `Cancelled Rides by Driver` = '1' THEN 1 ELSE 0 END AS cancel_rd_driver,
    NULLIF(`Driver Cancellation Reason`, 'null') AS reason_driver,
    CASE WHEN `Incomplete Rides` = '1' THEN 1 ELSE 0 END AS incomplete_rides,
    NULLIF(`Incomplete Rides Reason`, 'null') AS incomplete_reason,
    SAFE_CAST(NULLIF(`Booking Value`, 'null') AS INT64) AS booking_value,
    SAFE_CAST(NULLIF(`Ride Distance`, 'null') AS FLOAT64) AS ride_distance,
    SAFE_CAST(NULLIF(`Driver Ratings`, 'null') AS FLOAT64) AS driver_ratings,
    SAFE_CAST(NULLIF(`Customer Rating`, 'null') AS FLOAT64) AS customer_rating,
    NULLIF(`Payment Method`, 'null') AS payment_method
FROM 
    `uber-506405.uber_dataset.bronze_uber`;
