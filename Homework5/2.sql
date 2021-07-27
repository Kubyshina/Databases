-- 1. Подсчитайте средний возраст пользователей в таблице users.
USE shop;
SELECT AVG(TO_DAYS(NOW()) - TO_DAYS(birthday_at))/365.25 FROM users;

-- 2. Подсчитайте количество дней рождения, которые приходятся на каждый из дней недели. 
-- Следует учесть, что необходимы дни недели текущего года, а не года рождения.
USE shop;

SELECT 
	COUNT(DAYOFWEEK(concat_ws('.', DAY (birthday_at), MONTH(birthday_at), '2021'))
	),
	DAYOFWEEK(concat_ws('.', DAY (birthday_at), MONTH(birthday_at), '2021'))
FROM
	users
GROUP BY DAYOFWEEK(concat_ws('.', DAY (birthday_at), MONTH(birthday_at), '2021'));


-- 3. (по желанию) Подсчитайте произведение чисел в столбце таблицы.
USE SHOP;
SELECT EXP(SUM(LN(id))) FROM users;
