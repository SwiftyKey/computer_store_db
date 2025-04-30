CREATE SEQUENCE clients.t_client_id_seq
	AS integer
	START WITH 1
	INCREMENT BY 1
	NO MAXVALUE
	NO MINVALUE
	CACHE 1;

ALTER SEQUENCE clients.t_client_id_seq OWNER TO maindb;

ALTER SEQUENCE clients.t_client_id_seq
	OWNED BY clients.t_client.id;
