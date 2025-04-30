CREATE OR REPLACE FUNCTION storages.supply_status_check_exists(p_id integer) RETURNS boolean
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_exists boolean := FALSE;
BEGIN
    SELECT EXISTS(SELECT 1 FROM storages.t_supply_status WHERE id = p_id FOR UPDATE) INTO v_exists;

    IF NOT v_exists THEN
        RAISE EXCEPTION 'Supply status with id % does not exist.', p_id;
    END IF;

    RETURN TRUE;
END;
$$;

ALTER FUNCTION storages.supply_status_check_exists(p_id integer) OWNER TO maindb;

GRANT ALL ON FUNCTION storages.supply_status_check_exists(p_id integer) TO postgres;

GRANT ALL ON FUNCTION storages.supply_status_check_exists(p_id integer) TO program_service;

GRANT ALL ON FUNCTION storages.supply_status_check_exists(p_id integer) TO admin_service;
