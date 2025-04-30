CREATE OR REPLACE FUNCTION orders.order_status_next(p_id integer) RETURNS integer
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_id_next integer;
BEGIN
    PERFORM orders.order_status_check_exists(p_id);

    SELECT id_next
    INTO v_id_next
    FROM orders.t_order_status
    WHERE id = p_id
        FOR UPDATE;

    RETURN v_id_next;
END;
$$;

ALTER FUNCTION orders.order_status_next(p_id integer) OWNER TO maindb;

REVOKE ALL ON FUNCTION orders.order_status_next(p_id integer) FROM PUBLIC;

GRANT ALL ON FUNCTION orders.order_status_next(p_id integer) TO postgres;

GRANT ALL ON FUNCTION orders.order_status_next(p_id integer) TO program_service;

GRANT ALL ON FUNCTION orders.order_status_next(p_id integer) TO admin_service;
