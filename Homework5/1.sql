USE shop;

-- 1. Пусть в таблице users поля created_at и updated_at оказались незаполненными. Заполните их текущими датой и временем.
-- Обнулим поля
UPDATE users SET created_at = NULL, updated_at = NULL;
-- Поставим нужные значения
UPDATE users SET created_at = current_timestamp() , updated_at = current_timestamp();
-- Проверим
SELECT * FROM users LIMIT 10;


-- 2. Таблица users была неудачно спроектирована. 
-- Записи created_at и updated_at были заданы типом VARCHAR и в них долгое время помещались значения в формате 20.10.2017 8:10. 
-- Необходимо преобразовать поля к типу DATETIME, сохранив введённые ранее значения.

-- Приведём к начальному условию
ALTER TABLE users CHANGE created_at created_at VARCHAR(100), CHANGE updated_at updated_at VARCHAR(100);
UPDATE users SET created_at = '20.10.2017 8:10', updated_at = '20.10.2017 8:10';

-- Выполним преобразование
ALTER TABLE users ADD created_at_new DATETIME, ADD updated_at_new DATETIME;
 
UPDATE users SET created_at_new = STR_TO_DATE(created_at, '%d.%m.%Y %h:%i');
UPDATE users SET updated_at_new = STR_TO_DATE(updated_at, '%d.%m.%Y %h:%i');

ALTER TABLE users DROP COLUMN created_at, DROP COLUMN updated_at;

ALTER TABLE users CHANGE created_at_new created_at DATETIME, CHANGE updated_at_new updated_at DATETIME;

-- Проверим
SELECT * FROM users LIMIT 10;

-- 3. В таблице складских запасов storehouses_products в поле value могут встречаться самые разные цифры: 
-- 0, если товар закончился и выше нуля, если на складе имеются запасы. 
-- Необходимо отсортировать записи таким образом, чтобы они выводились в порядке увеличения значения value. 
-- Однако нулевые запасы должны выводиться в конце, после всех 

-- Подготовим таблицу
INSERT INTO storehouses_products (value) VALUES (0), (2500), (0), (30), (1), (0);

-- Запрос
SELECT value FROM storehouses_products ORDER BY value = 0, value;

-- 4. (по желанию) Из таблицы users необходимо извлечь пользователей, родившихся в августе и мае. 
-- Месяцы заданы в виде списка английских названий (may, august)

-- Подготовим таблицу
ALTER TABLE users CHANGE birthday_at birthday_at VARCHAR(100);
UPDATE users SET birthday_at = "15 may 1985" WHERE id IN (1, 2, 3);
UPDATE users SET birthday_at = "30 august 1988" WHERE id IN (5, 6);

-- Сам запрос
SELECT  * FROM users WHERE birthday_at LIKE '%may%' or birthday_at LIKE '%august%';

-- 5. (по желанию) Из таблицы catalogs извлекаются записи при помощи запроса. 
-- SELECT * FROM catalogs WHERE id IN (5, 1, 2); 
-- Отсортируйте записи в порядке, заданном в списке IN.
USE shop; 
SELECT * FROM catalogs WHERE id IN (5, 1, 2) ORDER BY IF (id = 5, 1, 2);
