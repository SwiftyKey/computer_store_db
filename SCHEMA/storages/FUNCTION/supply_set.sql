CREATE OR REPLACE FUNCTION storages.supply_set(p_id_supplier integer, p_id_storage integer, p_items json, p_dispatch_at timestamp with time zone) RETURNS integer
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_id integer;
    v_id_status integer;
    item record;
    v_total_cost numeric = 0;
    v_batch_cost numeric = 0;
BEGIN
    PERFORM storages.supplier_check_exists(p_id_supplier);
    PERFORM storages.storage_check_exists(p_id_storage);

    LOCK TABLE storages.t_supply IN EXCLUSIVE MODE;

    SELECT id
    INTO v_id_status
    FROM storages.t_supply_status
    WHERE c_name = 'В пути'
        FOR UPDATE;

    IF v_id_status IS NULL THEN
        RAISE EXCEPTION 'Status % is not found', 'В пути';
    END IF;

    INSERT INTO storages.t_supply (id_supplier, id_storage, id_status, c_dispatch_at)
    VALUES (p_id_supplier, p_id_storage, v_id_status, p_dispatch_at)
    RETURNING id INTO v_id;

    FOR item IN
        SELECT * FROM json_populate_recordset(null::ty_supply_item, p_items)
    LOOP
        IF item.count IS NULL OR item.count <= 0 THEN
			RAISE EXCEPTION 'The delivery must contain a positive quantity of product with id: %', item.id;
		END IF;

        v_batch_cost := item.count * item.cost;
        v_total_cost := v_total_cost + v_batch_cost;

        INSERT INTO storages.t_supply_info(id_product, id_supply, c_count, c_batch_cost)
        VALUES (item.id, v_id, item.count, v_batch_cost);
    END LOOP;

    UPDATE storages.t_supply
    SET c_total_cost = v_total_cost
    WHERE id = v_id;

    RETURN v_id;
EXCEPTION
    WHEN unique_violation THEN
        RAISE EXCEPTION 'Supply with id_supplier %, id_storage %, c_dispatch_at %  already exists.', p_id_supplier, p_id_storage, p_dispatch_at;
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Error adding supply: %', sqlerrm;
END;
$$;

ALTER FUNCTION storages.supply_set(p_id_supplier integer, p_id_storage integer, p_items json, p_dispatch_at timestamp with time zone) OWNER TO maindb;

REVOKE ALL ON FUNCTION storages.supply_set(p_id_supplier integer, p_id_storage integer, p_items json, p_dispatch_at timestamp with time zone) FROM PUBLIC;

GRANT ALL ON FUNCTION storages.supply_set(p_id_supplier integer, p_id_storage integer, p_items json, p_dispatch_at timestamp with time zone) TO postgres;

GRANT ALL ON FUNCTION storages.supply_set(p_id_supplier integer, p_id_storage integer, p_items json, p_dispatch_at timestamp with time zone) TO program_service;

GRANT ALL ON FUNCTION storages.supply_set(p_id_supplier integer, p_id_storage integer, p_items json, p_dispatch_at timestamp with time zone) TO admin_service;
