SELECT c.region, c.customer_name, SUM(o.profit) AS total_profit,
RANK() OVER(
    PARTITION BY c.region
    ORDER BY SUM(o.profit) DESC
)AS profit_rank,
DENSE_RANK() OVER(
    PARTITION BY c.region
    ORDER BY SUM(o.profit) DESC
)AS profit_dense_rank

FROM customers c
JOIN orders o ON o.customer_id = c.customer_id
GROUP BY c.region, c.customer_name;