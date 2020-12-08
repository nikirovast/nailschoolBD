1. Выбрать Название офиса(они называются по ближайшей станции метро), Телефон и Точный адрес офиса, нижний регистр Имени которого равен заданному значению.
  (БД: Предполагаем что на столбце имен нет проверки на initcap и соответственно имя может быть написано в каком угодно регистре)

WITH myconstants(OFFICE_NAME) AS (
	values(__OFFICENAME__)
)
SELECT o.name as name, o.phone as phone, o.location as location 
FROM 
	offices AS o 
WHERE 
	lower(o.name) = (select OFFICE_NAME from myconstants);

Допустимые параметры [__OFFICENAME__]:

('ozerki')

('moskovskaya')

('parnas')

Необходимость:

Поиск адреса и телефона офиса по его названию(ближайшей станции метро)


2. Выбрать Имя преподавателя, его опыт преподавания. Отсортировать по убыванию опыта. Вывести первые __EXPERIENCE__ результатов.

WITH myconstants(EXPERIENCE) AS (
	values(3)
)
SELECT c.name AS name, c.experience AS experience
FROM
	coaches AS c
ORDER BY
	c.experience DESC NULLS LAST
LIMIT (select EXPERIENCE from myconstants);

Допустимые параметры [__EXPERIENCE__]:

(1)

(6)

(3)

Необходимость:

Хотим отметить несколько самых опытных преподавателей на сайте или на стенде с преподавателями звездочками или нам нужно сделать какую-то статистику.

3. Выбрать Название инструмента, Тип инструмента и Цену, нижний регистр типа которых или 'kusachki' или 'nozhnicy', а также цена меньше заданного значения.
   Сортировать по возрастанию цены.
   (БД: Предполагаем что на столбце имен нет проверки на initcap и соответственно тип может быть написано в каком угодно регистре)

WITH myconstants(PRICE) AS (
	values(__PRICE__)
)
SELECT t.name AS name, t.price AS price, t.type AS type
FROM 
	tools AS t
WHERE 
	(lower(type) = 'kusachki' OR lower(type) = 'nozhnicy') AND price < (select PRICE from myconstants)
ORDER BY 	
	price;

Допустимые параметры [__PRICE__]:

(1500)

(300)

(180)

Необходимость:

Хотим выбрать режущий инструмент(ножницы или кусачки) на ту сумму, которую имеем.

4. Выбрать Название курса, Длительность, Количество отработок на модели, Цену,
   у которого длительность не превосходит заданного параметра и с отработкой на модели.
   Вывести с сортировкой, сначала по цене(по возрастанию), потом по количеству отработок на модели(по убыванию).

WITH myconstants(DURATION) AS (
	values(__DURATION__::interval)
)
SELECT c.name AS name, c.duration AS duration, c.skilltraining AS train, c.price AS price
FROM 
	courses AS c
WHERE 
	duration::interval <= (select DURATION from myconstants) AND skilltraining > 0
ORDER BY 
	price ASC, skilltraining DESC;

Допустимые параметры [__DURATION__]:

('2 days')

('7 days')

('4 days')

Необходимость:

Планируем посетить курс в свои выходные дни или отпуск, то есть ограниченное время можем выделить на курс,
и хотим подобрать курс с нужной длительностью и обязательно с отработкой на модели, ну и, конечно, же подешевле, но отработок на модели побольше.

