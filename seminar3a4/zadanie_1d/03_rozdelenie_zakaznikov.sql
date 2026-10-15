SELECT c.customer_name, SUM(o.sales), NTILE(4) OVER(
    ORDER BY SUM(o.sales) DESC
) AS quartile
FROM customers c JOIN orders o ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.customer_name;