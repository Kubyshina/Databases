-- 1. Проанализировать какие запросы могут выполняться наиболее часто в процессе работы приложения и добавить необходимые индексы
-- На мой взгляд, стоит дополнительно проиндексировать таблицу профилей по фамилии, так как это самый частый поиск:
CREATE INDEX ix_profiles_last_name ON profiles(last_name);

-- Таблицу сообщений по названию:
CREATE INDEX ix_messages_header ON messages(message_header);

-- 2. Задание на оконные функции. Построить запрос, который будет выводить следующие столбцы:

-- имя группы;
-- среднее количество пользователей в группах;
-- самый молодой пользователь в группе;
-- самый старший пользователь в группе;
-- общее количество пользователей в группе;
-- всего пользователей в системе;
-- отношение в процентах (общее количество пользователей в группе / всего пользователей в системе) * 100.

SELECT
	DISTINCT 
	c.name AS community_name,
	(
	SELECT
		COUNT(*)
	FROM
		communities_users) / (
	SELECT
		COUNT(*)
	FROM
		communities) AS users_average,
	(
	SELECT
		concat_ws(' ', p.first_name, p.last_name, p.birth_date)
	FROM
		profiles p
	WHERE
		p.birth_date IN (
		SELECT
			p.birth_date
		FROM
			profiles p
		WHERE
			p.id IN (
			SELECT
				user_id
			FROM
				communities_users
			WHERE
				community_id = cu.community_id))
	ORDER BY
		p.birth_date DESC
	LIMIT 1) AS youngest_user,
	(
	SELECT
		concat_ws(' ', p.first_name, p.last_name, p.birth_date)
	FROM
		profiles p
	WHERE
		p.birth_date IN (
		SELECT
			p.birth_date
		FROM
			profiles p
		WHERE
			p.id IN (
			SELECT
				user_id
			FROM
				communities_users
			WHERE
				community_id = cu.community_id))
	ORDER BY
		p.birth_date
	LIMIT 1) AS eldest_user,
	COUNT(cu.user_id) OVER (w) AS users_in_community,
	(
	SELECT
		COUNT(*)
	FROM
		profiles) AS total_users,
	COUNT(cu.user_id) OVER (w) / (
	SELECT
		COUNT(*)
	FROM
		profiles) * 100 AS percent
FROM 
	communities c
LEFT JOIN 
	communities_users cu ON
	(
		cu.community_id = c.id
	)

WINDOW w AS (PARTITION BY cu.community_id)
ORDER BY id;