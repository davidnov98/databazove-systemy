-- Active: 1790669352760@@127.0.0.1@5432@superstore
CREATE PROCEDURE apply_regional_discount(region_name VARCHAR(20),
discount_rate NUMERIC(10, 2))
LANGUAGE plpgsql
AS $procedure$
BEGIN
    UPDATE orders o
    SET sales = o.sales * (1 - discount_rate) FROM customers c
    WHERE c.customer_id = o.customer_id AND c.region = region_name;

    RAISE NOTICE 'Aplikovaná zľava % v regióne %', discount_rate, region_name;
END;
$procedure$

CALL apply_regional_discount('West', 0.10); 