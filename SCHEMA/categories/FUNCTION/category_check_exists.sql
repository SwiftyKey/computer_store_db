CREATE OR REPLACE FUNCTION categories.category_check_exists(p_id integer) RETURNS boolean
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    exists boolean := FALSE;
BEGIN
    SELECT EXISTS(SELECT 1 FROM categories.t_category WHERE id = p_id FOR UPDATE) INTO exists;

    IF NOT exists THEN
        RAISE EXCEPTION 'Category with id % does not exist.', p_id;
    END IF;

    RETURN TRUE;
END;
$$;

ALTER FUNCTION categories.category_check_exists(p_id integer) OWNER TO maindb;

REVOKE ALL ON FUNCTION categories.category_check_exists(p_id integer) FROM PUBLIC;

GRANT ALL ON FUNCTION categories.category_check_exists(p_id integer) TO program_service;

GRANT ALL ON FUNCTION categories.category_check_exists(p_id integer) TO admin_service;
