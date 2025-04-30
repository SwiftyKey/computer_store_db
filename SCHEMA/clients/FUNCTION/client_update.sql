CREATE OR REPLACE FUNCTION clients.client_update(p_id integer, p_name text = NULL::text, p_phone text = NULL::text, p_personal_discount numeric = NULL::numeric, p_money_spent numeric = NULL::numeric) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    PERFORM clients.client_check_exists(p_id);

    LOCK TABLE clients.t_client IN ROW EXCLUSIVE MODE;

    UPDATE clients.t_client
    SET c_name              = COALESCE(p_name, c_name),
        c_phone             = COALESCE(p_phone, c_phone),
        c_personal_discount = COALESCE(p_personal_discount, c_personal_discount),
        c_money_spent       = COALESCE(p_money_spent, c_money_spent)
    WHERE id = p_id;

EXCEPTION
    WHEN check_violation THEN
        RAISE EXCEPTION 'Invalid input data for client: %', sqlerrm;
    WHEN unique_violation THEN
        RAISE EXCEPTION 'Client with name % and phone % already exists.', p_name, p_phone;
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Error updating client: %', sqlerrm;

END;
$$;

ALTER FUNCTION clients.client_update(p_id integer, p_name text, p_phone text, p_personal_discount numeric, p_money_spent numeric) OWNER TO maindb;

GRANT ALL ON FUNCTION clients.client_update(p_id integer, p_name text, p_phone text, p_personal_discount numeric, p_money_spent numeric) TO program_service;

GRANT ALL ON FUNCTION clients.client_update(p_id integer, p_name text, p_phone text, p_personal_discount numeric, p_money_spent numeric) TO admin_service;

COMMENT ON FUNCTION clients.client_update(p_id integer, p_name text, p_phone text, p_personal_discount numeric, p_money_spent numeric) IS 'Обновляет информацию о существующем клиенте в таблице t_client.';
