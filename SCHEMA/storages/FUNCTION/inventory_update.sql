CREATE OR REPLACE FUNCTION storages.inventory_update(p_id_product_instance integer, p_wholesale_price numeric, p_condition text, p_event_type text) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    PERFORM products.product_instance_check_exists(p_id_product_instance);

    LOCK TABLE storages.t_inventory IN ROW EXCLUSIVE MODE;

    UPDATE storages.t_inventory
    SET c_wholesale_price = COALESCE(p_wholesale_price, c_wholesale_price),
        c_condition       = COALESCE(p_condition, c_condition),
        c_event_type      = COALESCE(p_event_type, c_event_type)
    WHERE id_product_instance = p_id_product_instance;

EXCEPTION
    WHEN check_violation THEN
        RAISE EXCEPTION 'Invalid inventory data: %', sqlerrm;
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Error updating inventory: %', sqlerrm;
END;
$$;

ALTER FUNCTION storages.inventory_update(p_id_product_instance integer, p_wholesale_price numeric, p_condition text, p_event_type text) OWNER TO maindb;
