SELECT p.category, AVG(o.discount) FROM products p
JOIN orders o ON o.product_id = p.product_id
GROUP BY p.category;

