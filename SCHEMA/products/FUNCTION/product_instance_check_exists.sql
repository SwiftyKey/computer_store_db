CREATE OR REPLACE FUNCTION products.product_instance_check_exists(p_id integer) RETURNS boolean
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_exists boolean := FALSE;
BEGIN
    SELECT EXISTS(SELECT 1 FROM products.t_product_instance WHERE id = p_id FOR UPDATE) INTO v_exists;

    IF NOT v_exists THEN
        RAISE EXCEPTION 'Product instance with id % does not exist.', p_id;
    END IF;

    RETURN TRUE;
END;
$$;

ALTER FUNCTION products.product_instance_check_exists(p_id integer) OWNER TO maindb;

REVOKE ALL ON FUNCTION products.product_instance_check_exists(p_id integer) FROM PUBLIC;

GRANT ALL ON FUNCTION products.product_instance_check_exists(p_id integer) TO program_service;

GRANT ALL ON FUNCTION products.product_instance_check_exists(p_id integer) TO admin_service;

--------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION products.product_instance_check_exists(p_serial_number text) RETURNS boolean
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_exists boolean := FALSE;
BEGIN
    SELECT EXISTS(SELECT 1 FROM products.t_product_instance WHERE c_serial_number = p_serial_number FOR UPDATE)
    INTO v_exists;

    IF NOT v_exists THEN
        RAISE EXCEPTION 'Product instance with c_serial_number % does not exist.', p_serial_number;
    END IF;

    RETURN TRUE;
END;
$$;

ALTER FUNCTION products.product_instance_check_exists(p_serial_number text) OWNER TO maindb;

REVOKE ALL ON FUNCTION products.product_instance_check_exists(p_serial_number text) FROM PUBLIC;

GRANT ALL ON FUNCTION products.product_instance_check_exists(p_serial_number text) TO program_service;

GRANT ALL ON FUNCTION products.product_instance_check_exists(p_serial_number text) TO admin_service;
