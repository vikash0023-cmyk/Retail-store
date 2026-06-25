create database retail;
use retail;
select * from fact_events;
select * from dim_campaigns;
select * from dim_products;
select * from dim_stores;
#Q1.  High-Value 'BOGOF' Products
SELECT DISTINCT 
    p.product_name, 
    e.base_price, 
    e.promo_type
FROM 
    fact_events e
JOIN 
    dim_products p ON e.product_code = p.product_code
WHERE 
    e.base_price > 500 
    AND e.promo_type = 'BOGOF';
    
#Q2. Store Count by City
SELECT 
    city, 
    COUNT(store_id) AS store_count
FROM 
    dim_stores
GROUP BY 
    city
ORDER BY 
    store_count DESC;
    
#Q3. Campaign Revenue Performance (In Millions)
SELECT 
        c.campaign_name,
        round(sum((f.base_price * f.`quantity_sold(before_promo)`)) /1000000, 2) AS TR_before_promo,
        round(sum((f.base_price * f.`quantity_sold(after_promo)`)) /1000000, 2) AS TR_after_promo
FROM fact_events f
JOIN dim_campaigns c ON f.campaign_id = c.campaign_id
GROUP BY campaign_name;


#Q4. Diwali Campaign Category Rankings by ISU%
WITH category_sales AS (
    SELECT 
        p.category,
        SUM(e.`quantity_sold(before_promo)`) AS total_qty_before,
        SUM(e.`quantity_sold(after_promo)`) AS total_qty_after
    FROM fact_events e
    JOIN dim_products p ON e.product_code = p.product_code
    JOIN dim_campaigns c ON e.campaign_id = c.campaign_id
    WHERE c.campaign_name = 'Diwali'
    GROUP BY p.category
),
isu_calculation AS (
    SELECT 
        category,
        ROUND(((total_qty_after - total_qty_before) / total_qty_before) * 100, 2) AS `isu%`
    FROM category_sales
)
SELECT 
    category,
    `isu%`,
    RANK() OVER (ORDER BY `isu%` DESC) AS rank_order
FROM isu_calculation;

#Q5. Top 5 Performing Products by Incremental Revenue % (IR%)
WITH product_revenue AS (
    SELECT 
        p.product_name,
        p.category,
        SUM(e.base_price * e.`quantity_sold(before_promo)`) AS total_rev_before,
        SUM(CASE 
            WHEN e.promo_type = 'BOGOF' THEN (e.base_price * 0.5) * (e.`quantity_sold(after_promo)` * 2)
            WHEN e.promo_type = '500 Cashback' THEN (e.base_price - 500) * e.`quantity_sold(after_promo)`
            WHEN e.promo_type = '50% OFF' THEN (e.base_price * 0.5) * e.`quantity_sold(after_promo)`
            WHEN e.promo_type = '25% OFF' THEN (e.base_price * 0.75) * e.`quantity_sold(after_promo)`
            WHEN e.promo_type = '33% OFF' THEN (e.base_price * 0.67) * e.`quantity_sold(after_promo)`
            ELSE e.base_price * e.`quantity_sold(after_promo)`
        END) AS total_rev_after
    FROM fact_events e
    JOIN dim_products p ON e.product_code = p.product_code
    GROUP BY p.product_name, p.category
)
SELECT 
    product_name,
    category,
    ROUND(((total_rev_after - total_rev_before) / total_rev_before) * 100, 2) AS `ir%`
FROM product_revenue
ORDER BY `ir%` DESC
LIMIT 5;


# Store performance
#Q1. Which are the top stores in terms of Incremental Revenue (IR) generated from the promotions ?

SELECT 
    store_id,
    ROUND(
        SUM((base_price * `quantity_sold(after_promo)`) - 
            (base_price * `quantity_sold(before_promo)`)),2
    ) AS incremental_revenue
FROM fact_events
GROUP BY store_id
ORDER BY incremental_revenue DESC
LIMIT 10;

#Q2. Which are the bottom 10 stores when it comes to increamental Sold Unit (ISU) during the promotional period?
SELECT 
    store_id,
    SUM(`quantity_sold(after_promo)` - `quantity_sold(before_promo)`) AS incremental_sold_units
FROM fact_events
GROUP BY store_id
ORDER BY incremental_sold_units ASC
LIMIT 10;

# Promotion Type Analysis
# 1. What are the top 2 promotion types that resulted in the highest incremental Revenue?

select
	promo_type,
    round(sum(base_price * `quantity_sold(after_promo)` - (base_price * `quantity_sold(before_promo)`)), 2) as Incremental_revenue
from fact_events
group by promo_type
order by Incremental_revenue desc
limit 2;

#2. What are the bottom 2 promotion types in terms of their impact on Incremental Sold Unit?
select
	promo_type,
    sum(`quantity_sold(after_promo)` - `quantity_sold(before_promo)`) as ISU
from fact_events
group by promo_type
order by ISU asc
limit 2;

# Product & Category analysis
#1. Which product categories saw the most significant lift in sales from the promotions ?

SELECT 
    p.category,
    SUM(f.`quantity_sold(after_promo)` - f.`quantity_sold(before_promo)`) AS sales_lift
FROM fact_events f
JOIN dim_products p
ON f.product_code = p.product_code
GROUP BY p.category
ORDER BY sales_lift DESC;
    
#2. Are there specific products that respond exceptionally well or poorly to promotion?

# Product expectionally well

SELECT 
    p.product_name,
    SUM(f.`quantity_sold(after_promo)` - f.`quantity_sold(before_promo)`) AS incremental_units
FROM fact_events f
JOIN dim_products p
ON f.product_code = p.product_code
GROUP BY p.product_name
ORDER BY incremental_units DESC
LIMIT 10;

# Product expectionally Poor
SELECT 
    p.product_name,
    SUM(f.`quantity_sold(after_promo)` - f.`quantity_sold(before_promo)`) AS incremental_units
FROM fact_events f
JOIN dim_products p
ON f.product_code = p.product_code
GROUP BY p.product_name
ORDER BY incremental_units ASC
LIMIT 10;

#3. What is the correlation between poduct category and promotion type effectiveness?
SELECT 
    p.category,
    f.promo_type,
    SUM(f.`quantity_sold(after_promo)` - f.`quantity_sold(before_promo)`) AS incremental_units,
    ROUND(
        SUM((f.base_price * f.`quantity_sold(after_promo)`)- 
            (f.base_price * f.`quantity_sold(before_promo)`)),2
    )AS incremental_revenue
FROM fact_events f
JOIN dim_products p
ON f.product_code = p.product_code
GROUP BY p.category, f.promo_type
ORDER BY incremental_revenue DESC;