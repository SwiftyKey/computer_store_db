CREATE OR REPLACE FUNCTION clients.basket_clear(p_id_client integer) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    LOCK TABLE clients.t_basket_info IN EXCLUSIVE MODE;

    PERFORM clients.client_check_exists(p_id_client);

    DELETE
    FROM clients.t_basket_info
    WHERE id_client = p_id_client;

END;
$$;

ALTER FUNCTION clients.basket_clear(p_id_client integer) OWNER TO maindb;

REVOKE ALL ON FUNCTION clients.basket_clear(p_id_client integer) FROM PUBLIC;

GRANT ALL ON FUNCTION clients.basket_clear(p_id_client integer) TO program_service;

GRANT ALL ON FUNCTION clients.basket_clear(p_id_client integer) TO admin_service;
