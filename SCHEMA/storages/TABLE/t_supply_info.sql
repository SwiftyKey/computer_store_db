CREATE TABLE storages.t_supply_info (
	id integer DEFAULT nextval('storages.t_supply_info_id_seq'::regclass) NOT NULL,
	id_product integer NOT NULL,
	id_supply integer,
	c_count integer DEFAULT 1 NOT NULL,
	c_batch_cost numeric(10,2) NOT NULL
);

ALTER TABLE storages.t_supply_info OWNER TO maindb;

GRANT SELECT,INSERT,UPDATE ON TABLE storages.t_supply_info TO program_service;

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE storages.t_supply_info TO admin_service;

COMMENT ON TABLE storages.t_supply_info IS 'Таблица состава поставки';

COMMENT ON COLUMN storages.t_supply_info.id IS 'Уникальный идентификатор';

COMMENT ON COLUMN storages.t_supply_info.id_product IS 'Уникальный идентификатор товара';

COMMENT ON COLUMN storages.t_supply_info.id_supply IS 'Уникальный идентификатор поставки';

COMMENT ON COLUMN storages.t_supply_info.c_count IS 'Количество товара';

COMMENT ON COLUMN storages.t_supply_info.c_batch_cost IS 'Цена за количество';

--------------------------------------------------------------------------------

CREATE INDEX ix_t_supply_info_id_product ON storages.t_supply_info USING btree (id_product);

--------------------------------------------------------------------------------

CREATE INDEX ix_t_supply_info_id_supply ON storages.t_supply_info USING btree (id_supply);

--------------------------------------------------------------------------------

ALTER TABLE storages.t_supply_info
	ADD CONSTRAINT ch_t_supply_info_c_batch_cost_value CHECK ((c_batch_cost > (0)::numeric));

--------------------------------------------------------------------------------

ALTER TABLE storages.t_supply_info
	ADD CONSTRAINT ch_t_supply_info_c_count_value CHECK ((c_count >= 1));

--------------------------------------------------------------------------------

ALTER TABLE storages.t_supply_info
	ADD CONSTRAINT fk_t_supply_info_t_product FOREIGN KEY (id_product) REFERENCES products.t_product(id);

--------------------------------------------------------------------------------

ALTER TABLE storages.t_supply_info
	ADD CONSTRAINT fk_t_supply_info_t_supply FOREIGN KEY (id_supply) REFERENCES storages.t_supply(id);

--------------------------------------------------------------------------------

ALTER TABLE storages.t_supply_info
	ADD CONSTRAINT pk_t_supply_info PRIMARY KEY (id);

--------------------------------------------------------------------------------

ALTER TABLE storages.t_supply_info
	ADD CONSTRAINT uk_t_supply_info_id_supply_id_product UNIQUE (id_supply, id_product);
