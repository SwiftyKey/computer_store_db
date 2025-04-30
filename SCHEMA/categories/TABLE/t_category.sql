CREATE TABLE categories.t_category (
	id integer DEFAULT nextval('categories.t_category_id_seq'::regclass) NOT NULL,
	id_parent integer,
	c_name text NOT NULL,
	c_path text NOT NULL
);

ALTER TABLE categories.t_category OWNER TO maindb;

GRANT SELECT,INSERT,UPDATE ON TABLE categories.t_category TO program_service;

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE categories.t_category TO admin_service;

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE categories.t_category TO postgres;

COMMENT ON TABLE categories.t_category IS 'Таблица категорий товаров';

COMMENT ON COLUMN categories.t_category.id IS 'Уникальный идентификатор';

COMMENT ON COLUMN categories.t_category.id_parent IS 'Уникальный идентификатор родительской категории';

COMMENT ON COLUMN categories.t_category.c_name IS 'Название категории';

COMMENT ON COLUMN categories.t_category.c_path IS 'Материализированный путь до категории';

--------------------------------------------------------------------------------

CREATE INDEX ix_t_category_id_parent ON categories.t_category USING btree (id_parent);

--------------------------------------------------------------------------------

ALTER TABLE categories.t_category
	ADD CONSTRAINT fk_t_category_t_category FOREIGN KEY (id_parent) REFERENCES categories.t_category(id) NOT VALID;

--------------------------------------------------------------------------------

ALTER TABLE categories.t_category
	ADD CONSTRAINT pk_t_category PRIMARY KEY (id);

--------------------------------------------------------------------------------

ALTER TABLE categories.t_category
	ADD CONSTRAINT uk_t_category_c_name UNIQUE (c_name);
