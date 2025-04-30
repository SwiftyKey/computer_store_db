CREATE OR REPLACE FUNCTION products.model_set(p_id_manufacturer integer, p_name text) RETURNS integer
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_id integer;
BEGIN
    LOCK TABLE products.t_model IN EXCLUSIVE MODE;

    PERFORM products.manufacturer_check_exists(p_id_manufacturer);

    INSERT INTO products.t_model (id_manufacturer, c_name)
    VALUES (p_id_manufacturer, p_name)
    RETURNING id INTO v_id;

    RETURN v_id;
EXCEPTION
    WHEN unique_violation THEN
        RAISE EXCEPTION 'Model with name % already exists.', p_name;
    WHEN foreign_key_violation THEN
        RAISE EXCEPTION 'Manufacturer with id % does not exist.', p_id_manufacturer;
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Error adding model: %', sqlerrm;
END;
$$;

ALTER FUNCTION products.model_set(p_id_manufacturer integer, p_name text) OWNER TO maindb;

REVOKE ALL ON FUNCTION products.model_set(p_id_manufacturer integer, p_name text) FROM PUBLIC;

GRANT ALL ON FUNCTION products.model_set(p_id_manufacturer integer, p_name text) TO program_service;

GRANT ALL ON FUNCTION products.model_set(p_id_manufacturer integer, p_name text) TO admin_service;
