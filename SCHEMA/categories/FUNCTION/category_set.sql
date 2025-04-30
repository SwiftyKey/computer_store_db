CREATE OR REPLACE FUNCTION categories.category_set(p_id_parent integer, p_name text) RETURNS integer
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_id integer;
    path text := '';
BEGIN
    LOCK TABLE categories.t_category IN EXCLUSIVE MODE;

    IF p_id_parent IS NOT NULL THEN
        PERFORM categories.category_check_exists(p_id_parent);
        SELECT c_path FROM categories.t_category WHERE id = p_id_parent INTO path;
        path := path || ':';
    END IF;

    INSERT INTO categories.t_category (id_parent, c_name, c_path)
    VALUES (p_id_parent, p_name, path)
    RETURNING id INTO v_id;

    UPDATE categories.t_category
    SET c_path = path || v_id::text
    WHERE id = v_id;

    RETURN v_id;
EXCEPTION
    WHEN unique_violation THEN
        RAISE EXCEPTION 'Category with name % already exists.', p_name;
    WHEN foreign_key_violation THEN
        RAISE EXCEPTION 'Parent category with id % does not exist.', p_id_parent;
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Error adding category: %', sqlerrm;
END;
$$;

ALTER FUNCTION categories.category_set(p_id_parent integer, p_name text) OWNER TO maindb;

REVOKE ALL ON FUNCTION categories.category_set(p_id_parent integer, p_name text) FROM PUBLIC;

GRANT ALL ON FUNCTION categories.category_set(p_id_parent integer, p_name text) TO program_service;

GRANT ALL ON FUNCTION categories.category_set(p_id_parent integer, p_name text) TO admin_service;
