CREATE OR REPLACE FUNCTION storages.inventory_get_product_count(p_id integer) RETURNS integer
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_count integer;
BEGIN
    PERFORM products.product_check_exists(p_id);

    SELECT COUNT(p.id)
    INTO v_count
    FROM products.t_product_instance pi
             JOIN
         products.t_product p ON p.id = pi.id_product
             JOIN
         storages.t_inventory ti ON pi.id = ti.id_product_instance
    WHERE ti.c_event_type NOT IN ('Sold', 'Scrapped')
      AND p.id = p_id
    GROUP BY p.id;

    RETURN v_count;
END;
$$;

ALTER FUNCTION storages.inventory_get_product_count(p_id integer) OWNER TO maindb;

REVOKE ALL ON FUNCTION storages.inventory_get_product_count(p_id integer) FROM PUBLIC;

GRANT ALL ON FUNCTION storages.inventory_get_product_count(p_id integer) TO program_service;

GRANT ALL ON FUNCTION storages.inventory_get_product_count(p_id integer) TO admin_service;
