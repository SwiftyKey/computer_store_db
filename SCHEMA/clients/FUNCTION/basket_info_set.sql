CREATE OR REPLACE FUNCTION clients.basket_info_set(p_id_client integer, p_id_product integer, p_count integer) RETURNS integer
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_id           integer;
    v_product_cost numeric;
BEGIN
    LOCK TABLE clients.t_basket_info IN EXCLUSIVE MODE;

    PERFORM clients.client_check_exists(p_id_client);
    PERFORM products.product_check_exists(p_id_product);

    SELECT c_price
    INTO v_product_cost
    FROM products.t_product
    WHERE id = p_id_product
        FOR UPDATE;

    INSERT INTO clients.t_basket_info (id_client, id_product, c_count, c_batch_cost)
    VALUES (p_id_client, p_id_product, p_count, v_product_cost * p_count)
    RETURNING id INTO v_id;

    RETURN v_id;
EXCEPTION
    WHEN unique_violation THEN
        RAISE EXCEPTION 'Basket info with the same client and product already exists.';
    WHEN foreign_key_violation THEN
        RAISE EXCEPTION 'Client or product with specified id does not exist.';
    WHEN check_violation THEN
        RAISE EXCEPTION 'Invalid basket info data.';
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Error adding basket info: %', sqlerrm;
END;
$$;

ALTER FUNCTION clients.basket_info_set(p_id_client integer, p_id_product integer, p_count integer) OWNER TO maindb;

REVOKE ALL ON FUNCTION clients.basket_info_set(p_id_client integer, p_id_product integer, p_count integer) FROM PUBLIC;

GRANT ALL ON FUNCTION clients.basket_info_set(p_id_client integer, p_id_product integer, p_count integer) TO program_service;

GRANT ALL ON FUNCTION clients.basket_info_set(p_id_client integer, p_id_product integer, p_count integer) TO admin_service;
