-- MySQL dump 10.13  Distrib 8.4.7, for Linux (x86_64)
--
-- Host: localhost    Database: JSONDB
-- ------------------------------------------------------
-- Server version	8.4.7

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
/*!50032 DROP TRIGGER IF EXISTS TG_BeforeInsert */;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`brett`@`%`*/ /*!50003 TRIGGER `TG_BeforeInsert` BEFORE INSERT ON `Word` FOR EACH ROW SET NEW.lowerWord = LOWER(NEW.word) */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Dumping routines for database 'JSONDB'
--
/*!50003 DROP FUNCTION IF EXISTS `getPathByValue` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`brett`@`%` FUNCTION `getPathByValue`(
   valueId BIGINT,
   userId BIGINT
) RETURNS text CHARSET utf8mb4
    READS SQL DATA
BEGIN

   DECLARE _valueId BIGINT;
   DECLARE _userId BIGINT;
   DECLARE _parentValueId BIGINT;
   DECLARE _path TEXT;
   
   SET _valueId = valueId,
            _userId = userId;
   
   SET _parentValueId = (
         SELECT   Value.parentValueId
         FROM     Value
         WHERE  Value.valueId = _valueId
         AND         Value.ownerId = _userId
      );
      
   SET _path = '';
   
   WHILE (_valueId IS NOT NULL 
   AND
                   _parentValueId IS NOT NULL) DO
                   
      SET _path = CONCAT(
         getSegmentByValue(_valueId, _userId),
         '/', 
         _path
      );
      SET _valueId = (
         SELECT   Value.parentValueId
         FROM     Value
         WHERE  Value.valueId = _valueId
         AND         Value.ownerId = _userId
      );
      
      SET _parentValueId = (
         SELECT   Value.parentValueId
         FROM     Value
         WHERE  Value.valueId = _valueId
         AND        Value.ownerId = _userId
      );
    
   END WHILE;

   SET _path = CONCAT('/my/', _path);
   
   /* Remove trailing slash */
   SET _path = SUBSTR(_path, 1, LENGTH(_path) - 1);
   
   RETURN _path;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `getSegmentByValue` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`brett`@`%` FUNCTION `getSegmentByValue`(
   valueId BIGINT,
   userId BIGINT
) RETURNS text CHARSET utf8mb4
    READS SQL DATA
BEGIN

    DECLARE _valueId BIGINT;
    DECLARE _userId BIGINT;
    DECLARE _objectKey TEXT;
    DECLARE _segment TEXT;
    
    SET _valueId = valueId,
             _userId = userId;
    
    IF _valueId IS NULL THEN
       RETURN '';
    END IF;
    
    SET _objectKey = (
       SELECT
          Word.word AS objectKey
       FROM
           Value
       INNER JOIN
           Word
       ON
           Value.objectKeyWordId =
           Word.wordId
       WHERE
          Value.valueId = _valueId
       AND
          Value.ownerId = _userId
    );
    
    SET _segment = NULL;
    
    IF (_objectKey IS NULL) THEN
       SET _segment  = (
          SELECT CAST(Value.objectIndex AS CHAR)
          FROM   Value
          WHERE Value.valueId = _valueId
          AND       Value.ownerId = _userId
       );
    ELSE
       SET _segment = urlencode(_objectKey);
    END IF;

   RETURN _segment;
   
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `getSetting` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`brett`@`%` FUNCTION `getSetting`(
   settingCode NVARCHAR(256)
) RETURNS text CHARSET utf8mb4
    READS SQL DATA
BEGIN

   DECLARE _settingCode NVARCHAR(256);
   DECLARE _settingValue TEXT;
   
   SET _settingCode = settingCode;
   
   SET _settingValue = NULL;
   
  SELECT  Setting.settingValue
  INTO
      _settingValue
  FROM
       Setting
  WHERE
      Setting. settingCode = _settingCode;
   
   RETURN _settingValue;
      
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `isDelineator` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`brett`@`%` FUNCTION `isDelineator`(
       nchar TEXT
 ) RETURNS tinyint(1)
    DETERMINISTIC
BEGIN

   DECLARE delineators TEXT;
   
   SET delineators = ",“.”\'()*\'\"{}:;!?~`|[] \t\r\n\b\\";
            
   RETURN IF(INSTR(delineators, nchar) > 0, 1, 0);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `urlencode` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`brett`@`%` FUNCTION `urlencode`(original_text text) RETURNS text CHARSET utf8mb4
    DETERMINISTIC
BEGIN

  SET @text = original_text;
  
  SET @text = REPLACE(@text, '/', '%2F');
  /*
  SET @text = REPLACE(@text, ' ', '%20');
  */
  RETURN @text;
  /*
	declare new_text text DEFAULT NULL;
	declare current_char text DEFAULT '';
	declare ascii_current_char int DEFAULT 0;
	declare pointer int DEFAULT 1;
	declare hex_pointer int DEFAULT 1;
	
	IF original_text IS NOT NULL then
		SET new_text = '';
		while pointer <= char_length(original_text) do
			SET current_char = mid(original_text,pointer,1);
			SET ascii_current_char = ascii(current_char);
			IF current_char = ' ' then
				SET current_char = '+';
			ELSEIF NOT (ascii_current_char BETWEEN 48 AND 57 || ascii_current_char BETWEEN 65 AND 90 || ascii_current_char BETWEEN 97 AND 122
									 || ascii_current_char = 45 || ascii_current_char = 95 || ascii_current_char = 46 || ascii_current_char = 126
									 || ascii_current_char = 34
									) then
				SET current_char = hex(current_char);
				SET hex_pointer = char_length(current_char)-1;
				while hex_pointer > 0 do
					SET current_char = INSERT(current_char, hex_pointer, 0, "%");
					SET hex_pointer = hex_pointer - 2;
				end while;
			end IF;
			SET new_text = concat(new_text,current_char);
			SET pointer = pointer + 1;
		end while;
	end IF;
	
	RETURN new_text;
*/
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `userEmailExists` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`brett`@`%` FUNCTION `userEmailExists`( 
    email NVARCHAR ( 320 )
 ) RETURNS tinyint(1)
    READS SQL DATA
BEGIN

   DECLARE _email NVARCHAR(320);
   DECLARE _count BIGINT;
   DECLARE _emailExists TINYINT;
   
   SET _email = email;
    
   SET       _count  = (
      SELECT   COUNT(*)
      FROM     User
      WHERE  User.userEmail = _email
      AND        User.validated = 1
   );
   
   IF _count IS NULL THEN
      SET _count = 0;
   END IF;
   
   IF _count = 1 THEN
      SET _emailExists = 1;
   ELSE
      SET _emailExists = 0;
   END IF;
   
   RETURN _emailExists;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `authenticate` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`brett`@`%` PROCEDURE `authenticate`(
   sessionKey VARCHAR(32),
   ipAddress VARCHAR(15),
   ignoreExpires TINYINT
)
BEGIN

   DECLARE _sessionKey VARCHAR(32);
   DECLARE _ipAddress VARCHAR(15);
   DECLARE _ignoreExpires TINYINT;
   DECLARE _timeout BIGINT;
   DECLARE _expiresDate DATETIME;
   DECLARE _expiresSeconds BIGINT;
   DECLARE _lastAccessedDate DATETIME;
   
   
   START TRANSACTION;
   
   SET
        _sessionKey = sessionKey,
        _ipAddress = ipAddress,
        _ignoreExpires = ignoreExpires,
        _timeout = CAST(
            getSetting(N'SESSION_TIMEOUT')
            AS UNSIGNED
        );
       
    IF EXISTS(
       SELECT *
       FROM   Session
       WHERE  Session.sessionKey = _sessionKey
       AND         Session.ipAddress = _ipAddress
       FOR UPDATE
    ) THEN
     
       SELECT   Session.lastAccessedDate
       INTO     _lastAccessedDate
       FROM     Session
       WHERE    Session.sessionKey = _sessionKey;
       
       SET _expiresDate = DATE_ADD(
          _lastAccessedDate,
          INTERVAL _timeout SECOND
       );
       
       IF _ignoreExpires = 1 OR _expiresDate > NOW()
       THEN
          UPDATE  Session
          SET     Session.lastAccessedDate = NOW(),
                  Session.ipAddress = _ipAddress
          WHERE   Session.sessionKey =  _sessionKey;
       ELSE
          SET _sessionKey = NULL;
       END IF;
       
    ELSE
       SET _sessionKey = NULL;
    END IF;
    
    SET _expiresSeconds  =
      UNIX_TIMESTAMP(
         DATE_ADD(
            NOW(),
            INTERVAL _timeout SECOND
         )
      )  * 1000;
   

    SELECT  Session.sessionKey,
            Session.userId,
            User.userEmail ,
            _expiresSeconds
                as expires
    FROM    Session
    INNER JOIN
            User
    ON      User.userId = Session.userId
    WHERE   Session.sessionKey =
            _sessionKey;
   
  COMMIT;
      
   
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `changeSecret` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`brett`@`%` PROCEDURE `changeSecret`(
   email NVARCHAR(320),
   oldSecret TEXT,
   newSecret TEXT
)
BEGIN

   DECLARE _email NVARCHAR(320);
   DECLARE _oldSecret TEXT;
   DECLARE _newSecret TEXT;
   DECLARE _result TINYINT;
   DECLARE _userId BIGINT;
 
   START TRANSACTION;
   
   SET _email = email;
   SET _oldSecret = oldSecret;
   SET _newSecret = newSecret;
   
   SET _result = 0;
   
   SET                _userId = (
      SELECT          User.userId
      FROM             User
      WHERE          User.userEmail = _email
      AND                 User.validated = 1
      AND                 User.logonSecret = _oldSecret
      
   );
   
   IF _userId IS NOT NULL 
   THEN
      UPDATE  User
      SET           User. logonSecret = _newSecret
      WHERE   User.userId = _userId;
      SET _result = 1;
   END IF;
   
   
   SELECT _result as result;
                    
   COMMIT;
   
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `createUser` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`brett`@`%` PROCEDURE `createUser`(
   email NVARCHAR(320),
   secret TEXT
)
BEGIN

   DECLARE _email NVARCHAR(320);
   DECLARE _secret TEXT;
   DECLARE _userId BIGINT;
   
   SET _email = email;
   SET _secret = secret;
   SET _userId = NULL;
  
   IF NOT EXISTS(
         SELECT *
         FROM    User
         WHERE   User.userEmail = _email
         FOR UPDATE)
   THEN
         
      INSERT INTO User(
         userEmail,
         logonSecret,
         newUserSecret,
         validated )
      VALUES  (_email, _secret, MD5(UUID()), 0 );
     
     SET _userId = LAST_INSERT_ID();
     
   ELSEIF EXISTS(
         SELECT   *
         FROM     User
         WHERE  User.userEmail = _email
         AND        validated = 0
         FOR UPDATE
   ) THEN
        UPDATE   User
        SET             logonSecret = _secret,
                             newUserSecret = MD5(UUID())
        WHERE    User.userEmail = _email;
        
        SET _userId = (
           SELECT userId
           FROM    User
           WHERE User.userEmail = _email
           FOR UPDATE
        );
        
   END IF;
   
   
   SELECT   userId,
                      newUserSecret
   FROM     User
   WHERE  User.userId = _userId;
   
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `deleteChildValues` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`brett`@`%` PROCEDURE `deleteChildValues`(
   valueId BIGINT
)
BEGIN

   DECLARE _valueId BIGINT;
   
   SET _valueId = valueId;
   
   DELETE
   FROM      Value
   WHERE   Value.parentValueId = _valueId;
   
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `deleteLockedValues` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`brett`@`%` PROCEDURE `deleteLockedValues`(
    lockedValueId BIGINT
)
BEGIN

     DECLARE _lockedValueId BIGINT;
     
     SET _lockedValueId = lockedValueId;
   
     DELETE
     FROM
         Value
     WHERE
         Value.valueId = _lockedValueId;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `deleteValue` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`brett`@`%` PROCEDURE `deleteValue`(
   valueId BIGINT
)
BEGIN

      DECLARE _valueId BIGINT;
      
      SET _valueId = valueId;
      
      DELETE
      FROM      Value
      WHERE   Value.valueId = _valueId;
   
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `endDocument` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`brett`@`%` PROCEDURE `endDocument`(
    ownerId BIGINT,
    replaceValueId BIGINT,
    lockedValueId  BIGINT,
    parentValueId BIGINT,
    stagingValueId BIGINT,
    appendToArray BIGINT
)
BEGIN

    DECLARE _ownerId BIGINT;
    DECLARE _replaceValueId BIGINT;
    DECLARE _lockedValueId BIGINT;
    DECLARE _parentValueId BIGINT;
    DECLARE _stagingValueId BIGINT;
    DECLARE _appendToArray BIGINT;
    DECLARE _objectIndex BIGINT;
    
    SET  _ownerId = ownerId,
              _replaceValueId = replaceValueId,
              _lockedValueId = lockedValueId,
              _parentValueId = parentValueId,
              _stagingValueId = stagingValueId,
              _appendToArray = appendToArray,
              _objectIndex = NULL;
              
  START TRANSACTION;
  
  IF (_appendToArray = 1) THEN
        SELECT
            COUNT(*) + 1
        INTO
            _objectIndex
        FROM
            Value
        WHERE
            Value.ownerId = _ownerId
        AND
            Value.parentValueId =
                _parentValueId
        AND
            Value.locked = 0
        FOR UPDATE;
        
        IF (_objectIndex IS NULL) THEN
            SET _objectIndex = 1;
        END IF;
        
        UPDATE
            Value
        SET
            Value.objectIndex = _objectIndex
        WHERE
            Value.valueId = _stagingValueId;
       
   END IF;
   
    IF (_appendToArray = 0) THEN
    
        UPDATE
            Value
        SET
            Value.locked = NULL
        WHERE
            Value.valueId =  _replaceValueId;
            
    END IF;
  
        DELETE
        FROM
           Value
        WHERE
           Value.valueId = _replaceValueId;
  
    
    UPDATE
            Value
    SET
            Value.locked = 0
    WHERE
            Value.valueId = _lockedValueId;
    
    COMMIT;
    
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `getCountByParentValueId` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`brett`@`%` PROCEDURE `getCountByParentValueId`(
    userId BIGINT,
    parentValueId BIGINT
)
BEGIN

    DECLARE _userId BIGINT;
    DECLARE _parentValueId BIGINT;
    
    SET _userId = userId,
             _parentValueId = parentValueId;
             
    SELECT
        COUNT(*)
    FROM
        Value
    WHERE
        Value.ownerId = _userId
    AND
        Value.locked = 0
    AND
        Value.parentValueId = _parentValueId;
        
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `getRootValueId` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`brett`@`%` PROCEDURE `getRootValueId`(
   userId BIGINT,
   ownerId BIGINT
)
BEGIN

   DECLARE _userId BIGINT;
   DECLARE _ownerId BIGINT;
   
   SET _userId = userId,
            _ownerId = ownerId;
   
   SELECT Value.valueId,
                    Value.type
   FROM   Value
   WHERE Value.ownerId = _ownerId
   AND       Value.parentValueId IS NULL
   AND       Value.locked = 0;


END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `getValueId` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`brett`@`%` PROCEDURE `getValueId`(
   ownerId BIGINT,
   parentValueId BIGINT,
   objectIndex BIGINT,
   objectKey TEXT
)
BEGIN

   DECLARE _ownerId BIGINT;
   DECLARE _parentValueId BIGINT;
   DECLARE _objectIndex BIGINT;
   DECLARE _objectKey TEXT;
   DECLARE _objectKeyWordId BIGINT;
   DECLARE _valueId BIGINT;
   DECLARE _type VARCHAR(10);
   DECLARE _locked TINYINT;
   
   SET _ownerId = ownerId,
            _parentValueId = parentValueId,
            _objectIndex = objectIndex,
            _objectKey = objectKey,
            _objectKeyWordId = NULL,
            _valueId = NULL,
            _type = NULL,
            _locked = NULL;
        
            
    IF _objectKey IS NOT NULL THEN
        SELECT
            Word.wordId
        INTO
            _objectKeyWordId
        FROM
            Word
        WHERE
            Word.word = _objectKey;
            
        SELECT
            v.locked
        INTO
            _locked
        FROM
            Value AS v
        WHERE 
            v.ownerId = _ownerId
        AND
           v.parentValueId = 
               _parentValueId
       AND
           v.objectKeyWordId = _objectKeyWordId
       AND
           v.locked = 1;

       SELECT
            v.valueId
        INTO
            _valueId
        FROM
            Value AS v
        WHERE
            v.ownerId = _ownerId
         AND
             v.parentValueId = 
               _parentValueId
       AND
           v.objectKeyWordId = _objectKeyWordId
       AND
           v.locked = 0;
    
   ELSE
        SELECT
            v.locked
        INTO
            _locked
        FROM
            Value AS v
        WHERE 
            v.ownerId = _ownerId
        AND
           v.parentValueId = 
               _parentValueId
       AND
              v.objectIndex = _objectIndex
       AND
              v.locked = 1;

       SELECT
            v.valueId
        INTO
            _valueId
        FROM
            Value AS v
        WHERE
            v.ownerId = _ownerId
        AND
            v.parentValueId = 
               _parentValueId
       AND
              v.objectIndex = _objectIndex
       AND
              v.locked = 0;
   END IF;
   
   
   IF _valueId IS NOT NULL THEN
       SELECT
            v.type,
            v.objectIndex,
            w.word
       INTO
           _type,
           _objectIndex,
           _objectKey
       FROM
           Value AS v
       LEFT JOIN
           Word as w
       ON
           v.objectKeyWordId = w.wordId
       WHERE
           v.valueId = _valueId;
    END IF;
           
   IF _locked IS NULL THEN
       SET _locked = 0;
   END IF;
   
   SELECT
            _valueId AS valueId,
            _type AS type,
            _locked as locked,
            _objectIndex AS objectIndex,
            _objectKey AS objectKey;
            
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `getValueIdByPath` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`brett`@`%` PROCEDURE `getValueIdByPath`(
   userId BIGINT,
   ownerId BIGINT,
   parentValueId BIGINT,
   objectIndex BIGINT,
   objectKey TEXT
)
BEGIN

   DECLARE _userId BIGINT;
   DECLARE _ownerId BIGINT;
   DECLARE _parentValueId BIGINT;
   DECLARE _objectIndex BIGINT;
   DECLARE _objectKey TEXT;
   DECLARE _objectKeyWordId BIGINT;
   
   
   SET
      _userId = userId,
      _ownerId = ownerId,
      _parentValueId = parentValueId,
      _objectIndex = objectIndex,
      _objectKey = objectKey,
      _objectKeyWordId = NULL;
   
   IF _objectKey IS NOT NULL THEN
       SELECT
           Word.wordId
       INTO
           _objectKeyWordId
       FROM
           Word
       WHERE
           Word.word = _objectKey;
           
   END IF;
   
   SELECT
       Value.valueId,
       Value.type
   FROM
       Value
   WHERE
        Value.ownerId = _ownerId
   AND
                     ( 
                               (
                                  _parentValueId IS NULL
                                  AND
                                  Value.parentValueId IS NULL
                               ) 
                               OR
                              (Value.parentValueId = 
                                    _parentValueId)
                        )
   AND            (_objectIndex IS NULL
                         OR
                          Value.objectIndex = _objectIndex)
   AND            (_objectKey IS NULL
                          OR
                         Value.objectKeyWordId  =
                           _objectKeyWordId)
  AND            Value.locked = 0
   -- THIS SECURITY CHECK WILL COME LATER
   AND           _ownerId = _userId;
   
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `getValuesById` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`brett`@`%` PROCEDURE `getValuesById`(
   ownerId BIGINT,
   valueId BIGINT
)
BEGIN

   DECLARE _ownerId BIGINT;
   DECLARE _valueId BIGINT;
   
   SET _ownerId = ownerId,
            _valueId = valueId;
            
   SELECT         Value.*,
                            (
                                SELECT
                                    Word.word
                                FROM
                                    Word
                                WHERE
                                    Word.wordId = 
                                    Value.objectKeyWordId
                            ) AS objectKey,
                            (
                                SELECT
                                    Word.word
                                FROM
                                    Word
                                WHERE
                                    Word.wordId = 
                                    Value.stringValueWordId
                            ) AS stringValue,
                            (
                               SELECT      COUNT(*)
                               FROM         Value AS Child
                               WHERE      
                                       Child.ownerId = 
                                       _ownerId
                               AND
                                        Child.parentValueId =
                                        Value.valueId
                               AND
                                        Child.locked = 0
                            ) AS childCount
   FROM            Value
   WHERE         Value.valueId =  _valueId
   AND                Value.ownerId = _ownerId;
   
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `getValuesByParentId` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`brett`@`%` PROCEDURE `getValuesByParentId`(
   ownerId BIGINT,
   parentValueId BIGINT
)
BEGIN

   DECLARE _ownerId BIGINT;
   DECLARE _parentValueId BIGINT;
   
   SET _parentValueId = parentValueId,
            _ownerId = ownerId;
   
   SELECT         Value.*,
                            (
                                SELECT
                                    Word.word
                                FROM
                                    Word
                                WHERE
                                    Word.wordId = 
                                    Value.objectKeyWordId
                            ) AS objectKey,
                            (
                                SELECT
                                    Word.word
                                FROM
                                    Word
                                WHERE
                                    Word.wordId = 
                                    Value.stringValueWordId
                            ) AS stringValue,
                            (
                               SELECT      COUNT(*)
                               FROM         Value AS Child
                               WHERE      
                                       Child.ownerId = 
                                       _ownerId
                               AND
                                        Child.parentValueId =
                                        Value.valueId
                               AND
                                        Child.locked = 0
                            ) AS childCount
   FROM            Value
   WHERE        Value.ownerId = _ownerId
   AND
                            Value.parentValueId = 
                            _parentValueId
   AND               Value.locked = 0
   ORDER BY   Value.objectIndex;
   
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `insertParentValueWords` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`brett`@`%` PROCEDURE `insertParentValueWords`(
    valueId BIGINT
)
BEGIN

    DECLARE _valueId BIGINT;
    
    SET _valueId = valueId;
    
    INSERT
    INTO
            ValueWord(
                valueId,
                wordId
            )
    SELECT
        _valueId,
        ValueWord.wordId
    FROM
        Value
    INNER JOIN
        ValueWord
    ON
        ValueWord.valueId = Value.parentValueId
    WHERE
        Value.valueId = $valueId
    AND
        NOT EXISTS(
            SELECT
                *
            FROM
               Value as v
            INNER JOIN
               ValueWord AS vw
            ON
                vw.valueId = v.parentValueId
            WHERE
                v.valueId = _valueId
            AND
                vw.wordId = ValueWord.wordId
        );
        
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `insertValue` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`brett`@`%` PROCEDURE `insertValue`(
           ownerId BIGINT,
           parentValueId BIGINT,
           replaceValueId BIGINT,
           locked TINYINT,
           type VARCHAR(10),
           objectIndex BIGINT,
           objectKey TEXT,
           isNull TINYINT,
           stringValue TEXT,
           numericValue DOUBLE,
           boolValue TINYINT
)
BEGIN

    DECLARE _ownerId BIGINT;
    DECLARE _parentValueId BIGINT;
    DECLARE _replaceValueId BIGINT;
    DECLARE _locked TINYINT;
    DECLARE _type VARCHAR(10);
    DECLARE _objectIndex BIGINT;
    DECLARE _objectKey TEXT;
    DECLARE _isNull TINYINT;
    DECLARE _stringValue TEXT;
    DECLARE _numericValue DOUBLE;
    DECLARE _boolValue TINYINT;
    DECLARE _objectKeyWordId BIGINT;
    DECLARE _stringValueWordId BIGINT;
    DECLARE _valueId BIGINT;
    DECLARE _stagingValueId BIGINT;
    
    SET _ownerId = ownerId, 
             _parentValueId =  parentValueId,
             _replaceValueId = replaceValueId,
             _locked = locked,
             _type = type,
             _objectIndex = objectIndex,
             _objectKey =  objectKey,
             _isNull =  isNull,
             _stringValue = stringValue,
             _numericValue = numericValue,
             _boolValue = boolValue,
             _objectKeyWordId = NULL,
             _stringValueWordId = NULL;
   
    IF _objectKey IS NOT NULL THEN
        CALL insertWord(
            _objectKey,
            _objectKeyWordId
        );
        CALL insertValueWords(
            _objectKey,
            null
        );
    END IF;
    
    IF _stringValue IS NOT NULL THEN
        CALL insertWord(
            _stringValue,
            _stringValueWordId
        );
        CALL insertValueWords(
            _stringValue,
            null
        );
    END IF;
    
    START TRANSACTION;
    
    IF _objectIndex IS NULL THEN
    
        IF _replaceValueId IS NOT NULL AND
                _locked = 1
        THEN
            SELECT
                Value.objectIndex
            INTO
                _objectIndex
            FROM
                Value
            WHERE 
                Value.valueId = _replaceValueId
            FOR UPDATE;
        ELSEIF _objectKey IS NOT NULL
        THEN
            SELECT
                Value.objectIndex
            INTO
                _objectIndex
            FROM
                Value
            WHERE
                Value.parentValueId = _parentValueId
            AND
                Value.objectKeyWordId = _objectKeyWordId
            FOR UPDATE;
        END IF;
    END IF;
    
    IF _objectIndex IS NULL
    THEN
    
            SELECT
                COUNT(Value.objectIndex) + 1
            INTO
                _objectIndex
            FROM
                Value
            WHERE 
                 Value.parentValueId =
                 _parentValueId
            FOR UPDATE;
        
    END IF;
    
    IF _objectIndex IS NULL THEN
        SET _objectIndex = 1;
    END IF;
       
    INSERT INTO Value(
           ownerId,
           parentValueId,
           locked,
           type,
           objectIndex,
           objectKeyWordId,
           isNull,
           stringValueWordId,
           numericValue,
           boolValue
  )
  VALUES(
           _ownerId,
           _parentValueId,
           _locked,
           _type,
           _objectIndex,
           _objectKeyWordId,
           _isNull,
           _stringValueWordId,
           _numericValue,
           _boolValue
   );
  
   SET _valueId = LAST_INSERT_ID();
  
   SET _stagingValueId = _valueId;
   
   CALL insertValueParentChild(
        _stagingValueId,
        _parentValueId
   );
     
    
    IF _objectKey IS NOT NULL THEN
        CALL insertValueWords(
            _objectKey,
            _valueId
        );
    END IF;
    
    IF _stringValue IS NOT NULL THEN
        CALL insertValueWords(
            _stringValue,
            _valueId
        );
    END IF;
   
   COMMIT;
   
   SELECT
       _valueId AS  valueId,
       _objectIndex AS objectIndex;
       
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `insertValueParentChild` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`brett`@`%` PROCEDURE `insertValueParentChild`(
    stagingValueId BIGINT,
    parentValueId BIGINT
)
BEGIN

    DECLARE _stagingValueId BIGINT;
    DECLARE _parentValueId BIGINT;
    
    SET
        _stagingValueId = stagingValueId,
        _parentValueId = parentValueId;
      
    INSERT INTO
        ValueParentChild(
            parentValueId,
            childValueId
        )
    SELECT
        ValueParentChild.parentValueId,
        _stagingValueId
    FROM
        ValueParentChild
    WHERE
        ValueParentChild.childValueId =
        _parentValueId;
        
    INSERT INTO
        ValueParentChild(
            parentValueId,
            childValueId
        )
    SELECT
        _stagingValueId,
        _stagingValueId;
    
    
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `insertValueWord` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`brett`@`%` PROCEDURE `insertValueWord`(
    word TEXT,
    valueId BIGINT,
    OUT wordId BIGINT
)
BEGIN

    DECLARE _valueId BIGINT;
    DECLARE _word TEXT;
    DECLARE _wordId BIGINT;
    
    SET _valueId = valueId,
             _word = word,
             _wordId = NULL;
             
    CALL insertWord(
        _word,
        _wordId
    );
 
    INSERT
    INTO
        ValueWord(
            valueId,
            wordId
         )
    SELECT 
         _valueId,
         _wordId
     WHERE
         NOT EXISTS(
             SELECT
                *
             FROM
                ValueWord
            WHERE
                ValueWord.valueId = _valueId
            AND
                ValueWord.wordId = _wordId
        );
        
     SET wordId = _wordId;
       
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `insertValueWords` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`brett`@`%` PROCEDURE `insertValueWords`(
    text TEXT,
    valueId BIGINT
)
exit_procedure: BEGIN
  
   
   DECLARE _text TEXT;
   DECLARE _valueId BIGINT;
   DECLARE _word TEXT;
   DECLARE _start BIGINT;
   DECLARE _length BIGINT;
   DECLARE _insertWordsOnly TINYINT;
   DECLARE _nchar TEXT;
   DECLARE _wordId BIGINT;
   
   SET _text = text;
   
   IF _text IS NULL THEN
       LEAVE exit_procedure;
   END IF;
   
   SET  _valueId = valueId,
            _word = NULL,
            _start = 1,
            _length = LENGTH(_text),
            _insertWordsOnly = NULL,
            _nchar = NULL;
            
  IF _valueId IS NULL THEN
          SET _insertWordsOnly = 1;
  ELSE
          SET _insertWordsOnly = 0;
  END IF;

   WHILE (_start <= _length) DO
         # Read first character
         SET _nchar = SUBSTR(
               _text,
               _start,
               1
         );
         # Read subsequent delineators 
         WHILE (isDelineator(_nchar) AND
                          _start <= _length) DO
               SET _start = _start + 1;
               SET _nchar = SUBSTR(
                     _text,
                     _start,
                     1
               );
         END WHILE;
         
         
         # Read word 
         SET _word = '';
         WHILE (isDelineator(_nchar) = 0 AND
                          _start <= _length) DO
              SET _word = CONCAT(_word, _nchar);
              SET _start = _start + 1;
              SET _nchar = SUBSTR(
                     _text,
                     _start,
                     1
               );
        END WHILE;
                          
        IF ( LENGTH(_word) > 0) THEN
        
            IF (_insertWordsOnly = 1) THEN
                CALL insertWord(_word, _wordId);
            ELSE
                CALL insertValueWord(
                    _word,
                    _valueId,
                    _wordId
                );
            END IF;
            
        END IF;
              
   END WHILE;
   
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `insertWord` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`brett`@`%` PROCEDURE `insertWord`(
    word TEXT,
    OUT wordId BIGINT
)
BEGIN

    DECLARE _word TEXT;
    DECLARE _wordId BIGINT;
    
    SET _word = word;
    
    INSERT
    INTO
        Word(
            word
        )
    SELECT
        _word
     WHERE
         NOT EXISTS(
             SELECT
                 *
             FROM
                 Word
             WHERE
                 Word.word = _word
         );
         
     SELECT
          Word.wordId
      INTO
          _wordId
      FROM
          Word
      WHERE
          Word.word = _word;
          
      SET wordId = _wordId;
      
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `logoff` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`brett`@`%` PROCEDURE `logoff`(
   sessionKey VARCHAR(32)
)
BEGIN
   DECLARE _sessionKey VARCHAR(32);
   
   SET _sessionKey = sessionKey;
   
   START TRANSACTION;
   
   DELETE
   FROM      Session
   WHERE   Session.sessionKey = _sessionKey;
   
   COMMIT;
   
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `logon` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`brett`@`%` PROCEDURE `logon`(
   email NVARCHAR(320),
   secret TEXT,
   ipAddress VARCHAR(15)
)
BEGIN

   DECLARE _email NVARCHAR(320);
   DECLARE _secret TEXT;
   DECLARE _ipAddress VARCHAR(15);
   DECLARE _timeout BIGINT;
   DECLARE _userId BIGINT;
   DECLARE _sessionKey VARCHAR(32);
   DECLARE _expiresSeconds BIGINT;
   
   START TRANSACTION;
   
   SET _email = email;
   SET _secret = secret;
   SET _ipAddress = ipAddress;
   SET _timeout = CAST(
              getSetting(N'SESSION_TIMEOUT')
                 AS UNSIGNED
             );
   SET                _userId = (
      SELECT          User.userId
      FROM             User
      WHERE          User.userEmail = _email
      AND                 User.newUserSecret IS NULL
      AND                 User.logonSecret = _secret
      
   );
   

   SET _sessionKey = MD5(UUID());
   
   IF _userId IS NOT NULL 
   THEN
       /* Delete expired sessions */
      DELETE
      FROM     Session
      WHERE   Session.userId = _userId
      AND         Session.lastAccessedDate <
                         DATE_ADD(
                            NOW(),
                            INTERVAL (-@timeout)
                            SECOND
                         );
   
      INSERT
      INTO      Session(
                          sessionKey,
                          userId,
                          ipAddress,
                          createdDate,
                          lastAccessedDate
                       )
      VALUES (
                      _sessionKey, 
                      _userId, 
                      _ipAddress,
                      NOW(),
                      NOW()
                   );
      
   ELSE
      SET _sessionKey = NULL;
   END IF;
   
   SET _expiresSeconds  =
      UNIX_TIMESTAMP(
         DATE_ADD(
            NOW(),
            INTERVAL _timeout SECOND
         )
      ) * 1000;
   
   
   COMMIT; 
   
   SELECT _userId as userId,
                    _sessionKey as sessionKey,
                   _expiresSeconds  as expires;
                   
   
   
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `lostSecret` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`brett`@`%` PROCEDURE `lostSecret`(
   email NVARCHAR(320)
)
BEGIN

   DECLARE _email NVARCHAR(320);
   
   START TRANSACTION;
   
   SET _email = email;
   
   UPDATE   User
   SET            User. lostSecret = MD5(UUID())
   WHERE    User.userEmail = _email;
   
   
   SELECT   lostSecret
   FROM     User
   WHERE   User.userEmail = _email;
    
   COMMIT;
   
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `resetSecret` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`brett`@`%` PROCEDURE `resetSecret`(
   email NVARCHAR(320),
   lostSecret VARCHAR(32),
   newSecret TEXT
)
BEGIN

   START TRANSACTION;
   
   SET @email = email;
   SET @lostSecret = lostSecret;
   SET @newSecret = newSecret;
   
   SET   @userId = (
      SELECT   userId
      FROM     User
      WHERE  User.userEmail = @email
      AND        User. lostSecret = @lostSecret
   );
  
   IF NOT ISNULL( @userId) THEN
      UPDATE   User
      SET             logonSecret = @newSecret,
                           lostSecret = NULL
      WHERE    User.userId = @userId;
   END IF;
   
   SELECT   NOT ISNULL(@userId)
   AS              response;
   
   COMMIT;
   
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `updateValue` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`brett`@`%` PROCEDURE `updateValue`(
           valueId BIGINT,
           ownerId BIGINT,
           locked TINYINT,
           type VARCHAR(10),
           objectKey TEXT,
           isNull TINYINT,
           stringValue TEXT,
           numericValue DOUBLE,
           boolValue TINYINT
)
BEGIN

    DECLARE _valueId BIGINT;
    DECLARE _ownerId BIGINT;
    DECLARE _locked TINYINT;
    DECLARE _type VARCHAR(10);
    DECLARE _objectKey TEXT;
    DECLARE _isNull TINYINT;
    DECLARE _stringValue TEXT;
    DECLARE _numericValue DOUBLE;
    DECLARE _boolValue TINYINT;
    DECLARE _objectKeyWordId BIGINT;
    DECLARE _stringValueWordId BIGINT;
    
    SET _valueId = valueId,
             _ownerId = ownerId,
             _locked = locked,
             _type = type,
             _objectKey = objectKey,
             _isNull =  isNull,
             _stringValue = stringValue,
             _numericValue = numericValue,
             _boolValue = boolValue,
             _objectKeyWordId = NULL,
             _stringValueWordId = NULL;
          
    
    IF _objectKey IS NOT NULL THEN
    
        CALL insertWord(
            _objectKey,
            _objectKeyWordId
        );
        
        CALL insertValueWords(
            _objectKey,
            null
        );
        
    END IF;
    
    
    
    IF _stringValue IS NOT NULL THEN
        CALL insertWord(
            _stringValue,
            _stringValueWordId
        );
        CALL insertValueWords(
            _stringValue,
            null
        );
    END IF;
    
   START TRANSACTION;
    
   DELETE
   FROM
       Value
   WHERE
       Value.parentValueId = _valueId;
  
   DELETE
    FROM
          ValueWord
    WHERE
         ValueWord.valueId = _valueId;
           
   UPDATE Value
   SET
           Value.ownerId = _ownerId,
           Value.locked = _locked,
           Value.type = _type,
           Value.objectKeyWordId =
               _objectKeyWordId,
           Value.isNull = _isNull,
           Value.stringValueWordId = 
               _stringValueWordId,
           Value.numericValue = _numericValue,
           Value.boolValue = _boolValue
   WHERE
           Value.valueId = _valueId;
     
    IF _objectKey IS NOT NULL THEN
        CALL insertValueWords(
            _objectKey,
            _valueId
        );
    END IF;
    
    IF _stringValue IS NOT NULL THEN
        CALL insertValueWords(
            _stringValue,
            _valueId
        );
    END IF;
   
    COMMIT;
    
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `validateUserEmail` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`brett`@`%` PROCEDURE `validateUserEmail`(
   email NVARCHAR(320),
   newUserSecret VARCHAR(32)
)
BEGIN

   
   DECLARE _email NVARCHAR(320);
   DECLARE _newUserSecret VARCHAR(32);
   DECLARE _userId BIGINT;
   
   START TRANSACTION;
   
   SET _email = email;
   SET _newUserSecret = newUserSecret;
   SET _userId = (
      SELECT   userId
      FROM      User
      WHERE   User.userEmail = _email
      AND         User.newUserSecret = _newUserSecret
      FOR UPDATE
   );
   
   
   
   IF NOT ISNULL(_userId) THEN
      UPDATE   User
      SET             newUserSecret = NULL,
                           validated = 1
      WHERE    User.userId = _userId;
   END IF;
   
   COMMIT;
   
   SELECT IF(ISNULL(_userId), 0, 1)
   AS            validated;
   
   
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-12-29 13:39:02
