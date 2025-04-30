CREATE OR REPLACE FUNCTION orders.order_status_check_exists(p_id integer) RETURNS boolean
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_exists BOOLEAN := FALSE;
BEGIN
    SELECT EXISTS(SELECT 1 FROM orders.t_order_status WHERE id = p_id FOR UPDATE) INTO v_exists;

    IF NOT v_exists THEN
        RAISE EXCEPTION 'Order status with id % does not exist.', p_id;
    END IF;

    RETURN TRUE;
END;
$$;

ALTER FUNCTION orders.order_status_check_exists(p_id integer) OWNER TO maindb;

REVOKE ALL ON FUNCTION orders.order_status_check_exists(p_id integer) FROM PUBLIC;

GRANT ALL ON FUNCTION orders.order_status_check_exists(p_id integer) TO program_service;

GRANT ALL ON FUNCTION orders.order_status_check_exists(p_id integer) TO admin_service;
