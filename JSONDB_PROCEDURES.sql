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
   
   WHILE (@valueId IS NOT NULL 
   AND
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
                      User.userEmail ,
                       @expires
                          as expires
   FROM      Session
   INNER JOIN
                      User
   ON            User.userId = Session.userId
   WHERE   Session.sessionKey =
@sessionKey;
   
  
      
   
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
/*!50003 DROP PROCEDURE IF EXISTS `createNextObjectIndex` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`brett`@`%` PROCEDURE `createNextObjectIndex`(
    ownerId BIGINT,
    parentValueId BIGINT
)
BEGIN
   SET @parentValueId = parentValueId,
            @ownerId = ownerId;
   
   SELECT
       MAX(v.objectIndex) + 1
   INTO
       @objectIndex
   FROM
       Value as v
   WHERE
           v.parentValueId = @parentValueId
   FOR UPDATE;
   
   
   IF @objectIndex IS NULL THEN
       SET @objectIndex = 0;
   END IF;
   
   INSERT
   INTO
       Value(
           ownerId,
           parentValueId,
           type,
           objectIndex,
           isNull
       )
       VALUES(
           @ownerId,
           @parentValueId,
           'null', #type
           @objectIndex,
           1 # isNull
        );
        
   SET @valueId = LAST_INSERT_ID();
   
   # Insert this values parents
   INSERT
   INTO
       ValueParentChild
       (parentValueId, childValueId)
   SELECT
       vpc.parentValueId,
       @valueId
   FROM
       ValueParentChild as vpc
   WHERE
       vpc.childValueId = @parentValueId;
       
   # Insert this value
   INSERT
   INTO
       ValueParentChild
       (parentValueId, childValueId)
   VALUES
       (@valueId, @valueId);
       
   SELECT @valueId AS valueId;
   
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
           type VARCHAR(10),
           objectIndex BIGINT,
           objectKey TEXT,
           isNull TINYINT,
           stringValue TEXT,
           numericValue DOUBLE,
           boolValue TINYINT
)
exit_procedure: BEGIN

   SET @valueId = NULL,
            @parentValueId = parentValueId,
            @ownerId = ownerId,
            @type = type,
            @objectIndex = objectIndex,
            @objectKey = objectKey,
            @isNull = isNull,
            @stringValue = stringValue,
            @numericValue = numericValue,
            @boolValue = boolValue,
            @insert = NULL;

IF @objectIndex IS NOT NULL THEN
           SELECT  Value.valueId
           INTO       @valueId
           FROM     Value
           WHERE    (@parentValueId IS NULL
                            AND
                            Value.parentValueId IS NULL)
                            OR (Value.parentValueId =
                            @parentValueId)
       AND           Value.objectIndex =    
                            @objectIndex
       FOR UPDATE;
ELSEIF @objectKey IS NOT NULL THEN
       SELECT    Value.valueId,
                           Value.objectIndex
       INTO         @valueId,
                           @objectIndex
       FROM       Value
       WHERE    (@parentValueId IS NULL
                            AND
                            Value.parentValueId IS NULL)
                            OR (Value.parentValueId =
                            @parentValueId)
       AND           Value.objectKey =    
                            @objectKey
       FOR UPDATE;
       
       
       
END IF;
                        
IF @objectIndex IS NULL THEN
    SELECT    MAX(Value.objectIndex)
    INTO         @max
    FROM       Value
    WHERE    (@parentValueId IS NULL
                            AND
                         Value.parentValueId IS NULL)
                         OR (Value.parentValueId =
                            @parentValueId)
    FOR UPDATE;
    
    IF @max IS NULL THEN
        SET @objectIndex = 0;
    ELSE
        SET   @objectIndex = @max + 1;
     END IF;
     
END IF;
                        

IF @valueId IS NULL THEN
   INSERT INTO Value(
           ownerId,
           parentValueId,
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
           @ownerId,
           @parentValueId,
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
   SET @insert = true;
   
ELSE
    UPDATE     Value AS v
    SET               v.ownerId = @ownerId,
                           v.parentValueId = 
                                @parentValueId,
                           v.type = @type,
                           v.objectIndex = @objectIndex,
                           v.objectKey = @objectKey,
                           v.lowerObjectKey =
                              LOWER(@objectKey),
                          v.isNull = @isNull,
                          v.stringValue = @stringValue,
                          v.numericValue =
                             @numericValue,
                          v.boolValue =
                              @v.boolValue
   WHERE      v.valueId = @valueId;
   
   SET @insert = false;
END IF;

   CALL startWords();
  
   CALL createValueWords(
         @objectKey
   );
            
   CALL createValueWords( 
         @stringValue
    );
            
   CALL endWords(@valueId);
             
   # Insert all parents parents
   
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
                            
   # Insert this value 
   INSERT
   INTO       ValueParentChild(
                              parentValueId,
                              childValueId
                      )
   SELECT   @valueId,
                      @valueId;
   
   
   SELECT @valueId AS valueId;
   
   
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `createWords` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`brett`@`%` PROCEDURE `createWords`(
      valueId BIGINT,
      text TEXT
)
exit_procedure: BEGIN
  /* This should run in the transaction
  space of the caller */
   IF text IS NULL THEN
       LEAVE exit_procedure;
   END IF;
   
   SET @lowerText = LOWER(text),
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
              IF NOT EXISTS(
                  SELECT * 
                  FROM _ValueWord as vw
                  WHERE vw.valueId = @valueId
                  AND        vw.word = @word
              ) THEN
                  INSERT
                  INTO _ValueWord(valueId, word)
                  VALUES (@valueId, @word);
              END IF;
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
    jobId BIGINT
)
BEGIN

   SET  @jobId = jobId;

   START TRANSACTION;
   
   DELETE
   FROM     Value
   WHERE  Value.jobId  = @jobId;
   
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
   jobId BIGINT,
   existingValueId BIGINT,
   lastPath TEXT
)
exit_procedure: BEGIN

   
   SET @jobId = jobId,
            @existingValueId = existingValueId,
            @lastPath = lastPath;

   SELECT    Job.userId
   INTO         @userId
   FROM       Job
   WHERE    Job.jobId =
                       @jobId;
 
   SET     @newValueId = (
          SELECT            Value.valueId
          FROM               Value
          WHERE            Value.parentValueId
                                       IS NULL
          AND                   Value.jobId = 
                                       @jobId
   );
          
  IF @existingValueId IS NOT NULL AND
       NOT EXISTS (
              SELECT          Value.valueId
              FROM             Value
              WHERE          Value.ownerId = @userId
              AND                 Value.valueId =
                                    @existingValueId
     ) THEN
          SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '@existingValueId invalid';
           LEAVE exit_procedure;
   END IF;

   IF  @userId IS NULL OR
         @newValueId IS NULL
   THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '@userId or @newValueId  invalid';
         LEAVE exit_procedure;
   END IF;
    
  # START TRANSACTION;
         
                             
  IF @existingValueId IS NOT NULL THEN
         
         # Insert new child values into
         # existing parents
         INSERT
         INTO        ValueParentChild(
                                 parentValueId,
                                 childValueId
                             )
         SELECT   existingParents.parentValueId,
                            newChildren.childValueId
         FROM      ValueParentChild as
                                existingParents,
                            ValueParentChild as
                                newChildren
         WHERE   existingParents.childValueId =
                                @existingValueId
                         
         AND         (
         
             @lastPath IS NOT NULL
             OR
             existingParents.parentValueId !=
            @existingValueId)
         AND         newChildren.parentValueId =
                                 @newValueId;
                                 
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
                     (@existingValueId IS NULL AND
                       v.parentValueId IS NULL
                      )
                      OR
                      (@existingValueId = 
                      v.parentValueId)
                 FOR UPDATE;
                 
                 IF @newObjectIndex IS NULL THEN
                     SET @newObjectIndex = 0;
                 END IF;
                 
                 IF @lastPath = '[]' THEN
                      SET @lastPath = NULL,
                                @newObjectKey = NULL;
                 ELSE
                      SET @newObjectKey = @lastPath;
                                           
                 END IF;
                
                 SET @newParentValueId =
                              @existingValueId;
         
          
         END IF;
         
         # delete existing value
         CALL deleteValue(@existingValueId);
         
         SELECT  Value.stringValue
         INTO        @newStringValue
         FROM      Value
         WHERE   Value.valueId =
                             @newValueId;
                             
         # Update new value with
         # saved properties
         UPDATE
                Value AS new
         SET
                  new.parentValueId =
                         @newParentValueId,
                  new.objectIndex =
                          @newObjectIndex,
                  new.objectKey =
                          @newObjectKey,
                   new.lowerObjectKey  =
                           LOWER(@newObjectKey)
          WHERE    
                   new.valueId =
                           @newValueId;
                           
          CALL startWords();
                      
          CALL createValueWords(
                  @newObjectKey
          );
                           
          CALL createValueWords(
                @newStringValue
          );
                           
          CALL endWords(@newValueId);
  
   END IF;
  
        
   # Upgrade new values
   UPDATE  Value
   SET     Value.jobId = NULL
   WHERE   Value.jobId = @jobId;
   
   # Clear the job
   DELETE
   FROM      Job
   WHERE     Job.jobId = @jobId;
   
   SELECT
       getPathByValue(v.valueId) as path
   FROM
       Value as v
   WHERE
       v.valueId = @newValueId;
   
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `endWords` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`brett`@`%` PROCEDURE `endWords`()
BEGIN

   INSERT
   INTO            Word(word)
   SELECT
   DISTINCT  _ValueWord.word
   FROM          _ValueWord
   LEFT JOIN  Word on
                           Word.word = _ValueWord.word
   WHERE        Word.wordId IS NULL;
 
   INSERT
   INTO            ValueWord(valueId, wordId)
   SELECT
   DISTINCT          _ValueWord.valueId,
                                 Word.wordId
   FROM                 Word
   INNER JOIN    _ValueWord
   ON                           _ValueWord.word = 
                                  Word.word
   LEFT JOIN        ValueWord
   ON                       ValueWord.valueId = 
                                     _ValueWord.valueId
   AND                    ValueWord.wordId = 
                                     Word.wordId
   WHERE             ValueWord.valueWordId
                                      IS NULL;
     
   DROP TEMPORARY TABLE IF EXISTS
       _ValueWord;
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
   AND       Value.jobId IS NULL
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
   AND            Value.jobId IS NULL
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
                                      Value.jobId IS NULL
                            ) as childCount
   FROM            Value
   WHERE         Value.valueId = 
                            @valueId
   AND               Value.jobId IS NULL;
   
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
                                        Child.jobId IS NULL
                            ) AS childCount
   FROM            Value
   WHERE         Value.parentValueId = 
                            @parentValueId
   AND               Value.jobId IS NULL
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
           ownerId BIGINT ,
           parentValueId BIGINT,
           type VARCHAR(10),
           objectKey TEXT,
           isNull TINYINT,
           stringValue TEXT,
           numericValue DOUBLE,
           boolValue TINYINT
)
BEGIN
    SET @ownerId = ownerId,
            @parentValueId =  parentValueId,
            @type = type,
           @objectKey =  objectKey,
           @isNull =  isNull,
           @stringValue = stringValue,
           @numericValue = numericValue,
          @boolValue = boolValue;
          
    SELECT
        MAX(v.objectIndex) + 1
    INTO
         @objectIndex
    FROM
        Value AS v
    WHERE
        v.parentValueId = @parentValueId;
        
    IF @objectIndex IS NULL THEN
        SET @objectIndex = 0;
    END IF;
    
    INSERT INTO Value(
           ownerId,
           parentValueId,
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
           @ownerId,
           @parentValueId,
           @type,
           @objectIndex,
           @objectKey,
           LOWER(objectKey),
           @isNull,
           @stringValue,
           @numericValue,
           @boolValue
   );
   
   SET @valueId = LAST_INSERT_ID();
 
   # Insert this values parents
   INSERT
   INTO
       ValueParentChild
       (parentValueId, childValueId)
   SELECT
       vpc.parentValueId,
       @valueId
   FROM
       ValueParentChild as vpc
   WHERE
       vpc.childValueId = @parentValueId;
       
   # Insert this value
   INSERT
   INTO
       ValueParentChild
       (parentValueId, childValueId)
   VALUES
       (@valueId, @valueId);
   
   # Index words
   CALL createWords(@valueId, @objectKey);
   CALL createWords(@valueId, @stringValue);
   
   SELECT
       @valueId AS  valueId;
       
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `lockValueByObjectIndex` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`brett`@`%` PROCEDURE `lockValueByObjectIndex`(
   parentValueId BIGINT,
   objectIndex BIGINT
)
BEGIN

    SET @parentValueId = parentValueId,
             @objectIndex = objectIndex;
    
    SELECT
        *
    FROM
        Value
    WHERE
        (
            (
                Value.parentValueId IS NULL
                AND  @parentValueId IS NULL
            )
           OR
           Value.parentValueId = @parentValueId
        )
       AND
           Value.objectIndex = @objectIndex
    FOR UPDATE;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `lockValueByObjectKey` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`brett`@`%` PROCEDURE `lockValueByObjectKey`(
   parentValueId BIGINT,
   objectKey TEXT
)
BEGIN

    SET @parentValueId = parentValueId,
             @objectKey = objectKey;
    
    SELECT     *
    FROM       Value
    WHERE      (
               (
                   Value.parentValueId IS NULL
               AND  @parentValueId IS NULL
               )
               OR
               Value.parentValueId = @parentValueId
           )
    AND        Value.objectKey = @objectKey
    FOR UPDATE;

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
   #COMMIT;
   
  # START TRANSACTION;
   
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
/*!50003 DROP PROCEDURE IF EXISTS `startDocument` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`brett`@`%` PROCEDURE `startDocument`(
   userId BIGINT,
   path TEXT
)
exit_procedure: BEGIN
/*
    SET @sessionKey = sessionKey,
             @path = path;
             
    SET @userId = (
        SELECT
            Session.userId
        FROM
            Session
        WHERE
            Session.sessionKey = @sessionKey
    );
    
    IF @userId IS NULL
    THEN
        LEAVE exit_procedure;
    END IF;
    */
    
    SET @userId = userId,
             @path = path;
    
    INSERT
    INTO
        Job(
            userId,
            jobPath
        )
    VALUES
        (
            @userId,
            @path
        );
        
    SELECT
        LAST_INSERT_ID() AS jobId;
        
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `startWords` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`brett`@`%` PROCEDURE `startWords`()
BEGIN

   DROP TEMPORARY TABLE IF EXISTS
       _ValueWord;
       
   CREATE TEMPORARY TABLE _ValueWord(
           valueId BIGINT NOT NULL REFERENCES Value(valueId) ON DELETE CASCADE,
           word TEXT NOT NULL
   );
   
   
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
           ownerId BIGINT ,
           type VARCHAR(10),
           isNull TINYINT,
           stringValue TEXT,
           numericValue DOUBLE,
           boolValue TINYINT
)
BEGIN
    SET    @valueId = valueId,
                @ownerId = ownerId,
                @type = type,
                @isNull = isNull,
                @stringValue = stringValue,
                @numericValue = numericValue,
                @boolValue = boolValue;
                
    CALL deleteChildValues(@valueId);
    
    UPDATE     Value AS v
    SET               v.ownerId = @ownerId,
                           v.type = @type,
                           v.isNull = @isNull,
                           v.stringValue = @stringValue,
                           v.numericValue =
                             @numericValue,
                           v.boolValue =
                              @boolValue
   WHERE      v.valueId = @valueId;
   
   # Index words
   SELECT
       v.objectKey
   INTO
       @objectKey
   FROM
       Value as v
   WHERE
       v.valueId = @valueId;
   
   DELETE
   FROM
       _ValueWord
   WHERE
       _ValueWord.valueId = @valueId;
       
   CALL createWords(@valueId, @objectKey);
   CALL createWords(@valueId, @stringValue);
   
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
/*!50003 DROP PROCEDURE IF EXISTS `wait` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`brett`@`%` PROCEDURE `wait`()
BEGIN

set @counter = 1;

while @counter > 0 do
   set @counter = @counter + 1;
end while;

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

-- Dump completed on 2025-07-30  1:00:54
