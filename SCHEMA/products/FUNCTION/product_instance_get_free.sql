CREATE OR REPLACE FUNCTION products.product_instance_get_free(p_id_product integer) RETURNS integer
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_id integer;
BEGIN
    PERFORM products.product_check_exists(p_id_product);

    SELECT pi.id
    INTO v_id
    FROM products.t_product_instance pi
             JOIN storages.t_inventory ti ON pi.id = ti.id_product_instance
    WHERE pi.id_product = p_id_product
      AND ti.c_event_type NOT IN ('Sold', 'Scrapped')
    LIMIT 1 FOR UPDATE;

    IF v_id IS NULL THEN
        RAISE EXCEPTION 'There are no available product instance with id_product %', p_id_product;
    END IF;

    RETURN v_id;
END;
$$;

ALTER FUNCTION products.product_instance_get_free(p_id_product integer) OWNER TO maindb;

GRANT ALL ON FUNCTION products.product_instance_get_free(p_id_product integer) TO program_service;

GRANT ALL ON FUNCTION products.product_instance_get_free(p_id_product integer) TO admin_service;
