USE vk;

UPDATE users SET phone = CONCAT('+7', 9000000000 + FLOOR(RAND() * 999999999));
ALTER TABLE users ADD CONSTRAINT phone_check CHECK (REGEXP_LIKE(phone, '^\\+7[0-9]{10}$'));
SELECT * FROM users LIMIT 10;


ALTER TABLE profiles ADD COLUMN gender ENUM('M', 'F');

UPDATE profiles SET gender = (
SELECT CASE WHEN RAND() > 0.5 THEN 'M' ELSE 'F' END 
);
SELECT * FROM vk.profiles LIMIT 10;