DROP DATABASE IF EXISTS example;
CREATE DATABASE example;

DROP TABLE IF EXISTS users;
CREATE TABLE users (
	id SERIAL PRIMARY KEY AUTO_INCREMENT,
	name VARCHAR(255) NOT NULL COMMENT '��� ������������'
) COMMENT '������������';

INSERT INTO users(name) VALUES
	('�����'),
	('���'),
	('���� �������');

SELECT * FROM users;