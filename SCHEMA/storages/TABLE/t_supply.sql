CREATE TABLE storages.t_supply (
	id integer DEFAULT nextval('storages.t_shipment_id_seq'::regclass) NOT NULL,
	id_supplier integer NOT NULL,
	id_storage integer NOT NULL,
	id_status integer NOT NULL,
	c_dispatch_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	c_receipt_at timestamp with time zone,
	c_total_cost numeric(10,2) DEFAULT 0 NOT NULL
);

ALTER TABLE storages.t_supply OWNER TO maindb;

GRANT SELECT,INSERT,UPDATE ON TABLE storages.t_supply TO program_service;

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE storages.t_supply TO admin_service;

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE storages.t_supply TO postgres;

COMMENT ON TABLE storages.t_supply IS 'Таблица поставок на склады';

COMMENT ON COLUMN storages.t_supply.id IS 'Уникальный идентификатор';

COMMENT ON COLUMN storages.t_supply.id_supplier IS 'Уникальный идентификатор поставщика';

COMMENT ON COLUMN storages.t_supply.id_storage IS 'Уникальный идентификатор склада';

COMMENT ON COLUMN storages.t_supply.id_status IS 'Уникальный идентификатор статуса поставки';

COMMENT ON COLUMN storages.t_supply.c_dispatch_at IS 'Дата и время отправки';

COMMENT ON COLUMN storages.t_supply.c_receipt_at IS 'Дата и время получения';

COMMENT ON COLUMN storages.t_supply.c_total_cost IS 'Цена за количество данного товара';

--------------------------------------------------------------------------------

CREATE INDEX ix_t_shipment_id_storage ON storages.t_supply USING btree (id_storage);

--------------------------------------------------------------------------------

CREATE INDEX ix_t_shipment_id_supplier ON storages.t_supply USING btree (id_supplier);

--------------------------------------------------------------------------------

CREATE INDEX ix_t_supply_id_status ON storages.t_supply USING btree (id_status);

--------------------------------------------------------------------------------

ALTER TABLE storages.t_supply
	ADD CONSTRAINT ch_t_shipment_c_timestamps_value CHECK (((c_receipt_at IS NULL) OR ((c_receipt_at IS NOT NULL) AND (c_dispatch_at < c_receipt_at))));

--------------------------------------------------------------------------------

ALTER TABLE storages.t_supply
	ADD CONSTRAINT ch_t_shipment_c_total_cost_value CHECK ((c_total_cost > (0)::numeric));

--------------------------------------------------------------------------------

ALTER TABLE storages.t_supply
	ADD CONSTRAINT fk_t_shipment_t_storage FOREIGN KEY (id_storage) REFERENCES storages.t_storage(id);

--------------------------------------------------------------------------------

ALTER TABLE storages.t_supply
	ADD CONSTRAINT fk_t_shipment_t_supplier FOREIGN KEY (id_supplier) REFERENCES storages.t_supplier(id);

--------------------------------------------------------------------------------

ALTER TABLE storages.t_supply
	ADD CONSTRAINT fk_t_supply_t_supply_status FOREIGN KEY (id_status) REFERENCES storages.t_supply_status(id);

--------------------------------------------------------------------------------

ALTER TABLE storages.t_supply
	ADD CONSTRAINT pk_t_shipment PRIMARY KEY (id);

--------------------------------------------------------------------------------

ALTER TABLE storages.t_supply
	ADD CONSTRAINT uk_t_supply_id_supplier_id_storage_c_dispatch_at UNIQUE (id_supplier, id_storage, c_dispatch_at);
