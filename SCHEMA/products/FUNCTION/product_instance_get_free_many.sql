CREATE OR REPLACE FUNCTION products.product_instance_get_free_many(p_id_product integer) RETURNS TABLE(id integer)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    PERFORM products.product_check_exists(p_id_product);

    RETURN QUERY
        SELECT pi.id
        FROM products.t_product_instance pi
                 JOIN storages.t_inventory ti ON pi.id = ti.id_product_instance
        WHERE pi.id_product = p_id_product AND ti.c_event_type NOT IN ('Sold', 'Scrapped')
            FOR UPDATE;

    IF NOT found THEN
        RAISE EXCEPTION 'There are no available product instances with id_product %', p_id_product;
    END IF;

    RETURN;
END;
$$;

ALTER FUNCTION products.product_instance_get_free_many(p_id_product integer) OWNER TO maindb;
