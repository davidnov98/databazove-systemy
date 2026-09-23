select o.order_id, c.customer_name, o.sales FROM orders o
JOIN customers c ON c.customer_id = o.customer_id
WHERE o.sales > 500
ORDER BY o.sales DESC;