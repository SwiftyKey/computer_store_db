CREATE OR REPLACE FUNCTION products.product_set(p_id_model integer, p_name text, p_description text, p_warranty_period integer, p_length double precision, p_width double precision, p_height double precision, p_weight double precision, p_price numeric, p_sku text, p_gtin text) RETURNS integer
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_id integer;
BEGIN
    LOCK TABLE products.t_product IN EXCLUSIVE MODE;

    PERFORM products.model_check_exists(p_id_model);

    INSERT INTO products.t_product (id_model, c_name, c_description, c_warranty_period, c_length,
                                    c_width, c_height, c_weight, c_price, c_sku, c_gtin)
    VALUES (p_id_model, p_name, p_description, p_warranty_period,
            p_length, p_width, p_height, p_weight, p_price, p_sku, p_gtin)
    RETURNING id INTO v_id;

    RETURN v_id;
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
        RAISE EXCEPTION 'Error adding product: %', sqlerrm;
END;
$$;

ALTER FUNCTION products.product_set(p_id_model integer, p_name text, p_description text, p_warranty_period integer, p_length double precision, p_width double precision, p_height double precision, p_weight double precision, p_price numeric, p_sku text, p_gtin text) OWNER TO maindb;

REVOKE ALL ON FUNCTION products.product_set(p_id_model integer, p_name text, p_description text, p_warranty_period integer, p_length double precision, p_width double precision, p_height double precision, p_weight double precision, p_price numeric, p_sku text, p_gtin text) FROM PUBLIC;

GRANT ALL ON FUNCTION products.product_set(p_id_model integer, p_name text, p_description text, p_warranty_period integer, p_length double precision, p_width double precision, p_height double precision, p_weight double precision, p_price numeric, p_sku text, p_gtin text) TO program_service;

GRANT ALL ON FUNCTION products.product_set(p_id_model integer, p_name text, p_description text, p_warranty_period integer, p_length double precision, p_width double precision, p_height double precision, p_weight double precision, p_price numeric, p_sku text, p_gtin text) TO admin_service;
