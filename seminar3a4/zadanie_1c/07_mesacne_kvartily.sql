WITH celkovy_mesacny_predaj AS (
    SELECT SUM(quantity * unit_price) AS total_amount,
    DATE_TRUNC('month',invoice_date) AS invoice_month, country
    FROM retail_sales GROUP BY DATE_TRUNC('month',invoice_date), country
)

SELECT country, invoice_month, total_amount, NTILE(4) OVER (
    PARTITION BY country
    ORDER BY  total_amount DESC
) AS sales_quartile FROM celkovy_mesacny_predaj ORDER BY country, invoice_month ASC;