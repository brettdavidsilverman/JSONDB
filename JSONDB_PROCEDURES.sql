-- MySQL dump 10.13  Distrib 8.4.4, for Linux (x86_64)
--
-- Host: localhost    Database: JSONDB
-- ------------------------------------------------------
-- Server version	8.4.4

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
/*!50032 DROP TRIGGER IF EXISTS TG_Value_Insert */;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`brett`@`%`*/ /*!50003 TRIGGER `TG_Value_Insert` AFTER INSERT ON `Value` FOR EACH ROW BEGIN

      SET @valueId = NEW.valueId;
      
      IF (NEW.objectKey IS NOT NULL) THEN
            CALL createValueWords(
                  @valueId,
                  LOWER(NEW.objectKey)
            );
      END IF;
      
      IF (NEW.stringValue IS NOT NULL) THEN
            CALL createValueWords(
                  @valueId,
                  LOWER(NEW.stringValue)
            );
      END IF;
      
      
      
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
/*!50032 DROP TRIGGER IF EXISTS TG_Value_Update */;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`brett`@`%`*/ /*!50003 TRIGGER `TG_Value_Update` AFTER UPDATE ON `Value` FOR EACH ROW BEGIN

      SET @deleted = 0;
      SET @valueId = NEW.valueId;
      
      IF ((OLD.objectKey IS NULL AND
            NEW.objectKey IS NOT NULL) OR
            (OLD.objectKey IS NOT NULL AND
            NEW.objectKey IS NULL) OR
            (OLD.objectKey != NEW.objectKey))
      THEN
      
            IF (OLD.objectKey IS NOT NULL) 
            THEN
                  DELETE
                  FROM       ValueWord
                  WHERE    ValueWord.valueId = 
                                       @valueId;
                  SET @deleted = 1;
            END IF;
                              
            IF (NEW.objectKey IS NOT NULL) 
            THEN
                  CALL createValueWords(
                        @valueId,
                        LOWER(NEW.objectKey)
                  );
            END IF;
      END IF;
      
      IF ((OLD.stringValue IS NULL AND
            NEW.stringValue IS NOT NULL) OR
            (OLD.stringValue IS NOT NULL AND
            NEW.stringValue IS NULL) OR
            (OLD.stringValue != NEW.stringValue)
            Or @deleted = 1)
      THEN
      
            IF (OLD.stringValue IS NOT NULL 
                  AND  @deleted = 0) 
            THEN
                  DELETE
                  FROM       ValueWord
                  WHERE    ValueWord.valueId = 
                                       @valueId;
            END IF;
                              
            IF (NEW.stringValue IS NOT NULL) 
            THEN
                  CALL createValueWords(
                        @valueId,
                        LOWER(NEW.stringValue)
                  );
            END IF;
      END IF;
      
END */;;
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
   valueId BIGINT
) RETURNS text CHARSET utf8mb4
BEGIN
   SET @valueId = valueId;
   
   SET @parentValueId = (
         SELECT   Value.parentValueId
         FROM     Value
         WHERE  Value.valueId = @valueId
      );
      
   SET @path = '';
   
   WHILE (@valueId IS NOT NULL AND
                   @parentValueId IS NOT NULL) DO
      SET @path = CONCAT(
         getSegmentByValue(@valueId),
         CONCAT('/', @path)
      );
      SET @valueId = (
         SELECT   Value.parentValueId
         FROM     Value
         WHERE  Value.valueId = @valueId
      );
      SET @parentValueId = (
         SELECT   Value.parentValueId
         FROM     Value
         WHERE  Value.valueId = @valueId
      );
    
   END WHILE;

   SET @path = CONCAT('/my/', @path);
   
   /* Remove trailing slash */
   SET @path = SUBSTR(@path, 1, LENGTH(@path) - 1);
   
   RETURN @path;
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
   valueId BIGINT
) RETURNS text CHARSET utf8mb4
BEGIN

    SET @valueId = valueId;
    
    IF @valueId IS NULL THEN
       RETURN '';
    END IF;
    
    SET @objectKey = (
       SELECT   objectKey
       FROM     Value
       WHERE   Value.valueId = @valueId
    );
    
    SET @segment = NULL;
    
    IF (@objectKey IS NULL) THEN
       SET @segment  = (
          SELECT CAST(Value.objectIndex AS CHAR)
          FROM   Value
          WHERE Value.valueId = @valueId
       );
    ELSE
       SET @segment = urlencode(@objectKey);
    END IF;

   RETURN @segment;
   
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

   SET @settingCode = settingCode;
   
   SET @settingValue = NULL;
   
   SET   @settingValue = (
      SELECT  settingValue
      FROM     Setting
      WHERE Setting. settingCode = @settingCode
   );
   
   RETURN @settingValue;
      
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `isChildValue` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`brett`@`%` FUNCTION `isChildValue`(
      parentValueId BIGINT,
      childValueId BIGINT
 ) RETURNS tinyint(1)
    READS SQL DATA
BEGIN
   SET @parentValueId = parentValueId,
            @childValueId = childValueId;
    
   IF (@parentValueId IS NULL) THEN
         RETURN 0;
   END IF;
   
   IF (@childValueId IS NULL) THEN
         RETURN 0;
   END IF;
   
   IF (@childValueId = @parentValueId) THEN
        RETURN 0;
   END IF;
   
   WHILE (@childValueId IS NOT NULL AND
                    @childValueId != @parentValueId) 
   DO
         SET      @childValueId = (
               SELECT      Value.parentValueId
               FROM         Value
               WHERE      Value.valueId = @childValueId
         );
   END WHILE;
   
   IF (@childValueId IS NULL) THEN
         RETURN 0;
  END IF;
  
   IF (@childValueId = @parentValueId) THEN
        RETURN 1;
   END IF;
   
   RETURN 0; 
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
       nchar TEXT ) RETURNS tinyint(1)
BEGIN
   SET @nchar = nchar,
            @delineators = ",“.”\'()*\'\"{}:;!?~`|[] \t\r\n\b\\";
            
   RETURN IF(INSTR(@delineators, @nchar) > 0, 1, 0);
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
BEGIN

  SET @text = original_text;
  
  SET @text = REPLACE(@text, '/', '%252F');
  SET @text = REPLACE(@text, ' ', '%20');
  
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
CREATE DEFINER=`brett`@`%` FUNCTION `userEmailExists`( email NVARCHAR ( 320 ) ) RETURNS tinyint(1)
    READS SQL DATA
BEGIN
   SET @email = email;
    
   SET       @emailExists = (
      SELECT   COUNT(*)
      FROM     User
      WHERE  User.userEmail = @email
      AND        User.validated = 1
   );
   
   RETURN @emailExists; 
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

  
   SET @sessionKey = sessionKey,
           @ipAddress = ipAddress,
           @ignoreExpires = ignoreExpires,
           @timeout = CAST(
                 getSetting(N'SESSION_TIMEOUT')
                 AS UNSIGNED
            );
       
    IF EXISTS(
       SELECT *
       FROM    Session
       WHERE Session.sessionKey = @sessionKey
       AND       Session.ipAddress = @ipAddress
    ) THEN
       SET   @lastAccessedDate = (
          SELECT   lastAccessedDate
          FROM      Session
          WHERE   Session. sessionKey = @sessionKey
       );
       
       SET @expires = DATE_ADD(
          @lastAccessedDate,
          INTERVAL @timeout SECOND
       );
       
       START TRANSACTION;
  
       IF @ignoreExpires = 1 OR @expires > NOW() THEN
          UPDATE   Session
          SET            lastAccessedDate = NOW()
          WHERE   Session.sessionKey =  @sessionKey;
       ELSE
          SET @sessionKey = NULL;
       END IF;
       
    ELSE
       SET @sessionKey = NULL;
    END IF;
    
    COMMIT;
    
    SET @expires  =
      UNIX_TIMESTAMP(
         DATE_ADD(
            NOW(),
            INTERVAL @timeout SECOND
         )
      )  * 1000;
   
    SELECT Session. sessionKey,
                      Session. userId,
                       @expires
                          as expires
   FROM      Session
   WHERE  Session. sessionKey = @sessionKey;
   
  
      
   
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

   START TRANSACTION;
   
   SET @email = email;
   SET @oldSecret = oldSecret;
   SET @newSecret = newSecret;
   
   SET @result = 0;
   
   SET                @userId = (
      SELECT          User.userId
      FROM             User
      WHERE          User.userEmail = @email
      AND                 User.validated = 1
      AND                 User.logonSecret = @oldSecret
      
   );
   
   IF @userId IS NOT NULL 
   THEN
      UPDATE  User
      SET           User. logonSecret = @newSecret
      WHERE   User.userId = @userId;
      SET @result = 1;
   END IF;
   
   
   SELECT @result as result;
                    
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

   
   
   SET @email = email;
   SET @secret = secret;
   SET @userId = NULL;
   
   START TRANSACTION;
   
   IF NOT EXISTS(
         SELECT *
         FROM    User
         WHERE   User.userEmail = @email)
   THEN
         
      INSERT INTO User(
         userEmail,
         logonSecret,
         newUserSecret,
         validated )
      VALUES  ( @email, @secret, MD5(UUID()), 0 );
     
     SET @userId = LAST_INSERT_ID();
     
   ELSEIF EXISTS(
         SELECT   *
         FROM     User
         WHERE  User.userEmail = @email
         AND        validated = 0
   ) THEN
        UPDATE   User
        SET             logonSecret = @secret,
                             newUserSecret = MD5(UUID())
        WHERE    User.userEmail = @email;
        
        SET @userId = (
           SELECT userId
           FROM    User
           WHERE User.userEmail = @email
        );
        
   END IF;
   
   COMMIT;
   
   SELECT   userId,
                      newUserSecret
   FROM     User
   WHERE  User.userId = @userId;
   
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `createValue` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`brett`@`%` PROCEDURE `createValue`(
           parentValueId BIGINT,
           ownerId BIGINT ,
           sessionKey VARCHAR(32),
           type VARCHAR(10),
           objectIndex BIGINT,
           objectKey TEXT,
           isNull TINYINT,
           stringValue TEXT,
           numericValue DOUBLE,
           boolValue TINYINT
)
exit_procedure: BEGIN

   SET @parentValueId = parentValueId,
            @ownerId = ownerId,
            @sessionKey = sessionKey,
            @type = type,
            @objectIndex = objectIndex,
            @objectKey = objectKey,
            @isNull = isNull,
            @stringValue = stringValue,
            @numericValue = numericValue,
            @boolValue = boolValue;
           
   SET @sessionId = (
              SELECT Session.sessionId
              FROM   Session
              WHERE Session.sessionKey =
                               @sessionKey
           );
           
   IF @sessionId IS NULL
   THEN
         LEAVE exit_procedure;
   END IF;
    
   START TRANSACTION; 
   
 
   INSERT INTO Value(
           parentValueId,
           ownerId,
           sessionId,
           type,
           objectIndex,
           objectKey,
           lowerObjectKey,
           isNull,
           stringValue,
           numericValue,
           boolValue
  )
  VALUES(
           @parentValueId,
           @ownerId,
           @sessionId,
           @type,
           @objectIndex,
           @objectKey,
           LOWER(@objectKey),
           @isNull,
           @stringValue,
           @numericValue,
           @boolValue
   );
   
   SET @valueId = LAST_INSERT_ID();
   

   /* Insert all parents parents */
   
   INSERT
   INTO       ValueParentChild(
                              parentValueId,
                              childValueId
                      )
   SELECT   vpc.parentValueId,
                     @valueId
   FROM     ValueParentChild vpc
   WHERE  vpc.childValueId =
                            @parentValueId;
                            
   /* Insert this value */
   INSERT
   INTO       ValueParentChild(
                              parentValueId,
                              childValueId
                      )
   SELECT   @valueId,
                      @valueId;
                      
   COMMIT;
   
   SELECT @valueId AS valueId;
   
   
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `createValueWord` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`brett`@`%` PROCEDURE `createValueWord`(
      valueId BIGINT,
      lowerWord TEXT
)
BEGIN
  /* This should run in the transaction
  space of the caller */
  
   SET @valueId = valueId,
            @lowerWord = lowerWord,
            @wordId = NULL;
            
   IF NOT EXISTS(
         SELECT *
         FROM   Word
         WHERE Word.word = @lowerWord
   ) THEN
         INSERT
         INTO         Word(word)
         VALUES   (@lowerWord);
         SET @wordId = LAST_INSERT_ID();
   ELSE
         SET @wordId = (
               SELECT Word. wordId
               FROM    Word
               WHERE Word.word = @lowerWord
         );
   END IF;
   
   IF NOT EXISTS(
         SELECT      *
         FROM         ValueWord
         WHERE      ValueWord.valueId = 
                                      @valueId
         AND             ValueWord.wordId =
                                      @wordId
   ) THEN
         INSERT
         INTO      ValueWord(valueId, wordId)
         VALUES (@valueId, @wordId);
   END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `createValueWords` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`brett`@`%` PROCEDURE `createValueWords`(
      valueId BIGINT,
      lowerText TEXT
)
BEGIN
  /* This should run in the transaction
  space of the caller */
  
   SET @valueId = valueId,
            @lowerText = lowerText,
            @word = NULL,
            @start = 1,
            @length = LENGTH(@lowerText);
            
   WHILE (@start <= @length) DO
         /* Read first character */
         SET @nchar = SUBSTR(
               @lowerText,
               @start,
               1
         );
         /* Read subsequent delineators */
         WHILE (isDelineator(@nchar) AND
                          @start <= @length) DO
               SET @start = @start + 1;
               SET @nchar = SUBSTR(
                     @lowerText,
                     @start,
                     1
               );
         END WHILE;
         
         
         /* Read word */
         SET @word = '';
         WHILE (isDelineator(@nchar) = 0 AND
                          @start <= @length) DO
              SET @word = CONCAT(@word, @nchar);
              SET @start = @start + 1;
              SET @nchar = SUBSTR(
                     @lowerText,
                     @start,
                     1
               );
        END WHILE;
                          
        IF ( LENGTH(@word) > 0) THEN
              CALL createValueWord(
                    @valueId,
                    @word
              );
        END IF;
              
   END WHILE;
            
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

   SET @valueId = valueId;
   
   DELETE
   FROM      Value
   WHERE   Value.valueId IN (
         SELECT ValueParentChild.childValueId
         FROM    ValueParentChild
         WHERE
              ValueParentChild.parentValueId =
              @valueId
   )
   AND      Value.valueId != @valueId;
  
  END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `deleteTempValues` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`brett`@`%` PROCEDURE `deleteTempValues`(
    sessionKey VARCHAR(32)
)
BEGIN

   SET @sessionKey = sessionKey;
   SET @sessionId = (
                           SELECT   Session.sessionId
                           FROM      Session
                           WHERE   Session.sessionKey =
                                               @sessionKey
                    );
   
   START TRANSACTION;
   
   DELETE
   FROM     Value
   WHERE  Value.sessionId = @sessionId;
   
   COMMIT;
   
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
      SET @valueId = valueId;
      
      DELETE
      FROM      Value
      WHERE   Value.valueId IN (
         SELECT ValueParentChild.childValueId
         FROM    ValueParentChild
         WHERE ValueParentChild
                          .parentValueId =  @valueId
     );
   
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `getCancelLastUpload` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`brett`@`%` PROCEDURE `getCancelLastUpload`(
   sessionKey VARCHAR(32)
)
BEGIN
   SET @sessionKey = sessionKey;
   
   SET @cancelLastUpload = (
         SELECT            SessionStatus
                                          .cancelLastUpload
         FROM               SessionStatus
         INNER JOIN  Session
         ON                     Session.sessionId =
                                     SessionStatus.sessionId
         WHERE           Session.sessionKey = 
                                          @sessionKey
   );

   SELECT      IF(@cancelLastUpload IS NULL,
                              0, @cancelLastUpload) as
                                 cancelLastUpload;
   
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

   SET @userId = userId,
            @ownerId = ownerId;
   
   SELECT valueId,
                    type
   FROM   Value
   WHERE Value.ownerId = @ownerId
   AND       Value.sessionId IS NULL
   AND       Value.parentValueId IS NULL;


END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `getSessionStatus` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`brett`@`%` PROCEDURE `getSessionStatus`(
   sessionKey VARCHAR(32)
)
BEGIN
   SET @sessionKey = sessionKey;
   
   SELECT            SessionStatus.sessionStatus
   FROM               SessionStatus
   INNER JOIN  Session
   ON                     Session.sessionId =
                               SessionStatus.sessionId
   WHERE           Session.sessionKey = 
                              @sessionKey;
   
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

   
   SET           @userId = userId,
                      @ownerId = ownerId,
                      @parentValueId = parentValueId,
                      @objectIndex = objectIndex,
                      @lowerObjectKey =
                         LOWER(objectKey);
   
   SELECT        Value.valueId,
                           Value.type
   FROM           Value
   WHERE      ( 
                               (
                                  @parentValueId IS NULL
                                  AND
                                  Value.parentValueId IS NULL
                               ) 
                               OR
                              (Value.parentValueId = 
                                    @parentValueId)
                        )
   AND            (@objectIndex IS NULL
                         OR
                          Value.objectIndex = @objectIndex)
   AND            (@lowerObjectKey IS NULL
                          OR
                         Value.lowerObjectKey =
                           @lowerObjectKey)
   AND            Value.sessionId IS NULL
   AND           Value.ownerId = @ownerId
   -- THIS SECURITY CHECK WILL COME LATER
   AND           @ownerId = @userId;
   
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
   valueId BIGINT
)
BEGIN
   SET @valueId = valueId;
            
   SELECT         Value.*,
                            (
                                  SELECT COUNT(*)
                                  FROM    Value
                                  WHERE  
                                        Value.parentValueId = 
                                        @valueId
                                  AND
                                      Value.sessionId IS NULL
                            ) as childCount
   FROM            Value
   WHERE         Value.valueId = 
                            @valueId
   AND               Value.sessionId IS NULL;
   
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
   parentValueId BIGINT
)
BEGIN
   SET @parentValueId = parentValueId;
            
    

   SELECT         Value.*,
                            (
                               SELECT      COUNT(*)
                               FROM         Value AS Child
                               WHERE      
                                        Child.parentValueId =
                                        Value.valueId
                                AND
                                        Child.sessionId IS NULL
                            ) AS childCount
   FROM            Value
   WHERE         Value.parentValueId = 
                            @parentValueId
   AND               Value.sessionId IS NULL
   ORDER BY   Value.objectIndex;
   
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `insertLastValue` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`brett`@`%` PROCEDURE `insertLastValue`(
    sessionKey VARCHAR(32),
    parentValueId BIGINT ,
    lastKey TEXT
)
BEGIN

   SET @sessionKey = sessionKey,
            @parentValueId = parentValueId,
            @lastKey = lastKey;
            
   
   SET  @sessionId = (
           SELECT Session.sessionId
           FROM    Session
           WHERE Session.sessionKey =
                             @sessionKey
   );
   
   SET  @ownerId = (
           SELECT Session.userId
           FROM    Session
           WHERE Session.sessionId =
                             @sessionId
   );
   
   START TRANSACTION;
   
   INSERT
   INTO
       Value(
           parentValueId,
           ownerId,
           type,
           sessionId,
           objectIndex,
           objectKey,
           lowerObjectKey,
           isNull
       )
   SELECT
       @parentValueId,
       @ownerId,
       'dummy',
       @sessionId ,
       (
           SELECT
               MAX(Value.objectIndex) + 1
           FROM
               Value
           WHERE
               Value.parentValueId = @parentValueId
       ),
       @lastKey,
       LOWER(@lastKey),
       1;
       
    SET @valueId = LAST_INSERT_ID();
    
    COMMIT;
    
    SELECT @valueId as valueId;

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
   SET @sessionKey = sessionKey;
   DELETE
   FROM      Session
   WHERE   Session.sessionKey = @sessionKey;
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

   START TRANSACTION;
   
   SET @email = email;
   SET @secret = secret;
   SET @ipAddress = ipAddress;
   SET @timeout = CAST(
              getSetting(N'SESSION_TIMEOUT')
                 AS UNSIGNED
             );
   SET                @userId = (
      SELECT          User.userId
      FROM             User
      WHERE          User.userEmail = @email
      AND                 User.newUserSecret IS NULL
      AND                 User.logonSecret = @secret
      
   );
   

   SET @sessionKey = MD5(UUID());
   
   IF @userId IS NOT NULL 
   THEN
       /* Delete expired sessions */
      DELETE
      FROM     Session
      WHERE   Session.userId = @userId
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
                      @sessionKey, 
                      @userId, 
                      @ipAddress,
                      NOW(),
                      NOW()
                   );
      
   ELSE
      SET @sessionKey = NULL;
   END IF;
   
   SET @expires  =
      UNIX_TIMESTAMP(
         DATE_ADD(
            NOW(),
            INTERVAL @timeout SECOND
         )
      ) * 1000;
   
   
   COMMIT; 
   
   SELECT @userId as userId,
                    @sessionKey as sessionKey,
                   @expires  as expires;
                   
   
   
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
   START TRANSACTION;
   SET @email = email;
   
   UPDATE   User
   SET            User. lostSecret = MD5(UUID())
   WHERE    User.userEmail = @email;
   
   
   SELECT   lostSecret
   FROM     User
   WHERE   User.userEmail = @email;
    
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
/*!50003 DROP PROCEDURE IF EXISTS `setCancelLastUpload` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`brett`@`%` PROCEDURE `setCancelLastUpload`(
   sessionKey VARCHAR(32),
   cancelLastUpload TINYINT
)
exit_procedure: BEGIN
   
   SET @sessionKey = sessionKey,
            @cancelLastUpload = 
                  cancelLastUpload;
            
   
   SET  @sessionId = (
           SELECT Session.sessionId
           FROM    Session
           WHERE Session.sessionKey =
                             @sessionKey
   );
   
   IF @sessionId IS NULL THEN
         LEAVE exit_procedure;
   END IF;
   
   START TRANSACTION;
   
   IF EXISTS(
            SELECT *
            FROM     SessionStatus
            WHERE  SessionStatus.sessionId =
                               @sessionId
   ) THEN
         UPDATE SessionStatus
         SET           SessionStatus
                                 .cancelLastUpload =
                                @cancelLastUpload
         WHERE   SessionStatus.sessionId =
                            @sessionId;
  ELSE
         INSERT
         INTO      SessionStatus(
                             sessionId,
                             cancelLastUpload
                          )
         VALUES (
                             @sessionId,
                             @cancelLastUpload
                          );
  END IF;
   
  COMMIT;
   
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `setSessionStatus` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`brett`@`%` PROCEDURE `setSessionStatus`(
   sessionKey VARCHAR(32),
   sessionStatus TEXT
)
exit_procedure: BEGIN
   
   SET @sessionKey = sessionKey,
            @sessionStatus = sessionStatus;
            
   
   SET  @sessionId = (
           SELECT Session.sessionId
           FROM    Session
           WHERE Session.sessionKey =
                             @sessionKey
   );
   
   IF @sessionId IS NULL THEN
         LEAVE exit_procedure;
   END IF;
   
   START TRANSACTION;
           UPDATE   Session
           SET            Session.lastAccessedDate = 
                                   NOW()
           WHERE   Session.sessionId = 
                                  @sessionId;
   COMMIT;
   
   START TRANSACTION;
   
          DELETE
          FROM     SessionStatus
          WHERE  SessionStatus.sessionId =
                               @sessionId;
                               
         INSERT
         INTO      SessionStatus(
                             sessionId,
                             sessionStatus
                          )
         VALUES (
                             @sessionId,
                             @sessionStatus
                          );
   
  COMMIT;
   
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `upgradeTempValues` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`brett`@`%` PROCEDURE `upgradeTempValues`(
   sessionKey VARCHAR(32),
   existingValueId BIGINT,
   lastPath TEXT
)
exit_procedure: BEGIN


   SET @sessionKey = sessionKey,
            @existingValueId = existingValueId,
            @lastPath = lastPath;

   SELECT    Session.sessionId,
                        Session.userId
   INTO         @sessionId,
                       @userId
   FROM       Session
   WHERE    Session.sessionKey =
                       @sessionKey;
 
   SET     @tempValueId = (
          SELECT            Value.valueId
          FROM               Value
          WHERE            Value.parentValueId
                                       IS NULL
          AND                   Value.sessionId = 
                                       @sessionId
   );
   
  IF @existingValueId IS NOT NULL AND
       NOT EXISTS (
              SELECT          Value.valueId
              FROM             Value
              WHERE          Value.ownerId = @userId
              AND                 Value.valueId =
                                    @existingValueId
     ) THEN
           LEAVE exit_procedure;
   END IF;

   IF  @userId IS NULL OR
         @sessionId IS NULL OR
         @tempValueId IS NULL
   THEN
         LEAVE exit_procedure;
   END IF;
   
  START TRANSACTION;
  
  IF @existingValueId IS NOT NULL THEN
         
         # Insert new child values into
         # existing parents
         INSERT
         INTO        ValueParentChild(
                                 parentValueId,
                                 childValueId
                             )
         SELECT   existingParents.parentValueId,
                            tempChildren.childValueId
         FROM      ValueParentChild as
                                existingParents,
                            ValueParentChild as
                                tempChildren
         WHERE   existingParents.childValueId =
                                @existingValueId
         AND         (
             @lastPath IS NOT NULL
             OR
             existingParents.parentValueId !=
            @existingValueId)
         AND         tempChildren.parentValueId =
                                 @tempValueId;
                                 
         # Save existing value properties
         SELECT   Value. parentValueId,
                            Value. objectIndex,
                            Value.objectKey
         INTO        @newParentValueId,
                            @newObjectIndex,
                            @newObjectKey
         FROM      Value
         WHERE   Value.valueId =
                             @existingValueId;

          IF @lastPath IS NOT NULL THEN
                 SELECT
                     MAX(v.objectIndex) + 1
                 INTO
                     @newObjectIndex
                 FROM
                     Value as v
                 WHERE
                     v.parentValueId =
                         @existingValueId
                 FOR UPDATE;
                 
                 UPDATE
                     Value as temp
                 SET
                     temp.parentValueId =
                         @existingValueId,
                     temp.objectIndex = 
                         @newObjectIndex,
                     temp.objectKey = @lastPath,
                     temp.lowerObjectKey =
                         LOWER(@lastPath)
                 WHERE
                     temp.valueId =
                         @tempValueId;
                        
         ELSE
          
                 # delete existing value
                 CALL deleteValue(@existingValueId);
         
                 # Update temp value with
                # saved properties
                UPDATE
                       Value AS temp
                SET
                         temp.parentValueId =
                                @newParentValueId,
                         temp.objectIndex =
                                 @newObjectIndex,
                         temp.objectKey =
                                 @newObjectKey,
                          temp.lowerObjectKey  =
                                  LOWER(@newObjectKey)
                 WHERE    
                          temp.valueId =
                                  @tempValueId;
         END IF;
         
   END IF;
   
   # Upgrade temp values
   UPDATE Value
   SET           Value.sessionId = NULL
   WHERE   Value.sessionId = @sessionId;
   
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

   SET @email = email;
   SET @newUserSecret = newUserSecret;
   SET @userId = (
      SELECT   userId
      FROM      User
      WHERE   User.userEmail = @email
      AND         User.newUserSecret = @newUserSecret
   );
   
   START TRANSACTION;
   
   IF NOT ISNULL(@userId) THEN
      UPDATE   User
      SET             newUserSecret = NULL,
                           validated = 1
      WHERE    User.userId = @userId;
   END IF;
   
   COMMIT;
   
   SELECT NOT ISNULL(@userId)
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

-- Dump completed on 2025-06-16 13:33:09
