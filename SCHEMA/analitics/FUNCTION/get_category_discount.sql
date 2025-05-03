CREATE OR REPLACE FUNCTION analitics.get_category_discount(p_id integer) RETURNS numeric
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_discount numeric;
    v_cur record;
    v_path integer[];
BEGIN
    PERFORM categories.category_check_exists(p_id);

    SELECT string_to_array(c_path, ':')::integer[]
    INTO v_path
    FROM categories.t_category
    WHERE id = p_id
    FOR UPDATE;

    FOREACH v_cur IN ARRAY (
            SELECT array_agg(val ORDER BY idx DESC)
            FROM   unnest(v_path) WITH ORDINALITY AS t(val, idx)
        )
    LOOP
        SELECT c_discount
        INTO v_discount
        FROM analitics.t_discount
        WHERE c_type = 'Category' AND
              c_id_object = v_cur AND
              c_is_active;

        IF v_discount IS NOT NULL THEN
            RETURN v_discount;
        END IF;
    END LOOP;

    RETURN NULL;
END;
$$;

ALTER FUNCTION analitics.get_category_discount(p_id integer) OWNER TO maindb;

REVOKE ALL ON FUNCTION analitics.get_category_discount(p_id integer) FROM PUBLIC;

GRANT ALL ON FUNCTION analitics.get_category_discount(p_id integer) TO program_service;

GRANT ALL ON FUNCTION analitics.get_category_discount(p_id integer) TO admin_service;
