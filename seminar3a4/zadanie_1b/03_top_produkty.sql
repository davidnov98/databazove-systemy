WITH product_sales AS (
    SELECT product_category, product_name, SUM(total_amount) AS suma
    FROM flourmills_sales GROUP BY product_category, product_name
),
ranked_products AS (
    SELECT product_category, product_name, suma,
    RANK() OVER (
        PARTITION BY product_category
        ORDER BY suma DESC
    ) AS category_rank
    FROM product_sales
)
SELECT product_category, product_name, suma,
category_rank FROM ranked_products WHERE category_rank <= 3
ORDER BY product_category, category_rank;