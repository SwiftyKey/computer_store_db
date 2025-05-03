CREATE OR REPLACE FUNCTION categories.is_leaf_category(p_id_category integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_count INTEGER;
BEGIN
    SELECT COUNT(*) INTO v_count FROM categories.t_category WHERE id_parent = p_id_category;
    RETURN v_count = 0;
END;
$$;

ALTER FUNCTION categories.is_leaf_category(p_id_category integer) OWNER TO maindb;

REVOKE ALL ON FUNCTION categories.is_leaf_category(p_id_category integer) FROM PUBLIC;

GRANT ALL ON FUNCTION categories.is_leaf_category(p_id_category integer) TO program_service;

GRANT ALL ON FUNCTION categories.is_leaf_category(p_id_category integer) TO admin_service;
