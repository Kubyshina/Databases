-- 1. В базе данных shop и sample присутствуют одни и те же таблицы, учебной базы данных. Переместите запись id = 1 из таблицы shop.users в таблицу sample.users. Используйте транзакции.
USE shop;

/* DROP TABLE IF EXISTS sample.users;
CREATE TABLE sample.users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255),
  birthday_at DATE,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP);
  */

START TRANSACTION;
SELECT @id:=id, @name:=name, @birthday_at:=birthday_at, @created_at:=created_at, @updated_at:=updated_at FROM shop.users WHERE id = 1;
INSERT INTO sample.users (id, name, birthday_at, created_at, updated_at) VALUES (@id, @name, @birthday_at, @created_at, @updated_at);
DELETE FROM shop.users WHERE id = 1;
COMMIT;

SELECT * FROM sample.users;
SELECT * FROM shop.users;

-- 2. Создайте представление, которое выводит название name товарной позиции из таблицы products и соответствующее название каталога name из таблицы catalogs.
DROP VIEW IF EXISTS prod;
CREATE VIEW prod AS SELECT p.name AS product_name, c.name AS catalog_name FROM products p LEFT JOIN catalogs c ON p.catalog_id = c.id ;

SELECT * FROM prod;

-- 3. (по желанию) Пусть имеется таблица с календарным полем created_at. В ней размещены разряженые календарные записи за август 2018 года '2018-08-01', '2016-08-04', '2018-08-16' и 2018-08-17. 
-- Составьте запрос, который выводит полный список дат за август, выставляя в соседнем поле значение 1, если дата присутствует в исходном таблице и 0, если она отсутствует.

-- Не придумала, как сделать =(


-- 4. (по желанию) Пусть имеется любая таблица с календарным полем created_at. Создайте запрос, который удаляет устаревшие записи из таблицы, оставляя только 5 самых свежих записей.
-- TRUNCATE sample.users;
-- INSERT INTO sample.users (name, birthday_at, created_at, updated_at) SELECT first_name, birth_date,  created_at, updated_at FROM vk.profiles;
-- DROP TABLE temp;

CREATE TEMPORARY TABLE temp (id SERIAL);
INSERT INTO temp (id) SELECT id FROM sample.users ORDER BY created_at DESC LIMIT 5;
DELETE FROM sample.users WHERE id NOT IN (SELECT id FROM temp);

SELECT * FROM sample.users;