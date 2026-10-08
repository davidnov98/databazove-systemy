CREATE PROCEDURE get_sales_between(start_date DATE, end_date DATE)
LANGUAGE plpgsql
AS $procedure$
DECLARE
    total NUMERIC(10, 2);
BEGIN 
    SELECT SUM(sales) INTO total FROM orders
    WHERE order_date BETWEEN start_date AND end_date;
    RAISE NOTICE 'Zaciatok obdobia % Koniec obdobia % suma %', start_date, end_date, total;
END;
$procedure$;


CALL get_sales_between('2024-01-01', '2024-03-31');