CREATE OR REPLACE FUNCTION storages.supply_status_set(p_id_next integer, p_name text) RETURNS integer
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_id integer;
BEGIN
    LOCK TABLE storages.t_supply_status IN EXCLUSIVE MODE;

    IF p_id_next IS NOT NULL THEN
        PERFORM storages.supply_status_check_exists(p_id_next);
    END IF;

    INSERT INTO storages.t_supply_status (id_next, c_name)
    VALUES (p_id_next, p_name)
    RETURNING id INTO v_id;

    RETURN v_id;
EXCEPTION
    WHEN unique_violation THEN
        RAISE EXCEPTION 'Supply status with name % already exists.', p_name;
    WHEN foreign_key_violation THEN
        RAISE EXCEPTION 'Next supply status with id % does not exist.', p_id_next;
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Error adding supply status: %', sqlerrm;
END;
$$;

ALTER FUNCTION storages.supply_status_set(p_id_next integer, p_name text) OWNER TO maindb;

GRANT ALL ON FUNCTION storages.supply_status_set(p_id_next integer, p_name text) TO postgres;

GRANT ALL ON FUNCTION storages.supply_status_set(p_id_next integer, p_name text) TO program_service;

GRANT ALL ON FUNCTION storages.supply_status_set(p_id_next integer, p_name text) TO admin_service;
