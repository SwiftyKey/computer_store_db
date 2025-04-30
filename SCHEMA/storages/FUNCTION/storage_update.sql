CREATE OR REPLACE FUNCTION storages.storage_update(p_id integer, p_name text, p_address text) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    PERFORM storages.storage_check_exists(p_id);

    LOCK TABLE storages.t_storage IN ROW EXCLUSIVE MODE;

    UPDATE storages.t_storage
    SET c_name    = COALESCE(p_name, c_name),
        c_address = COALESCE(p_address, c_address)
    WHERE id = p_id;
EXCEPTION
    WHEN unique_violation THEN
        RAISE EXCEPTION 'Storage with name % already exists.', p_name;
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Error adding storage: %', sqlerrm;
END;
$$;

ALTER FUNCTION storages.storage_update(p_id integer, p_name text, p_address text) OWNER TO maindb;

REVOKE ALL ON FUNCTION storages.storage_update(p_id integer, p_name text, p_address text) FROM PUBLIC;

GRANT ALL ON FUNCTION storages.storage_update(p_id integer, p_name text, p_address text) TO postgres;

GRANT ALL ON FUNCTION storages.storage_update(p_id integer, p_name text, p_address text) TO program_service;

GRANT ALL ON FUNCTION storages.storage_update(p_id integer, p_name text, p_address text) TO admin_service;
