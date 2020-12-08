1. Выбрать название курса, его цену, преподавателя, который данный курс проводит и дату этого курса, по адресу, нижний регистр Имени которого равен заданному значению.
   (БД: Предполагаем что на столбце имен нет проверки на initcap и соответственно имя может быть написано в каком угодно регистре)
   Сортировать по ближайшей дате курса, т.е. сначала выводим ближайшие по дате курсы.

EXPLAIN ANALYZE WITH myconstants(OFFICE_NAME) AS (
	values('parnas')
)
SELECT courses.name as course, courses.price as price, to_char(classes.nextdate, �DD Mon YYYY�) as date, coaches.name as coach
FROM
	 classes
INNER JOIN courses ON courses.id = classes.courseid
INNER JOIN coaches ON courses.coachid = coaches.id
WHERE 
	classes.officeid = (SELECT offices.id FROM offices WHERE lower(offices.name) = (select OFFICE_NAME from myconstants))
ORDER BY
	 classes.nextdate asc;

Допустимые параметры [OFFICE_NAME]:

('ozerki')

('moskovskaya')

('parnas')

Необходимость:

Клиент хочет пройти курс в ближайшем к нему филиале школы и хочет узнать, когда в этом филиале будут курсы и какие.

Оптимизация:

Объединение таблиц с помощью join-ов вместо обыкновенных "склеек таблиц",

созданы индексы:

CREATE INDEX offices_lower_idx ON public.offices USING btree (lower((name)::text));
CREATE INDEX classes_nextdate_idx ON public.classes USING btree (nextdate);
CREATE INDEX courses_id_idx ON public.courses USING btree (id);
CREATE INDEX coaches_id_idx ON public.coaches USING btree (id);
CREATE INDEX classes_courseid_idx ON public.classes USING btree (courseid);
CREATE INDEX courses_coachid_idx ON public.courses USING btree (coachid);

2. Выбрать имена преподавателей, их опыт работы, названия курсов,
   у которых определенный тип курса и ведется работа с использованием определенного инструмента.

EXPLAIN ANALYZE WITH myconstants(CT, TT) AS (
	values('manikyur', 'pusher')
)

SELECT course, coaches. name AS coach, coaches.experience AS exp
FROM 
	(SELECT DISTINCT courses.name AS course, courses.price AS price, courses.id as cid
		FROM course_tool 
		INNER JOIN courses ON courses.id = course_tool.courseid
		INNER JOIN tools ON tools.id = course_tool.toolid
	WHERE 
		(courses.pathid = (SELECT id FROM paths WHERE lower(name) = (SELECT CT FROM myconstants))) 
		AND (lower(tools.type) = (SELECT TT FROM myconstants))) sorted
INNER JOIN coaches ON cid = coaches.id
ORDER BY exp;

Допустимые параметры [CT, TT]:

('manikyur', 'freza')

('manikyur', 'pusher')

('pedikyur', 'nozhnicy')

Необходимость:

Хотим научиться выполнять услугу определенного типа с использованием определенного типа инструмента, хотим узнать какие курсы есть с такими условиями,
какие преподаватели их ведут, и их опыт; или же посмотреть, каких курсов мало преподается в школе.

Оптимизация:

Не будем добавлять индекс на paths(name), так как их не предполагается много(пока 4 и может увеличиться незначительно),
а в таком случае индекс замедлит выполнение запроса.

Объединение таблиц с помощью join-ов вместо обыкновенных "склеек таблиц",

созданы следующие индексы:

CREATE INDEX tools_lower_idx ON public.tools USING btree (lower((type)::text));
CREATE INDEX courses_id_idx ON public.courses USING btree (id);
CREATE INDEX course_tool_courseid_idx ON public.course_tool USING btree (courseid);
CREATE INDEX course_tool_toolid_idx ON public.course_tool USING btree (toolid);
CREATE INDEX tools_id_idx ON public.tools USING btree (id);
CREATE INDEX coaches_experience_idx ON public.coaches USING btree (experience);

3. Выбрать список с названиями инструментов, их ценами, их типами и среднее значение цены для инструментов данного типа, необходимых на данный курс.
   (БД: Предполагаем что на столбце имен нет проверки на initcap и соответственно имя может быть написано в каком угодно регистре).

EXPLAIN ANALYZE WITH myconstants(COURSE_NAME) AS (
	values('kombinirovannyj pedikyur')
)

SELECT
	tool,
	type,
	producer,
	price,
  	avg
FROM (	SELECT 
		tools.name as tool,
		tools.id as id, 
		tools.type as type,
		producers.name as producer,
		tools.price as price,
 		avg(tools.price) OVER (PARTITION BY type) as avg
	FROM tools 
	INNER JOIN producers ON tools.producerid = producers.id )  counted_avg
INNER JOIN course_tool ON  id = course_tool.toolid
WHERE
	courseid =( SELECT id FROM courses WHERE lower(courses.name) = (select COURSE_NAME from myconstants));

Допустимые параметры [COURSE_NAME]:

('francuzskij manikyur')

('kombinirovannyj pedikyur')

('venzelya')

Необходимость:

Записались на курс и хотим узнать какие инструменты рекомендованы на курс,
но так же хотим увидеть среднюю цену за инструмент данного типа(возможно, преподаватель рекомендует слишком дорогой, а мы купим аналог подешевле).

Оптимизация:

Использование оконной функции.

Объединение таблиц с помощью join-ов вместо обыкновенных "склеек таблиц"
(также следует отметить, что подзапрос был использован только для корректной работы оконной функции),

созданы следующие индексы:

CREATE INDEX courses_lower_idx ON public.courses USING btree (lower((name)::text));
CREATE INDEX course_tool_toolid_idx ON public.course_tool USING btree (toolid);
CREATE INDEX tools_id_idx ON public.tools USING btree (id);
CREATE INDEX tools_producerid_idx ON public.tools USING btree (producerid);
CREATE INDEX producers_id_idx ON public.producers USING btree (id);