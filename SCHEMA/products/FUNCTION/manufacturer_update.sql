CREATE OR REPLACE FUNCTION products.manufacturer_update(p_id integer, p_name text, p_address text) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    PERFORM products.manufacturer_check_exists(p_id);

    LOCK TABLE products.t_manufacturer IN ROW EXCLUSIVE MODE;

    UPDATE products.t_manufacturer
    SET c_name    = COALESCE(p_name, c_name),
        c_address = COALESCE(p_address, c_address)
    WHERE id = p_id;

EXCEPTION
    WHEN unique_violation THEN
        RAISE EXCEPTION 'Manufacturer with name % already exists.', p_name;
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Error updating manufacturer: %', sqlerrm;
END;
$$;

ALTER FUNCTION products.manufacturer_update(p_id integer, p_name text, p_address text) OWNER TO maindb;

REVOKE ALL ON FUNCTION products.manufacturer_update(p_id integer, p_name text, p_address text) FROM PUBLIC;

GRANT ALL ON FUNCTION products.manufacturer_update(p_id integer, p_name text, p_address text) TO program_service;

GRANT ALL ON FUNCTION products.manufacturer_update(p_id integer, p_name text, p_address text) TO admin_service;
