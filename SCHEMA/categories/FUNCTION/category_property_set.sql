CREATE OR REPLACE FUNCTION categories.category_property_set(p_id_category integer, p_id_property integer) RETURNS integer
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_id integer;
BEGIN
    LOCK TABLE categories.t_category_property IN EXCLUSIVE MODE;

    PERFORM categories.category_check_exists(p_id_category);
    PERFORM categories.property_check_exists(p_id_property);

    INSERT INTO categories.t_category_property (id_category, id_property)
    VALUES (p_id_category, p_id_property)
    RETURNING id INTO v_id;

    RETURN v_id;

EXCEPTION
    WHEN unique_violation THEN
        RAISE EXCEPTION 'Category Property with category id % and property id % already exists.', p_id_category, p_id_property;
    WHEN foreign_key_violation THEN
        RAISE EXCEPTION 'Category or Property does not exist.';
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Error adding category property: %', sqlerrm;
END;
$$;

ALTER FUNCTION categories.category_property_set(p_id_category integer, p_id_property integer) OWNER TO maindb;

REVOKE ALL ON FUNCTION categories.category_property_set(p_id_category integer, p_id_property integer) FROM PUBLIC;

GRANT ALL ON FUNCTION categories.category_property_set(p_id_category integer, p_id_property integer) TO program_service;

GRANT ALL ON FUNCTION categories.category_property_set(p_id_category integer, p_id_property integer) TO admin_service;
