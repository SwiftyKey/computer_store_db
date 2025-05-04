CREATE OR REPLACE FUNCTION public.generate_price() RETURNS numeric
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN round((random() * 100000 + 1000)::numeric, 2); -- Случайное значение от 1000 до 101000 руб.
END;
$$;

ALTER FUNCTION public.generate_price() OWNER TO postgres;
