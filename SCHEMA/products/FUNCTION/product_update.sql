CREATE OR REPLACE FUNCTION products.product_update(p_id integer, p_id_model integer, p_name text, p_description text, p_warranty_period integer, p_length double precision, p_width double precision, p_height double precision, p_weight double precision, p_price numeric, p_sku text, p_gtin text) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    PERFORM products.product_check_exists(p_id);

    LOCK TABLE products.t_product IN ROW EXCLUSIVE MODE;

    IF p_id_model IS NOT NULL THEN
        PERFORM products.model_check_exists(p_id_model);
    END IF;

    UPDATE products.t_product
    SET id_model          = COALESCE(p_id_model, id_model),
        c_name            = COALESCE(p_name, c_name),
        c_description     = COALESCE(p_description, c_description),
        c_warranty_period = COALESCE(p_warranty_period, c_warranty_period),
        c_length          = COALESCE(p_length, c_length),
        c_width           = COALESCE(p_width, c_width),
        c_height          = COALESCE(p_height, c_height),
        c_weight          = COALESCE(p_weight, c_weight),
        c_price           = COALESCE(p_price, c_price),
        c_sku             = COALESCE(p_sku, c_sku),
        c_gtin            = COALESCE(p_gtin, c_gtin)
    WHERE id = p_id;

EXCEPTION
    WHEN unique_violation THEN
        IF sqlerrm LIKE '%uk_t_product_c_sku%' THEN
            RAISE EXCEPTION 'Product with sku % already exists.', p_sku;
        ELSIF sqlerrm LIKE '%uk_t_product_c_gtin%' THEN
            RAISE EXCEPTION 'Product with gtin % already exists.', p_gtin;
        ELSE
            RAISE EXCEPTION 'Unique violation occurred.';
        END IF;
    WHEN foreign_key_violation THEN
        RAISE EXCEPTION 'Model with id % does not exist.', p_id_model;
    WHEN check_violation THEN
        RAISE EXCEPTION 'Invalid product data.';
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Error updating product: %', sqlerrm;
END;
$$;

ALTER FUNCTION products.product_update(p_id integer, p_id_model integer, p_name text, p_description text, p_warranty_period integer, p_length double precision, p_width double precision, p_height double precision, p_weight double precision, p_price numeric, p_sku text, p_gtin text) OWNER TO maindb;

REVOKE ALL ON FUNCTION products.product_update(p_id integer, p_id_model integer, p_name text, p_description text, p_warranty_period integer, p_length double precision, p_width double precision, p_height double precision, p_weight double precision, p_price numeric, p_sku text, p_gtin text) FROM PUBLIC;

GRANT ALL ON FUNCTION products.product_update(p_id integer, p_id_model integer, p_name text, p_description text, p_warranty_period integer, p_length double precision, p_width double precision, p_height double precision, p_weight double precision, p_price numeric, p_sku text, p_gtin text) TO program_service;

GRANT ALL ON FUNCTION products.product_update(p_id integer, p_id_model integer, p_name text, p_description text, p_warranty_period integer, p_length double precision, p_width double precision, p_height double precision, p_weight double precision, p_price numeric, p_sku text, p_gtin text) TO admin_service;
