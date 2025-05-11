CREATE TABLE orders.t_order (
	id integer DEFAULT nextval('orders.t_order_id_seq'::regclass) NOT NULL,
	id_client integer NOT NULL,
	id_status integer NOT NULL,
	c_total_price numeric(10,2),
	c_placement_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	c_exec_at timestamp with time zone,
	c_address text NOT NULL
);

ALTER TABLE orders.t_order OWNER TO maindb;

GRANT SELECT,INSERT,UPDATE ON TABLE orders.t_order TO program_service;

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE orders.t_order TO admin_service;

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE orders.t_order TO postgres;

COMMENT ON TABLE orders.t_order IS 'Таблица заказов';

COMMENT ON COLUMN orders.t_order.id IS 'Уникальный идентификатор';

COMMENT ON COLUMN orders.t_order.id_client IS 'Уникальный идентификатор клиента';

COMMENT ON COLUMN orders.t_order.id_status IS 'Уникальный идентификатор статуса заказа';

COMMENT ON COLUMN orders.t_order.c_total_price IS 'Цена за весь состав заказа';

COMMENT ON COLUMN orders.t_order.c_placement_at IS 'Дата и время оформления заказа';

COMMENT ON COLUMN orders.t_order.c_exec_at IS 'Дата и время выполнения заказа';

COMMENT ON COLUMN orders.t_order.c_address IS 'Адрес доставки заказа';

--------------------------------------------------------------------------------

CREATE INDEX ix_t_order_id_client ON orders.t_order USING btree (id_client);

--------------------------------------------------------------------------------

CREATE INDEX ix_t_order_id_status ON orders.t_order USING btree (id_status);

--------------------------------------------------------------------------------

ALTER TABLE orders.t_order
	ADD CONSTRAINT ch_t_order_c_total_price_value CHECK (((c_total_price IS NULL) OR (c_total_price > (0)::numeric)));

--------------------------------------------------------------------------------

ALTER TABLE orders.t_order
	ADD CONSTRAINT ch_t_order_timestamps_value CHECK (((c_exec_at IS NULL) OR ((c_exec_at IS NOT NULL) AND (c_placement_at < c_exec_at))));

--------------------------------------------------------------------------------

ALTER TABLE orders.t_order
	ADD CONSTRAINT fk_t_order_t_client FOREIGN KEY (id_client) REFERENCES clients.t_client(id);

--------------------------------------------------------------------------------

ALTER TABLE orders.t_order
	ADD CONSTRAINT fk_t_order_t_order_status FOREIGN KEY (id_status) REFERENCES orders.t_order_status(id);

--------------------------------------------------------------------------------

ALTER TABLE orders.t_order
	ADD CONSTRAINT pk_t_order PRIMARY KEY (id);

--------------------------------------------------------------------------------

ALTER TABLE orders.t_order
	ADD CONSTRAINT uk_t_order_id_client_c_placement_at UNIQUE (id_client, c_placement_at);
