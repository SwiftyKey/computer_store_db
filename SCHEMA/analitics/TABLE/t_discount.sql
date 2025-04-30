CREATE TABLE analitics.t_discount (
	id integer DEFAULT nextval('analitics.t_discount_id_seq'::regclass) NOT NULL,
	c_type text DEFAULT 'Product'::text NOT NULL,
	c_id_object integer NOT NULL,
	c_discount numeric(2,2) DEFAULT 0 NOT NULL,
	c_is_active boolean DEFAULT true NOT NULL,
	c_start_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	c_end_at timestamp with time zone NOT NULL
);

ALTER TABLE analitics.t_discount OWNER TO maindb;

GRANT SELECT,INSERT,UPDATE ON TABLE analitics.t_discount TO program_service;

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE analitics.t_discount TO admin_service;

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE analitics.t_discount TO postgres;

COMMENT ON TABLE analitics.t_discount IS 'Таблица скидок на товары, их категории или модели';

COMMENT ON COLUMN analitics.t_discount.id IS 'Уникальный идентификатор';

COMMENT ON COLUMN analitics.t_discount.c_type IS 'Тип объекта';

COMMENT ON COLUMN analitics.t_discount.c_id_object IS 'Уникальный идентификатор объекта';

COMMENT ON COLUMN analitics.t_discount.c_discount IS 'Скидка на объект';

COMMENT ON COLUMN analitics.t_discount.c_is_active IS 'Активность скидки';

COMMENT ON COLUMN analitics.t_discount.c_start_at IS 'Временная метка начала скидки';

COMMENT ON COLUMN analitics.t_discount.c_end_at IS 'Временная метка окончания скидки';

--------------------------------------------------------------------------------

CREATE INDEX ix_t_discount_c_type_c_id_object ON analitics.t_discount USING btree (c_type, c_id_object);

--------------------------------------------------------------------------------

CREATE INDEX ix_t_discount_c_type_c_id_object_c_is_active ON analitics.t_discount USING btree (c_type, c_id_object, c_is_active);

--------------------------------------------------------------------------------

ALTER TABLE analitics.t_discount
	ADD CONSTRAINT ch_t_discount_c_id_object_value CHECK ((c_id_object >= 0));

--------------------------------------------------------------------------------

ALTER TABLE analitics.t_discount
	ADD CONSTRAINT ch_t_discount_c_type_value CHECK ((c_type = ANY (ARRAY['Product'::text, 'Category'::text, 'Model'::text])));

--------------------------------------------------------------------------------

ALTER TABLE analitics.t_discount
	ADD CONSTRAINT ch_t_discount_timestamps_value CHECK ((c_start_at < c_end_at));

--------------------------------------------------------------------------------

ALTER TABLE analitics.t_discount
	ADD CONSTRAINT pk_t_discount PRIMARY KEY (id);

--------------------------------------------------------------------------------

ALTER TABLE analitics.t_discount
	ADD CONSTRAINT uk_t_discount_type_id_object_discount_is_active_start_at UNIQUE (c_type, c_id_object, c_discount, c_is_active, c_start_at);
