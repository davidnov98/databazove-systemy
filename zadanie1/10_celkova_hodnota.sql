SELECT c.customer_name, SUM(o.sales) AS total FROM customers c
JOIN orders o ON o.customer_id = c.customer_id
GROUP BY c.customer_id HAVING SUM(o.sales) > 2000;