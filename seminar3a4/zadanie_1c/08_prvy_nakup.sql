WITH zaznam AS (
    SELECT customer_id, invoice_no, invoice_date, stock_code,
    description, quantity, unit_price,
    ROW_NUMBER() OVER(
        PARTITION BY customer_id
        ORDER BY invoice_date ASC
    ) AS cislo FROM retail_sales
)
SELECT customer_id, invoice_no, invoice_date, stock_code,
description, quantity, unit_price FROM zaznam WHERE cislo = 1
ORDER BY customer_id ASC;