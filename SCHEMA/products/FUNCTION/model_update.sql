CREATE OR REPLACE FUNCTION products.model_update(p_id integer, p_id_manufacturer integer, p_name text) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    PERFORM products.model_check_exists(p_id);

    LOCK TABLE products.t_model IN ROW EXCLUSIVE MODE;

    IF p_id_manufacturer IS NOT NULL THEN
        PERFORM products.manufacturer_check_exists(p_id_manufacturer);
    END IF;

    UPDATE products.t_model
    SET id_manufacturer = COALESCE(p_id_manufacturer, id_manufacturer),
        c_name          = COALESCE(p_name, c_name)
    WHERE id = p_id;

EXCEPTION
    WHEN unique_violation THEN
        RAISE EXCEPTION 'Model with name % already exists.', p_name;
    WHEN foreign_key_violation THEN
        RAISE EXCEPTION 'Manufacturer with id % does not exist.', p_id_manufacturer;
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Error updating model: %', sqlerrm;
END;
$$;

ALTER FUNCTION products.model_update(p_id integer, p_id_manufacturer integer, p_name text) OWNER TO maindb;

REVOKE ALL ON FUNCTION products.model_update(p_id integer, p_id_manufacturer integer, p_name text) FROM PUBLIC;

GRANT ALL ON FUNCTION products.model_update(p_id integer, p_id_manufacturer integer, p_name text) TO program_service;

GRANT ALL ON FUNCTION products.model_update(p_id integer, p_id_manufacturer integer, p_name text) TO admin_service;
