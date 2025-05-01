CREATE OR REPLACE FUNCTION orders.order_cancel(p_id integer) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_id_status   integer;
    v_status_name text;
BEGIN
    PERFORM orders.order_check_exists(p_id);

    SELECT id_status
    INTO v_id_status
    FROM orders.t_order
    WHERE id = p_id
        FOR UPDATE;

    SELECT c_name
    INTO v_status_name
    FROM orders.t_order_status
    WHERE id = v_id_status
        FOR UPDATE;

    IF v_status_name == 'Оплачен' THEN
        RAISE EXCEPTION 'You cannot cancel a paid order with id %', v_id_status;
    END IF;

    SELECT id
    INTO v_id_status
    FROM orders.t_order_status
    WHERE c_name = 'Отменен'
        FOR UPDATE;

    UPDATE orders.t_order
    SET id_status = v_id_status
    WHERE id = p_id;

    SELECT storages.inventory_update(id_product_instance, NULL, NULL, 'Moved')
    FROM t_order_info
    WHERE id_order = p_id;
END;
$$;

ALTER FUNCTION orders.order_cancel(p_id integer) OWNER TO maindb;

REVOKE ALL ON FUNCTION orders.order_cancel(p_id integer) FROM PUBLIC;

GRANT ALL ON FUNCTION orders.order_cancel(p_id integer) TO program_service;

GRANT ALL ON FUNCTION orders.order_cancel(p_id integer) TO admin_service;
