CREATE OR REPLACE FUNCTION public.generate_dimension() RETURNS double precision
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN round((random() * 30 + 5)::numeric, 2); -- Случайное значение от 5 до 35 см
END;
$$;

ALTER FUNCTION public.generate_dimension() OWNER TO postgres;
