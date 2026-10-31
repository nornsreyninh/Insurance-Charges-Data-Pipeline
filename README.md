# Medical Insurance Charges Data Pipeline

## 📌 Project Overview
This project is an end-to-end data analytics pipeline that analyzes medical insurance charges. It demonstrates skills in Python (Data Cleaning), SQL Server (Data Modeling), and Power BI (Data Visualization).

## 🛠️ Tech Stack
*   **Data Cleaning:** Python (Pandas, NumPy)
*   **Database:** Microsoft SQL Server (SSMS)
*   **Visualization:** Power BI
*   **Version Control:** Git & GitHub

## 📂 Repository Structure
*   `insurance_clean.csv` - The cleaned dataset ready for SQL import.
*   `database_setup.sql` - The SQL script to create the Star Schema (Fact and Dimensions) and insert data.
*   `Insurance_Dashboard.pbix` - The final Power BI file.
*   `README.md` - Project documentation.

## 🗄️ Data Modeling
The data was transformed into a **Star Schema** to optimize for Power BI querying:
*   **Fact Table:** `fact_insurance` (contains policy_id, age, bmi, charges, and foreign keys).
*   **Dimension Tables:** `dim_region`, `dim_age_group`, `dim_bmi_category`.

## 📊 Dashboard Insights
The interactive dashboard answers key business questions:
1.  **Smoking Impact:** Smokers pay roughly **4x more** on average than non-smokers ($32,050 vs $8,440).
2.  **Regional Risk:** The Southeast region has the highest average charges ($14,735).
3.  **BMI Correlation:** Obese smokers are the highest-risk segment, averaging $41,557 in charges.

## 📈 Dashboard Screenshot
![Dashboard Screenshot](dashboard.png)
