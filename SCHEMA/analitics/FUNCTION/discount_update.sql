CREATE OR REPLACE FUNCTION analitics.discount_update(p_id integer, p_type text, p_id_object integer, p_discount numeric, p_is_active boolean, p_start_at timestamp with time zone, p_end_at timestamp with time zone) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    PERFORM analitics.discount_check_exists(p_id);

    LOCK TABLE analitics.t_discount IN ROW EXCLUSIVE MODE;

    UPDATE analitics.t_discount
    SET c_type      = COALESCE(p_type, c_type),
        c_id_object = COALESCE(p_id_object, c_id_object),
        c_discount  = COALESCE(p_discount, c_discount),
        c_is_active = COALESCE(p_is_active, c_is_active),
        c_start_at  = COALESCE(p_start_at, c_start_at),
        c_end_at    = COALESCE(p_end_at, c_end_at)
    WHERE id = p_id;

EXCEPTION
    WHEN unique_violation THEN
        RAISE EXCEPTION 'Discount with the same type, id_object, discount, is_active, and start_at already exists.';
    WHEN check_violation THEN
        RAISE EXCEPTION 'Invalid discount data.';
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Error updating discount: %', sqlerrm;
END;
$$;

ALTER FUNCTION analitics.discount_update(p_id integer, p_type text, p_id_object integer, p_discount numeric, p_is_active boolean, p_start_at timestamp with time zone, p_end_at timestamp with time zone) OWNER TO maindb;

REVOKE ALL ON FUNCTION analitics.discount_update(p_id integer, p_type text, p_id_object integer, p_discount numeric, p_is_active boolean, p_start_at timestamp with time zone, p_end_at timestamp with time zone) FROM PUBLIC;

GRANT ALL ON FUNCTION analitics.discount_update(p_id integer, p_type text, p_id_object integer, p_discount numeric, p_is_active boolean, p_start_at timestamp with time zone, p_end_at timestamp with time zone) TO program_service;

GRANT ALL ON FUNCTION analitics.discount_update(p_id integer, p_type text, p_id_object integer, p_discount numeric, p_is_active boolean, p_start_at timestamp with time zone, p_end_at timestamp with time zone) TO admin_service;
