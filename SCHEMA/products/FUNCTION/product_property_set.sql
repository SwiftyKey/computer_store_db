CREATE OR REPLACE FUNCTION products.product_property_set(p_id_product integer, p_id_category_property integer, p_value text) RETURNS integer
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_id integer;
BEGIN
    LOCK TABLE products.t_product_property IN EXCLUSIVE MODE;

    PERFORM products.product_check_exists(p_id_product);
    PERFORM categories.category_property_check_exists(p_id_category_property);

    INSERT INTO products.t_product_property (id_product, id_category_property, c_value)
    VALUES (p_id_product, p_id_category_property, p_value)
    RETURNING id INTO v_id;

    RETURN v_id;
EXCEPTION
    WHEN unique_violation THEN
        RAISE EXCEPTION 'Product property with the same product and category property already exists.';
    WHEN foreign_key_violation THEN
        RAISE EXCEPTION 'Product or category property does not exist.';
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Error adding product property: %', sqlerrm;
END;
$$;

ALTER FUNCTION products.product_property_set(p_id_product integer, p_id_category_property integer, p_value text) OWNER TO maindb;

REVOKE ALL ON FUNCTION products.product_property_set(p_id_product integer, p_id_category_property integer, p_value text) FROM PUBLIC;

GRANT ALL ON FUNCTION products.product_property_set(p_id_product integer, p_id_category_property integer, p_value text) TO program_service;

GRANT ALL ON FUNCTION products.product_property_set(p_id_product integer, p_id_category_property integer, p_value text) TO admin_service;
