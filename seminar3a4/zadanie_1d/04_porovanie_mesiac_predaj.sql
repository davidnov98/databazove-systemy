SELECT DATE_TRUNC('month', order_date) AS monthly_sales, SUM(sales) AS total,
LAG(SUM(sales), 1) OVER(
    ORDER BY DATE_TRUNC('month', order_date)
) AS prev_month_sales,
LEAD(SUM(sales), 1) OVER(
    ORDER BY DATE_TRUNC('month', order_date)
) AS next_month_sales
FROM orders GROUP BY DATE_TRUNC('month', order_date) ORDER BY monthly_sales ASC;