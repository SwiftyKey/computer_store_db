CREATE SEQUENCE analitics.t_discount_id_seq
	AS integer
	START WITH 1
	INCREMENT BY 1
	NO MAXVALUE
	NO MINVALUE
	CACHE 1;

ALTER SEQUENCE analitics.t_discount_id_seq OWNER TO maindb;

ALTER SEQUENCE analitics.t_discount_id_seq
	OWNED BY analitics.t_discount.id;
