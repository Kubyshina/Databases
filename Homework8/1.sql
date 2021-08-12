-- 1. Составьте список пользователей users, которые осуществили хотя бы один заказ orders в интернет магазине.
USE shop;

INSERT INTO orders (user_id) VALUES (1);
INSERT INTO orders (user_id) VALUES (1);
INSERT INTO orders (user_id) VALUES (3);
INSERT INTO orders (user_id) VALUES (3);
INSERT INTO orders (user_id) VALUES (1);
INSERT INTO orders (user_id) VALUES (5);

SELECT u.name FROM orders o LEFT JOIN users u ON o.user_id = u.id GROUP BY u.name;

-- 2. Выведите список товаров products и разделов catalogs, который соответствует товару.
SELECT p.id, p.name, c.name FROM products p INNER JOIN catalogs c ON p.catalog_id = c.id;

-- 3. (по желанию) Пусть имеется таблица рейсов flights (id, from, to) и таблица городов cities (label, name). Поля from, to и label содержат английские названия городов, поле name — русское. 
-- Выведите список рейсов flights с русскими названиями городов.
CREATE TABLE flights (
  id SERIAL PRIMARY KEY,
  `from` VARCHAR(100), 
  `to` VARCHAR (100)
);
INSERT INTO flights (`from`, `to`)
VALUES ('moscow', 'omsk'), ('novgorod', 'kazan'), ('irkutsk', 'moscow'), ('omsk', 'irkutsk'), ('moscow', 'kazan');

CREATE TABLE cities (
  label VARCHAR(100),
  name VARCHAR(100)
);
INSERT INTO cities (label, name)
VALUES ('moscow', 'Москва'), ('irkutsk', 'Иркутск'), ('novgorod', 'Новгород'), ('kazan', 'Казань'), ('omsk', 'Омск');

SELECT f.id, c.name AS `from`, c1.name AS `to` FROM flights f INNER JOIN cities c ON f.`from`= c.label INNER JOIN cities c1 ON f.`to`= c1.label; 
