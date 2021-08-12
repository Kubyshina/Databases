-- Представление - связь аэропортов и городов
DROP VIEW IF EXISTS skyscanner.airports_cities_countries;
CREATE VIEW skyscanner.airports_cities_countries AS
SELECT
	a.id AS airport_id,
	a.name AS airport_name,
	a.abbreviation AS airport_abbreviation,
	(
	SELECT
		name
	FROM
		skyscanner.cities
	WHERE
		id = a.city_id) AS city_id,
	(
	SELECT
		name
	FROM
		skyscanner.cities
	WHERE
		id = a.city_id) AS city_name,
	(
	SELECT
		country_id
	FROM
		skyscanner.cities
	WHERE
		id = a.city_id) AS country_id
FROM
	skyscanner.airports a;

-- Представление - связь рейсов с датами и авиакомпаниями
DROP VIEW IF EXISTS skyscanner.full_flight_info;
CREATE VIEW skyscanner.full_flight_info AS
SELECT	
	fd.id AS flight_id,
	fd.departure_time AS departure,
	al.name AS airline,
	concat_ws(' ', al.abbreviation, f.flight_number) AS flight_number,
	(
	SELECT
		city_name
	FROM
		skyscanner.airports_cities_countries
	WHERE
		airport_id = f.airport_from_id) AS city_from,
	(
	SELECT
		airport_abbreviation
	FROM
		skyscanner.airports_cities_countries
	WHERE
		airport_id = f.airport_from_id) AS airport_from,
	(
	SELECT
		city_name
	FROM
		skyscanner.airports_cities_countries
	WHERE
		airport_id = f.airport_to_id) AS city_to,
	(
	SELECT
		airport_abbreviation
	FROM
		skyscanner.airports_cities_countries
	WHERE
		airport_id = f.airport_to_id) AS airport_to
FROM
	skyscanner.flights_dates fd
LEFT JOIN skyscanner.airlines_flights af ON
	fd.airline_flight_id = af.flight_id
LEFT JOIN skyscanner.flights f ON
	af.flight_id = f.id
LEFT JOIN skyscanner.airlines al ON
	af.airline_id = al.id;

-- Запрос 1. Показать все возможные аэропорты вылета
SELECT
	airport_abbreviation AS airport_code,
	airport_name AS airport_full_name,
	city_name AS city,
	(
	SELECT
		name
	FROM
		skyscanner.countries
	WHERE
		id = country_id) AS country
FROM
	skyscanner.airports_cities_countries;


-- Запрос 2. Показать все города, в которые запланированы рейсы из Москвы
SELECT
	acc2.city_name AS city
FROM
	skyscanner.flights_dates fd
LEFT JOIN skyscanner.airlines_flights af ON
	fd.airline_flight_id = af.flight_id
LEFT JOIN skyscanner.flights f ON
	af.flight_id = f.id
LEFT JOIN skyscanner.airports_cities_countries acc1 ON
	f.airport_from_id = acc1.airport_id
LEFT JOIN skyscanner.airports_cities_countries acc2 ON
	f.airport_to_id = acc2.airport_id
WHERE
	acc1.city_name = 'Moscow'
GROUP BY
	acc2.city_id;


-- Запрос 3. Показать все рейсы из Москвы в Горно-Алтайск
SELECT
	fd.departure_time AS departure,
	a2.name AS airline,
	f.flight_number AS flight_number,
	ci.name AS city_from,
	a.abbreviation AS airport_from,
	cit.name AS city_to,
	ai.abbreviation AS airport_to
FROM
	skyscanner.flights_dates fd
LEFT JOIN skyscanner.airlines_flights af ON
	fd.airline_flight_id = af.flight_id
LEFT JOIN skyscanner.flights f ON
	af.flight_id = f.id
LEFT JOIN skyscanner.airlines a2 ON
	af.airline_id = a2.id
LEFT JOIN skyscanner.airports a ON
	f.airport_from_id = a.id
LEFT JOIN skyscanner.airports ai ON
	f.airport_to_id = ai.id
LEFT JOIN skyscanner.cities ci ON
	a.city_id = ci.id
LEFT JOIN skyscanner.cities cit ON
	ai.city_id = cit.id
WHERE
	ci.name = 'Moscow'
	AND
	cit.name = 'Gorno-Altaysk';


-- Запрос 4. Какие билеты есть в наличии на рейсы из Москвы в Горно-Алтайск на 1 января 2021 года
SELECT	
	(
	SELECT
		name
	FROM
		skyscanner.retailers
	WHERE
		id = rf.retailer_id) AS retailer,
	(
	SELECT
		web_site
	FROM
		skyscanner.retailers
	WHERE
		id = rf.retailer_id) AS web_site,
	price,
	(
	SELECT
		class
	FROM
		skyscanner.tickets_classes
	WHERE
		id = ft.ticket_class_id) AS ticket_class,
	fd.departure_time AS departure,
	a2.name AS airline,
	f.flight_number AS flight_number,
	ci.name AS city_from,
	a.abbreviation AS airport_from,
	cit.name AS city_to,
	ai.abbreviation AS airport_to
FROM
	skyscanner.flights_tickets ft
LEFT JOIN skyscanner.retailers_flights rf ON
	ft.retailers_flights_id = rf.id
LEFT JOIN 
	skyscanner.flights_dates fd ON
	rf.flight_id = fd.id
LEFT JOIN skyscanner.airlines_flights af ON
	fd.airline_flight_id = af.flight_id
LEFT JOIN skyscanner.flights f ON
	af.flight_id = f.id
LEFT JOIN skyscanner.airlines a2 ON
	af.airline_id = a2.id
LEFT JOIN skyscanner.airports a ON
	f.airport_from_id = a.id
LEFT JOIN skyscanner.airports ai ON
	f.airport_to_id = ai.id
LEFT JOIN skyscanner.cities ci ON
	a.city_id = ci.id
LEFT JOIN skyscanner.cities cit ON
	ai.city_id = cit.id
WHERE
	ci.name = 'Moscow'
	AND
	cit.name = 'Gorno-Altaysk'
	AND 
	DATE(fd.departure_time) = '2021-01-01';

-- Запрос 5а. Посмотреть количество вылетов из Москвы по датам
SELECT	
	DATE(fd.departure_time) AS departure,
	COUNT(flight_number) AS flights_count
FROM
	skyscanner.flights_dates fd 
LEFT JOIN skyscanner.airlines_flights af ON
	fd.airline_flight_id = af.flight_id
LEFT JOIN skyscanner.flights f ON
	af.flight_id = f.id
WHERE f.airport_from_id IN (SELECT id FROM skyscanner.airports WHERE city_id = (SELECT id FROM skyscanner.cities WHERE name = 'Moscow'))
	GROUP BY DATE(fd.departure_time);
	
-- Запрос 5б. То же самое через представление skyscanner.full_flight_info
SELECT	
	(
	SELECT
		name
	FROM
		skyscanner.retailers
	WHERE
		id = rf.retailer_id) AS retailer,
	(
	SELECT
		web_site
	FROM
		skyscanner.retailers
	WHERE
		id = rf.retailer_id) AS web_site,
	price,
	(
	SELECT
		class
	FROM
		skyscanner.tickets_classes
	WHERE
		id = ft.ticket_class_id) AS ticket_class,
	fd.departure AS departure,
	fd.airline AS airline,
	fd.flight_number AS flight_number,
	fd.city_from AS city_from,
	fd.airport_from AS airport_from,
	fd.city_to AS city_to,
	fd.airport_to AS airport_to
FROM
	skyscanner.flights_tickets ft
LEFT JOIN skyscanner.retailers_flights rf ON
	ft.retailers_flights_id = rf.id
LEFT JOIN 
	skyscanner.full_flight_info fd ON
	fd.flight_id = rf.flight_id
WHERE
	fd.city_from = 'Moscow'
	AND
	fd.city_to = 'Gorno-Altaysk'
	AND 
	DATE(fd.departure) = '2021-01-01';

