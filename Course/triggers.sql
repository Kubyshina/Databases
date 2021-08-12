-- Триггеры: при добавлении аэропорта, города или страны пересчитывать их количество
DROP TRIGGER IF EXISTS skyscanner.countries_count;

DELIMITER //
CREATE TRIGGER skyscanner.countries_count AFTER INSERT ON skyscanner.countries
FOR EACH ROW
BEGIN
  SELECT COUNT(*) INTO @countries_total FROM skyscanner.countries;
END//
DELIMITER ;

DROP TRIGGER IF EXISTS skyscanner.cities_count;

DELIMITER //
CREATE TRIGGER skyscanner.cities_count AFTER INSERT ON skyscanner.cities
FOR EACH ROW
BEGIN
  SELECT COUNT(*) INTO @cities_total FROM skyscanner.cities;
END//
DELIMITER ;

DROP TRIGGER IF EXISTS skyscanner.airports_count;

DELIMITER //
CREATE TRIGGER skyscanner.airports_count AFTER INSERT ON skyscanner.airports
FOR EACH ROW
BEGIN
  SELECT COUNT(*) INTO @airports_total FROM skyscanner.airports;
END//
DELIMITER ;

INSERT INTO skyscanner.airports (name, abbreviation, city_id) VALUES ('Zhukovsky', 'ZIA', 1);
SELECT @airports_total;

INSERT INTO skyscanner.cities (name, country_id) VALUES ('Omsk', 1);
SELECT @cities_total;

INSERT INTO skyscanner.countries (name) VALUES ('Germany');
SELECT @countries_total;