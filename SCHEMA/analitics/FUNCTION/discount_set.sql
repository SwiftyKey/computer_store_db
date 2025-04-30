CREATE OR REPLACE FUNCTION analitics.discount_set(p_type text, p_id_object integer, p_discount numeric, p_is_active boolean, p_start_at timestamp with time zone, p_end_at timestamp with time zone) RETURNS integer
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_id integer;
BEGIN
    LOCK TABLE analitics.t_discount IN EXCLUSIVE MODE;

    INSERT INTO analitics.t_discount (c_type, c_id_object, c_discount, c_is_active, c_start_at, c_end_at)
    VALUES (p_type, p_id_object, p_discount, p_is_active, p_start_at, p_end_at)
    RETURNING id INTO v_id;

    RETURN v_id;
EXCEPTION
    WHEN unique_violation THEN
        RAISE EXCEPTION 'Discount with the same type, id_object, discount, is_active, and start_at already exists.';
    WHEN check_violation THEN
        RAISE EXCEPTION 'Invalid discount data.';
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Error adding discount: %', sqlerrm;
END;
$$;

ALTER FUNCTION analitics.discount_set(p_type text, p_id_object integer, p_discount numeric, p_is_active boolean, p_start_at timestamp with time zone, p_end_at timestamp with time zone) OWNER TO maindb;

REVOKE ALL ON FUNCTION analitics.discount_set(p_type text, p_id_object integer, p_discount numeric, p_is_active boolean, p_start_at timestamp with time zone, p_end_at timestamp with time zone) FROM PUBLIC;

GRANT ALL ON FUNCTION analitics.discount_set(p_type text, p_id_object integer, p_discount numeric, p_is_active boolean, p_start_at timestamp with time zone, p_end_at timestamp with time zone) TO program_service;

GRANT ALL ON FUNCTION analitics.discount_set(p_type text, p_id_object integer, p_discount numeric, p_is_active boolean, p_start_at timestamp with time zone, p_end_at timestamp with time zone) TO admin_service;
