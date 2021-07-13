-- 1. ѕодсчитайте средний возраст пользователей в таблице users.
USE shop;
SELECT AVG(TO_DAYS(NOW()) - TO_DAYS(birthday_at))/365.25 FROM users;

-- 2. ѕодсчитайте количество дней рождени€, которые приход€тс€ на каждый из дней недели. 
-- —ледует учесть, что необходимы дни недели текущего года, а не года рождени€.
USE shop;

SELECT 
	COUNT(DAYOFWEEK(concat_ws('.', DAY (birthday_at), MONTH(birthday_at), '2021'))
	),
	DAYOFWEEK(concat_ws('.', DAY (birthday_at), MONTH(birthday_at), '2021'))
FROM
	users
GROUP BY DAYOFWEEK(concat_ws('.', DAY (birthday_at), MONTH(birthday_at), '2021'));


-- 3. (по желанию) ѕодсчитайте произведение чисел в столбце таблицы.
USE SHOP;
SELECT EXP(SUM(LN(id))) FROM users;
