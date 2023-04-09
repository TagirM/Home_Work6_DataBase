/*
1. Написать функцию, которая удаляет всю информацию об указанном пользователе из БД vk. 
Пользователь задается по id. Удалить нужно все сообщения, лайки, медиа записи, профиль и запись из таблицы users. 
Функция должна возвращать номер пользователя.
*/
USE vk;
DROP FUNCTION IF EXISTS delete_user_data;
SET SQL_SAFE_UPDATES = 0;

DELIMITER //
CREATE FUNCTION delete_user_data(inp_id BIGINT) RETURNS FLOAT READS SQL DATA
BEGIN
	DECLARE `result` FLOAT;
	SET FOREIGN_KEY_CHECKS=0;

	-- Удаление всех сообщений из таблицы messages(входящих и исходящих)
	DELETE 
    FROM messages 
    WHERE from_user_id = inp_id OR to_user_id = inp_id;

    -- Удаление всех заявок в друзья из таблицы friend_requests
	DELETE 
    FROM friend_requests
    WHERE initiator_user_id = inp_id OR target_user_id = inp_id;

	-- Удаление всех лайков пользователя
	DELETE 
    FROM likes 
    WHERE user_id = inp_id;

	-- Удаление всех медиа файлов
	DELETE 
    FROM media 
    WHERE user_id = inp_id;

	-- Удаление профиля пользователя из таблицы profiles
	DELETE 
    FROM profiles 
    WHERE user_id = inp_id;

  -- Удаление пользователя из таблицы users
	DELETE 
    FROM users 
    WHERE id = inp_id;

    -- Удаление пользователя из таблицы users_communities
	DELETE 
    FROM users_communities
    WHERE user_id = inp_id;

	SET FOREIGN_KEY_CHECKS=1;
	SET `result` = inp_id;
    RETURN `result`;
END//
DELIMITER ;
SELECT delete_user_data(100);



-- Задача 2. Предыдущую задачу решить с помощью процедуры и обернуть используемые команды в транзакцию внутри процедуры.

USE vk;
SET @inp_id = 1;
START TRANSACTION;
SET FOREIGN_KEY_CHECKS=0;
	-- Удаление всех сообщений из таблицы messages(входящих и исходящих)
	DELETE 
    FROM messages 
    WHERE from_user_id = @inp_id OR to_user_id = @inp_id;

    -- Удаление всех заявок в друзья из таблицы friend_requests
	DELETE 
    FROM friend_requests
    WHERE initiator_user_id = @inp_id OR target_user_id = @inp_id;

	-- Удаление всех лайков пользователя
	DELETE 
    FROM likes 
    WHERE user_id = @inp_id;

	-- Удаление всех медиа файлов
	DELETE 
    FROM media 
    WHERE user_id = @inp_id;

	-- Удаление профиля пользователя из таблицы profiles
	DELETE 
    FROM profiles 
    WHERE user_id = @inp_id;

  -- Удаление пользователя из таблицы users
	DELETE 
    FROM users 
    WHERE id = @inp_id;

    -- Удаление пользователя из таблицы users_communities
	DELETE 
    FROM users_communities
    WHERE user_id = @inp_id;
SET FOREIGN_KEY_CHECKS=1;
COMMIT;




/* Задача 3*. Написать триггер, который проверяет новое появляющееся сообщество. Длина названия сообщества (поле name) должна быть не менее 5 символов. 
Если требование не выполнено, то выбрасывать исключение с пояснением.*/

DELIMITER //
DROP TRIGGER IF EXISTS check_community_name_length;
CREATE TRIGGER check_community_name_length
BEFORE INSERT ON communities
FOR EACH ROW
BEGIN
  IF (LENGTH(NEW.name) < 5) THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Длина названия сообщества должна быть не менее 5 символов!';
  END IF;
END//

DELIMITER ;


