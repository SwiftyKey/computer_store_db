CREATE OR REPLACE FUNCTION clients.client_get_discount(p_id integer, p_max_discount numeric = 0.5, p_inflection_point numeric = 500000, p_slope double precision = 0.00005) RETURNS numeric
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_discount numeric;
BEGIN
    PERFORM clients.client_check_exists(p_id);

    SELECT p_max_discount / (1 + exp(-p_slope * (c_money_spent - p_inflection_point)))
    INTO v_discount
    FROM clients.t_client
    WHERE id = p_id
    FOR UPDATE;

    RETURN v_discount;
END;
$$;

ALTER FUNCTION clients.client_get_discount(p_id integer, p_max_discount numeric, p_inflection_point numeric, p_slope double precision) OWNER TO maindb;

REVOKE ALL ON FUNCTION clients.client_get_discount(p_id integer, p_max_discount numeric, p_inflection_point numeric, p_slope double precision) FROM PUBLIC;

GRANT ALL ON FUNCTION clients.client_get_discount(p_id integer, p_max_discount numeric, p_inflection_point numeric, p_slope double precision) TO program_service;

GRANT ALL ON FUNCTION clients.client_get_discount(p_id integer, p_max_discount numeric, p_inflection_point numeric, p_slope double precision) TO admin_service;
