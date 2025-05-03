CREATE OR REPLACE FUNCTION categories.property_set(p_name text, p_type text, p_id_unit integer) RETURNS integer
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_id INTEGER;
BEGIN
    PERFORM categories.unit_check_exists(p_id_unit);

    LOCK TABLE categories.t_property IN EXCLUSIVE MODE;

    INSERT INTO categories.t_property (c_name, c_type, id_unit)
    VALUES (p_name, p_type, p_id_unit)
    RETURNING id INTO v_id;

    RETURN v_id;
EXCEPTION
    WHEN unique_violation THEN
        RAISE EXCEPTION 'Property with name % already exists.', p_name;
    WHEN foreign_key_violation THEN
        RAISE EXCEPTION 'Unit with id % does not exist.', p_id_unit;
    WHEN check_violation THEN
        RAISE EXCEPTION 'Invalid property data.';
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Error adding property: %', SQLERRM;
END;
$$;

ALTER FUNCTION categories.property_set(p_name text, p_type text, p_id_unit integer) OWNER TO maindb;

REVOKE ALL ON FUNCTION categories.property_set(p_name text, p_type text, p_id_unit integer) FROM PUBLIC;

GRANT ALL ON FUNCTION categories.property_set(p_name text, p_type text, p_id_unit integer) TO program_service;

GRANT ALL ON FUNCTION categories.property_set(p_name text, p_type text, p_id_unit integer) TO admin_service;
