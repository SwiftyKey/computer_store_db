CREATE OR REPLACE FUNCTION orders.order_payment(p_id integer) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_id_client   integer;
    v_total_price numeric;
    v_id_status   integer;
    v_status_name text;
BEGIN
    PERFORM orders.order_check_exists(p_id);

    SELECT id_client, c_total_price, id_status
    INTO v_id_client, v_total_price, v_id_status
    FROM orders.t_order
    WHERE id = p_id
        FOR UPDATE;

    SELECT c_name
    INTO v_status_name
    FROM orders.t_order_status
    WHERE id = v_id_status
        FOR UPDATE;

    IF v_status_name != 'Доставлен' THEN
        RAISE EXCEPTION 'You can not pay for an order with id % that has not been delivered', v_id_status;
    END IF;

    PERFORM clients.client_check_exists(v_id_client);

    UPDATE clients.t_client
    SET c_money_spent = c_money_spent + v_total_price
    WHERE id = v_id_client;

    UPDATE orders.t_order
    SET id_status = orders.order_status_next(v_id_status)
    WHERE id = p_id;

    SELECT storages.inventory_update(id_product_instance, NULL, NULL, 'Sold')
    FROM t_order_info
    WHERE id_order = p_id;
END;
$$;

ALTER FUNCTION orders.order_payment(p_id integer) OWNER TO maindb;

REVOKE ALL ON FUNCTION orders.order_payment(p_id integer) FROM PUBLIC;

GRANT ALL ON FUNCTION orders.order_payment(p_id integer) TO program_service;

GRANT ALL ON FUNCTION orders.order_payment(p_id integer) TO admin_service;
