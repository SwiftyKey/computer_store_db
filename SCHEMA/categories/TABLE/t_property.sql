CREATE TABLE categories.t_property (
	id integer DEFAULT nextval('categories.t_property_id_seq'::regclass) NOT NULL,
	c_name text NOT NULL,
	c_type text NOT NULL,
	id_unit integer
);

ALTER TABLE categories.t_property OWNER TO maindb;

GRANT SELECT,INSERT,UPDATE ON TABLE categories.t_property TO program_service;

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE categories.t_property TO admin_service;

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE categories.t_property TO postgres;

COMMENT ON TABLE categories.t_property IS 'Таблица свойств';

COMMENT ON COLUMN categories.t_property.id IS 'Уникальный идентификатор';

COMMENT ON COLUMN categories.t_property.c_name IS 'Название свойства';

COMMENT ON COLUMN categories.t_property.c_type IS 'Тип значения свойства';

COMMENT ON COLUMN categories.t_property.id_unit IS 'Уникальный идентификатор единицы измерения';

--------------------------------------------------------------------------------

CREATE INDEX ix_t_property_id_unit ON categories.t_property USING btree (id_unit);

--------------------------------------------------------------------------------

ALTER TABLE categories.t_property
	ADD CONSTRAINT pk_t_property PRIMARY KEY (id);

--------------------------------------------------------------------------------

ALTER TABLE categories.t_property
	ADD CONSTRAINT t_property_t_unit_fk FOREIGN KEY (id_unit) REFERENCES categories.t_unit(id);

--------------------------------------------------------------------------------

ALTER TABLE categories.t_property
	ADD CONSTRAINT uk_t_property_c_name UNIQUE (c_name);
