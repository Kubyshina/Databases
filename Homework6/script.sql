USE vk;

-- 1. Проанализировать запросы, которые выполнялись на занятии, определить возможные корректировки и/или улучшения (JOIN пока не применять).
-- По предыдущим занятиям: не хватает связи таблицы media и пользователями/сообществами.
-- По текущему занятию нет замечаний.

-- 2. Пусть задан некоторый пользователь. Из всех друзей этого пользователя найдите человека, который больше всех общался с нашим пользователем.
-- Сообщения друзей пользователю 1
WITH friends_messages AS (
	WITH friends AS (
	SELECT
				friend_id
	FROM
				friendship
	WHERE
				user_id = 1
		AND friendship_status = 1
		AND confirmed_at IS NOT NULL
	UNION
	SELECT
				user_id
	FROM
				friendship
	WHERE
				friend_id = 1
		AND friendship_status = 1
		AND confirmed_at IS NOT NULL
		)
	SELECT
			(
		SELECT
			concat_ws(' ', first_name, last_name)
		FROM
			profiles prof
		WHERE
			prof.user_id = messages.from_user_id
			) AS other_user_name
	FROM 
			messages
	WHERE 
			from_user_id IN (
		-- все друзья 1
		SELECT
			friend_id
		FROM
			friends
			)
		AND
			to_user_id = 1
	UNION ALL
	SELECT	
			(
		SELECT
			concat_ws(' ', first_name, last_name)
		FROM
			profiles prof
		WHERE
			prof.user_id = messages.to_user_id
			) AS other_user_name
	FROM 
			messages
	WHERE
		from_user_id = 1
		AND to_user_id IN (
		-- все друзья 1
		SELECT
			friend_id
		FROM
			friends
		)
)
SELECT
	COUNT(other_user_name) AS messages_number,
	other_user_name
FROM
	friends_messages
GROUP BY
	other_user_name
ORDER BY
	messages_number DESC
LIMIT 1;


-- 3. Подсчитать общее количество лайков, которые получили 10 самых молодых пользователей.
WITH youngest AS (
	SELECT
		user_id,
		birth_date,
		TO_DAYS(NOW()) - TO_DAYS(birth_date) AS days_from_birt
	FROM
			profiles
	ORDER BY
			birth_date DESC
	LIMIT 10
)
SELECT
	SUM(1) AS total_likes
FROM
	likes
WHERE
	entity_id IN (
SELECT user_id FROM youngest) AND entity_name = 'user';


-- 4. Определить кто больше поставил лайков (всего) - мужчины или женщины?
SELECT SUM(1) AS total_likes,
(
SELECT
			gender 
		FROM
			profiles prof
		WHERE
			prof.user_id = from_user_id) AS gender
FROM likes GROUP BY 
gender ORDER BY total_likes DESC LIMIT 1;

-- 5. Найти 10 пользователей, которые проявляют наименьшую активность в использовании социальной сети.
-- Активность определяю по общему количеству постов, лайков и сообщений.

WITH activities AS (
	-- количество постов пользователей
	SELECT
		(
			SELECT
				SUM(1)
			FROM
				posts
			WHERE
				user_id = p.user_id) AS activity,
		user_id
	FROM
		profiles p
	GROUP BY
		user_id
	UNION ALL
	-- количество лайков пользователей
	SELECT
		(
			SELECT
				SUM(1)
			FROM
				likes
			WHERE
				from_user_id = p.user_id) AS activity,
		user_id
	FROM
		profiles p
	GROUP BY
		user_id
	UNION ALL
	-- количество сообщений пользователей
	SELECT
		(
			SELECT
				SUM(1)
			FROM
				messages m
			WHERE
				from_user_id = p.user_id) AS activity,
		user_id
	FROM
		profiles p
	GROUP BY
		user_id
	ORDER BY
		user_id
)
SELECT
-- количество общих активностей пользователей
	SUM(activity)
		AS total_activity,
	(
		SELECT
			concat_ws(' ', first_name, last_name)
		FROM
			profiles prof
		WHERE
			prof.user_id = activities.user_id
	) AS user_name
FROM
	activities
GROUP BY
	user_id
ORDER BY
	total_activity
LIMIT 10;

