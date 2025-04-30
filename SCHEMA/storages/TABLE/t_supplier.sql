CREATE TABLE storages.t_supplier (
	id integer DEFAULT nextval('storages.t_supplier_id_seq'::regclass) NOT NULL,
	c_name text NOT NULL,
	c_address text NOT NULL,
	c_phone text NOT NULL
);

ALTER TABLE storages.t_supplier OWNER TO maindb;

GRANT SELECT,INSERT,UPDATE ON TABLE storages.t_supplier TO program_service;

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE storages.t_supplier TO admin_service;

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE storages.t_supplier TO postgres;

COMMENT ON TABLE storages.t_supplier IS 'Таблица поставщиков';

COMMENT ON COLUMN storages.t_supplier.id IS 'Уникальный идентификатор';

COMMENT ON COLUMN storages.t_supplier.c_name IS 'Название поставщика';

COMMENT ON COLUMN storages.t_supplier.c_address IS 'Адрес поставщика';

COMMENT ON COLUMN storages.t_supplier.c_phone IS 'Телефон поставщика';

--------------------------------------------------------------------------------

ALTER TABLE storages.t_supplier
	ADD CONSTRAINT pk_t_supplier PRIMARY KEY (id);

--------------------------------------------------------------------------------

ALTER TABLE storages.t_supplier
	ADD CONSTRAINT uk_t_supplier_c_name UNIQUE (c_name);
