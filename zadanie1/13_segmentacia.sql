SELECT c.customer_name, SUM(o.sales) as total, AVG(o.discount) as priem,
COUNT(o.order_id) AS pocet,
CASE 
    WHEN SUM(o.sales) > 2500 THEN 'VIP'
    ELSE 'REGULAR'
END AS typ
FROM customers c
JOIN orders o
ON o.customer_id = c.customer_id
GROUP BY c.customer_name
ORDER BY total DESC;