1. Выбрать название наилучших* курсов для прохождения, их полные цены, суммарные цены на все инструменты к курсу, ближайшие даты курса,
   день недели, в который курсы начнутся.

   * Выбираем 5 наилучших курсов по следующему правилу: находим стоимость одного дня курса(условно) делением полной цены курса на количество дней,
   которые курс идет, находим условную "стоимость одной отработки на курсе" делением делением полной цены курса на количество отработок
   ( НО: так как есть курсы без отработки, то мы проверяем условие деления на ноль, и чтобы не портить статистику, в таких случаях умножаем цену отработки на 2),
   суммируем эти стоимости и выбираем 5 наилучших стоимостей, где условные затраты на день курса минимальны.

   Так как один и тот же курс может идти несколько раз в разное время, то сначала из каждого курса выбираем занятие по данному курсу с ближайшей датой, ее как раз и выводим и еще выводим, какому дню недели она соответствует.

   В запросе используются:

   Конкатенация строк для красивого отображения денежной суммы,
   приведение даты к красивому виду,
   вывод дня недели в красивом виде,
   вывод цен с двумя знаками после запятой для красоты,
   оператор выбора CASE,
   преобразование интервала к double с помощью EXTRACT для возможности поделить на интервал(на количество дней)

SELECT course, 
CONCAT(fprice::text, ' rub') AS fprice,
CONCAT(tprice::text, ' rub') AS tprice,
to_char(date, 'DD Mon YYYY') AS date,
day 
FROM(SELECT DISTINCT ON (courses.name)
		courses.name AS course,
		courses.price AS fprice,
		courses.price/EXTRACT(DAY FROM courses.duration) AS dprice,

		(CASE WHEN skilltraining = 0 THEN 2 * courses.price 
           	 ELSE (courses.price/skilltraining)::numeric(10,2)
       		 END) AS mprice,

		classes.nextdate AS date,
		to_char(classes.nextdate, 'dy') AS day,

		(CASE WHEN skilltraining = 0 THEN 2*courses.price 
           	 ELSE (courses.price/skilltraining)::numeric(10,2)
       		 END) + courses.price/EXTRACT(DAY FROM courses.duration)AS pdprice,

 		sum(tools.price) OVER(PARTITION BY course_tool.courseid) AS tprice

            FROM course_tool
	    INNER JOIN tools ON tools.id = course_tool.toolid
	    INNER JOIN courses ON courses.id = course_tool.courseid
            INNER JOIN classes ON courses.id = classes.courseid
            ORDER BY courses.name, date) main
ORDER BY pdprice
LIMIT 5;

Необходимость:

Клиенту нужно потратить свои средства на обучение наиболее эффективно, и как можно быстрее пройти обучение. Предлагаем 5 оптимальных на данный момент курсов.
(Например, понятно, что однодневный курс без отработки за 8000 рублей менее эффективен, чем трехдневный с 5 отработками за 15000 рублей)

Оптимизация:

Объединение таблиц с помощью join-ов вместо обыкновенных "склеек таблиц",

созданы индексы:

CREATE INDEX ON courses(name);
CREATE INDEX ON courses(price);
CREATE INDEX ON courses(duration);
CREATE INDEX ON courses(skilltraining);
CREATE INDEX ON classes(nextdate);
CREATE INDEX ON tools(price);
CREATE INDEX ON course_tool(courseid);
CREATE INDEX ON tools(id);
CREATE INDEX ON course_tool(toolid);
CREATE INDEX ON course_tool(courseid);
CREATE INDEX ON courses(id);
CREATE INDEX ON classes(courseid);
CREATE INDEX ON courses(name);

2. Вывести имя преподавателя, на курсах какого типа специализируется данный преподаватель больше,
   среднюю цену курсов у данного преподавателя, среднюю продолжительность курсов у данного преподавателя,
   процентный вклад преподавателя в общую прибыль за данный период(mopr) и в проведенные курсы(copr).
   Также последний столбец показывает на то, нужно ли назначать премию преподавателю за данный период.(Назначается, если вклад в прибыль больше 15%)

   В запросе используются:

   Конкатенация строк для красивого отображения денежной суммы и процентов,
   приведение к процентному виду,
   вывод цен с двумя знаками после запятой для красоты,
   оператор выбора CASE,
   преобразование интервала к double с помощью EXTRACT для возможности посчитать среднюю продолжительность,
   вывод в отдельный столбец назначени премии

WITH myco(SD, FD) AS (
	values('20.11.2019'::date, '20.12.2019'::date)
)

SELECT 
	coaches.name AS coach,
	paths.name AS poppath,
	avgdur,
	avgprice,
	CONCAT(mo, '%') AS mopr,
	CONCAT(co, '%')AS copr,
	(CASE WHEN mo >=15 THEN 'Premy' ELSE ('--') END) AS ach
FROM(
	SELECT 
		p,
		co,
		avgdur, 
		avgprice, 
		mo,
		a.coid AS c
	FROM(
		SELECT DISTINCT ON(1)
			t.coachid as coid,
			t.total as t,
			t.pathid as p
		FROM(
			SELECT 
				COUNT(*) AS total, 
				coachid,
				pathid FROM courses GROUP BY coachid,
				pathid
			ORDER BY total DESC
		    )t
	    )a
INNER JOIN(
SELECT
	coid,
	((coc::numeric/allc::numeric)*100)::numeric(10,2) AS co,
	((com::numeric/allm::numeric)*100)::numeric(10,2) AS mo,
	avgdur,
	avgprice
FROM(
	SELECT
		COUNT(classes.id) AS allc 
	FROM classes 
	WHERE classes.nextdate>(SELECT SD FROM myco) AND classes.nextdate<(SELECT FD FROM myco)) AS foo1
CROSS JOIN(
	SELECT 
		SUM(courses.price) AS allm 
	FROM courses
	INNER JOIN classes ON classes.courseid = courses.id
	WHERE classes.nextdate>(SELECT SD FROM myco) AND classes.nextdate<(SELECT FD FROM myco)) AS foo3
CROSS JOIN(
	SELECT DISTINCT ON (courses.coachid)
		COUNT(classes.id) OVER(PARTITION BY courses.coachid) AS coc,
		SUM(courses.price) OVER(PARTITION BY courses.coachid) as com,
		CONCAT((AVG(EXTRACT(DAY FROM courses.duration)) OVER(PARTITION BY courses.coachid)),' days') AS avgdur,
		CONCAT((AVG(courses.price) OVER(PARTITION BY courses.coachid))::numeric(10,2),' rub') AS avgprice,
		courses.coachid AS coid
	FROM classes
	INNER JOIN courses ON classes.courseid = courses.id
	WHERE classes.nextdate>(SELECT SD FROM myco) AND classes.nextdate<(SELECT FD FROM myco)
	  )foo2
	  )b ON a.coid = b.coid
    )last
INNER JOIN
coaches ON coaches.id = c
INNER JOIN
paths ON paths.id = p
ORDER BY mo DESC;

Допустимые параметры [SD, FD]:

('20.11.2018', '20.11.2019')

('20.11.2018', '20.12.2019')

Необходимость:

Статистика для оценивания качества работы преподавателей и назначения премии

Оптимизация:

Объединение таблиц с помощью join-ов вместо обыкновенных "склеек таблиц",

использование оконных функций,

индексы на поля таблицы path не были созданы, так как там мало данных и их значительное расширение не планируется,

созданы индексы:

CREATE INDEX ON coaches(name);
CREATE INDEX ON coaches(id);
CREATE INDEX ON classes(nextdate);
CREATE INDEX ON classes(courseid);
CREATE INDEX ON courses(id);
CREATE INDEX ON coaches(id);
CREATE INDEX ON courses(name);
CREATE INDEX ON courses(duration);
CREATE INDEX ON classes(id);
CREATE INDEX ON courses(coachid);
CREATE INDEX ON courses(price);



