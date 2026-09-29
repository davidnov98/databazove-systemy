SELECT (EXTRACT(MONTH FROM sale_date)) as mesiac, 
SUM(total_amount) as suma FROM flourmills_sales
GROUP BY (EXTRACT(MONTH FROM sale_date));

SELECT * FROM (SELECT (EXTRACT(MONTH FROM sale_date)) as mesiac, 
SUM(total_amount) as suma FROM flourmills_sales
GROUP BY (EXTRACT(MONTH FROM sale_date))) AS suhrn
ORDER BY suma DESC;