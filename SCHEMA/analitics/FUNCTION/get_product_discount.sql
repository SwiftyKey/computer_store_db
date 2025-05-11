CREATE OR REPLACE FUNCTION analitics.get_product_discount(p_path text[], p_id_object integer) RETURNS numeric
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_discount numeric := 0;
    v_id_object integer;
    v_type text;
BEGIN
    IF array_length(p_path, 1) NOT BETWEEN 1 AND 3 THEN
        RAISE EXCEPTION 'p_path length must be between (1, 3)';
    END IF;

    IF p_path[0] != 'Product' THEN
        RAISE EXCEPTION 'First element of array must be "Product"';
    END IF;

    PERFORM products.product_check_exists(p_id_object);
    PERFORM analitics.objects_status_update(NOW());
    
    FOREACH v_type IN ARRAY p_path
    LOOP
        v_id_object := CASE v_type
            WHEN 'Product' THEN
                p_id_object
            WHEN 'Category' THEN
                products.product_get_category(p_id_object)
            ELSE
                products.product_get_model(p_id_object)
            END;

        SELECT c_discount
        INTO v_discount
        FROM analitics.t_discount
        WHERE c_type = v_type AND
              c_id_object = v_id_object AND
              c_is_active
        FOR UPDATE;

        IF v_discount IS NOT NULL THEN
            RETURN v_discount;
        END IF;
    END LOOP;

    RETURN analitics.get_category_discount(products.product_get_category(p_id_object));
END;
$$;

ALTER FUNCTION analitics.get_product_discount(p_path text[], p_id_object integer) OWNER TO maindb;

REVOKE ALL ON FUNCTION analitics.get_product_discount(p_path text[], p_id_object integer) FROM PUBLIC;

GRANT ALL ON FUNCTION analitics.get_product_discount(p_path text[], p_id_object integer) TO program_service;

GRANT ALL ON FUNCTION analitics.get_product_discount(p_path text[], p_id_object integer) TO admin_service;
