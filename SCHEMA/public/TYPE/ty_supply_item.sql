CREATE TYPE public.ty_supply_item AS (
	id integer,
	count integer,
	c_cost numeric(10,2)
);

ALTER TYPE public.ty_supply_item OWNER TO postgres;
