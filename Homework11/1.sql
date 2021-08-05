-- 1. Создайте таблицу logs типа Archive. Пусть при каждом создании записи в таблицах users, catalogs и products в таблицу logs помещается 
-- время и дата создания записи, название таблицы, идентификатор первичного ключа и содержимое поля name.
USE shop;

DROP TABLE logs;
CREATE TABLE logs (
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    table_name VARCHAR(100),
    id INT,
    name VARCHAR(100)
)
ENGINE = ARCHIVE;

DELIMITER //
DROP TRIGGER IF EXISTS insert_users//
CREATE TRIGGER insert_users BEFORE INSERT ON users
FOR EACH ROW
BEGIN
	INSERT INTO logs (table_name, id, name) 
    VALUES ('users', NEW.id, NEW.name);
END//

DROP TRIGGER IF EXISTS insert_catalogs//
CREATE TRIGGER insert_catalogs BEFORE INSERT ON catalogs
FOR EACH ROW
BEGIN
	INSERT INTO logs (table_name, id, name) 
    VALUES ('catalogs', NEW.id, NEW.name);
END//

DROP TRIGGER IF EXISTS insert_products//
CREATE TRIGGER insert_products BEFORE INSERT ON products
FOR EACH ROW
BEGIN
	INSERT INTO logs (table_name, id, name) 
    VALUES ('products', NEW.id, NEW.name);
END//

DELIMITER ;

INSERT INTO users (name, birthday_at)
VALUES ('Тест Тестович', '1999-01-01');
        
INSERT INTO catalogs (name)
VALUES ('Мыши');
        
INSERT INTO products (name, description, price, catalog_id)
VALUES ('Зелёная мышь', 'Зелёная мышь на колёсиках', 100.00, 4);
        
SELECT * FROM logs;
        