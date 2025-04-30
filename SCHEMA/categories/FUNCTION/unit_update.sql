CREATE OR REPLACE FUNCTION categories.unit_update(p_id integer, p_unit text) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    PERFORM categories.unit_check_exists(p_id);

    LOCK TABLE categories.t_unit IN ROW EXCLUSIVE MODE;

    UPDATE categories.t_unit
    SET c_unit = COALESCE(p_unit, c_unit)
    WHERE id = p_id;

EXCEPTION
    WHEN unique_violation THEN
        RAISE EXCEPTION 'Unit with value % already exists.', p_unit;
    WHEN check_violation THEN
        RAISE EXCEPTION 'Invalid unit value: %', p_unit;
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Error updating unit: %', SQLERRM;
END;
$$;

ALTER FUNCTION categories.unit_update(p_id integer, p_unit text) OWNER TO maindb;

COMMENT ON FUNCTION categories.unit_update(p_id integer, p_unit text) IS 'Обновляет существующую единицу измерения в таблице t_unit.';
