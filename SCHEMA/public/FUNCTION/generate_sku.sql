CREATE OR REPLACE FUNCTION public.generate_sku() RETURNS text
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN left(md5(random()::text)::text, 14);
END;
$$;

ALTER FUNCTION public.generate_sku() OWNER TO postgres;
