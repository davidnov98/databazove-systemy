SELECT product_name, product_category, total_amount 
FROM flourmills_sales AS f1 WHERE total_amount > (
    SELECT AVG(f2.total_amount) FROM flourmills_sales AS f2
    WHERE f2.product_category = f1.product_category
);

