CREATE TABLE storages.t_inventory (
	id integer DEFAULT nextval('storages.t_inventory_id_seq'::regclass) NOT NULL,
	id_product_instance integer NOT NULL,
	id_supply integer NOT NULL,
	c_wholesale_price numeric(10,2) NOT NULL,
	c_condition text DEFAULT 'New'::text NOT NULL,
	c_event_type text DEFAULT 'Received'::text NOT NULL
);

ALTER TABLE storages.t_inventory OWNER TO maindb;

GRANT SELECT,INSERT,UPDATE ON TABLE storages.t_inventory TO program_service;

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE storages.t_inventory TO admin_service;

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE storages.t_inventory TO postgres;

COMMENT ON TABLE storages.t_inventory IS 'Содержимое складов';

COMMENT ON COLUMN storages.t_inventory.id IS 'Уникальный идентификатор';

COMMENT ON COLUMN storages.t_inventory.id_product_instance IS 'Уникальный идентификатор экземпляра товара';

COMMENT ON COLUMN storages.t_inventory.id_supply IS 'Уникальный идентификатор поставщика данного товара';

COMMENT ON COLUMN storages.t_inventory.c_wholesale_price IS 'Цена закупки товара за шт';

COMMENT ON COLUMN storages.t_inventory.c_condition IS 'Состояние товара';

COMMENT ON COLUMN storages.t_inventory.c_event_type IS 'Действие над товаром';

--------------------------------------------------------------------------------

CREATE INDEX ix_t_inventory_id_product_instance ON storages.t_inventory USING btree (id_product_instance);

--------------------------------------------------------------------------------

CREATE INDEX ix_t_inventory_id_supply ON storages.t_inventory USING btree (id_supply);

--------------------------------------------------------------------------------

ALTER TABLE storages.t_inventory
	ADD CONSTRAINT ch_t_inventory_c_condition_value CHECK ((c_condition = ANY (ARRAY['New'::text, 'Used'::text, 'Damaged'::text, 'Showcase'::text])));

--------------------------------------------------------------------------------

ALTER TABLE storages.t_inventory
	ADD CONSTRAINT ch_t_inventory_c_event_type_value CHECK ((c_event_type = ANY (ARRAY['Received'::text, 'Sold'::text, 'Moved'::text, 'Scrapped'::text, 'Returned'::text])));

--------------------------------------------------------------------------------

ALTER TABLE storages.t_inventory
	ADD CONSTRAINT ch_t_inventory_c_wholesale_price_value CHECK ((c_wholesale_price > (0)::numeric)) NOT VALID;

--------------------------------------------------------------------------------

ALTER TABLE storages.t_inventory
	ADD CONSTRAINT fk_t_inventory_t_product_instance FOREIGN KEY (id_product_instance) REFERENCES products.t_product_instance(id);

--------------------------------------------------------------------------------

ALTER TABLE storages.t_inventory
	ADD CONSTRAINT fk_t_inventory_t_supply FOREIGN KEY (id_supply) REFERENCES storages.t_supply(id);

--------------------------------------------------------------------------------

ALTER TABLE storages.t_inventory
	ADD CONSTRAINT pk_t_inventory PRIMARY KEY (id);

--------------------------------------------------------------------------------

ALTER TABLE storages.t_inventory
	ADD CONSTRAINT uk_t_inventory_id_product_instance_id_supply UNIQUE (id_product_instance, id_supply);
