CREATE TABLE storages.t_storage (
	id integer DEFAULT nextval('storages.t_storage_id_seq'::regclass) NOT NULL,
	c_name text NOT NULL,
	c_address text NOT NULL
);

ALTER TABLE storages.t_storage OWNER TO maindb;

GRANT SELECT,INSERT,UPDATE ON TABLE storages.t_storage TO program_service;

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE storages.t_storage TO admin_service;

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE storages.t_storage TO postgres;

COMMENT ON TABLE storages.t_storage IS 'Таблица складов';

COMMENT ON COLUMN storages.t_storage.id IS 'Уникальный идентификатор';

COMMENT ON COLUMN storages.t_storage.c_name IS 'Название склада';

COMMENT ON COLUMN storages.t_storage.c_address IS 'Адрес склада';

--------------------------------------------------------------------------------

ALTER TABLE storages.t_storage
	ADD CONSTRAINT pk_t_storage PRIMARY KEY (id);

--------------------------------------------------------------------------------

ALTER TABLE storages.t_storage
	ADD CONSTRAINT uk_t_storage_c_name UNIQUE (c_name);
