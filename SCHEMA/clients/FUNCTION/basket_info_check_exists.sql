CREATE OR REPLACE FUNCTION clients.basket_info_check_exists(p_id_client integer, p_id_product integer) RETURNS boolean
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_exists boolean := FALSE;
BEGIN
    SELECT EXISTS(SELECT 1
                  FROM clients.t_basket_info
                  WHERE id_client = p_id_client
                    AND id_product = p_id_product
                      FOR UPDATE)
    INTO v_exists;

    IF NOT v_exists THEN
        RAISE EXCEPTION 'Basket info with id_client % and id_product % does not exist.', p_id_client, p_id_product;
    END IF;

    RETURN TRUE;
END;
$$;

ALTER FUNCTION clients.basket_info_check_exists(p_id_client integer, p_id_product integer) OWNER TO maindb;

REVOKE ALL ON FUNCTION clients.basket_info_check_exists(p_id_client integer, p_id_product integer) FROM PUBLIC;

GRANT ALL ON FUNCTION clients.basket_info_check_exists(p_id_client integer, p_id_product integer) TO program_service;

GRANT ALL ON FUNCTION clients.basket_info_check_exists(p_id_client integer, p_id_product integer) TO admin_service;
