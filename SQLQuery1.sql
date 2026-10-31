USE Insurance;
GO

-- 1. Empty the Fact table
TRUNCATE TABLE dbo.fact_insurance;
GO

-- 2. Insert using explicit text conversion
INSERT INTO dbo.fact_insurance (
    region_key, age_group_key, bmi_category_key,
    age, bmi, children, is_smoker, is_female, charges, log_charges
)
SELECT 
    (SELECT region_key FROM dbo.dim_region WHERE region = s.region),
    (SELECT age_group_key FROM dbo.dim_age_group WHERE age_group = 
        CASE 
            WHEN s.age BETWEEN 18 AND 25 THEN '18-25'
            WHEN s.age BETWEEN 26 AND 35 THEN '26-35'
            WHEN s.age BETWEEN 36 AND 45 THEN '36-45'
            WHEN s.age BETWEEN 46 AND 55 THEN '46-55'
            ELSE '56+' 
        END),
    (SELECT bmi_category_key FROM dbo.dim_bmi_category WHERE bmi_category = 
        CASE 
            WHEN s.bmi < 18.5 THEN 'Underweight'
            WHEN s.bmi < 25 THEN 'Normal'
            WHEN s.bmi < 30 THEN 'Overweight'
            ELSE 'Obese' 
        END),
    s.age, s.bmi, s.children, 
    
    -- Check for 'yes' OR '1' in smoker
    CASE 
        WHEN LOWER(CAST(s.smoker AS NVARCHAR(20))) IN ('yes', '1') THEN 1 
        ELSE 0 
    END,
    
    -- Check for 'female' OR '1' in sex
    CASE 
        WHEN LOWER(CAST(s.sex AS NVARCHAR(20))) IN ('female', '1') THEN 1 
        ELSE 0 
    END,
    
    s.charges, LOG(s.charges + 1)
FROM dbo.insurance_clean s;
GO

-- 3. Verify the math
SELECT 
    is_smoker,
    is_female,
    COUNT(*) AS Policy_Count,
    ROUND(AVG(charges), 2) AS Avg_Charges
FROM fact_insurance
GROUP BY
is_smoker, is_female;
GO
SELECT 
    b.bmi_category, 
    COUNT(*) AS Policy_Count,
    ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM fact_insurance)), 2) AS Percentage
FROM fact_insurance f
JOIN dim_bmi_category b ON f.bmi_category_key = b.bmi_category_key
GROUP BY b.bmi_category
ORDER BY Policy_Count DESC;

SELECT 
    is_smoker, 
    COUNT(*) AS Count,
    ROUND(AVG(charges), 2) AS Avg_Charges
FROM fact_insurance
GROUP BY is_smoker;
SELECT * FROM dbo.dim_region;

SELECT 
    r.region, 
    COUNT(f.region_key) AS Total_Records,
    ROUND(AVG(f.charges), 2) AS Avg_Charges
FROM dbo.fact_insurance f
LEFT JOIN dbo.dim_region r ON f.region_key = r.region_key
GROUP BY r.region;