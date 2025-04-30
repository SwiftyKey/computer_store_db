CREATE OR REPLACE FUNCTION products.product_property_check_exists(p_id integer) RETURNS boolean
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_exists boolean := FALSE;
BEGIN
    SELECT EXISTS(SELECT 1 FROM products.t_product_property WHERE id = p_id FOR UPDATE) INTO v_exists;

    IF NOT v_exists THEN
        RAISE EXCEPTION 'Product property with id % does not exist.', p_id;
    END IF;

    RETURN TRUE;
END;
$$;

ALTER FUNCTION products.product_property_check_exists(p_id integer) OWNER TO maindb;

REVOKE ALL ON FUNCTION products.product_property_check_exists(p_id integer) FROM PUBLIC;

GRANT ALL ON FUNCTION products.product_property_check_exists(p_id integer) TO program_service;

GRANT ALL ON FUNCTION products.product_property_check_exists(p_id integer) TO admin_service;

--------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION products.product_property_check_exists(p_id_product integer, p_id_category_property integer) RETURNS boolean
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_exists boolean := FALSE;
BEGIN
    SELECT EXISTS(SELECT 1
                  FROM products.t_product_property
                  WHERE id_product = p_id_product
                    AND id_category_property = p_id_category_property
                      FOR UPDATE)
    INTO v_exists;

    IF NOT v_exists THEN
        RAISE EXCEPTION 'Product property with id_product % and id_category_property % does not exist.', p_id_product, p_id_category_property;
    END IF;

    RETURN TRUE;
END;
$$;

ALTER FUNCTION products.product_property_check_exists(p_id_product integer, p_id_category_property integer) OWNER TO maindb;

REVOKE ALL ON FUNCTION products.product_property_check_exists(p_id_product integer, p_id_category_property integer) FROM PUBLIC;

GRANT ALL ON FUNCTION products.product_property_check_exists(p_id_product integer, p_id_category_property integer) TO program_service;

GRANT ALL ON FUNCTION products.product_property_check_exists(p_id_product integer, p_id_category_property integer) TO admin_service;
