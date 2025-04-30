CREATE OR REPLACE FUNCTION clients.client_check_exists(p_id integer) RETURNS boolean
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    client_exists boolean := FALSE;
BEGIN
    SELECT EXISTS(SELECT 1 FROM clients.t_client WHERE id = p_id FOR UPDATE) INTO client_exists;

    IF NOT client_exists THEN
        RAISE EXCEPTION 'Client with id % does not exist.', p_id;
    END IF;

    RETURN TRUE;
END;
$$;

ALTER FUNCTION clients.client_check_exists(p_id integer) OWNER TO maindb;

REVOKE ALL ON FUNCTION clients.client_check_exists(p_id integer) FROM PUBLIC;

GRANT ALL ON FUNCTION clients.client_check_exists(p_id integer) TO program_service;

GRANT ALL ON FUNCTION clients.client_check_exists(p_id integer) TO admin_service;

COMMENT ON FUNCTION clients.client_check_exists(p_id integer) IS 'Проверяет существование клиента по ID и выбрасывает исключение, если он не существует.';
