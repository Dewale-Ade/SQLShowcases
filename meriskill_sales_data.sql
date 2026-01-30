-- This is the first project from MeriSKILL Internship Program
-- Overview of the Sales Dataset

SELECT *
FROM meriskill_sales_data_1;


---------------------------- Cleaning of the dataset -----------------------------------------

-- Check for NULL values
SELECT *
FROM meriskill_sales_data_1
WHERE order_id IS NULL
   OR product IS NULL
   OR quantity_ordered IS NULL
   OR price_each IS NULL
   OR order_date IS NULL
   OR purchase_address IS NULL
   OR month IS NULL
   OR sales IS NULL
   OR city IS NULL
   OR hour IS NULL;


-- Check for duplicates
SELECT
    order_id,
    product,
    quantity_ordered,
    price_each,
    order_date,
    purchase_address,
    month,
    sales,
    city,
    hour,
    COUNT(*)
FROM meriskill_sales_data_1
GROUP BY
    order_id,
    product,
    quantity_ordered,
    price_each,
    order_date,
    purchase_address,
    month,
    sales,
    city,
    hour
HAVING COUNT(*) > 1
ORDER BY order_id;


-- Delete duplicates while keeping original record
WITH cte AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY
                   order_id,
                   product,
                   quantity_ordered,
                   price_each,
                   order_date,
                   purchase_address,
                   month,
                   sales,
                   city,
                   hour
               ORDER BY order_id
           ) AS rn
    FROM meriskill_sales_data_1
)
DELETE FROM meriskill_sales_data_1
USING cte
WHERE meriskill_sales_data_1.ctid = cte.ctid
  AND cte.rn <> 1;


-- Check distinct values
SELECT DISTINCT order_id
FROM meriskill_sales_data_1;

SELECT DISTINCT quantity_ordered
FROM meriskill_sales_data_1;

SELECT DISTINCT product
FROM meriskill_sales_data_1
ORDER BY product;


-- Create column for Order Date only
ALTER TABLE meriskill_sales_data_1
ADD COLUMN dates DATE;

UPDATE meriskill_sales_data_1
SET dates = order_date::date;


-- Create column for Season
ALTER TABLE meriskill_sales_data_1
ADD COLUMN season VARCHAR(25);


-- Convert month (int) to string
ALTER TABLE meriskill_sales_data_1
ADD COLUMN month_string VARCHAR(25);

UPDATE meriskill_sales_data_1
SET month_string = month::VARCHAR;


-- Categorize Months by Season
SELECT month_string,
       CASE
           WHEN month BETWEEN 1 AND 2 THEN 'Winter'
           WHEN month BETWEEN 3 AND 5 THEN 'Spring'
           WHEN month BETWEEN 6 AND 8 THEN 'Summer'
           WHEN month BETWEEN 9 AND 11 THEN 'Autumn'
           WHEN month = 12 THEN 'Winter'
           ELSE NULL
       END AS season
FROM meriskill_sales_data_1;


UPDATE meriskill_sales_data_1
SET season = CASE
    WHEN month BETWEEN 1 AND 2 THEN 'Winter'
    WHEN month BETWEEN 3 AND 5 THEN 'Spring'
    WHEN month BETWEEN 6 AND 8 THEN 'Summer'
    WHEN month BETWEEN 9 AND 11 THEN 'Autumn'
    WHEN month = 12 THEN 'Winter'
    ELSE NULL
END;


-- Convert Hour (int) to string
ALTER TABLE meriskill_sales_data_1
ADD COLUMN hour_string VARCHAR(25);

UPDATE meriskill_sales_data_1
SET hour_string = hour::VARCHAR;


-- Create column for Period of Purchase
ALTER TABLE meriskill_sales_data_1
ADD COLUMN period VARCHAR(25);


-- Categorize period of purchase
SELECT hour,
       CASE
           WHEN hour BETWEEN 0 AND 5 THEN 'Night'
           WHEN hour BETWEEN 6 AND 11 THEN 'Morning'
           WHEN hour BETWEEN 12 AND 17 THEN 'Afternoon'
           WHEN hour BETWEEN 18 AND 23 THEN 'Evening'
           ELSE NULL
       END AS period
FROM meriskill_sales_data_1;


UPDATE meriskill_sales_data_1
SET period = CASE
    WHEN hour BETWEEN 0 AND 5 THEN 'Night'
    WHEN hour BETWEEN 6 AND 11 THEN 'Morning'
    WHEN hour BETWEEN 12 AND 17 THEN 'Afternoon'
    WHEN hour BETWEEN 18 AND 23 THEN 'Evening'
    ELSE NULL
END;


-- Create column for Weekdays
ALTER TABLE meriskill_sales_data_1
ADD COLUMN weekdays VARCHAR(25);

UPDATE meriskill_sales_data_1
SET weekdays = TO_CHAR(order_date, 'Day');




