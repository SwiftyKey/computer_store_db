CREATE OR REPLACE FUNCTION products.product_property_update(p_id integer, p_id_product integer, p_id_category_property integer, p_value text) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    PERFORM products.product_property_check_exists(p_id);

    LOCK TABLE products.t_product_property IN ROW EXCLUSIVE MODE;

    IF p_id_product IS NOT NULL THEN
        PERFORM products.product_check_exists(p_id_product);
    END IF;

    IF p_id_category_property IS NOT NULL THEN
        PERFORM categories.category_property_check_exists(p_id_category_property);
    END IF;

    UPDATE products.t_product_property
    SET id_product           = COALESCE(p_id_product, id_product),
        id_category_property = COALESCE(p_id_category_property, id_category_property),
        c_value              = COALESCE(p_value, c_value)
    WHERE id = p_id;

EXCEPTION
    WHEN unique_violation THEN
        RAISE EXCEPTION 'Product property with the same product and category property already exists.';
    WHEN foreign_key_violation THEN
        RAISE EXCEPTION 'Product or category property does not exist.';
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Error updating product property: %', sqlerrm;
END;
$$;

ALTER FUNCTION products.product_property_update(p_id integer, p_id_product integer, p_id_category_property integer, p_value text) OWNER TO maindb;

REVOKE ALL ON FUNCTION products.product_property_update(p_id integer, p_id_product integer, p_id_category_property integer, p_value text) FROM PUBLIC;

GRANT ALL ON FUNCTION products.product_property_update(p_id integer, p_id_product integer, p_id_category_property integer, p_value text) TO program_service;

GRANT ALL ON FUNCTION products.product_property_update(p_id integer, p_id_product integer, p_id_category_property integer, p_value text) TO admin_service;
