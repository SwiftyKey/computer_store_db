CREATE TABLE clients.t_client (
	id integer DEFAULT nextval('clients.t_client_id_seq'::regclass) NOT NULL,
	c_name text NOT NULL,
	c_phone text NOT NULL,
	c_personal_discount numeric(2,2) DEFAULT 0 NOT NULL,
	c_money_spent numeric(10,2) DEFAULT 0 NOT NULL
);

ALTER TABLE clients.t_client OWNER TO maindb;

GRANT SELECT,INSERT,UPDATE ON TABLE clients.t_client TO program_service;

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE clients.t_client TO admin_service;

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE clients.t_client TO postgres;

COMMENT ON TABLE clients.t_client IS 'Таблица клиентов';

COMMENT ON COLUMN clients.t_client.id IS 'Уникальный идентификатор';

COMMENT ON COLUMN clients.t_client.c_name IS 'ФИО клиента';

COMMENT ON COLUMN clients.t_client.c_phone IS 'Номер телефона клиента';

COMMENT ON COLUMN clients.t_client.c_personal_discount IS 'Персональная скидка';

COMMENT ON COLUMN clients.t_client.c_money_spent IS 'Количество потраченных денег клиентом';

--------------------------------------------------------------------------------

ALTER TABLE clients.t_client
	ADD CONSTRAINT ch_t_client_c_money_spent_value CHECK ((c_money_spent >= (0)::numeric)) NOT VALID;

--------------------------------------------------------------------------------

ALTER TABLE clients.t_client
	ADD CONSTRAINT ch_t_client_c_personal_discount_value CHECK (((c_personal_discount >= (0)::numeric) AND (c_personal_discount <= (50)::numeric))) NOT VALID;

--------------------------------------------------------------------------------

ALTER TABLE clients.t_client
	ADD CONSTRAINT pk_t_client PRIMARY KEY (id);

--------------------------------------------------------------------------------

ALTER TABLE clients.t_client
	ADD CONSTRAINT uk_t_client_c_name_c_phone UNIQUE (c_name, c_phone);
