WITH daily_sales AS (
    SELECT sale_date, SUM(total_amount) AS sales
    FROM flourmills_sales
    GROUP BY sale_date
)

SELECT * FROM daily_sales WHERE sales > 3000000
ORDER BY sales DESC;