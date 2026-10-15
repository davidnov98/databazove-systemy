WITH poradie AS (
    SELECT country, DATE_TRUNC('month', invoice_date) AS invoice_month, customer_id,
    SUM(quantity * unit_price) AS total_amount, DENSE_RANK() OVER(
        PARTITION BY country, DATE_TRUNC('month', invoice_date)
        ORDER BY SUM(quantity * unit_price) DESC
    ) AS sales_rank
    FROM retail_sales GROUP BY country, DATE_TRUNC('month', invoice_date),
    customer_id
)
SELECT country, invoice_month, customer_id, total_amount, sales_rank FROM poradie
WHERE sales_rank BETWEEN 1 AND 5 ORDER BY country, invoice_month, sales_rank, customer_id;