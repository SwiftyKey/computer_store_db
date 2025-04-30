CREATE OR REPLACE FUNCTION storages.supplier_set(p_name text, p_address text, p_phone text) RETURNS integer
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_id integer;
BEGIN
    LOCK TABLE storages.t_supplier IN EXCLUSIVE MODE;

    INSERT INTO storages.t_supplier (c_name, c_address, c_phone)
    VALUES (p_name, p_address, p_phone)
    RETURNING id INTO v_id;

    RETURN v_id;
EXCEPTION
    WHEN unique_violation THEN
        RAISE EXCEPTION 'Supplier with name % already exists.', p_name;
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Error adding supplier: %', sqlerrm;
END;
$$;

ALTER FUNCTION storages.supplier_set(p_name text, p_address text, p_phone text) OWNER TO maindb;

REVOKE ALL ON FUNCTION storages.supplier_set(p_name text, p_address text, p_phone text) FROM PUBLIC;

GRANT ALL ON FUNCTION storages.supplier_set(p_name text, p_address text, p_phone text) TO postgres;

GRANT ALL ON FUNCTION storages.supplier_set(p_name text, p_address text, p_phone text) TO program_service;

GRANT ALL ON FUNCTION storages.supplier_set(p_name text, p_address text, p_phone text) TO admin_service;
