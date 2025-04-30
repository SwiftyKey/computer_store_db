CREATE OR REPLACE FUNCTION clients.basket_info_update(p_id_client integer, p_id_product integer, p_count integer) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_product_cost numeric;
BEGIN
    PERFORM clients.basket_info_check_exists(p_id_client, p_id_product);

    LOCK TABLE clients.t_basket_info IN ROW EXCLUSIVE MODE;

    IF p_id_client IS NOT NULL THEN
        PERFORM clients.client_check_exists(p_id_client);
    END IF;

    IF p_id_product IS NOT NULL THEN
        PERFORM products.product_check_exists(p_id_product);
    END IF;

    SELECT c_price
    INTO v_product_cost
    FROM products.t_product
    WHERE id = p_id_product
        FOR UPDATE;

    IF p_count IS NULL OR p_count <= 0 THEN
        p_count := 1;
    END IF;

    UPDATE clients.t_basket_info
    SET c_count      = p_count,
        c_batch_cost = p_count * v_product_cost
    WHERE id_client = p_id_client
      AND id_product = p_id_product;

EXCEPTION
    WHEN unique_violation THEN
        RAISE EXCEPTION 'Basket info with the same client and product already exists.';
    WHEN foreign_key_violation THEN
        RAISE EXCEPTION 'Client or product with specified id does not exist.';
    WHEN check_violation THEN
        RAISE EXCEPTION 'Invalid basket info data.';
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Error updating basket info: %', sqlerrm;
END;
$$;

ALTER FUNCTION clients.basket_info_update(p_id_client integer, p_id_product integer, p_count integer) OWNER TO maindb;

REVOKE ALL ON FUNCTION clients.basket_info_update(p_id_client integer, p_id_product integer, p_count integer) FROM PUBLIC;

GRANT ALL ON FUNCTION clients.basket_info_update(p_id_client integer, p_id_product integer, p_count integer) TO program_service;

GRANT ALL ON FUNCTION clients.basket_info_update(p_id_client integer, p_id_product integer, p_count integer) TO admin_service;
