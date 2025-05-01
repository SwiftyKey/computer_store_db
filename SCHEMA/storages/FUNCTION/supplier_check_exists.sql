CREATE OR REPLACE FUNCTION storages.supplier_check_exists(p_id integer) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    IF NOT EXISTS(
        SELECT 1
        FROM storages.t_supplier
        WHERE id = p_id
        FOR UPDATE
    ) THEN
        RAISE EXCEPTION 'Supplier with id % does not exist', p_id;
    END IF;
END;
$$;

ALTER FUNCTION storages.supplier_check_exists(p_id integer) OWNER TO maindb;

REVOKE ALL ON FUNCTION storages.supplier_check_exists(p_id integer) FROM PUBLIC;

GRANT ALL ON FUNCTION storages.supplier_check_exists(p_id integer) TO postgres;

GRANT ALL ON FUNCTION storages.supplier_check_exists(p_id integer) TO program_service;

GRANT ALL ON FUNCTION storages.supplier_check_exists(p_id integer) TO admin_service;
