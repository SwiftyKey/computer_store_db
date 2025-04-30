CREATE OR REPLACE FUNCTION orders.order_status_update(p_id integer, p_id_next integer, p_name text) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    PERFORM orders.order_status_check_exists(p_id);

    LOCK TABLE orders.t_order_status IN ROW EXCLUSIVE MODE;

    IF p_id_next IS NOT NULL THEN
        PERFORM orders.order_status_check_exists(p_id_next);
    END IF;

    UPDATE orders.t_order_status
    SET id_next = COALESCE(p_id_next, id_next),
        c_name = COALESCE(p_name, c_name)
    WHERE id = p_id;

EXCEPTION
    WHEN unique_violation THEN
        RAISE EXCEPTION 'Order status with name % already exists.', p_name;
    WHEN foreign_key_violation THEN
        RAISE EXCEPTION 'Next order status with id % does not exist.', p_id_next;
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Error updating order status: %', SQLERRM;
END;
$$;

ALTER FUNCTION orders.order_status_update(p_id integer, p_id_next integer, p_name text) OWNER TO maindb;

REVOKE ALL ON FUNCTION orders.order_status_update(p_id integer, p_id_next integer, p_name text) FROM PUBLIC;

GRANT ALL ON FUNCTION orders.order_status_update(p_id integer, p_id_next integer, p_name text) TO program_service;

GRANT ALL ON FUNCTION orders.order_status_update(p_id integer, p_id_next integer, p_name text) TO admin_service;
