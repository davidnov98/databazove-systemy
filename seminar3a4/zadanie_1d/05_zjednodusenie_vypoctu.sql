SELECT 
    p.category,
    p.product_name,
    SUM(o.sales) AS product_sales,
    SUM(SUM(o.sales)) OVER (PARTITION BY p.category) AS category_total,
    ROUND(
        SUM(o.sales) * 100.0 /
        SUM(SUM(o.sales)) OVER (PARTITION BY p.category),
        2
    ) AS pct_of_category
FROM orders o
JOIN products p ON o.product_id = p.product_id
GROUP BY p.category, p.product_name;

WITH product AS (
    SELECT p.category, p.product_name, SUM(o.sales) AS product_sales
    FROM orders o 
    JOIN products p ON p.product_id = o.product_id
    GROUP BY p.category, p.product_name
)
SELECT category, product_name, product_sales, 
    SUM(product_sales) OVER(
        PARTITION BY category
    ) AS category_total,
    ROUND(product_sales * 100.0 / SUM(product_sales) OVER(PARTITION BY category),2)
    AS pct_of_category FROM product;