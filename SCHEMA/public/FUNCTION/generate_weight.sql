CREATE OR REPLACE FUNCTION public.generate_weight() RETURNS double precision
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN round((random() * 5 + 0.1)::numeric, 2); -- Случайное значение от 0.1 до 5 кг
END;
$$;

ALTER FUNCTION public.generate_weight() OWNER TO postgres;
