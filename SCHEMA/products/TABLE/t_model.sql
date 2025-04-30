CREATE TABLE products.t_model (
	id integer DEFAULT nextval('products.t_model_id_seq'::regclass) NOT NULL,
	id_manufacturer integer NOT NULL,
	c_name text NOT NULL
);

ALTER TABLE products.t_model OWNER TO maindb;

GRANT SELECT,INSERT,UPDATE ON TABLE products.t_model TO program_service;

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE products.t_model TO admin_service;

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE products.t_model TO postgres;

COMMENT ON TABLE products.t_model IS 'Таблица моделей товаров';

COMMENT ON COLUMN products.t_model.id IS 'Уникальный идентификатор';

COMMENT ON COLUMN products.t_model.id_manufacturer IS 'Уникальный идентификатор производителя';

COMMENT ON COLUMN products.t_model.c_name IS 'Название модели';

--------------------------------------------------------------------------------

CREATE INDEX ix_t_model_id_manufacturer ON products.t_model USING btree (id_manufacturer);

--------------------------------------------------------------------------------

ALTER TABLE products.t_model
	ADD CONSTRAINT fk_t_model_t_manufacturer FOREIGN KEY (id_manufacturer) REFERENCES products.t_manufacturer(id);

--------------------------------------------------------------------------------

ALTER TABLE products.t_model
	ADD CONSTRAINT pk_t_model PRIMARY KEY (id);

--------------------------------------------------------------------------------

ALTER TABLE products.t_model
	ADD CONSTRAINT uk_t_model_c_name UNIQUE (c_name);
