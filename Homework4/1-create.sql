DROP DATABASE vk;
CREATE DATABASE vk;

USE vk;

DROP TABLE IF EXISTS users;
CREATE TABLE users (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "������������� ������", 
	email VARCHAR(100) NOT NULL UNIQUE COMMENT "�����",
    phone VARCHAR(100) NOT NULL UNIQUE COMMENT "�������",
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "����� �������� ������",  
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "����� ���������� ������"
) COMMENT '������� �������������';

DROP TABLE IF EXISTS profiles;
CREATE TABLE profiles (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "������������� ������", 
    user_id INT UNSIGNED UNIQUE NOT NULL COMMENT "������ �� ������������", 
	first_name VARCHAR(100) NOT NULL COMMENT "��� ������������",
	last_name VARCHAR(100) NOT NULL COMMENT "������� ������������",
    birth_date DATE COMMENT "���� ��������",    
    country VARCHAR(100) COMMENT "������ ����������",
    city VARCHAR(100) COMMENT "����� ����������",
    `status` ENUM('ONLINE', 'OFFLINE', 'INACTIVE') COMMENT "������� ������",
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT '������� �������� �������������';

-- ��������� ���� "user_id" ������� "profiles" � ����� "id" ������� "users" c ������� �������� �����
ALTER TABLE profiles ADD CONSTRAINT fk_profiles_user_id FOREIGN KEY (user_id) REFERENCES users(id);

DROP TABLE IF EXISTS messages;
CREATE TABLE messages (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "������������� ������", 
	from_user_id INT UNSIGNED NOT NULL COMMENT "������ �� ����������� ���������",
	to_user_id INT UNSIGNED NOT NULL COMMENT "������ �� ���������� ���������",
    message_header VARCHAR(255) COMMENT "��������� ���������",
    message_body TEXT NOT NULL COMMENT "����� ���������",
    is_delivered BOOLEAN NOT NULL COMMENT "������� ��������",
    was_edited BOOLEAN NOT NULL COMMENT "������� ������ ��������� ��� ���� ���������",
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "����� �������� ������",
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "����� ���������� ������"
) COMMENT '������� ��������� �������������';

ALTER TABLE messages ADD CONSTRAINT fk_messages_from_user_id FOREIGN KEY (from_user_id) REFERENCES users(id);
ALTER TABLE messages ADD CONSTRAINT fk_messages_to_user_id FOREIGN KEY (to_user_id) REFERENCES users(id);

DROP TABLE IF EXISTS friendship;
CREATE TABLE friendship (
    user_id INT UNSIGNED NOT NULL COMMENT "������ �� ���������� ��������� ���������",
    friend_id INT UNSIGNED NOT NULL COMMENT "������ �� ���������� ����������� �������",
    friendship_status ENUM('FRIENDSHIP', 'FOLLOWING', 'BLOCKED') COMMENT "C����� (������� ���������) ���������",
	requested_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "����� ����������� ����������� �������",
	confirmed_at DATETIME COMMENT "����� ������������� �����������",
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "����� �������� ������",  
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "����� ���������� ������",  
	PRIMARY KEY (user_id, friend_id) COMMENT "��������� ��������� ����"
) COMMENT '������� ������ �������������';

ALTER TABLE friendship ADD CONSTRAINT fk_friendship_user_id FOREIGN KEY (user_id) REFERENCES users(id);
ALTER TABLE friendship ADD CONSTRAINT fk_friendship_friend_id FOREIGN KEY (friend_id) REFERENCES users(id);

-- ������� �����
DROP TABLE IF EXISTS communities;
CREATE TABLE communities (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "������������� �����",
  name VARCHAR(150) NOT NULL UNIQUE COMMENT "�������� ������",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "����� �������� ������",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "����� ���������� ������"
) COMMENT "������";

-- ������� ����� ������������� � �����
DROP TABLE IF EXISTS communities_users;
CREATE TABLE communities_users (
  community_id INT UNSIGNED NOT NULL COMMENT "������ �� ������",
  user_id INT UNSIGNED NOT NULL COMMENT "������ �� ������������",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "����� �������� ������", 
  PRIMARY KEY (community_id, user_id) COMMENT "��������� ��������� ����"
) COMMENT "��������� �����, ����� ����� �������������� � ��������";

ALTER TABLE communities_users ADD CONSTRAINT fk_cu_user_id FOREIGN KEY (user_id) REFERENCES users(id);
ALTER TABLE communities_users ADD CONSTRAINT fk_cu_community_id FOREIGN KEY (community_id) REFERENCES communities(id);

DROP TABLE IF EXISTS entity_types;
CREATE TABLE entity_types (
  `name` varchar(100) NOT NULL PRIMARY KEY COMMENT '��� ��������'
) COMMENT '���������� ������� � �������� ���������, ������� ����� ��������� ����';

CREATE TABLE likes (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT '������������� ������',
    from_user_id INT UNSIGNED NOT NULL COMMENT "������ �� ������������ ����������� ����",
    entity_id INT UNSIGNED NOT NULL COMMENT "������ �� ������ ��������",
    entity_name VARCHAR(128) NOT NULL COMMENT "������ �� �����",
    created_at datetime DEFAULT CURRENT_TIMESTAMP COMMENT '����� �������� ������',
    updated_at datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '����� ���������� ������'
) COMMENT '������� ������';

ALTER TABLE likes ADD CONSTRAINT fk_likes_entity_name FOREIGN KEY (entity_name) REFERENCES entity_types(`name`);

DROP TABLE IF EXISTS posts;
CREATE TABLE posts (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT '������������� ������',
  user_id INT UNSIGNED DEFAULT NULL COMMENT '������ �� ������������� ������������ ������� ����������� ����',
  community_id INT UNSIGNED DEFAULT NULL COMMENT '������ �� ������������ ������������ ������� ����������� ����',
  post_content TEXT COMMENT '����� ������������ �����',
  visibility VARCHAR(100) NOT NULL COMMENT '������ �� ������� ��������� �����',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '����� ���������� �����',
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '����� ���������� ������'
) COMMENT '����� ������������� � �����';

DROP TABLE IF EXISTS visibility;
CREATE TABLE visibility (
  `value` VARCHAR(100) NOT NULL PRIMARY KEY COMMENT '��� ���������'
) COMMENT '���������� ��������� ��������� �������� �� ��������';

ALTER TABLE posts ADD CONSTRAINT fk_post_user_id FOREIGN KEY (user_id) REFERENCES users(id);
ALTER TABLE posts ADD CONSTRAINT fk_post_community_id FOREIGN KEY (community_id) REFERENCES communities(id);
ALTER TABLE posts ADD CONSTRAINT fk_post_visibility_id FOREIGN KEY (visibility) REFERENCES visibility(`value`);

DROP TABLE IF EXISTS media;
CREATE TABLE media (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT '������������� ������',
  media_type VARCHAR(100) NOT NULL COMMENT '������ �� ��� ��������',
  link VARCHAR(1000) NOT NULL COMMENT '������ �� ����',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '����� �������� ������',
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '����� ���������� ������'
) COMMENT '�����';

DROP TABLE IF EXISTS media_types;
CREATE TABLE media_types (
  `name` VARCHAR(100) NOT NULL PRIMARY KEY COMMENT '��� ��������'
) COMMENT '��� ����� ��������';

ALTER TABLE media ADD CONSTRAINT fk_media_type_id FOREIGN KEY (media_type) REFERENCES media_types(`name`);

DROP TABLE IF EXISTS posts_media;
CREATE TABLE posts_media (
  post_id INT UNSIGNED NOT NULL COMMENT '������ �� ������������� �����',
  media_id INT UNSIGNED NOT NULL COMMENT '������ �� ������������� �����',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '����� �������� ������',
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '����� ���������� ������',
  PRIMARY KEY (post_id, media_id)
) COMMENT '����� ������ � �����';

ALTER TABLE posts_media ADD CONSTRAINT fk_pm_media_id FOREIGN KEY (media_id) REFERENCES media(id);
ALTER TABLE posts_media ADD CONSTRAINT fk_pm_post_id FOREIGN KEY (post_id) REFERENCES posts(id);

DROP TABLE IF EXISTS messages_media;
CREATE TABLE messages_media (
  message_id int unsigned NOT NULL COMMENT '������ �� ������������� ���������',
  media_id int unsigned NOT NULL COMMENT '������ �� ������������� �����',
  created_at datetime DEFAULT CURRENT_TIMESTAMP COMMENT '����� �������� ������',
  updated_at datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '����� ���������� ������',
  PRIMARY KEY (message_id, media_id)
) COMMENT '����� ��������� � �����';

ALTER TABLE messages_media ADD CONSTRAINT fk_mm_media_id FOREIGN KEY (media_id) REFERENCES media (id);
ALTER TABLE messages_media ADD CONSTRAINT fk_mm_message_id FOREIGN KEY (message_id) REFERENCES messages (id);
