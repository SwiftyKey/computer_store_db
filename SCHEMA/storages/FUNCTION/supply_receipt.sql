CREATE OR REPLACE FUNCTION storages.supply_receipt(p_id integer, p_receipt_at timestamp with time zone) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_id_status integer;
BEGIN
    PERFORM storages.supply_check_exists(p_id);

    SELECT id
    INTO v_id_status
    FROM storages.t_supply_status
    WHERE c_name = 'Принят'
        FOR UPDATE;

    IF v_id_status IS NULL THEN
        RAISE EXCEPTION 'Status % is not found', 'Принят';
    END IF;

    LOCK TABLE storages.t_supply IN ROW EXCLUSIVE MODE;

    UPDATE storages.t_supply
    SET id_status     = v_id_status,
        c_receipt_at  = p_receipt_at
    WHERE id = p_id;
END;
$$;

ALTER FUNCTION storages.supply_receipt(p_id integer, p_receipt_at timestamp with time zone) OWNER TO maindb;

REVOKE ALL ON FUNCTION storages.supply_receipt(p_id integer, p_receipt_at timestamp with time zone) FROM PUBLIC;

GRANT ALL ON FUNCTION storages.supply_receipt(p_id integer, p_receipt_at timestamp with time zone) TO postgres;

GRANT ALL ON FUNCTION storages.supply_receipt(p_id integer, p_receipt_at timestamp with time zone) TO program_service;

GRANT ALL ON FUNCTION storages.supply_receipt(p_id integer, p_receipt_at timestamp with time zone) TO admin_service;
