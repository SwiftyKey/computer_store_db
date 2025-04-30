CREATE OR REPLACE FUNCTION categories.unit_check_exists(p_id integer) RETURNS boolean
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    exists BOOLEAN := FALSE;
BEGIN
    SELECT EXISTS(SELECT 1 FROM categories.t_unit WHERE id = p_id FOR UPDATE) INTO exists;

    IF NOT exists THEN
        RAISE EXCEPTION 'Unit with id % does not exist.', p_id;
    END IF;

    RETURN TRUE;
END;
$$;

ALTER FUNCTION categories.unit_check_exists(p_id integer) OWNER TO maindb;

REVOKE ALL ON FUNCTION categories.unit_check_exists(p_id integer) FROM PUBLIC;

GRANT ALL ON FUNCTION categories.unit_check_exists(p_id integer) TO program_service;

GRANT ALL ON FUNCTION categories.unit_check_exists(p_id integer) TO admin_service;

COMMENT ON FUNCTION categories.unit_check_exists(p_id integer) IS 'Проверяет существование единицы измерения по ID и выбрасывает исключение, если она не существует.';
