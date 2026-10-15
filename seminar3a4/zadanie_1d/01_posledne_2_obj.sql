WITH objednavky AS (
    SELECT customer_id, order_id, order_date, ROW_NUMBER() OVER(
        PARTITION BY customer_id
        ORDER BY order_date DESC
    ) AS row_num

    FROM orders
)
SELECT c.customer_name, o.order_id, o.order_date, row_num FROM objednavky o
JOIN customers c ON c.customer_id = o.customer_id
WHERE row_num BETWEEN 1 AND 2 ORDER BY c.customer_name, row_num;