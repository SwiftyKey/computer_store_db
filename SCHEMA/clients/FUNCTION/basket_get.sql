CREATE OR REPLACE FUNCTION clients.basket_get(p_id_client integer) RETURNS TABLE(id_product integer, c_count integer, c_batch_cost numeric)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    PERFORM clients.client_check_exists(p_id_client);

    RETURN QUERY
        SELECT bi.id_product, bi.c_count, bi.c_batch_cost
        FROM clients.t_basket_info bi
        WHERE id_client = p_id_client
            FOR UPDATE;

    IF NOT found THEN
        RAISE EXCEPTION 'There are no available products in basket with id_client %', p_id_client;
    END IF;

    RETURN;
END;
$$;

ALTER FUNCTION clients.basket_get(p_id_client integer) OWNER TO maindb;

REVOKE ALL ON FUNCTION clients.basket_get(p_id_client integer) FROM PUBLIC;

GRANT ALL ON FUNCTION clients.basket_get(p_id_client integer) TO program_service;

GRANT ALL ON FUNCTION clients.basket_get(p_id_client integer) TO admin_service;
