-- 1. Создайте хранимую функцию hello(), которая будет возвращать приветствие, в зависимости от текущего времени суток. С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро", 
-- с 12:00 до 18:00 функция должна возвращать фразу "Добрый день", с 18:00 до 00:00 — "Добрый вечер", с 00:00 до 6:00 — "Доброй ночи".
-- DROP FUNCTION hello;

DELIMITER //
CREATE FUNCTION hello()
RETURNS TEXT DETERMINISTIC 
BEGIN
	SET @cur_hour = DATE_FORMAT(NOW(), "%H");
	CASE 
	WHEN @cur_hour IN (0, 1, 2, 3, 4, 5) THEN
  	SET @greeting = "Доброй ночи";
	WHEN @cur_hour IN (6, 7, 8, 9, 10, 11) THEN
  	SET @greeting = "Доброе утро";
  WHEN @cur_hour IN (12, 13, 14, 15, 16, 17) THEN
  	SET @greeting = "Добрый день";
  WHEN @cur_hour IN (18, 19, 20, 21, 22, 23) THEN
		SET @greeting = "Добрый вечер";
	END CASE;
	RETURN @greeting;
END//

DELIMITER ;

SELECT hello();

-- 2. В таблице products есть два текстовых поля: name с названием товара и description с его описанием. Допустимо присутствие обоих полей или одно из них. 
-- Ситуация, когда оба поля принимают неопределенное значение NULL неприемлема. Используя триггеры, добейтесь того, чтобы одно из этих полей или оба поля были заполнены. 
-- При попытке присвоить полям NULL-значение необходимо отменить операцию.
DELIMITER //
CREATE TRIGGER insert_products BEFORE INSERT ON products
FOR EACH ROW
BEGIN
  IF NEW.name IS NULL AND NEW.description IS NULL THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Нельзя вставить строку!';
	END IF;
END//

DELIMITER ;

INSERT INTO products (id, name, description) VALUES (555, "123", "44");
INSERT INTO products (id, name) VALUES (556, "123");
INSERT INTO products (id, description) VALUES (557, "44");
INSERT INTO products (id, price) VALUES (558, 44);

-- 3. (по желанию) Напишите хранимую функцию для вычисления произвольного числа Фибоначчи. Числами Фибоначчи называется последовательность в которой число равно сумме двух предыдущих чисел. Вызов функции FIBONACCI(10) должен возвращать число 55.
-- DROP FUNCTION FIBONACCI;
DELIMITER //
CREATE FUNCTION FIBONACCI(num INT) 
RETURNS INT DETERMINISTIC
BEGIN
	SET @res = 1;
	SET @temp = 0;
	SET @prev = 0;
  SET @i = 2;
 	IF (num = 0) THEN
			SET @res = 0;
	ELSEIF (num = 1) THEN
			SET @res = 1;
	ELSE 
		WHILE @i < num + 1 DO
			SET @temp = @res;	
			SET @res = @res + @prev;
			SET @prev = @temp;			
			SET @i = @i + 1;
	  END WHILE;
	 END IF;
	RETURN @res;
END//

DELIMITER ;

SELECT FIBONACCI(10);
