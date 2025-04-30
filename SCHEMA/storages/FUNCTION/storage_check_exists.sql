CREATE OR REPLACE FUNCTION storages.storage_check_exists(p_id integer) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_count integer;
BEGIN
    SELECT COUNT(*)
    INTO v_count
    FROM storages.t_storage
    WHERE id = p_id
        FOR UPDATE;

    IF v_count = 0 THEN
        RAISE EXCEPTION 'Storage with id % does not exist', p_id;
    END IF;
END;
$$;

ALTER FUNCTION storages.storage_check_exists(p_id integer) OWNER TO maindb;

REVOKE ALL ON FUNCTION storages.storage_check_exists(p_id integer) FROM PUBLIC;

GRANT ALL ON FUNCTION storages.storage_check_exists(p_id integer) TO postgres;

GRANT ALL ON FUNCTION storages.storage_check_exists(p_id integer) TO program_service;

GRANT ALL ON FUNCTION storages.storage_check_exists(p_id integer) TO admin_service;
