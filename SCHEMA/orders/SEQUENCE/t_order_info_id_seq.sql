CREATE SEQUENCE orders.t_order_info_id_seq
	AS integer
	START WITH 1
	INCREMENT BY 1
	NO MAXVALUE
	NO MINVALUE
	CACHE 1;

ALTER SEQUENCE orders.t_order_info_id_seq OWNER TO maindb;

ALTER SEQUENCE orders.t_order_info_id_seq
	OWNED BY orders.t_order_info.id;
