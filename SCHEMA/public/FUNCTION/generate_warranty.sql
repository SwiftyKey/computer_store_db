CREATE OR REPLACE FUNCTION public.generate_warranty() RETURNS integer
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN floor(random() * 4 + 1);
END;
$$;

ALTER FUNCTION public.generate_warranty() OWNER TO postgres;
