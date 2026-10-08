WITH RECURSIVE calendar_range AS (
    SELECT MIN(sale_date) AS start_date,
    MAX(sale_date) AS end_date FROM flourmills_sales
),
calendar AS (
    SELECT start_date, end_date FROM calendar_range
    UNION ALL
    SELECT (start_date + 1), end_date FROM calendar
    WHERE start_date < end_date
    
)
SELECT start_date FROM CALENDAR ORDER BY start_date ASC;