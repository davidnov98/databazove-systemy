SELECT c.region,
    COUNT(CASE WHEN o.sales > 1000 THEN 1 END) AS high_value,
    COUNT(CASE WHEN o.sales <= 1000 THEN 1 END) AS low_value
FROM customers c JOIN orders o ON o.customer_id = c.customer_id
GROUP BY c.region;