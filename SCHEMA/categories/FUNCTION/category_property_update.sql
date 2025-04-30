CREATE OR REPLACE FUNCTION categories.category_property_update(p_id integer, p_id_category integer, p_id_property integer) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    PERFORM categories.category_property_check_exists(p_id);

    LOCK TABLE categories.t_category_property IN ROW EXCLUSIVE MODE;

    IF p_id_category IS NOT NULL THEN
        PERFORM categories.category_check_exists(p_id_category);
    END IF;

    IF p_id_property IS NOT NULL THEN
        PERFORM categories.property_check_exists(p_id_property);
    END IF;

    UPDATE categories.t_category_property
    SET id_category = COALESCE(p_id_category, id_category),
        id_property = COALESCE(p_id_property, id_property)
    WHERE id = p_id;

EXCEPTION
    WHEN unique_violation THEN
        RAISE EXCEPTION 'Category Property with category id % and property id % already exists.', p_id_category, p_id_property;
    WHEN foreign_key_violation THEN
        RAISE EXCEPTION 'Category or Property does not exist.';
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Error updating category property: %', sqlerrm;
END;
$$;

ALTER FUNCTION categories.category_property_update(p_id integer, p_id_category integer, p_id_property integer) OWNER TO maindb;

REVOKE ALL ON FUNCTION categories.category_property_update(p_id integer, p_id_category integer, p_id_property integer) FROM PUBLIC;

GRANT ALL ON FUNCTION categories.category_property_update(p_id integer, p_id_category integer, p_id_property integer) TO program_service;

GRANT ALL ON FUNCTION categories.category_property_update(p_id integer, p_id_category integer, p_id_property integer) TO admin_service;
