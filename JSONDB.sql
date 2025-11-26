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

--
-- Table structure for table `Session`
--

DROP TABLE IF EXISTS `Session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Session` (
  `sessionId` bigint NOT NULL AUTO_INCREMENT,
  `sessionKey` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `userId` bigint NOT NULL,
  `createdDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ipAddress` varchar(15) NOT NULL,
  `lastAccessedDate` datetime NOT NULL,
  PRIMARY KEY (`sessionId`),
  UNIQUE KEY `UI_Session_sessionKey` (`sessionKey`) USING BTREE,
  KEY `I_Session_userId` (`userId`) USING BTREE,
  KEY `I_Session_ipAddress` (`ipAddress`) USING BTREE,
  CONSTRAINT `FK_Session_userId` FOREIGN KEY (`userId`) REFERENCES `User` (`userId`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1054 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Session`
--

LOCK TABLES `Session` WRITE;
/*!40000 ALTER TABLE `Session` DISABLE KEYS */;
INSERT INTO `Session` VALUES (1050,'628a0a145d0516f19758845db4d7735e',119,'2025-11-25 23:32:15','49.183.5.148','2025-11-26 00:38:47'),(1051,'60d56ccb7a4e5c11e08d248d4edd6f52',119,'2025-11-26 00:41:48','49.183.5.148','2025-11-26 00:59:28'),(1052,'122a901a794a5152279513b0f28a0681',119,'2025-11-26 00:59:55','49.183.5.148','2025-11-26 01:00:02'),(1053,'f5bcbb0aece0057579cb3e00a4f6ca1c',119,'2025-11-26 01:00:26','49.183.5.148','2025-11-26 01:04:37');
/*!40000 ALTER TABLE `Session` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Setting`
--

DROP TABLE IF EXISTS `Setting`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Setting` (
  `settingId` bigint NOT NULL AUTO_INCREMENT,
  `settingCode` varchar(256) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `settingValue` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `settingDescription` text NOT NULL,
  PRIMARY KEY (`settingId`),
  UNIQUE KEY `UI_Setting_settingCode` (`settingCode`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Setting`
--

LOCK TABLES `Setting` WRITE;
/*!40000 ALTER TABLE `Setting` DISABLE KEYS */;
INSERT INTO `Setting` VALUES (1,'SESSION_TIMEOUT','3600','Session timeout in seconds');
/*!40000 ALTER TABLE `Setting` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `StagingValue`
--

DROP TABLE IF EXISTS `StagingValue`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `StagingValue` (
  `valueId` bigint NOT NULL AUTO_INCREMENT,
  `parentValueId` bigint DEFAULT NULL,
  `ownerId` bigint NOT NULL,
  `type` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `objectIndex` bigint NOT NULL,
  `objectKey` text,
  `lowerObjectKey` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `numericValue` double DEFAULT NULL,
  `stringValue` text,
  `boolValue` tinyint DEFAULT NULL,
  `isNull` tinyint NOT NULL,
  PRIMARY KEY (`valueId`)
) ENGINE=InnoDB AUTO_INCREMENT=2655506 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `StagingValue`
--

LOCK TABLES `StagingValue` WRITE;
/*!40000 ALTER TABLE `StagingValue` DISABLE KEYS */;
/*!40000 ALTER TABLE `StagingValue` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `User`
--

DROP TABLE IF EXISTS `User`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `User` (
  `userId` bigint NOT NULL AUTO_INCREMENT,
  `userEmail` varchar(320) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `logonSecret` text,
  `newUserSecret` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `lostSecret` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `validated` tinyint NOT NULL,
  PRIMARY KEY (`userId`),
  UNIQUE KEY `UI_userEmail` (`userEmail`)
) ENGINE=InnoDB AUTO_INCREMENT=120 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `User`
--

LOCK TABLES `User` WRITE;
/*!40000 ALTER TABLE `User` DISABLE KEYS */;
INSERT INTO `User` VALUES (119,'brettdavidsilverman@gmail.com','kiIYowCfV/z9uCC7IZLVLzaAhVgvMaDthqR59rD1RPeb+1YWyRG+JOzG/sBscqgf+OPnNBWXoZmvNMRVlOWN0w==',NULL,NULL,1);
/*!40000 ALTER TABLE `User` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Value`
--

DROP TABLE IF EXISTS `Value`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Value` (
  `valueId` bigint NOT NULL AUTO_INCREMENT,
  `ownerId` bigint NOT NULL,
  `parentValueId` bigint DEFAULT NULL,
  `type` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `objectIndex` bigint DEFAULT NULL,
  `objectKeyWordId` bigint DEFAULT NULL,
  `locked` tinyint DEFAULT NULL,
  `numericValue` double DEFAULT NULL,
  `stringValueWordId` bigint DEFAULT NULL,
  `boolValue` tinyint DEFAULT NULL,
  `isNull` tinyint NOT NULL,
  PRIMARY KEY (`valueId`),
  UNIQUE KEY `UI_Value_ownerId_parentValueId_locked_objectIndex` (`ownerId`,`parentValueId`,`locked`,`objectIndex`) USING BTREE,
  KEY `I_Value_stringValueId` (`stringValueWordId`) USING BTREE,
  KEY `I_Value_ownerId` (`ownerId`),
  KEY `I_Value_parentValueId` (`parentValueId`),
  KEY `I_Value_parentValueId_objectKeyWordId` (`parentValueId`,`objectKeyWordId`) USING BTREE,
  KEY `I_Value_objectKeyWordId` (`objectKeyWordId`),
  KEY `I_Value_objectKeyWordId_numericValue` (`objectKeyWordId`,`numericValue`) USING BTREE,
  KEY `I_Value_objectKeyWordId_stringValue` (`objectKeyWordId`,`stringValueWordId`) USING BTREE,
  KEY `I_,Value_locked` (`locked`) USING BTREE,
  KEY `I_Value_parentValueId_objectDepth` (`parentValueId`) USING BTREE,
  CONSTRAINT `FK_Value_objectKeyWordId` FOREIGN KEY (`objectKeyWordId`) REFERENCES `Word` (`wordId`),
  CONSTRAINT `FK_Value_ownerId` FOREIGN KEY (`ownerId`) REFERENCES `User` (`userId`) ON DELETE CASCADE,
  CONSTRAINT `FK_Value_parentValueId` FOREIGN KEY (`parentValueId`) REFERENCES `Value` (`valueId`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=35848377 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Value`
--

LOCK TABLES `Value` WRITE;
/*!40000 ALTER TABLE `Value` DISABLE KEYS */;
/*!40000 ALTER TABLE `Value` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ValueParentChild`
--

DROP TABLE IF EXISTS `ValueParentChild`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ValueParentChild` (
  `parentValueId` bigint NOT NULL,
  `childValueId` bigint NOT NULL,
  PRIMARY KEY (`parentValueId`,`childValueId`),
  KEY `I_ValueParentChild_parentValueId` (`parentValueId`) USING BTREE,
  KEY `I_ValueParentChild_childValueId` (`childValueId`) USING BTREE,
  CONSTRAINT `FK_ValueParentChild_childValueId` FOREIGN KEY (`childValueId`) REFERENCES `Value` (`valueId`) ON DELETE CASCADE,
  CONSTRAINT `FK_ValueParentChild_parentValueId` FOREIGN KEY (`parentValueId`) REFERENCES `Value` (`valueId`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ValueParentChild`
--

LOCK TABLES `ValueParentChild` WRITE;
/*!40000 ALTER TABLE `ValueParentChild` DISABLE KEYS */;
/*!40000 ALTER TABLE `ValueParentChild` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ValueWord`
--

DROP TABLE IF EXISTS `ValueWord`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ValueWord` (
  `valueId` bigint NOT NULL,
  `wordId` bigint NOT NULL,
  PRIMARY KEY (`wordId`,`valueId`),
  UNIQUE KEY `UI_ValueWord_valueId_wordId` (`valueId`,`wordId`) USING BTREE,
  UNIQUE KEY `UI_ValueWord_wordId_valueId` (`wordId`,`valueId`) USING BTREE,
  KEY `I_ValueWord_valueId` (`valueId`) USING BTREE,
  KEY `I_ValueWord_wordId` (`wordId`) USING BTREE,
  CONSTRAINT `FK_ValueWord_valueId` FOREIGN KEY (`valueId`) REFERENCES `Value` (`valueId`) ON DELETE CASCADE,
  CONSTRAINT `FK_ValueWord_wordId` FOREIGN KEY (`wordId`) REFERENCES `Word` (`wordId`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ValueWord`
--

LOCK TABLES `ValueWord` WRITE;
/*!40000 ALTER TABLE `ValueWord` DISABLE KEYS */;
/*!40000 ALTER TABLE `ValueWord` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Word`
--

DROP TABLE IF EXISTS `Word`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Word` (
  `wordId` bigint NOT NULL AUTO_INCREMENT,
  `word` text CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `lowerWord` text,
  PRIMARY KEY (`wordId`),
  KEY `I_Word_word` (`word`(100)) USING BTREE,
  KEY `I_Word_lowerWord` (`lowerWord`(100)) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1230284 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Word`
--

LOCK TABLES `Word` WRITE;
/*!40000 ALTER TABLE `Word` DISABLE KEYS */;
/*!40000 ALTER TABLE `Word` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
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
   SET @valueId = valueId,
            @userId = userId;
   
   SET @parentValueId = (
         SELECT   Value.parentValueId
         FROM     Value
         WHERE  Value.valueId = @valueId
         AND         Value.ownerId = @userId
      );
      
   SET @path = '';
   
   WHILE (@valueId IS NOT NULL 
   AND
                   @parentValueId IS NOT NULL) DO
                   
      SET @path = CONCAT(
         getSegmentByValue(@valueId, @userId),
         '/', 
         @path
      );
      SET @valueId = (
         SELECT   Value.parentValueId
         FROM     Value
         WHERE  Value.valueId = @valueId
         AND         Value.ownerId = @userId
      );
      
      SET @parentValueId = (
         SELECT   Value.parentValueId
         FROM     Value
         WHERE  Value.valueId = @valueId
         AND        Value.ownerId = @userId
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
   valueId BIGINT,
   userId BIGINT
) RETURNS text CHARSET utf8mb4
    READS SQL DATA
BEGIN

    SET @valueId = valueId,
             @userId = userId;
    
    IF @valueId IS NULL THEN
       RETURN '';
    END IF;
    
    SET @objectKey = (
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
          Value.valueId = @valueId
       AND
          Value.ownerId = @userId
    );
    
    SET @segment = NULL;
    
    IF (@objectKey IS NULL) THEN
       SET @segment  = (
          SELECT CAST(Value.objectIndex AS CHAR)
          FROM   Value
          WHERE Value.valueId = @valueId
          AND       Value.ownerId = @userId
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
    DETERMINISTIC
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
       
       IF @ignoreExpires = 1 OR @expires > NOW() THEN
          UPDATE   Session
          SET              lastAccessedDate = NOW(),
                               ipAddress = @ipAddress
          WHERE   Session.sessionKey =  @sessionKey;
       ELSE
          SET @sessionKey = NULL;
       END IF;
       
    ELSE
       SET @sessionKey = NULL;
    END IF;
    
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
  
   IF NOT EXISTS(
         SELECT *
         FROM    User
         WHERE   User.userEmail = @email
         FOR UPDATE)
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
         FOR UPDATE
   ) THEN
        UPDATE   User
        SET             logonSecret = @secret,
                             newUserSecret = MD5(UUID())
        WHERE    User.userEmail = @email;
        
        SET @userId = (
           SELECT userId
           FROM    User
           WHERE User.userEmail = @email
           FOR UPDATE
        );
        
   END IF;
   
   
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
   WHERE   Value.parentValueId = @valueId;
   
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
     SET @lockedValueId = lockedValueId;
   
     DELETE
     FROM
         Value
     WHERE
         Value.valueId = @lockedValueId;

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
      WHERE   Value.valueId = @valueId;
   
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
 
    SET  @ownerId = ownerId,
              @replaceValueId = replaceValueId,
              @lockedValueId = lockedValueId,
              @parentValueId = parentValueId,
              @stagingValueId = stagingValueId,
              @appendToArray = appendToArray,
              @objectIndex = NULL;
  
  IF (@appendToArray = 1) THEN
        SELECT
            COUNT(*) + 1
        INTO
            @objectIndex
        FROM
            Value
        WHERE
            Value.ownerId = @ownerId
        AND
            Value.parentValueId =
                @parentValueId
        AND
            Value.locked = 0
        FOR UPDATE;
        
        IF (@objectIndex IS NULL) THEN
            SET @objectIndex = 1;
        END IF;
        
        UPDATE
            Value
        SET
            Value.objectIndex = @objectIndex
        WHERE
            Value.valueId = @stagingValueId;
       
   END IF;
   
    IF (@appendToArray = 0) THEN
    
        UPDATE
            Value
        SET
            Value.locked = NULL
        WHERE
            Value.valueId = @replaceValueId;
            
    END IF;
   
    DELETE
    FROM
        Value
    WHERE
        Value.valueId = @replaceValueId;
        
    UPDATE
            Value
    SET
            Value.locked = 0
    WHERE
            Value.valueId = @lockedValueId;
    
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
    SET @userId = userId,
             @parentValueId = @parentValueId;
             
    SELECT
        COUNT(*)
    FROM
        Value
    WHERE
        Value.ownerId = @userId
    AND
        Value.locked = 0
    AND
        Value.parentValueId = @parentValueId;
        
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
   
   SELECT Value.valueId,
                    Value.type
   FROM   Value
   WHERE Value.ownerId = @ownerId
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
   SET @ownerId = ownerId,
            @parentValueId = parentValueId,
            @objectIndex = objectIndex,
            @objectKey = objectKey,
            @objectKeyWordId = NULL,
            @valueId = NULL,
            @type = NULL,
            @locked = NULL;
        
            
    IF @objectKey IS NOT NULL THEN
        SELECT
            Word.wordId
        INTO
            @objectKeyWordId
        FROM
            Word
        WHERE
            Word.word = @objectKey;
            
        SELECT
            v.locked
        INTO
            @locked
        FROM
            Value AS v
        WHERE 
            v.ownerId = @ownerId
        AND
           v.parentValueId = 
               @parentValueId
       AND
           v.objectKeyWordId = @objectKeyWordId
       AND
           v.locked = 1;
       # FOR UPDATE;
       

       SELECT
            v.valueId
        INTO
            @valueId
        FROM
            Value AS v
        WHERE
            v.ownerId = @ownerId
         AND
             v.parentValueId = 
               @parentValueId
       AND
           v.objectKeyWordId = @objectKeyWordId
       AND
           v.locked = 0;
       #FOR UPDATE;
   ELSE
        SELECT
            v.locked
        INTO
            @locked
        FROM
            Value AS v
        WHERE 
            v.ownerId = @ownerId
        AND
           v.parentValueId = 
               @parentValueId
       AND
              v.objectIndex = @objectIndex
       AND
              v.locked = 1;
       #FOR UPDATE;

       SELECT
            v.valueId
        INTO
            @valueId
        FROM
            Value AS v
        WHERE
            v.ownerId = @ownerId
        AND
            v.parentValueId = 
               @parentValueId
       AND
              v.objectIndex = @objectIndex
       AND
              v.locked = 0;
       #FOR UPDATE;
   END IF;
   
   
   IF @valueId IS NOT NULL THEN
       SELECT
            v.type,
            v.objectIndex,
            w.word
       INTO
           @type,
           @objectIndex,
           @objectKey
       FROM
           Value AS v
       LEFT JOIN
           Word as w
       ON
           v.objectKeyWordId = w.wordId
       WHERE
           v.valueId = @valueId
       ;
    END IF;
           
   IF @locked IS NULL THEN
       SET @locked = 0;
   END IF;
   
   SELECT
            @valueId AS valueId,
            @type AS type,
            @locked as locked,
            @objectIndex AS objectIndex,
            @objectKey AS objectKey;
            
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

   
   SET
      @userId = userId,
      @ownerId = ownerId,
      @parentValueId = parentValueId,
      @objectIndex = objectIndex,
      @objectKey = objectKey,
      @objectKeyWordId = NULL;
   
   IF @objectKey IS NOT NULL THEN
       SELECT
           Word.wordId
       INTO
           @objectKeyWordId
       FROM
           Word
       WHERE
           Word.word = @objectKey;
           
   END IF;
   
   SELECT
       Value.valueId,
       Value.type
   FROM
       Value
   WHERE
        Value.ownerId = @ownerId
   AND
                     ( 
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
   AND            (@objectKey IS NULL
                          OR
                         Value.objectKeyWordId  =
                           @objectKeyWordId)
  AND            Value.locked = 0
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
   ownerId BIGINT,
   valueId BIGINT
)
BEGIN

   SET @ownerId = ownerId,
            @valueId = valueId;
            
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
                                       @ownerId
                               AND
                                        Child.parentValueId =
                                        Value.valueId
                               AND
                                        Child.locked = 0
                            ) AS childCount
   FROM            Value
   WHERE         Value.valueId =  @valueId
   AND                Value.ownerId = @ownerId;
   
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
   SET @parentValueId = parentValueId,
            @ownerId = ownerId;
   
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
                                       @ownerId
                               AND
                                        Child.parentValueId =
                                        Value.valueId
                               AND
                                        Child.locked = 0
                            ) AS childCount
   FROM            Value
   WHERE        Value.ownerId = @ownerId
   AND
                            Value.parentValueId = 
                            @parentValueId
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

    SET @valueId = valueId;
    
    INSERT
    INTO
            ValueWord(
                valueId,
                wordId
            )
    SELECT
        @valueId,
        ValueWord.wordId
    FROM
        Value
    INNER JOIN
        ValueWord
    ON
        ValueWord.valueId = Value.parentValueId
    WHERE
        Value.valueId = @valueId
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
                v.valueId = @valueId
            AND
                vw.wordId = ValueWord.wordId
        );
        
    #COMMIT;
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

    SET @ownerId = ownerId, 
             @parentValueId =  parentValueId,
             @replaceValueId = replaceValueId,
             @locked = locked,
             @type = type,
             @objectIndex = objectIndex,
             @objectKey =  objectKey,
             @isNull =  isNull,
             @stringValue = stringValue,
             @numericValue = numericValue,
             @boolValue = boolValue,
             @objectKeyWordId = NULL,
             @stringValueId = NULL;
   
    IF @objectKey IS NOT NULL THEN
        CALL insertWord(
            @objectKey,
            @objectKeyWordId
        );
        CALL insertValueWords(
            @objectKey,
            null
        );
    END IF;
    
    IF @stringValue IS NOT NULL THEN
        CALL insertWord(
            @stringValue,
            @stringValueWordId
        );
        CALL insertValueWords(
            @stringValue,
            null
        );
    END IF;
    
    START TRANSACTION;
    
    IF @objectIndex IS NULL THEN
        IF @replaceValueId IS NOT NULL AND
                @locked = 1
        THEN
            SELECT
                Value.objectIndex
            INTO
                @objectIndex
            FROM
                Value
            WHERE 
                Value.valueId = @replaceValueId
            FOR UPDATE;
        ELSEIF @objectKey IS NOT NULL
        THEN
            SELECT
                Value.objectIndex
            INTO
                @objectIndex
            FROM
                Value
            WHERE
                Value.parentValueId = @parentValueId
            AND
                Value.objectKeyWordId = @objectKeyWordId
            FOR UPDATE;
        END IF;
    END IF;
    
    IF @objectIndex IS NULL
    THEN
    
            SELECT
                COUNT(Value.objectIndex) + 1
            INTO
                @objectIndex
            FROM
                Value
            WHERE 
                 Value.parentValueId =
                 @parentValueId
            FOR UPDATE;
        
    END IF;
    
    IF @objectIndex IS NULL THEN
        SET @objectIndex = 1;
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
           @ownerId,
           @parentValueId,
           @locked,
           @type,
           @objectIndex,
           @objectKeyWordId,
           @isNull,
           @stringValueWordId,
           @numericValue,
           @boolValue
   );
  
   SET @valueId = LAST_INSERT_ID();
  
   SET @stagingValueId = @valueId;
   
   CALL insertValueParentChild(
        @stagingValueId,
        @parentValueId
   );
     
    
    IF @objectKey IS NOT NULL THEN
        CALL insertValueWords(
            @objectKey,
            @valueId
        );
    END IF;
    
    IF @stringValue IS NOT NULL THEN
        CALL insertValueWords(
            @stringValue,
            @valueId
        );
    END IF;
   
   COMMIT;
   
   SELECT
       @valueId AS  valueId,
       @objectIndex AS objectIndex;
       
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


    SET
        @stagingValueId = stagingValueId,
        @parentValueId = parentValueId;
      
    INSERT INTO
        ValueParentChild(
            parentValueId,
            childValueId
        )
    SELECT
        ValueParentChild.parentValueId,
        @stagingValueId
    FROM
        ValueParentChild
    WHERE
        ValueParentChild.childValueId =
        @parentValueId;
        
    INSERT INTO
        ValueParentChild(
            parentValueId,
            childValueId
        )
    SELECT
        @stagingValueId,
        @stagingValueId;
    
    
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

    SET @valueId = valueId,
             @word = word,
             @wordId = NULL;
             
    CALL insertWord(
        @word,
        @wordId
    );
 
    INSERT
    INTO
        ValueWord(
            valueId,
            wordId
         )
    SELECT 
         @valueId,
         @wordId
     WHERE
         NOT EXISTS(
             SELECT
                *
             FROM
                ValueWord
            WHERE
                ValueWord.valueId = @valueId
            AND
                ValueWord.wordId = @wordId
        );
        
     SET wordId = @wordId;
       
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
  
   IF text IS NULL THEN
       LEAVE exit_procedure;
   END IF;
   
   
   SET @lowerText = LOWER(text),
            @word = NULL,
            @start = 1,
            @length = LENGTH(@lowerText),
            @insertWordsOnly = NULL;
            
  IF valueId IS NULL THEN
          SET @insertWordsOnly = 1;
  ELSE
          SET @insertWordsOnly = 0;
  END IF;

   WHILE (@start <= @length) DO
         # Read first character
         SET @nchar = SUBSTR(
               @lowerText,
               @start,
               1
         );
         # Read subsequent delineators 
         WHILE (isDelineator(@nchar) AND
                          @start <= @length) DO
               SET @start = @start + 1;
               SET @nchar = SUBSTR(
                     @lowerText,
                     @start,
                     1
               );
         END WHILE;
         
         
         # Read word 
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
        
            IF (@insertWordsOnly = 1) THEN
                CALL insertWord(@word, @wordId);
            ELSE
                CALL insertValueWord(
                    @word,
                    valueId,
                    @wordId
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

    SET @word = word;
    
    INSERT
    INTO
        Word(
            word
        )
    SELECT
        @word
     WHERE
         NOT EXISTS(
             SELECT
                 *
             FROM
                 Word
             WHERE
                 Word.word = @word
         );
         
     SELECT
          Word.wordId
      INTO
          @wordId
      FROM
          Word
      WHERE
          Word.word = @word;
          
      SET wordId = @wordId;
      
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

    SET @valueId = valueId,
             @ownerId = ownerId,
             @locked = locked,
             @type = type,
             @objecyKey = objectKey,
             @isNull =  isNull,
             @stringValue = stringValue,
             @numericValue = numericValue,
             @boolValue = boolValue,
             @objectKeyWordId = NULL,
             @stringValueWordId = NULL;
          
    
    IF @objectKey IS NOT NULL THEN
    
        CALL insertWord(
            @objectKey,
            @objectKeyWordId
        );
        
        CALL insertValueWords(
            @objectKey,
            null
        );
        
    END IF;
    
    
    
    IF @stringValue IS NOT NULL THEN
        CALL insertWord(
            @stringValue,
            @stringValueWordId
        );
        CALL insertValueWords(
            @stringValue,
            null
        );
    END IF;
    
 
   DELETE
   FROM
       Value
   WHERE
       Value.parentValueId = @valueId;
  
   DELETE
    FROM
          ValueWord
    WHERE
         ValueWord.valueId = @valueId;
           
   UPDATE Value
   SET
           Value.ownerId = @ownerId,
           Value.locked = @locked,
           Value.type = @type,
           Value.objectKeyWordId =
               @objectKeyWordId,
           Value.isNull = @isNull,
           Value.stringValueWordId = 
               @stringValueWordId,
           Value.numericValue = @numericValue,
           Value.boolValue = @boolValue
   WHERE
           Value.valueId = @valueId;
        
        
    
    IF @objectKey IS NOT NULL THEN
        CALL insertValueWords(
            @objectKey,
            @valueId
        );
    END IF;
    
    IF @stringValue IS NOT NULL THEN
        CALL insertValueWords(
            @stringValue,
            @valueId
        );
    END IF;
   
    
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

-- Dump completed on 2025-11-26  1:10:30
