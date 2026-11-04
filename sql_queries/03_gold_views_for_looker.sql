-- ============================================================================
-- FILE: 03_gold_views_for_looker.sql
-- DESKRIPSI: Hasil eksplorasi metrik bisnis utama (Booking Status, Success Rate, 
--            Performa Kendaraan, dan Kerugian akibat Incomplete Rides) 
-- ============================================================================

-- 1. gold_uber_main
CREATE OR REPLACE VIEW `uber-506405.uber_dataset.gold_uber_main` AS
SELECT
  *,
  -- Ekstrak jam (0-23) dan nama hari untuk Heatmap/Bar Chart
  EXTRACT(HOUR FROM `time`) AS booking_hour,
  FORMAT_DATE('%A', `date`) AS day_name,
  
  -- Kolom bantuan (1 atau 0) agar tinggal drag-and-drop di Scorecard Looker Studio
  CASE WHEN booking_status = 'Completed' THEN 1 ELSE 0 END AS is_completed,
  CASE WHEN booking_status IN ('Cancelled by Customer', 'Cancelled by Driver') THEN 1 ELSE 0 END AS is_cancelled,
  CASE WHEN booking_status = 'No Driver Found' THEN 1 ELSE 0 END AS is_no_driver
FROM `uber-506405.uber_dataset.silver_uber`;

-- ============================================================================
-- 2. gold_cancellation_reasons

CREATE OR REPLACE VIEW `uber-506405.uber_dataset.gold_cancellation_reasons` AS
SELECT `date`, vehicle_type, pickup_location, 'Customer Cancellation' AS issue_category, reason_cust AS reason, booking_id
FROM `uber-506405.uber_dataset.silver_uber` WHERE reason_cust IS NOT NULL
UNION ALL
SELECT `date`, vehicle_type, pickup_location, 'Driver Cancellation' AS issue_category, reason_driver AS reason, booking_id
FROM `uber-506405.uber_dataset.silver_uber` WHERE reason_driver IS NOT NULL
UNION ALL
SELECT `date`, vehicle_type, pickup_location, 'Incomplete Ride' AS issue_category, incomplete_reason AS reason, booking_id
FROM `uber-506405.uber_dataset.silver_uber` WHERE incomplete_reason IS NOT NULL;

