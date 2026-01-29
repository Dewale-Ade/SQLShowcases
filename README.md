View Dataset

SELECT *
FROM public."MeriSKILL_Sales_Data_1";


Check for NULL Values


SELECT *
FROM public."MeriSKILL_Sales_Data_1"
WHERE
    "Order ID" IS NULL
 OR "Product" IS NULL
 OR "Quantity Ordered" IS NULL
 OR "Price Each" IS NULL
 OR "Order Date" IS NULL
 OR "Purchase Address" IS NULL
 OR "Month" IS NULL
 OR "Sales" IS NULL
 OR "City" IS NULL
 OR "Hour" IS NULL;


Check for Duplicates

SELECT
    "Order ID", "Product", "Quantity Ordered", "Price Each",
    "Order Date", "Purchase Address", "Month",
    "Sales", "City", "Hour",
    COUNT(*)
FROM public."MeriSKILL_Sales_Data_1"
GROUP BY
    "Order ID", "Product", "Quantity Ordered", "Price Each",
    "Order Date", "Purchase Address", "Month",
    "Sales", "City", "Hour"
HAVING COUNT(*) > 1
ORDER BY "Order ID";


Remove Duplicates (Keep First Record)

WITH cte AS (
    SELECT
        ctid,
        ROW_NUMBER() OVER (
            PARTITION BY
                "Order ID", "Product", "Quantity Ordered",
                "Price Each", "Order Date", "Purchase Address",
                "Month", "Sales", "City", "Hour"
            ORDER BY "Order ID"
        ) AS rn
    FROM public."MeriSKILL_Sales_Data_1"
)
DELETE FROM public."MeriSKILL_Sales_Data_1"
USING cte
WHERE public."MeriSKILL_Sales_Data_1".ctid = cte.ctid
  AND cte.rn <> 1;
  

Distinct Checks

SELECT DISTINCT "Order ID"
FROM public."MeriSKILL_Sales_Data_1";

SELECT DISTINCT "Quantity Ordered"
FROM public."MeriSKILL_Sales_Data_1";

SELECT DISTINCT "Product"
FROM public."MeriSKILL_Sales_Data_1"
ORDER BY "Product";


Create Date-only Column

ALTER TABLE public."MeriSKILL_Sales_Data_1"
ADD COLUMN dates DATE;

UPDATE public."MeriSKILL_Sales_Data_1"
SET dates = "Order Date"::date;


Add Season Column

ALTER TABLE public."MeriSKILL_Sales_Data_1"
ADD COLUMN season VARCHAR(25);


Month as String

ALTER TABLE public."MeriSKILL_Sales_Data_1"
ADD COLUMN month_string VARCHAR(25);

UPDATE public."MeriSKILL_Sales_Data_1"
SET month_string = "Month"::VARCHAR;



Categorize Season

UPDATE public."MeriSKILL_Sales_Data_1"
SET season = CASE
    WHEN "Month" BETWEEN 1 AND 2 THEN 'Winter'
    WHEN "Month" BETWEEN 3 AND 5 THEN 'Spring'
    WHEN "Month" BETWEEN 6 AND 8 THEN 'Summer'
    WHEN "Month" BETWEEN 9 AND 11 THEN 'Autumn'
    WHEN "Month" = 12 THEN 'Winter'
    ELSE NULL
END;


Hour as String

ALTER TABLE public."MeriSKILL_Sales_Data_1"
ADD COLUMN hour_string VARCHAR(25);

UPDATE public."MeriSKILL_Sales_Data_1"
SET hour_string = "Hour"::VARCHAR;


Period of Purchase

ALTER TABLE public."MeriSKILL_Sales_Data_1"
ADD COLUMN period VARCHAR(25);

UPDATE public."MeriSKILL_Sales_Data_1"
SET period = CASE
    WHEN "Hour" BETWEEN 0 AND 5 THEN 'Night'
    WHEN "Hour" BETWEEN 6 AND 11 THEN 'Morning'
    WHEN "Hour" BETWEEN 12 AND 17 THEN 'Afternoon'
    WHEN "Hour" BETWEEN 18 AND 23 THEN 'Evening'
    ELSE NULL
END;


Weekday Column

ALTER TABLE public."MeriSKILL_Sales_Data_1"
ADD COLUMN weekdays VARCHAR(25);

UPDATE public."MeriSKILL_Sales_Data_1"
SET weekdays = TRIM(TO_CHAR("Order Date", 'Day'));



