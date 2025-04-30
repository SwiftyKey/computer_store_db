CREATE OR REPLACE FUNCTION storages.supply_status_next(p_id integer) RETURNS integer
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_id_next integer;
BEGIN
    PERFORM storages.supply_status_check_exists(p_id);

    SELECT id_next
    INTO v_id_next
    FROM storages.t_supply_status
    WHERE id = p_id
        FOR UPDATE;

    RETURN v_id_next;
END;
$$;

ALTER FUNCTION storages.supply_status_next(p_id integer) OWNER TO maindb;

GRANT ALL ON FUNCTION storages.supply_status_next(p_id integer) TO postgres;

GRANT ALL ON FUNCTION storages.supply_status_next(p_id integer) TO program_service;

GRANT ALL ON FUNCTION storages.supply_status_next(p_id integer) TO admin_service;
