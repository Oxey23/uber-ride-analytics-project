-- ============================================================================
-- FILE: 02_exploratory_data_analysis.sql
-- DESKRIPSI: Eksplorasi metrik bisnis utama (Booking Status, Success Rate, 
--            Performa Kendaraan, dan Kerugian akibat Incomplete Rides)
-- ============================================================================

-- 1. Top Alasan Pembatalan Gabungan (Customer & Driver)
WITH combined_reasons AS (
  SELECT reason_cust AS reason, booking_id
  FROM `uber-506405.uber_dataset.silver_uber`
  WHERE reason_cust IS NOT NULL
  UNION ALL
  SELECT reason_driver AS reason, booking_id
  FROM `uber-506405.uber_dataset.silver_uber`
  WHERE reason_driver IS NOT NULL
)
SELECT 
  reason, 
  COUNT(booking_id) AS total_cancel_reason
FROM combined_reasons
GROUP BY 1
ORDER BY total_cancel_reason DESC;

-- 2. Distribusi Status Pemesanan (Booking Status)
SELECT 
  booking_status, 
  COUNT(booking_id) AS total_bookings
FROM `uber-506405.uber_dataset.silver_uber`
GROUP BY booking_status
ORDER BY total_bookings DESC;

-- 3. Net Success Rate (%) dan Rata-rata Waktu Tunggu Jemput (VTAT)
SELECT
  ROUND(COUNT(CASE WHEN booking_status = 'Completed' THEN 1 END) * 100.0 / COUNT(*), 2) AS net_success_rate_pct,
  ROUND(AVG(avg_vtat), 2) AS average_arrive_minutes
FROM `uber-506405.uber_dataset.silver_uber`;

-- 4. Performa Pendapatan & Waktu Jemput per Tipe Kendaraan
SELECT
  vehicle_type,
  COUNT(booking_id) AS total_rides,
  SUM(booking_value) AS total_revenue,
  ROUND(AVG(avg_vtat), 2) AS average_arrive_minutes
FROM `uber-506405.uber_dataset.silver_uber`
GROUP BY vehicle_type
ORDER BY total_revenue DESC;

-- 5. Analisis Kerugian Pendapatan (Value Lost) dari Incomplete Rides
SELECT
  incomplete_reason,
  COUNT(booking_id) AS total_incomplete_rides,
  SUM(booking_value) AS incomplete_value_lost
FROM `uber-506405.uber_dataset.silver_uber`
WHERE booking_status = 'Incomplete'
GROUP BY incomplete_reason
ORDER BY incomplete_value_lost DESC;
