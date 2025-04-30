CREATE OR REPLACE FUNCTION categories.property_update(p_id integer, p_name text, p_type text, p_id_unit integer) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    PERFORM categories.property_check_exists(p_id);
    PERFORM categories.unit_check_exists(p_id_unit);

    LOCK TABLE categories.t_property IN ROW EXCLUSIVE MODE;

    UPDATE categories.t_property
    SET c_name = COALESCE(p_name, c_name),
        c_type = COALESCE(p_type, c_type),
        id_unit = COALESCE(p_id_unit, id_unit)
    WHERE id = p_id;

EXCEPTION
    WHEN unique_violation THEN
        RAISE EXCEPTION 'Property with name % already exists.', p_name;
    WHEN foreign_key_violation THEN
        RAISE EXCEPTION 'Unit with id % does not exist.', p_id_unit;
    WHEN check_violation THEN
        RAISE EXCEPTION 'Invalid property data.';
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Error updating property: %', SQLERRM;
END;
$$;

ALTER FUNCTION categories.property_update(p_id integer, p_name text, p_type text, p_id_unit integer) OWNER TO maindb;

REVOKE ALL ON FUNCTION categories.property_update(p_id integer, p_name text, p_type text, p_id_unit integer) FROM PUBLIC;

GRANT ALL ON FUNCTION categories.property_update(p_id integer, p_name text, p_type text, p_id_unit integer) TO program_service;

GRANT ALL ON FUNCTION categories.property_update(p_id integer, p_name text, p_type text, p_id_unit integer) TO admin_service;
