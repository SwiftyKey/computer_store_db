CREATE TABLE products.t_product_property (
	id integer DEFAULT nextval('products.t_product_property_id_seq'::regclass) NOT NULL,
	id_product integer NOT NULL,
	id_category_property integer NOT NULL,
	c_value text NOT NULL
);

ALTER TABLE products.t_product_property OWNER TO maindb;

GRANT SELECT,INSERT,UPDATE ON TABLE products.t_product_property TO program_service;

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE products.t_product_property TO admin_service;

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE products.t_product_property TO postgres;

COMMENT ON TABLE products.t_product_property IS 'Таблица свойств товара';

COMMENT ON COLUMN products.t_product_property.id IS 'Уникальный идентификатор';

COMMENT ON COLUMN products.t_product_property.id_product IS 'Уникальный идентификатор товара';

COMMENT ON COLUMN products.t_product_property.id_category_property IS 'Уникальный идентификатор свойства категории';

COMMENT ON COLUMN products.t_product_property.c_value IS 'Значение свойства';

--------------------------------------------------------------------------------

CREATE INDEX ix_t_product_property_id_category_property ON products.t_product_property USING btree (id_category_property);

--------------------------------------------------------------------------------

CREATE INDEX ix_t_product_property_id_product ON products.t_product_property USING btree (id_product);

--------------------------------------------------------------------------------

ALTER TABLE products.t_product_property
	ADD CONSTRAINT fk_t_product_property_t_category_property FOREIGN KEY (id_category_property) REFERENCES categories.t_category_property(id);

--------------------------------------------------------------------------------

ALTER TABLE products.t_product_property
	ADD CONSTRAINT fk_t_product_property_t_product FOREIGN KEY (id_product) REFERENCES products.t_product(id);

--------------------------------------------------------------------------------

ALTER TABLE products.t_product_property
	ADD CONSTRAINT pk_t_product_property PRIMARY KEY (id);

--------------------------------------------------------------------------------

ALTER TABLE products.t_product_property
	ADD CONSTRAINT uk_t_product_property_id_product_id_category_property UNIQUE (id_product, id_category_property);
