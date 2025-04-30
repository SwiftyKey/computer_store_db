CREATE TABLE categories.t_unit (
	id integer DEFAULT nextval('categories.t_unit_id_seq'::regclass) NOT NULL,
	c_unit text NOT NULL
);

ALTER TABLE categories.t_unit OWNER TO maindb;

GRANT SELECT,INSERT,UPDATE ON TABLE categories.t_unit TO program_service;

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE categories.t_unit TO admin_service;

COMMENT ON TABLE categories.t_unit IS 'Таблица единиц измерения';

COMMENT ON COLUMN categories.t_unit.id IS 'Уникальный идентификатор';

COMMENT ON COLUMN categories.t_unit.c_unit IS 'Единица измерения';

--------------------------------------------------------------------------------

ALTER TABLE categories.t_unit
	ADD CONSTRAINT pk_t_unit PRIMARY KEY (id);

--------------------------------------------------------------------------------

ALTER TABLE categories.t_unit
	ADD CONSTRAINT uk_t_unit_c_unit UNIQUE (c_unit);
