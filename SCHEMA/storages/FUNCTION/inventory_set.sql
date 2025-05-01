CREATE OR REPLACE FUNCTION storages.inventory_set(p_id_product_instance integer, p_id_supply integer, p_wholesale_price numeric, p_condition text = 'New'::text, p_event_type text = 'Received'::text) RETURNS integer
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_id integer;
BEGIN
    LOCK TABLE storages.t_inventory IN EXCLUSIVE MODE;

    PERFORM products.product_instance_check_exists(p_id_product_instance);
    PERFORM storages.supply_check_exists(p_id_supply); -- Предполагаем, что есть storages.supply_check_exists

    INSERT INTO storages.t_inventory (id_product_instance, id_supply, c_wholesale_price, c_condition, c_event_type)
    VALUES (p_id_product_instance, p_id_supply, p_wholesale_price, p_condition, p_event_type)
    RETURNING id INTO v_id;

    RETURN v_id;
EXCEPTION
    WHEN unique_violation THEN
        RAISE EXCEPTION 'Inventory with the same product instance and supply already exists.';
    WHEN check_violation THEN
        RAISE EXCEPTION 'Invalid inventory data.';
    WHEN foreign_key_violation THEN
        RAISE EXCEPTION 'Product instance or supply does not exist.';
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Error adding inventory: %', sqlerrm;
END;
$$;

ALTER FUNCTION storages.inventory_set(p_id_product_instance integer, p_id_supply integer, p_wholesale_price numeric, p_condition text, p_event_type text) OWNER TO maindb;

REVOKE ALL ON FUNCTION storages.inventory_set(p_id_product_instance integer, p_id_supply integer, p_wholesale_price numeric, p_condition text, p_event_type text) FROM PUBLIC;

GRANT ALL ON FUNCTION storages.inventory_set(p_id_product_instance integer, p_id_supply integer, p_wholesale_price numeric, p_condition text, p_event_type text) TO program_service;

GRANT ALL ON FUNCTION storages.inventory_set(p_id_product_instance integer, p_id_supply integer, p_wholesale_price numeric, p_condition text, p_event_type text) TO admin_service;
