CREATE OR REPLACE FUNCTION categories.unit_set(p_unit text) RETURNS integer
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    id INTEGER;
BEGIN
    LOCK TABLE categories.t_unit IN EXCLUSIVE MODE;

    INSERT INTO categories.t_unit (c_unit)
    VALUES (p_unit)
    RETURNING id INTO id;

    RETURN id;
EXCEPTION
    WHEN unique_violation THEN
        RAISE EXCEPTION 'Unit with value % already exists.', p_unit;
    WHEN check_violation THEN
        RAISE EXCEPTION 'Invalid unit value: %', p_unit;
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Error adding unit: %', SQLERRM;
END;
$$;

ALTER FUNCTION categories.unit_set(p_unit text) OWNER TO maindb;

COMMENT ON FUNCTION categories.unit_set(p_unit text) IS 'Добавляет новую единицу измерения в таблицу t_unit.';
