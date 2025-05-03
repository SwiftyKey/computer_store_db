CREATE OR REPLACE FUNCTION analitics.objects_status_update(p_timestamp timestamp with time zone) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
BEGIN
    IF p_timestamp IS NULL THEN
        RAISE EXCEPTION 'p_timestamp is null';
    END IF;
    
    UPDATE analitics.t_discount
    SET c_is_active = (p_timestamp BETWEEN c_start_at AND c_end_at)
    WHERE c_is_active = true;
END;
$$;

ALTER FUNCTION analitics.objects_status_update(p_timestamp timestamp with time zone) OWNER TO maindb;

REVOKE ALL ON FUNCTION analitics.objects_status_update(p_timestamp timestamp with time zone) FROM PUBLIC;

GRANT ALL ON FUNCTION analitics.objects_status_update(p_timestamp timestamp with time zone) TO program_service;

GRANT ALL ON FUNCTION analitics.objects_status_update(p_timestamp timestamp with time zone) TO admin_service;
