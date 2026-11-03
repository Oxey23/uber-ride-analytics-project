# 🚖 Uber Ride Analytics: End-to-End SQL & BI Dashboard

![Google BigQuery](https://img.shields.io/badge/Google_BigQuery-4285F4?style=for-the-badge&logo=google-cloud&logoColor=white)
![SQL](https://img.shields.io/badge/SQL-Data_Transformation-F29111?style=for-the-badge&logo=postgresql&logoColor=white)
![Looker Studio](https://img.shields.io/badge/Looker_Studio-BI_Dashboard-4285F4?style=for-the-badge&logo=looker&logoColor=white)

## 📌 Project Overview
This project analyzes **Uber ride booking operations (2024)** using **Google BigQuery (SQL)** and **Looker Studio**. The primary goal is to evaluate operational efficiency, identify the root causes of ride cancellations (both customer and driver sides), measure revenue losses from incomplete rides, and provide actionable business recommendations.

🔗 **[View Interactive Looker Studio Dashboard Here](https://datastudio.google.com/reporting/14a1f47d-e1fa-41e7-9815-1d375d7b08ee)**

---

## 🖼️ Dashboard Preview
![Uber Analytics Dashboard](./dashboard_preview/preview_dashboard.pn)
*(Note: Ensure the image file name inside `dashboard_preview/` matches the path above)*

---

## 🏗️ Data Architecture (Medallion Approach)
To simulate a real-world analytics engineering workflow, the raw Kaggle dataset was processed in Google BigQuery using a structured multi-layer approach:

1. **Bronze Layer (Raw Data):** Ingested raw CSV data from Kaggle into BigQuery (`raw_uber`).
2. **Silver Layer (`01_data_cleaning_silver.sql`):**
   - Removed extra double-quotes (`""`) from `Booking ID` and `Customer ID`.
   - Standardized string `'null'` values into actual SQL `NULL` values using `NULLIF()`.
   - Converted data types (`DATE`, `TIME`, `FLOAT64`, and `INT64`) using `SAFE_CAST()`.
   - Standardized binary flags (`1` and `0`) for cancellation and incomplete ride indicators.
3. **Gold Layer (`03_gold_views_for_looker.sql`):**
   - Created `gold_uber_main` with derived time dimensions (`booking_hour`, `day_name`) and KPI binary flags for seamless aggregation in Looker Studio.
   - Created `gold_cancellation_reasons` using `UNION ALL` to consolidate Customer Cancellations, Driver Cancellations, and Incomplete Ride reasons into a single filterable view.

---

## 📂 Repository Structure
```text
📦 uber-ride-analytics-project
 ┣ 📂 dashboard_preview
 ┃ ┗ 🖼️ dashboard_screenshot.png       # Full snapshot of the Looker Studio dashboard
 ┣ 📂 sql_queries
 ┃ ┣ 📜 01_data_cleaning_silver.sql    # Data cleaning, NULL handling, & type casting
 ┃ ┣ 📜 02_exploratory_analysis.sql    # Ad-hoc SQL queries for KPIs & revenue loss
 ┃ ┗ 📜 03_gold_views_for_looker.sql   # Aggregated views feeding Looker Studio
 ┣ 📜 LICENSE
 ┗ 📜 README.md
