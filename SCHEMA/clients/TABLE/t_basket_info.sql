CREATE TABLE clients.t_basket_info (
	id integer DEFAULT nextval('clients.t_basket_info_id_seq'::regclass) NOT NULL,
	id_client integer NOT NULL,
	id_product integer NOT NULL,
	c_count integer DEFAULT 1 NOT NULL,
	c_batch_cost numeric(10,2) NOT NULL
);

ALTER TABLE clients.t_basket_info OWNER TO maindb;

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE clients.t_basket_info TO program_service;

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE clients.t_basket_info TO admin_service;

COMMENT ON TABLE clients.t_basket_info IS 'Таблица корзины товаров';

COMMENT ON COLUMN clients.t_basket_info.id IS 'Уникальный идентификатор';

COMMENT ON COLUMN clients.t_basket_info.id_client IS 'Уникальный идентификатор клиента';

COMMENT ON COLUMN clients.t_basket_info.id_product IS 'Уникальный идентификатор товара';

COMMENT ON COLUMN clients.t_basket_info.c_count IS 'Количество товара';

COMMENT ON COLUMN clients.t_basket_info.c_batch_cost IS 'Цена за количество товара';

--------------------------------------------------------------------------------

CREATE INDEX ix_t_basket_info_id_client ON clients.t_basket_info USING btree (id_client);

--------------------------------------------------------------------------------

CREATE INDEX ix_t_basket_info_id_product ON clients.t_basket_info USING btree (id_product);

--------------------------------------------------------------------------------

ALTER TABLE clients.t_basket_info
	ADD CONSTRAINT ch_t_basket_info_c_batch_cost CHECK ((c_batch_cost > (0)::numeric));

--------------------------------------------------------------------------------

ALTER TABLE clients.t_basket_info
	ADD CONSTRAINT ch_t_basket_info_c_count_value CHECK ((c_count >= 1));

--------------------------------------------------------------------------------

ALTER TABLE clients.t_basket_info
	ADD CONSTRAINT fk_t_basket_info_t_client FOREIGN KEY (id_client) REFERENCES clients.t_client(id);

--------------------------------------------------------------------------------

ALTER TABLE clients.t_basket_info
	ADD CONSTRAINT fk_t_basket_info_t_product FOREIGN KEY (id_product) REFERENCES products.t_product(id);

--------------------------------------------------------------------------------

ALTER TABLE clients.t_basket_info
	ADD CONSTRAINT pk_t_basket_info PRIMARY KEY (id);

--------------------------------------------------------------------------------

ALTER TABLE clients.t_basket_info
	ADD CONSTRAINT uk_t_basket_info_id_client_id_product UNIQUE (id_client, id_product);
