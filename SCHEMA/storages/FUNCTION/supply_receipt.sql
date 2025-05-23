CREATE OR REPLACE FUNCTION storages.supply_receipt(p_id integer, p_receipt_at timestamp with time zone) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_id_status           integer;
    item                  record;
    v_id_product_instance integer;
    v_wholesale_price     numeric;
BEGIN
    PERFORM storages.supply_check_exists(p_id);

    SELECT id
    INTO v_id_status
    FROM storages.t_supply_status
    WHERE c_name = 'Получен'
        FOR UPDATE;

    IF v_id_status IS NULL THEN
        RAISE EXCEPTION 'Status % is not found', 'Получен';
    END IF;

    LOCK TABLE storages.t_supply IN ROW EXCLUSIVE MODE;

    UPDATE storages.t_supply
    SET id_status    = v_id_status,
        c_receipt_at = p_receipt_at
    WHERE id = p_id;

    FOR item IN
        SELECT id_product AS id, c_count AS count, c_batch_cost AS batch_cost
        FROM storages.t_supply_info AS info
        WHERE info.id_supply = p_id
        LOOP
            FOR i IN 1..item.count
                LOOP
                    v_id_product_instance := products.product_instance_set(
                            item.id,
                            CONCAT(p_id, '.', item.id, '.', i)
                                             );
                    v_wholesale_price := item.batch_cost / item.count;
                    PERFORM storages.inventory_set(v_id_product_instance, p_id, v_wholesale_price);
                END LOOP;
        END LOOP;
EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Error updating supply: %', sqlerrm;
END;
$$;

ALTER FUNCTION storages.supply_receipt(p_id integer, p_receipt_at timestamp with time zone) OWNER TO maindb;

REVOKE ALL ON FUNCTION storages.supply_receipt(p_id integer, p_receipt_at timestamp with time zone) FROM PUBLIC;

GRANT ALL ON FUNCTION storages.supply_receipt(p_id integer, p_receipt_at timestamp with time zone) TO postgres;

GRANT ALL ON FUNCTION storages.supply_receipt(p_id integer, p_receipt_at timestamp with time zone) TO program_service;

GRANT ALL ON FUNCTION storages.supply_receipt(p_id integer, p_receipt_at timestamp with time zone) TO admin_service;
