CREATE OR REPLACE FUNCTION orders.order_status_set(p_id_next integer, p_name text) RETURNS integer
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_id INTEGER;
BEGIN
    LOCK TABLE orders.t_order_status IN EXCLUSIVE MODE;

    IF p_id_next IS NOT NULL THEN
        PERFORM orders.order_status_check_exists(p_id_next);
    END IF;

    INSERT INTO orders.t_order_status (id_next, c_name)
    VALUES (p_id_next, p_name)
    RETURNING id INTO v_id;

    RETURN v_id;
EXCEPTION
    WHEN unique_violation THEN
        RAISE EXCEPTION 'Order status with name % already exists.', p_name;
    WHEN foreign_key_violation THEN
        RAISE EXCEPTION 'Next order status with id % does not exist.', p_id_next;
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Error adding order status: %', SQLERRM;
END;
$$;

ALTER FUNCTION orders.order_status_set(p_id_next integer, p_name text) OWNER TO maindb;

REVOKE ALL ON FUNCTION orders.order_status_set(p_id_next integer, p_name text) FROM PUBLIC;

GRANT ALL ON FUNCTION orders.order_status_set(p_id_next integer, p_name text) TO program_service;

GRANT ALL ON FUNCTION orders.order_status_set(p_id_next integer, p_name text) TO admin_service;
