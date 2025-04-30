CREATE TABLE storages.t_supply_status (
	id integer DEFAULT nextval('storages.t_supply_status_id_seq'::regclass) NOT NULL,
	id_next integer,
	c_name text NOT NULL
);

ALTER TABLE storages.t_supply_status OWNER TO maindb;

GRANT SELECT,INSERT,UPDATE ON TABLE storages.t_supply_status TO program_service;

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE storages.t_supply_status TO admin_service;

COMMENT ON TABLE storages.t_supply_status IS 'Таблица статусов поставок на склад';

COMMENT ON COLUMN storages.t_supply_status.id IS 'Уникальный идентификатор';

COMMENT ON COLUMN storages.t_supply_status.id_next IS 'Уникальный идентификатор следующего статуса';

COMMENT ON COLUMN storages.t_supply_status.c_name IS 'Название статуса';

--------------------------------------------------------------------------------

CREATE INDEX ix_t_supply_status_id_next ON storages.t_supply_status USING btree (id_next);

--------------------------------------------------------------------------------

ALTER TABLE storages.t_supply_status
	ADD CONSTRAINT fk_t_supply_status FOREIGN KEY (id_next) REFERENCES storages.t_supply_status(id);

--------------------------------------------------------------------------------

ALTER TABLE storages.t_supply_status
	ADD CONSTRAINT pk_t_supply_status PRIMARY KEY (id);

--------------------------------------------------------------------------------

ALTER TABLE storages.t_supply_status
	ADD CONSTRAINT uk_t_supply_status_c_name UNIQUE (c_name);
