CREATE OR REPLACE FUNCTION public.generate_gtin() RETURNS text
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN left(md5(random()::text)::text, 14);
END;
$$;

ALTER FUNCTION public.generate_gtin() OWNER TO postgres;
