CREATE OR REPLACE FUNCTION orders.order_set(p_id_client integer, p_address text) RETURNS integer
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_id               integer;
    v_id_status        integer;
    v_item             record;
    v_now              timestamptz;
    v_discount         numeric;
    v_product_discount numeric;
    v_client_discount  numeric;
    v_total_price      numeric;
    v_price            numeric;
    instance_cursor    refcursor;
    v_instance_id      int;
BEGIN
    PERFORM clients.client_check_exists(p_id_client);

    SELECT id
    INTO v_id_status
    FROM orders.t_order_status
    WHERE c_name = 'Принят'
        FOR UPDATE;

    IF v_id_status IS NULL THEN
        RAISE EXCEPTION 'Status % is not found', 'Принят';
    END IF;

    SELECT NOW() INTO v_now;

    INSERT INTO orders.t_order (id_client, id_status, c_address, c_placement_at)
    VALUES (p_id_client, v_id_status, p_address, v_now)
    RETURNING id INTO v_id;

    v_client_discount := clients.client_get_discount(p_id_client);

    FOR v_item IN
        SELECT id_product, c_count, c_batch_cost
        FROM clients.basket_get(p_id_client)
        LOOP
            OPEN instance_cursor FOR SELECT id
                                     FROM products.product_instance_get_free_many(v_item.id_product)
                                     LIMIT v_item.c_count;
            LOOP
                FETCH instance_cursor INTO v_instance_id;
                EXIT WHEN v_instance_id IS NULL;

                PERFORM storages.inventory_update(v_instance_id, NULL, NULL, 'Moved');

                v_product_discount := analitics.get_product_discount(
                        ARRAY ['Product', 'Category', 'Model'],
                        v_item.id_product
                                      );
                v_discount := COALESCE(v_product_discount, v_client_discount);
                v_price := v_item.c_batch_cost / v_item.c_count * (1 - v_discount);
                v_total_price := v_total_price + v_price;

                INSERT INTO orders.t_order_info(id_order, id_product_instance, c_cost)
                VALUES (v_id, v_instance_id, v_price);
            END LOOP;

            CLOSE instance_cursor;
        END LOOP;

    UPDATE orders.t_order
    SET id_status = orders.order_status_next(v_id_status),
        c_total_price = v_total_price
    WHERE id = v_id;

    PERFORM clients.basket_clear(p_id_client);

    RETURN v_id;
EXCEPTION
    WHEN unique_violation THEN
        RAISE EXCEPTION 'order with id_client %, c_placement_at % already exists.', p_id_client, v_now;
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Error adding order: %', sqlerrm;
END;
$$;

ALTER FUNCTION orders.order_set(p_id_client integer, p_address text) OWNER TO maindb;

REVOKE ALL ON FUNCTION orders.order_set(p_id_client integer, p_address text) FROM PUBLIC;

GRANT ALL ON FUNCTION orders.order_set(p_id_client integer, p_address text) TO postgres;

GRANT ALL ON FUNCTION orders.order_set(p_id_client integer, p_address text) TO program_service;

GRANT ALL ON FUNCTION orders.order_set(p_id_client integer, p_address text) TO admin_service;
