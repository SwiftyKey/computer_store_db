CREATE OR REPLACE FUNCTION products.products_get_by_category(p_id_category integer) RETURNS TABLE(id integer, c_name text, c_description text, c_price numeric, c_manufacturer_name text, c_model_name text, c_count integer)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    PERFORM categories.category_check_exists(p_id_category);


    RETURN QUERY
        SELECT p.id,
               p.c_name,
               p.c_description,
               p.c_price,
               mfr.c_name                                 AS c_manufacturer_name,
               m.c_name                                   AS c_model_name,
               storages.inventory_get_product_count(p.id) AS c_count
        FROM products.t_product p
                 JOIN
             products.t_model m ON p.id_model = m.id
                 JOIN
             products.t_manufacturer mfr ON m.id_manufacturer = mfr.id
                 JOIN
             products.t_product_property pp ON pp.id_product = p.id
                 JOIN
             categories.t_category_property cp ON pp.id_category_property = cp.id
                 JOIN
             categories.t_category c ON cp.id_category = c.id
        WHERE c.id = p_id_category
        GROUP BY p.id, mfr.c_name, m.c_name;

    IF NOT found THEN
        RAISE EXCEPTION 'There are no products in this category with id %', p_id_category;
    END IF;
END;
$$;

ALTER FUNCTION products.products_get_by_category(p_id_category integer) OWNER TO maindb;

REVOKE ALL ON FUNCTION products.products_get_by_category(p_id_category integer) FROM PUBLIC;

GRANT ALL ON FUNCTION products.products_get_by_category(p_id_category integer) TO program_service;

GRANT ALL ON FUNCTION products.products_get_by_category(p_id_category integer) TO admin_service;
