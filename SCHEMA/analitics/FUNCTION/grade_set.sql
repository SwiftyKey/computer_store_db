CREATE OR REPLACE FUNCTION analitics.grade_set(p_type text, p_id_object integer, p_grade integer) RETURNS integer
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_id                integer;
    v_prev_grade        double precision;
    v_prev_grades_count integer;
BEGIN
    LOCK TABLE analitics.t_grade IN EXCLUSIVE MODE;

    SELECT id, c_cur_grade, c_cur_grades_count
    INTO v_id, v_prev_grade, v_prev_grades_count
    FROM analitics.t_grade
    WHERE c_type = p_type
      AND c_id_object = p_id_object
    ORDER BY c_grade_at DESC
    LIMIT 1 FOR UPDATE;

    IF v_id IS NULL
    THEN
        v_prev_grade := p_grade;
        v_prev_grades_count := 1;
    ELSE
        v_prev_grades_count := v_prev_grades_count + 1;
        v_prev_grade := (v_prev_grade * v_prev_grades_count + p_grade) / v_prev_grades_count;
    END IF;

    INSERT INTO analitics.t_grade(c_type, c_id_object, c_grade_at, c_cur_grade, c_cur_grades_count)
    VALUES (p_type, p_id_object, NOW(), v_prev_grade, v_prev_grades_count)
    RETURNING id INTO v_id;

    RETURN v_id;
EXCEPTION
    WHEN unique_violation THEN
        RAISE EXCEPTION 'Grade with the same type, id_object, and grade_at already exists.';
    WHEN check_violation THEN
        RAISE EXCEPTION 'Invalid grade data.';
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Error adding grade: %', sqlerrm;
END;
$$;

ALTER FUNCTION analitics.grade_set(p_type text, p_id_object integer, p_grade integer) OWNER TO maindb;

REVOKE ALL ON FUNCTION analitics.grade_set(p_type text, p_id_object integer, p_grade integer) FROM PUBLIC;

REVOKE ALL ON FUNCTION analitics.grade_set(p_type text, p_id_object integer, p_grade integer) FROM maindb;

GRANT ALL ON FUNCTION analitics.grade_set(p_type text, p_id_object integer, p_grade integer) TO program_service;

GRANT ALL ON FUNCTION analitics.grade_set(p_type text, p_id_object integer, p_grade integer) TO admin_service;

COMMENT ON FUNCTION analitics.grade_set(p_type text, p_id_object integer, p_grade integer) IS 'Функция, для добавления оценки на объект';
