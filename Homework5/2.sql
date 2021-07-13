-- 1. ����������� ������� ������� ������������� � ������� users.
USE shop;
SELECT AVG(TO_DAYS(NOW()) - TO_DAYS(birthday_at))/365.25 FROM users;

-- 2. ����������� ���������� ���� ��������, ������� ���������� �� ������ �� ���� ������. 
-- ������� ������, ��� ���������� ��� ������ �������� ����, � �� ���� ��������.
USE shop;

SELECT 
	COUNT(DAYOFWEEK(concat_ws('.', DAY (birthday_at), MONTH(birthday_at), '2021'))
	),
	DAYOFWEEK(concat_ws('.', DAY (birthday_at), MONTH(birthday_at), '2021'))
FROM
	users
GROUP BY DAYOFWEEK(concat_ws('.', DAY (birthday_at), MONTH(birthday_at), '2021'));


-- 3. (�� �������) ����������� ������������ ����� � ������� �������.
USE SHOP;
SELECT EXP(SUM(LN(id))) FROM users;
