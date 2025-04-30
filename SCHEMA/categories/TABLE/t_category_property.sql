CREATE TABLE categories.t_category_property (
	id integer DEFAULT nextval('categories.t_category_property_id_seq'::regclass) NOT NULL,
	id_category integer NOT NULL,
	id_property integer NOT NULL
);

ALTER TABLE categories.t_category_property OWNER TO maindb;

GRANT SELECT,INSERT,UPDATE ON TABLE categories.t_category_property TO program_service;

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE categories.t_category_property TO admin_service;

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE categories.t_category_property TO postgres;

COMMENT ON TABLE categories.t_category_property IS 'Таблица свойств принадлежащих категории';

COMMENT ON COLUMN categories.t_category_property.id IS 'Уникальный идентификатор';

COMMENT ON COLUMN categories.t_category_property.id_category IS 'Уникальный идентификатор категории';

COMMENT ON COLUMN categories.t_category_property.id_property IS 'Уникальный идентификатор свойства';

--------------------------------------------------------------------------------

CREATE INDEX ix_t_category_property_id_category ON categories.t_category_property USING btree (id_category);

--------------------------------------------------------------------------------

CREATE INDEX ix_t_category_property_id_property ON categories.t_category_property USING btree (id_property);

--------------------------------------------------------------------------------

ALTER TABLE categories.t_category_property
	ADD CONSTRAINT fk_t_category_property_t_category FOREIGN KEY (id_category) REFERENCES categories.t_category(id);

--------------------------------------------------------------------------------

ALTER TABLE categories.t_category_property
	ADD CONSTRAINT fk_t_category_property_t_property FOREIGN KEY (id_property) REFERENCES categories.t_property(id);

--------------------------------------------------------------------------------

ALTER TABLE categories.t_category_property
	ADD CONSTRAINT pk_t_category_property PRIMARY KEY (id);

--------------------------------------------------------------------------------

ALTER TABLE categories.t_category_property
	ADD CONSTRAINT uk_t_category_property_id_category_id_property UNIQUE (id_category, id_property);
