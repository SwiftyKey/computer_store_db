CREATE OR REPLACE FUNCTION products.manufacturer_set(p_name text, p_address text) RETURNS integer
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_id integer;
BEGIN
    LOCK TABLE products.t_manufacturer IN EXCLUSIVE MODE;

    INSERT INTO products.t_manufacturer (c_name, c_address)
    VALUES (p_name, p_address)
    RETURNING id INTO v_id;

    RETURN v_id;
EXCEPTION
    WHEN unique_violation THEN
        RAISE EXCEPTION 'Manufacturer with name % already exists.', p_name;
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Error adding manufacturer: %', sqlerrm;
END;
$$;

ALTER FUNCTION products.manufacturer_set(p_name text, p_address text) OWNER TO maindb;

REVOKE ALL ON FUNCTION products.manufacturer_set(p_name text, p_address text) FROM PUBLIC;

GRANT ALL ON FUNCTION products.manufacturer_set(p_name text, p_address text) TO program_service;

GRANT ALL ON FUNCTION products.manufacturer_set(p_name text, p_address text) TO admin_service;
