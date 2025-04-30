CREATE OR REPLACE FUNCTION storages.supplier_update(p_id integer, p_name text, p_address text, p_phone text) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    PERFORM storages.supplier_check_exists(p_id);

    LOCK TABLE storages.t_supplier IN ROW EXCLUSIVE MODE;

    UPDATE storages.t_supplier
    SET c_name    = COALESCE(p_name, c_name),
        c_address = COALESCE(p_address, c_address),
        c_phone   = COALESCE(p_phone, c_phone)
    WHERE id = p_id;
EXCEPTION
    WHEN unique_violation THEN
        RAISE EXCEPTION 'Supplier with name % already exists.', p_name;
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Error adding supplier: %', sqlerrm;
END;
$$;

ALTER FUNCTION storages.supplier_update(p_id integer, p_name text, p_address text, p_phone text) OWNER TO maindb;

REVOKE ALL ON FUNCTION storages.supplier_update(p_id integer, p_name text, p_address text, p_phone text) FROM PUBLIC;

GRANT ALL ON FUNCTION storages.supplier_update(p_id integer, p_name text, p_address text, p_phone text) TO postgres;

GRANT ALL ON FUNCTION storages.supplier_update(p_id integer, p_name text, p_address text, p_phone text) TO program_service;

GRANT ALL ON FUNCTION storages.supplier_update(p_id integer, p_name text, p_address text, p_phone text) TO admin_service;
