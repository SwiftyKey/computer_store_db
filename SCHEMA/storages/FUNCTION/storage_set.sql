CREATE OR REPLACE FUNCTION storages.storage_set(p_name text, p_address text) RETURNS integer
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_id integer;
BEGIN
    LOCK TABLE storages.t_storage IN EXCLUSIVE MODE;

    INSERT INTO storages.t_storage (c_name, c_address)
    VALUES (p_name, p_address)
    RETURNING id INTO v_id;

    RETURN v_id;
EXCEPTION
    WHEN unique_violation THEN
        RAISE EXCEPTION 'Storage with name % already exists.', p_name;
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Error adding storage: %', sqlerrm;
END;
$$;

ALTER FUNCTION storages.storage_set(p_name text, p_address text) OWNER TO maindb;

REVOKE ALL ON FUNCTION storages.storage_set(p_name text, p_address text) FROM PUBLIC;

GRANT ALL ON FUNCTION storages.storage_set(p_name text, p_address text) TO postgres;

GRANT ALL ON FUNCTION storages.storage_set(p_name text, p_address text) TO program_service;

GRANT ALL ON FUNCTION storages.storage_set(p_name text, p_address text) TO admin_service;
