CREATE OR REPLACE FUNCTION clients.client_set(p_name text, p_phone text) RETURNS integer
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    new_client_id integer;
BEGIN
    LOCK TABLE clients.t_client IN EXCLUSIVE MODE;

    IF EXISTS (SELECT 1 FROM clients.t_client WHERE c_name = p_name AND c_phone = p_phone) THEN
        RAISE EXCEPTION 'Client with name % and phone % already exists.', p_name, p_phone;
    END IF;

    INSERT INTO clients.t_client (c_name, c_phone)
    VALUES (p_name, p_phone)
    RETURNING id INTO new_client_id;

    RETURN new_client_id;
EXCEPTION
    WHEN check_violation THEN
        RAISE EXCEPTION 'Invalid input data for client: %', sqlerrm;
    WHEN unique_violation THEN
        RAISE EXCEPTION 'Client with name % and phone % already exists.', p_name, p_phone;
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Error adding client: %', sqlerrm;
END;
$$;

ALTER FUNCTION clients.client_set(p_name text, p_phone text) OWNER TO maindb;

GRANT ALL ON FUNCTION clients.client_set(p_name text, p_phone text) TO program_service;

GRANT ALL ON FUNCTION clients.client_set(p_name text, p_phone text) TO admin_service;

COMMENT ON FUNCTION clients.client_set(p_name text, p_phone text) IS 'Добавляет нового клиента в таблицу t_client.';
