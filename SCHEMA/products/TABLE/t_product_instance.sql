CREATE TABLE products.t_product_instance (
	id integer DEFAULT nextval('products.t_product_instance_id_seq'::regclass) NOT NULL,
	id_product integer NOT NULL,
	c_serial_number text NOT NULL
);

ALTER TABLE products.t_product_instance OWNER TO maindb;

GRANT SELECT,INSERT,UPDATE ON TABLE products.t_product_instance TO program_service;

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE products.t_product_instance TO admin_service;

COMMENT ON TABLE products.t_product_instance IS 'Таблица экземпляров товаров';

COMMENT ON COLUMN products.t_product_instance.id IS 'Уникальный идентификатор';

COMMENT ON COLUMN products.t_product_instance.id_product IS 'Уникальный идентификатор товара';

COMMENT ON COLUMN products.t_product_instance.c_serial_number IS 'Внутренний серийный номер экземпляра товара';

--------------------------------------------------------------------------------

CREATE INDEX ix_t_product_instance_id_product ON products.t_product_instance USING btree (id_product);

--------------------------------------------------------------------------------

ALTER TABLE products.t_product_instance
	ADD CONSTRAINT fk_t_product_instance_t_product FOREIGN KEY (id_product) REFERENCES products.t_product(id);

--------------------------------------------------------------------------------

ALTER TABLE products.t_product_instance
	ADD CONSTRAINT pk_t_product_instance PRIMARY KEY (id);

--------------------------------------------------------------------------------

ALTER TABLE products.t_product_instance
	ADD CONSTRAINT uk_t_product_instance_c_serial_number UNIQUE (c_serial_number);
