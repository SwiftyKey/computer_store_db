CREATE TABLE products.t_product (
	id integer DEFAULT nextval('products.t_product_id_seq'::regclass) NOT NULL,
	id_model integer NOT NULL,
	c_name text NOT NULL,
	c_description text,
	c_warranty_period integer DEFAULT 1 NOT NULL,
	c_length double precision NOT NULL,
	c_width double precision NOT NULL,
	c_height double precision NOT NULL,
	c_weight double precision NOT NULL,
	c_price numeric(10,2) NOT NULL,
	c_sku text NOT NULL,
	c_gtin text NOT NULL
);

ALTER TABLE products.t_product OWNER TO maindb;

GRANT SELECT,INSERT,UPDATE ON TABLE products.t_product TO program_service;

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE products.t_product TO admin_service;

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE products.t_product TO postgres;

COMMENT ON TABLE products.t_product IS 'Таблица товаров';

COMMENT ON COLUMN products.t_product.id IS 'Уникальный идентификатор';

COMMENT ON COLUMN products.t_product.id_model IS 'Уникальный идентификатор модели';

COMMENT ON COLUMN products.t_product.c_name IS 'Название товара';

COMMENT ON COLUMN products.t_product.c_description IS 'Описание товара';

COMMENT ON COLUMN products.t_product.c_warranty_period IS 'Гарантийный период товара';

COMMENT ON COLUMN products.t_product.c_length IS 'Длина (мм)';

COMMENT ON COLUMN products.t_product.c_width IS 'Ширина (мм)';

COMMENT ON COLUMN products.t_product.c_height IS 'Высота (мм)';

COMMENT ON COLUMN products.t_product.c_weight IS 'Вес (кг)';

COMMENT ON COLUMN products.t_product.c_price IS 'Цена (руб)';

COMMENT ON COLUMN products.t_product.c_sku IS 'Код производителя';

COMMENT ON COLUMN products.t_product.c_gtin IS 'Глобальный номер товарной продукции';

--------------------------------------------------------------------------------

CREATE INDEX ix_t_product_c_name ON products.t_product USING btree (c_name);

--------------------------------------------------------------------------------

CREATE INDEX ix_t_product_id_model ON products.t_product USING btree (id_model);

--------------------------------------------------------------------------------

ALTER TABLE products.t_product
	ADD CONSTRAINT ch_t_product_c_gtin_length CHECK (((length(c_gtin) >= 8) AND (length(c_gtin) <= 14)));

--------------------------------------------------------------------------------

ALTER TABLE products.t_product
	ADD CONSTRAINT ch_t_product_c_height_value CHECK ((c_height > (0)::double precision));

--------------------------------------------------------------------------------

ALTER TABLE products.t_product
	ADD CONSTRAINT ch_t_product_c_length_value CHECK ((c_length > (0)::double precision));

--------------------------------------------------------------------------------

ALTER TABLE products.t_product
	ADD CONSTRAINT ch_t_product_c_price_value CHECK ((c_price > (0)::numeric));

--------------------------------------------------------------------------------

ALTER TABLE products.t_product
	ADD CONSTRAINT ch_t_product_c_sku_length CHECK (((length(c_sku) >= 4) AND (length(c_sku) <= 15)));

--------------------------------------------------------------------------------

ALTER TABLE products.t_product
	ADD CONSTRAINT ch_t_product_c_warranty_period_value CHECK ((c_warranty_period = ANY (ARRAY[1, 2, 3, 4])));

--------------------------------------------------------------------------------

ALTER TABLE products.t_product
	ADD CONSTRAINT ch_t_product_c_weight_value CHECK ((c_weight > (0)::double precision));

--------------------------------------------------------------------------------

ALTER TABLE products.t_product
	ADD CONSTRAINT ch_t_product_c_width_value CHECK ((c_width > (0)::double precision));

--------------------------------------------------------------------------------

ALTER TABLE products.t_product
	ADD CONSTRAINT fk_t_product_t_model FOREIGN KEY (id_model) REFERENCES products.t_model(id);

--------------------------------------------------------------------------------

ALTER TABLE products.t_product
	ADD CONSTRAINT pk_t_product PRIMARY KEY (id);

--------------------------------------------------------------------------------

ALTER TABLE products.t_product
	ADD CONSTRAINT uk_t_product_c_gtin UNIQUE (c_gtin);

--------------------------------------------------------------------------------

ALTER TABLE products.t_product
	ADD CONSTRAINT uk_t_product_c_sku UNIQUE (c_sku);
