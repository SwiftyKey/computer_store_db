CREATE TABLE orders.t_order_info (
	id integer DEFAULT nextval('orders.t_order_info_id_seq'::regclass) NOT NULL,
	id_order integer NOT NULL,
	id_product_instance integer NOT NULL,
	c_cost numeric(10,2) NOT NULL,
	c_grade integer
);

ALTER TABLE orders.t_order_info OWNER TO maindb;

GRANT SELECT,INSERT,UPDATE ON TABLE orders.t_order_info TO program_service;

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE orders.t_order_info TO admin_service;

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE orders.t_order_info TO postgres;

COMMENT ON TABLE orders.t_order_info IS 'Таблица состава заказов';

COMMENT ON COLUMN orders.t_order_info.id IS 'Уникальный идентификатор';

COMMENT ON COLUMN orders.t_order_info.id_order IS 'Уникальный идентификатор заказа';

COMMENT ON COLUMN orders.t_order_info.id_product_instance IS 'Уникальный идентификатор товара';

COMMENT ON COLUMN orders.t_order_info.c_cost IS 'Цена за заказанное количество товара';

COMMENT ON COLUMN orders.t_order_info.c_grade IS 'Оценка заказанного товара';

--------------------------------------------------------------------------------

CREATE INDEX ix_t_order_info_id_order ON orders.t_order_info USING btree (id_order);

--------------------------------------------------------------------------------

CREATE INDEX ix_t_order_info_id_product_instance ON orders.t_order_info USING btree (id_product_instance);

--------------------------------------------------------------------------------

ALTER TABLE orders.t_order_info
	ADD CONSTRAINT ch_t_order_info_c_cost_value CHECK ((c_cost > (0)::numeric));

--------------------------------------------------------------------------------

ALTER TABLE orders.t_order_info
	ADD CONSTRAINT ch_t_order_info_c_grade_value CHECK (((c_grade >= 1) AND (c_grade <= 5)));

--------------------------------------------------------------------------------

ALTER TABLE orders.t_order_info
	ADD CONSTRAINT fk_t_order_info_t_order FOREIGN KEY (id_order) REFERENCES orders.t_order(id);

--------------------------------------------------------------------------------

ALTER TABLE orders.t_order_info
	ADD CONSTRAINT fk_t_order_info_t_product_instance FOREIGN KEY (id_product_instance) REFERENCES products.t_product_instance(id);

--------------------------------------------------------------------------------

ALTER TABLE orders.t_order_info
	ADD CONSTRAINT pk_t_info PRIMARY KEY (id);

--------------------------------------------------------------------------------

ALTER TABLE orders.t_order_info
	ADD CONSTRAINT uk_t_order_info_id_order_id_product_instance UNIQUE (id_order, id_product_instance);
