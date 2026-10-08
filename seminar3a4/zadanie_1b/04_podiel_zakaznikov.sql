WITH predaj AS (
    SELECT customer_type, SUM(total_amount) AS revenue
    FROM flourmills_sales GROUP BY customer_type
),
predaj_percent AS (
    SELECT customer_type, revenue, 
    SUM(revenue) OVER() AS total_revenue,
    ROUND(revenue * 100.0 / SUM(revenue) OVER(), 2) AS revenue_percentage
    FROM predaj
)
SELECT customer_type, revenue, total_revenue, revenue_percentage
FROM predaj_percent ORDER BY revenue DESC;