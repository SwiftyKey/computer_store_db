CREATE TABLE products.t_manufacturer (
	id integer DEFAULT nextval('products.t_manufacturer_id_seq'::regclass) NOT NULL,
	c_name text NOT NULL,
	c_address text NOT NULL
);

ALTER TABLE products.t_manufacturer OWNER TO maindb;

GRANT SELECT,INSERT,UPDATE ON TABLE products.t_manufacturer TO program_service;

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE products.t_manufacturer TO admin_service;

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE products.t_manufacturer TO postgres;

COMMENT ON TABLE products.t_manufacturer IS 'Таблица производителей';

COMMENT ON COLUMN products.t_manufacturer.id IS 'Уникальный идентификатор';

COMMENT ON COLUMN products.t_manufacturer.c_name IS 'Название производителя';

COMMENT ON COLUMN products.t_manufacturer.c_address IS 'Адрес производителя';

--------------------------------------------------------------------------------

ALTER TABLE products.t_manufacturer
	ADD CONSTRAINT pk_t_manufacturer PRIMARY KEY (id);

--------------------------------------------------------------------------------

ALTER TABLE products.t_manufacturer
	ADD CONSTRAINT uk_t_manufacturer_c_name UNIQUE (c_name);
