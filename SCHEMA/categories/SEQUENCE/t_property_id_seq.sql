CREATE SEQUENCE categories.t_property_id_seq
	AS integer
	START WITH 1
	INCREMENT BY 1
	NO MAXVALUE
	NO MINVALUE
	CACHE 1;

ALTER SEQUENCE categories.t_property_id_seq OWNER TO maindb;

ALTER SEQUENCE categories.t_property_id_seq
	OWNED BY categories.t_property.id;
