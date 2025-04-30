CREATE OR REPLACE FUNCTION products.product_instance_get_free_many(p_id_product integer) RETURNS TABLE(id integer)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    PERFORM products.product_check_exists(p_id_product);

    RETURN QUERY
        SELECT id
        FROM products.t_product_instance
        WHERE id_product = p_id_product
            FOR UPDATE;

    IF NOT found THEN
        RAISE EXCEPTION 'There are no available product instances with id_product %', p_id_product;
    END IF;

    RETURN;
END;
$$;

ALTER FUNCTION products.product_instance_get_free_many(p_id_product integer) OWNER TO maindb;

GRANT ALL ON FUNCTION products.product_instance_get_free_many(p_id_product integer) TO program_service;

GRANT ALL ON FUNCTION products.product_instance_get_free_many(p_id_product integer) TO admin_service;
