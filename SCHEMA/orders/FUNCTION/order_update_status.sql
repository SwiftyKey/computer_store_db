CREATE OR REPLACE FUNCTION orders.order_update_status(p_id integer, p_id_status integer) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    PERFORM orders.order_check_exists(p_id);

    IF p_id_status IS NOT NULL THEN
        PERFORM orders.order_status_check_exists(p_id_status);
    END IF;

    UPDATE orders.t_order
    SET id_status = COALESCE(p_id_status, id_status)
    WHERE id = p_id;
END;
$$;

ALTER FUNCTION orders.order_update_status(p_id integer, p_id_status integer) OWNER TO maindb;

REVOKE ALL ON FUNCTION orders.order_update_status(p_id integer, p_id_status integer) FROM PUBLIC;

GRANT ALL ON FUNCTION orders.order_update_status(p_id integer, p_id_status integer) TO postgres;

GRANT ALL ON FUNCTION orders.order_update_status(p_id integer, p_id_status integer) TO program_service;

GRANT ALL ON FUNCTION orders.order_update_status(p_id integer, p_id_status integer) TO admin_service;
