CREATE OR REPLACE FUNCTION products.manufacturer_check_exists(p_id integer) RETURNS boolean
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_exists boolean := FALSE;
BEGIN
    SELECT EXISTS(SELECT 1 FROM products.t_manufacturer WHERE id = p_id FOR UPDATE) INTO v_exists;

    IF NOT v_exists THEN
        RAISE EXCEPTION 'Manufacturer with id % does not exist.', p_id;
    END IF;

    RETURN TRUE;
END;
$$;

ALTER FUNCTION products.manufacturer_check_exists(p_id integer) OWNER TO maindb;

REVOKE ALL ON FUNCTION products.manufacturer_check_exists(p_id integer) FROM PUBLIC;

GRANT ALL ON FUNCTION products.manufacturer_check_exists(p_id integer) TO program_service;

GRANT ALL ON FUNCTION products.manufacturer_check_exists(p_id integer) TO admin_service;
