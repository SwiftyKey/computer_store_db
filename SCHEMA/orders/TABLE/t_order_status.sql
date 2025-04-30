CREATE TABLE orders.t_order_status (
	id integer DEFAULT nextval('orders.t_order_status_id_seq'::regclass) NOT NULL,
	id_next integer,
	c_name text NOT NULL
);

ALTER TABLE orders.t_order_status OWNER TO maindb;

GRANT SELECT,INSERT,UPDATE ON TABLE orders.t_order_status TO program_service;

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE orders.t_order_status TO admin_service;

COMMENT ON TABLE orders.t_order_status IS 'Таблица статусов заказа';

COMMENT ON COLUMN orders.t_order_status.id IS 'Уникальный идентификатор';

COMMENT ON COLUMN orders.t_order_status.id_next IS 'Уникальный идентификатор следующего статуса';

COMMENT ON COLUMN orders.t_order_status.c_name IS 'Название статуса';

--------------------------------------------------------------------------------

CREATE INDEX ix_t_order_status_id_next ON orders.t_order_status USING btree (id_next);

--------------------------------------------------------------------------------

ALTER TABLE orders.t_order_status
	ADD CONSTRAINT fk_t_order_status FOREIGN KEY (id_next) REFERENCES orders.t_order_status(id);

--------------------------------------------------------------------------------

ALTER TABLE orders.t_order_status
	ADD CONSTRAINT pk_t_order_status PRIMARY KEY (id);

--------------------------------------------------------------------------------

ALTER TABLE orders.t_order_status
	ADD CONSTRAINT uk_t_order_status_c_name UNIQUE (c_name);
