SELECT c.region, SUM(o.sales) AS total, AVG(o.discount) AS priem, 
COUNT(o.order_id) AS pocet FROM customers c JOIN orders o
ON o.customer_id = c.customer_id
GROUP BY c.region;