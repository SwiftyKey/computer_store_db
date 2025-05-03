CREATE OR REPLACE FUNCTION products.product_get_model(p_id integer) RETURNS integer
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_id integer;
BEGIN
    PERFORM products.product_check_exists(p_id);

    SELECT id_model
    INTO v_id
    FROM products.t_product
    WHERE id = p_id
    FOR UPDATE;

    RETURN v_id;
END;
$$;

ALTER FUNCTION products.product_get_model(p_id integer) OWNER TO maindb;

REVOKE ALL ON FUNCTION products.product_get_model(p_id integer) FROM PUBLIC;

GRANT ALL ON FUNCTION products.product_get_model(p_id integer) TO program_service;

GRANT ALL ON FUNCTION products.product_get_model(p_id integer) TO admin_service;
