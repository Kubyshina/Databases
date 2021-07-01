/*
 Список сущностей:
 
 1. профиль
 2. пост
 3. друзья
 4. сообщества
 5. сообщения
 6. медиа
 
 */

DROP DATABASE vk;
CREATE DATABASE vk;

USE vk;

DROP TABLE IF EXISTS users;
CREATE TABLE users (
	id INT AUTO_INCREMENT PRIMARY KEY,
	email VARCHAR(100) UNIQUE NOT NULL,
	phone VARCHAR(11) UNIQUE NOT NULL,
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

DROP TABLE IF EXISTS profiles;
CREATE TABLE profiles (
	id INT AUTO_INCREMENT PRIMARY KEY,
	first_name VARCHAR(100),
	last_name VARCHAR(100),
	birth_date DATE,
	user_id INT UNIQUE NOT NULL,
	country VARCHAR(100),
	city VARCHAR(100),
	profile_status ENUM('ONLINE', 'OFFLINE', 'INACTIVE')
	
);

ALTER TABLE profiles ADD CONSTRAINT fk_profile_user_id FOREIGN KEY (user_id) REFERENCES users(id);

DROP TABLE IF EXISTS messages;
CREATE TABLE messages (
	id INT AUTO_INCREMENT PRIMARY KEY,
	from_user_id INT NOT NULL,
	to_user_id INT NOT NULL,
	message_header VARCHAR(255),
	message_body TEXT(1000) NOT NULL,
	sent_flag TINYINT NOT NULL,
	received_flag TINYINT NOT NULL,
	edited_flag TINYINT NOT NULL,
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
	-- FOREIGN KEY (from_user_id) REFERENCES users(id),
	-- FOREIGN KEY (to_user_id) REFERENCES users(id)
);

ALTER TABLE messages ADD CONSTRAINT fk_messages_from_user_id  FOREIGN KEY (from_user_id) REFERENCES users(id);
ALTER TABLE messages ADD CONSTRAINT fk_messages_to_user_id  FOREIGN KEY (to_user_id) REFERENCES users(id);

DROP TABLE IF EXISTS friendship;
CREATE TABLE friendship (
	id INT AUTO_INCREMENT PRIMARY KEY,
	user_id INT NOT NULL,
	friend_id INT NOT NULL,
	friendship_status ENUM('FRIENDSHIP', 'FOLLOWING', 'BLOCKED'),
	requested_at DATETIME NOT NULL,
	accepted_at DATETIME,
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

ALTER TABLE friendship ADD CONSTRAINT fk_frendship_user_id  FOREIGN KEY (user_id) REFERENCES users(id);
ALTER TABLE friendship ADD CONSTRAINT fk_frendship_friend_id  FOREIGN KEY (friend_id) REFERENCES users(id);

DROP TABLE IF EXISTS communities;
CREATE TABLE communities (
	id INT AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(255) UNIQUE NOT NULL,
	user_id INT NOT NULL,
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

DROP TABLE IF EXISTS communities_users;
CREATE TABLE communities_users (
	community_id INT NOT NULL,
	user_id INT NOT NULL,
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	PRIMARY KEY (community_id, user_id)
);

ALTER TABLE communities_users ADD CONSTRAINT fk_cu_user_id  FOREIGN KEY (user_id) REFERENCES users(id);
ALTER TABLE communities_users ADD CONSTRAINT fk_cu_community_id  FOREIGN KEY (community_id) REFERENCES communities(id);

DROP TABLE IF EXISTS media_files;
CREATE TABLE media_files (
	id INT AUTO_INCREMENT PRIMARY KEY,
	user_id INT NOT NULL,
	media_file_title VARCHAR(255),
	media_file_content BINARY,
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

ALTER TABLE media_files ADD CONSTRAINT fk_mf_user_id  FOREIGN KEY (user_id) REFERENCES users(id);


DROP TABLE IF EXISTS posts;
CREATE TABLE posts (
	id INT AUTO_INCREMENT PRIMARY KEY,
	user_id INT NOT NULL,
	post_title VARCHAR(255),
	post_content TEXT,
	post_media_id INT, 
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

ALTER TABLE posts ADD CONSTRAINT fk_posts_user_id  FOREIGN KEY (user_id) REFERENCES users(id);

DROP TABLE IF EXISTS posts_media_files;
CREATE TABLE posts_media_files (
	post_id INT NOT NULL,
	media_file_id INT NOT NULL,
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	PRIMARY KEY (post_id, media_file_id)
);

ALTER TABLE posts_media_files ADD CONSTRAINT fk_pmf_post_id  FOREIGN KEY (post_id) REFERENCES posts(id);
ALTER TABLE posts_media_files ADD CONSTRAINT fk_pmf_mf_id  FOREIGN KEY (media_file_id) REFERENCES media_files(id);

DROP TABLE IF EXISTS likes_on_profiles;
CREATE TABLE likes_on_profiles (
	user_id INT NOT NULL,
	from_user_id INT NOT NULL,
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	PRIMARY KEY (user_id, from_user_id)
);

ALTER TABLE likes_on_profiles ADD CONSTRAINT fk_lopr_user_id  FOREIGN KEY (user_id) REFERENCES users(id);
ALTER TABLE likes_on_profiles ADD CONSTRAINT fk_lopr_user_from_id  FOREIGN KEY (from_user_id) REFERENCES users(id);

DROP TABLE IF EXISTS likes_on_media_files;
CREATE TABLE likes_on_media_files (
	media_file_id INT NOT NULL,
	from_user_id INT NOT NULL,
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	PRIMARY KEY (media_file_id, from_user_id)
);

ALTER TABLE likes_on_media_files ADD CONSTRAINT fk_lomf_mf_id  FOREIGN KEY (media_file_id) REFERENCES media_files(id);
ALTER TABLE likes_on_media_files ADD CONSTRAINT fk_lomf_user_from_id  FOREIGN KEY (from_user_id) REFERENCES users(id);

DROP TABLE IF EXISTS likes_on_posts;
CREATE TABLE likes_on_posts (
	post_id INT NOT NULL,
	from_user_id INT NOT NULL,
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	PRIMARY KEY (post_id, from_user_id)
);

ALTER TABLE likes_on_posts ADD CONSTRAINT fk_lop_post_id  FOREIGN KEY (post_id) REFERENCES posts(id);
ALTER TABLE likes_on_posts ADD CONSTRAINT fk_lop_user_from_id  FOREIGN KEY (from_user_id) REFERENCES users(id);

SELECT * FROM communities;

-- ALTER TABLE profiles ADD CONSTRAINT PRIMARY KEY (id);

SELECT * FROM profiles;