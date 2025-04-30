CREATE SEQUENCE products.t_manufacturer_id_seq
	AS integer
	START WITH 1
	INCREMENT BY 1
	NO MAXVALUE
	NO MINVALUE
	CACHE 1;

ALTER SEQUENCE products.t_manufacturer_id_seq OWNER TO maindb;

ALTER SEQUENCE products.t_manufacturer_id_seq
	OWNED BY products.t_manufacturer.id;
