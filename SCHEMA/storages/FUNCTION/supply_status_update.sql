CREATE OR REPLACE FUNCTION storages.supply_status_update(p_id integer, p_id_next integer, p_name text) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    PERFORM storages.supply_status_check_exists(p_id);

    LOCK TABLE storages.t_supply_status IN ROW EXCLUSIVE MODE;

    IF p_id_next IS NOT NULL THEN
        PERFORM storages.supply_status_check_exists(p_id_next);
    END IF;

    UPDATE storages.t_supply_status
    SET id_next = COALESCE(p_id_next, id_next),
        c_name  = COALESCE(p_name, c_name)
    WHERE id = p_id;

EXCEPTION
    WHEN unique_violation THEN
        RAISE EXCEPTION 'Supply status with name % already exists.', p_name;
    WHEN foreign_key_violation THEN
        RAISE EXCEPTION 'Next supply status with id % does not exist.', p_id_next;
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Error updating supply status: %', sqlerrm;
END;
$$;

ALTER FUNCTION storages.supply_status_update(p_id integer, p_id_next integer, p_name text) OWNER TO maindb;

GRANT ALL ON FUNCTION storages.supply_status_update(p_id integer, p_id_next integer, p_name text) TO postgres;

GRANT ALL ON FUNCTION storages.supply_status_update(p_id integer, p_id_next integer, p_name text) TO program_service;

GRANT ALL ON FUNCTION storages.supply_status_update(p_id integer, p_id_next integer, p_name text) TO admin_service;
