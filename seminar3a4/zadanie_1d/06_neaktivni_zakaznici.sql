WITH datum AS (
    SELECT c.customer_id, c.customer_name, MAX(o.order_date) OVER(
        PARTITION BY c.customer_id
    ) AS last_order_date,
    MAX(o.order_date) OVER() AS latest_order_date
    FROM customers c JOIN orders o ON o.customer_id = c.customer_id
) 
SELECT customer_id, customer_name, last_order_date FROM datum
WHERE last_order_date < latest_order_date - INTERVAL '90 days'
ORDER BY last_order_date ASC;
