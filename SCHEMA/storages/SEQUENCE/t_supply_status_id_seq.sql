CREATE SEQUENCE storages.t_supply_status_id_seq
	AS integer
	START WITH 1
	INCREMENT BY 1
	NO MAXVALUE
	NO MINVALUE
	CACHE 1;

ALTER SEQUENCE storages.t_supply_status_id_seq OWNER TO maindb;

ALTER SEQUENCE storages.t_supply_status_id_seq
	OWNED BY storages.t_supply_status.id;
