CREATE OR REPLACE FUNCTION categories.category_update(p_id integer, p_id_parent integer, p_name text) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    AS $_$
BEGIN
    PERFORM categories.category_check_exists(p_id);

    LOCK TABLE categories.t_category IN ROW EXCLUSIVE MODE;

    IF p_id_parent IS NOT NULL THEN
        PERFORM categories.category_check_exists(p_id_parent);
    END IF;

    UPDATE categories.t_category
    SET id_parent = COALESCE(p_id_parent, id_parent),
        c_name    = COALESCE(p_name, c_name),
        c_path    = regexp_replace(c_path, '([0-9:]*:)([0-9]+)$', '\1' || p_id_parent::text)
    WHERE id = p_id;

EXCEPTION
    WHEN unique_violation THEN
        RAISE EXCEPTION 'Category with name % already exists.', p_name;
    WHEN foreign_key_violation THEN
        RAISE EXCEPTION 'Parent category with id % does not exist.', p_id_parent;
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Error updating category: %', sqlerrm;
END;
$_$;

ALTER FUNCTION categories.category_update(p_id integer, p_id_parent integer, p_name text) OWNER TO maindb;

REVOKE ALL ON FUNCTION categories.category_update(p_id integer, p_id_parent integer, p_name text) FROM PUBLIC;

GRANT ALL ON FUNCTION categories.category_update(p_id integer, p_id_parent integer, p_name text) TO program_service;

GRANT ALL ON FUNCTION categories.category_update(p_id integer, p_id_parent integer, p_name text) TO admin_service;
