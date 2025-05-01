CREATE OR REPLACE FUNCTION orders.order_check_exists(p_id integer) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    IF NOT EXISTS(
        SELECT 1
        FROM orders.t_order
        WHERE id = p_id
        FOR UPDATE
    ) THEN
        RAISE EXCEPTION 'Order with id % does not exists', p_id;
    END IF;
END;
$$;

ALTER FUNCTION orders.order_check_exists(p_id integer) OWNER TO maindb;

REVOKE ALL ON FUNCTION orders.order_check_exists(p_id integer) FROM PUBLIC;

GRANT ALL ON FUNCTION orders.order_check_exists(p_id integer) TO postgres;

GRANT ALL ON FUNCTION orders.order_check_exists(p_id integer) TO program_service;

GRANT ALL ON FUNCTION orders.order_check_exists(p_id integer) TO admin_service;
