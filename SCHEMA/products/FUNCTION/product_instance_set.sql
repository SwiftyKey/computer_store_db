CREATE OR REPLACE FUNCTION products.product_instance_set(p_id_product integer, p_serial_number text) RETURNS integer
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_id integer;
BEGIN
    LOCK TABLE products.t_product_instance IN EXCLUSIVE MODE;

    PERFORM products.product_check_exists(p_id_product);

    INSERT INTO products.t_product_instance (id_product, c_serial_number)
    VALUES (p_id_product, p_serial_number)
    RETURNING id INTO v_id;

    RETURN v_id;
EXCEPTION
    WHEN unique_violation THEN
        RAISE EXCEPTION 'Product instance with serial number % already exists.', p_serial_number;
    WHEN foreign_key_violation THEN
        RAISE EXCEPTION 'Product with id % does not exist.', p_id_product;
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Error adding product instance: %', sqlerrm;
END;
$$;

ALTER FUNCTION products.product_instance_set(p_id_product integer, p_serial_number text) OWNER TO maindb;

REVOKE ALL ON FUNCTION products.product_instance_set(p_id_product integer, p_serial_number text) FROM PUBLIC;

GRANT ALL ON FUNCTION products.product_instance_set(p_id_product integer, p_serial_number text) TO program_service;

GRANT ALL ON FUNCTION products.product_instance_set(p_id_product integer, p_serial_number text) TO admin_service;
