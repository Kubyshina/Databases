/*
ALTER TABLE skyscanner.airlines_flights DROP CONSTRAINT fk_af_airline_id;
ALTER TABLE skyscanner.retailers_flights DROP CONSTRAINT fk_rf_retailer_id;
ALTER TABLE skyscanner.cities DROP CONSTRAINT fk_cities_country_id;
ALTER TABLE skyscanner.airports DROP CONSTRAINT fk_airports_city_id;
ALTER TABLE skyscanner.airlines_flights DROP CONSTRAINT fk_af_flight_id;
ALTER TABLE skyscanner.flights DROP CONSTRAINT fk_flights_airport_from_id;
ALTER TABLE skyscanner.flights DROP CONSTRAINT fk_flights_airport_to_id;
ALTER TABLE skyscanner.flights_dates DROP CONSTRAINT fk_fd_af_id;
ALTER TABLE skyscanner.retailers_flights DROP CONSTRAINT fk_rf_flight_id;
ALTER TABLE skyscanner.flights_tickets DROP CONSTRAINT fk_ft_flight_id;
ALTER TABLE skyscanner.flights_tickets DROP CONSTRAINT fk_ft_rf_id;
*/

DROP TABLE IF EXISTS skyscanner.airlines;
CREATE TABLE skyscanner.airlines (
	id SERIAL PRIMARY KEY,
	name VARCHAR(100) NOT NULL COMMENT 'Название авиакомпании',
	abbreviation VARCHAR(3) NOT NULL COMMENT 'Сокращенное название авиакомпании',
	KEY index_of_airline_name(name),
	KEY index_of_airline_abbreviation(abbreviation)
)
ENGINE=InnoDB
DEFAULT CHARSET=cp1251
COLLATE=cp1251_general_ci
COMMENT 'Справочник авиакомпаний';

INSERT INTO skyscanner.airlines (name, abbreviation) VALUES
  ('Аэрофлот', 'SU'),
  ('Россия', 'FV'),
  ('Победа', 'DP'),
  ('S7 Airlines', 'S7'),
  ('Ural Airlines', 'U6'); 

DROP TABLE IF EXISTS skyscanner.retailers;
CREATE TABLE skyscanner.retailers (
	id SERIAL PRIMARY KEY,
	name VARCHAR(100) NOT NULL COMMENT 'Название продвца авиабилетов',
	web_site VARCHAR(100) NOT NULL COMMENT 'Сайт продавца авиабилетов',
	KEY index_of_retailer_name(name)
)
ENGINE=InnoDB
DEFAULT CHARSET=cp1251
COLLATE=cp1251_general_ci
COMMENT 'Справочник продавцов авиабилетов';

INSERT INTO skyscanner.retailers (name, web_site) VALUES
  ('Аэрофлот', 'https://www.aeroflot.ru/'),
  ('City.Travel', 'https://city.travel/'),
  ('Tickets.ru', 'https://tickets.ru/'),
  ('Pobeda', 'https://www.pobeda.aero/'),
  ('MEGO.travel', 'https://mego.travel/');

DROP TABLE IF EXISTS skyscanner.countries;
CREATE TABLE skyscanner.countries (
	id SERIAL PRIMARY KEY,
	name VARCHAR(100) NOT NULL COMMENT 'Страна',
	KEY index_of_country_name(name)
)
ENGINE=InnoDB
DEFAULT CHARSET=cp1251
COLLATE=cp1251_general_ci
COMMENT 'Справочник стран';

INSERT INTO skyscanner.countries (name) VALUES
  ('Russia'),
  ('Egypt'),
  ('Thailand');

DROP TABLE IF EXISTS skyscanner.cities;
CREATE TABLE skyscanner.cities (
	id SERIAL PRIMARY KEY,
	name VARCHAR(100) NOT NULL COMMENT 'Город',
	country_id BIGINT UNSIGNED NOT NULL COMMENT 'ID страны',
	time_zone VARCHAR(10) COMMENT 'Часовой пояс',
	KEY index_of_city_name(name)
)
ENGINE=InnoDB
DEFAULT CHARSET=cp1251
COLLATE=cp1251_general_ci
COMMENT 'Справочник городов';
ALTER TABLE skyscanner.cities ADD CONSTRAINT fk_cities_country_id  FOREIGN KEY (country_id) REFERENCES skyscanner.countries(id);

INSERT INTO skyscanner.cities (name, country_id) VALUES
  ('Moscow', 1),
  ('Sochi', 1),
  ('Gorno-Altaysk', 1),
  ('Bangkok', 3),
  ('Hurghada', 2);

DROP TABLE IF EXISTS skyscanner.airports;
CREATE TABLE skyscanner.airports (
	id SERIAL PRIMARY KEY,
	name VARCHAR(100) NOT NULL COMMENT 'Название аэропорта',
	abbreviation VARCHAR(3) NOT NULL COMMENT 'Сокращенное название аэропорта',
	city_id BIGINT UNSIGNED NOT NULL COMMENT 'Город',
	KEY index_of_airport_name(name),
	KEY index_of_airport_abbreviation(abbreviation)
)
ENGINE=InnoDB
DEFAULT CHARSET=cp1251
COLLATE=cp1251_general_ci
COMMENT 'Справочник аэропортов';
ALTER TABLE skyscanner.airports ADD CONSTRAINT fk_airports_city_id  FOREIGN KEY (city_id) REFERENCES skyscanner.cities(id);

INSERT INTO skyscanner.airports (name, abbreviation, city_id) VALUES
  ('Domodedovo', 'DME', 1),
  ('Sheremetyevo', 'SVO', 1),
  ('Vnukovo', 'VKO', 1),
  ('Gorno-Altaysk', 'RGK', 3),
  ('Adler-Sochi', 'AER', 2),
  ('Hurghada', 'HRG', 4);

DROP TABLE IF EXISTS skyscanner.flights;
CREATE TABLE skyscanner.flights (
	id SERIAL PRIMARY KEY,
	flight_number VARCHAR(5) NOT NULL COMMENT 'Номер рейса',
	airport_from_id BIGINT UNSIGNED NOT NULL COMMENT 'Аэропорт вылета',
	airport_to_id BIGINT UNSIGNED  NOT NULL COMMENT 'Аэропорт прилёта',
	KEY index_of_flight_number(flight_number)
)
ENGINE=InnoDB
DEFAULT CHARSET=cp1251
COLLATE=cp1251_general_ci
COMMENT 'Справочник рейсов';
ALTER TABLE skyscanner.flights ADD CONSTRAINT fk_flights_airport_from_id FOREIGN KEY (airport_from_id) REFERENCES skyscanner.airports(id);
ALTER TABLE skyscanner.flights ADD CONSTRAINT fk_flights_airport_to_id FOREIGN KEY (airport_to_id) REFERENCES skyscanner.airports(id);

INSERT INTO skyscanner.flights (flight_number, airport_from_id, airport_to_id) VALUES
  ('539', 1, 4),
  ('540', 4, 1),
  ('541', 1, 5),
  ('542', 5, 1),
  ('777', 2, 4),
  ('778', 4, 2);

DROP TABLE IF EXISTS skyscanner.airlines_flights;
CREATE TABLE skyscanner.airlines_flights (
	id SERIAL PRIMARY KEY,
	airline_id BIGINT UNSIGNED NOT NULL COMMENT 'Авиакомпания',
	flight_id BIGINT UNSIGNED NOT NULL COMMENT 'Рейс'
)
ENGINE=InnoDB
DEFAULT CHARSET=cp1251
COLLATE=cp1251_general_ci
COMMENT 'Связь рейсов и авиакомпаний';
ALTER TABLE skyscanner.airlines_flights ADD CONSTRAINT fk_af_airline_id FOREIGN KEY (airline_id) REFERENCES skyscanner.airlines(id);
ALTER TABLE skyscanner.airlines_flights ADD CONSTRAINT fk_af_flight_id FOREIGN KEY (flight_id) REFERENCES skyscanner.flights(id);

INSERT INTO skyscanner.airlines_flights (airline_id, flight_id) VALUES
  (1, 1),
  (1, 2),
  (1, 3),
  (1, 4),
  (4, 5),
  (4, 6);

DROP TABLE IF EXISTS skyscanner.flights_dates;
CREATE TABLE skyscanner.flights_dates (
	id SERIAL PRIMARY KEY,
	airline_flight_id BIGINT UNSIGNED NOT NULL COMMENT 'Рейс',
	departure_time DATETIME NOT NULL COMMENT 'Время отправление',
	arrival_time DATETIME NOT NULL COMMENT 'Время прибытия',
	KEY index_of_departure_time(departure_time),
	KEY index_of_arrival_time(arrival_time)
)
ENGINE=InnoDB
DEFAULT CHARSET=cp1251
COLLATE=cp1251_general_ci
COMMENT 'Справочник рейсов по датам';
ALTER TABLE skyscanner.flights_dates ADD CONSTRAINT fk_fd_af_id FOREIGN KEY (airline_flight_id) REFERENCES skyscanner.airlines_flights(id);

INSERT INTO skyscanner.flights_dates (airline_flight_id, departure_time, arrival_time) VALUES
  (1, '2021-01-01 14:30:00', '2021-01-01 17:30:00'),
  (1, '2021-01-02 14:30:00', '2021-01-02 17:30:00'),
  (1, '2021-01-05 14:30:00', '2021-01-05 17:30:00'),
  (1, '2021-01-07 14:30:00', '2021-01-07 17:30:00'),
  (2, '2021-01-01 20:30:00', '2021-01-01 23:30:00'),
  (2, '2021-01-04 20:30:00', '2021-01-04 23:30:00'),
  (2, '2021-01-06 20:30:00', '2021-01-06 23:30:00'),
  (2, '2021-01-07 20:30:00', '2021-01-07 23:30:00'),
  (3, '2021-01-01 15:15:00', '2021-01-01 18:30:00'),
  (3, '2021-01-05 15:15:00', '2021-01-05 18:30:00'),
  (4, '2021-01-02 09:35:00', '2021-01-02 12:30:00'),
  (4, '2021-01-06 09:35:00', '2021-01-06 12:30:00'),
  (5, '2021-01-01 08:05:00', '2021-01-01 13:25:00'),
  (5, '2021-01-03 08:30:00', '2021-01-03 13:50:00'),
  (5, '2021-01-05 08:05:00', '2021-01-05 13:25:00'),
  (6, '2021-01-02 22:00:00', '2021-01-03 01:00:00'),
  (6, '2021-01-04 22:00:00', '2021-01-05 01:00:00'),
  (6, '2021-01-06 22:00:00', '2021-01-07 01:00:00');

DROP TABLE IF EXISTS skyscanner.tickets_classes;
CREATE TABLE skyscanner.tickets_classes (
	id SERIAL PRIMARY KEY,
	class VARCHAR(20) COMMENT 'Класс билета',
	KEY index_of_ticket_class(class)
)
ENGINE=InnoDB
DEFAULT CHARSET=cp1251
COLLATE=cp1251_general_ci
COMMENT 'Справочник классов билетов';

INSERT INTO skyscanner.tickets_classes (class) VALUES
  ('Промо'),
  ('Эконом'),
  ('Бизнес');

DROP TABLE IF EXISTS skyscanner.retailers_flights;
CREATE TABLE skyscanner.retailers_flights (
	id SERIAL PRIMARY KEY,
	retailer_id BIGINT UNSIGNED NOT NULL COMMENT 'Продавец билетов',
	flight_id BIGINT UNSIGNED NOT NULL COMMENT 'Рейс'
)
ENGINE=InnoDB
DEFAULT CHARSET=cp1251
COLLATE=cp1251_general_ci
COMMENT 'Справочник наличия билетов на рейс у продавцов';
ALTER TABLE skyscanner.retailers_flights ADD CONSTRAINT fk_rf_retailer_id FOREIGN KEY (retailer_id) REFERENCES skyscanner.retailers(id);
ALTER TABLE skyscanner.retailers_flights ADD CONSTRAINT fk_rf_flight_id FOREIGN KEY (flight_id) REFERENCES skyscanner.flights_dates(id);

INSERT INTO skyscanner.retailers_flights (retailer_id, flight_id) VALUES
  (1, 1),
  (1, 2),
  (2, 1),
  (2, 2),
  (3, 1),
  (3, 2),
  (1, 3),
  (1, 4),
  (3, 5),
  (3, 6),
  (5, 5),
  (5, 6);

DROP TABLE IF EXISTS skyscanner.flights_tickets;
CREATE TABLE skyscanner.flights_tickets (
	id SERIAL PRIMARY KEY,
	retailers_flights_id BIGINT UNSIGNED NOT NULL COMMENT 'Рейс у продавца билетов',
	ticket_class_id BIGINT UNSIGNED NOT NULL COMMENT 'Класс  билета',
	price DECIMAL (11,2) NOT NULL COMMENT 'Цена'
)
ENGINE=InnoDB
DEFAULT CHARSET=cp1251
COLLATE=cp1251_general_ci
COMMENT 'Справочник цен на билеты у продавца';
ALTER TABLE skyscanner.flights_tickets ADD CONSTRAINT fk_ft_rf_id FOREIGN KEY (retailers_flights_id) REFERENCES skyscanner.retailers_flights(id);
ALTER TABLE skyscanner.flights_tickets ADD CONSTRAINT fk_ft_flight_id FOREIGN KEY (ticket_class_id) REFERENCES skyscanner.tickets_classes(id);

INSERT INTO skyscanner.flights_tickets (retailers_flights_id, ticket_class_id, price) VALUES
  (1, 1, 1000.00),
  (2, 1, 1000.00),
  (3, 2, 1500.00),
  (4, 2, 1500.00),
  (5, 1, 1000.00),
  (6, 1, 1000.00),
  (7, 2, 1500.00),
  (8, 1, 900.00),
  (9, 1, 900.00),
  (10, 2, 3000.00),
  (11, 2, 3000.00);