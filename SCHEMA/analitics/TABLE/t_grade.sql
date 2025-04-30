CREATE TABLE analitics.t_grade (
	id integer DEFAULT nextval('analitics.t_grade_id_seq'::regclass) NOT NULL,
	c_type text DEFAULT 'Product'::text NOT NULL,
	c_id_object integer NOT NULL,
	c_cur_grade double precision DEFAULT 0 NOT NULL,
	c_cur_grades_count integer DEFAULT 0 NOT NULL,
	c_grade_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);

ALTER TABLE analitics.t_grade OWNER TO maindb;

GRANT SELECT,INSERT,UPDATE ON TABLE analitics.t_grade TO program_service;

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE analitics.t_grade TO admin_service;

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE analitics.t_grade TO postgres;

COMMENT ON TABLE analitics.t_grade IS 'Таблица оценок товаров, категорий или моделей';

COMMENT ON COLUMN analitics.t_grade.id IS 'Уникальный идентификатор';

COMMENT ON COLUMN analitics.t_grade.c_type IS 'Объект оценки';

COMMENT ON COLUMN analitics.t_grade.c_id_object IS 'Уникальный идентификатор объекта';

COMMENT ON COLUMN analitics.t_grade.c_cur_grade IS 'Текущая оценка';

COMMENT ON COLUMN analitics.t_grade.c_cur_grades_count IS 'Текущее количество оценок';

COMMENT ON COLUMN analitics.t_grade.c_grade_at IS 'Временная метка оценки';

--------------------------------------------------------------------------------

CREATE INDEX ix_t_grade_c_type_c_id_object ON analitics.t_grade USING btree (c_type, c_id_object);

--------------------------------------------------------------------------------

ALTER TABLE analitics.t_grade
	ADD CONSTRAINT ch_t_grade_c_cur_grade_value CHECK (((c_cur_grade >= (1)::double precision) AND (c_cur_grade <= (5)::double precision)));

--------------------------------------------------------------------------------

ALTER TABLE analitics.t_grade
	ADD CONSTRAINT ch_t_grade_c_cur_grades_count_value CHECK ((c_cur_grades_count >= 0));

--------------------------------------------------------------------------------

ALTER TABLE analitics.t_grade
	ADD CONSTRAINT ch_t_grade_c_id_object_value CHECK ((c_id_object >= 0));

--------------------------------------------------------------------------------

ALTER TABLE analitics.t_grade
	ADD CONSTRAINT ch_t_grade_c_type_value CHECK ((c_type = ANY (ARRAY['Product'::text, 'Category'::text, 'Model'::text])));

--------------------------------------------------------------------------------

ALTER TABLE analitics.t_grade
	ADD CONSTRAINT pk_t_grade PRIMARY KEY (id);

--------------------------------------------------------------------------------

ALTER TABLE analitics.t_grade
	ADD CONSTRAINT uk_t_grade_c_type_c_id_object_c_grade_at UNIQUE (c_type, c_id_object, c_grade_at);
