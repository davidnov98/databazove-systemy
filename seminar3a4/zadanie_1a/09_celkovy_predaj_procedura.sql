CREATE PROCEDURE get_customer_sales(cust_id VARCHAR(20))
LANGUAGE plpgsql
AS $procedure$
DECLARE 
    total NUMERIC(10,2);
BEGIN
    SELECT SUM(sales) INTO total FROM orders
    WHERE customer_id = cust_id;

    RAISE NOTICE 'Celkový predaj zákazníka % je %', cust_id, total;
END;
$procedure$;

CALL get_customer_sales('C001');
