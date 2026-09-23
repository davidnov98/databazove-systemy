SELECT c.region, SUM(o.sales) FROM customers c
LEFT JOIN orders o ON o.customer_id = c.customer_id
GROUP BY c.region;

