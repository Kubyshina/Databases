USE shop;

-- 1. ����� � ������� users ���� created_at � updated_at ��������� ��������������. ��������� �� �������� ����� � ��������.
-- ������� ����
UPDATE users SET created_at = NULL, updated_at = NULL;
-- �������� ������ ��������
UPDATE users SET created_at = current_timestamp() , updated_at = current_timestamp();
-- ��������
SELECT * FROM users LIMIT 10;


-- 2. ������� users ���� �������� ��������������. 
-- ������ created_at � updated_at ���� ������ ����� VARCHAR � � ��� ������ ����� ���������� �������� � ������� 20.10.2017 8:10. 
-- ���������� ������������� ���� � ���� DATETIME, �������� �������� ����� ��������.

-- ������� � ���������� �������
ALTER TABLE users CHANGE created_at created_at VARCHAR(100), CHANGE updated_at updated_at VARCHAR(100);
UPDATE users SET created_at = '20.10.2017 8:10', updated_at = '20.10.2017 8:10';

-- �������� ��������������
ALTER TABLE users ADD created_at_new DATETIME, ADD updated_at_new DATETIME;
 
UPDATE users SET created_at_new = STR_TO_DATE(created_at, '%d.%m.%Y %h:%i');
UPDATE users SET updated_at_new = STR_TO_DATE(updated_at, '%d.%m.%Y %h:%i');

ALTER TABLE users DROP COLUMN created_at, DROP COLUMN updated_at;

ALTER TABLE users CHANGE created_at_new created_at DATETIME, CHANGE updated_at_new updated_at DATETIME;

-- ��������
SELECT * FROM users LIMIT 10;

-- 3. � ������� ��������� ������� storehouses_products � ���� value ����� ����������� ����� ������ �����: 
-- 0, ���� ����� ���������� � ���� ����, ���� �� ������ ������� ������. 
-- ���������� ������������� ������ ����� �������, ����� ��� ���������� � ������� ���������� �������� value. 
-- ������ ������� ������ ������ ���������� � �����, ����� ���� 

-- ���������� �������
INSERT INTO storehouses_products (value) VALUES (0), (2500), (0), (30), (1), (0);

-- ������
SELECT value FROM storehouses_products ORDER BY value = 0, value;

-- 4. (�� �������) �� ������� users ���������� ������� �������������, ���������� � ������� � ���. 
-- ������ ������ � ���� ������ ���������� �������� (may, august)

-- ���������� �������
ALTER TABLE users CHANGE birthday_at birthday_at VARCHAR(100);
UPDATE users SET birthday_at = "15 may 1985" WHERE id IN (1, 2, 3);
UPDATE users SET birthday_at = "30 august 1988" WHERE id IN (5, 6);

-- ��� ������
SELECT  * FROM users WHERE birthday_at LIKE '%may%' or birthday_at LIKE '%august%';

-- 5. (�� �������) �� ������� catalogs ����������� ������ ��� ������ �������. 
-- SELECT * FROM catalogs WHERE id IN (5, 1, 2); 
-- ������������ ������ � �������, �������� � ������ IN.
USE shop; 
SELECT * FROM catalogs WHERE id IN (5, 1, 2) ORDER BY IF (id = 5, 1, 2);
