SELECT c.customer_name, o.order_id, o.sales FROM customers c
FULL OUTER JOIN orders o ON o.customer_id = c.customer_id