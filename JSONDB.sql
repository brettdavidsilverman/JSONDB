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
-- Table structure for table `Session`
--

DROP TABLE IF EXISTS `Session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Session` (
  `sessionId` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `userId` bigint NOT NULL,
  `createdDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ipAddress` varchar(15) NOT NULL,
  `lastAccessedDate` datetime NOT NULL,
  PRIMARY KEY (`sessionId`),
  UNIQUE KEY `UI_Session_userId` (`userId`) USING BTREE,
  UNIQUE KEY `I_Session_ipAddress` (`ipAddress`) USING BTREE,
  CONSTRAINT `FK_Session_userId` FOREIGN KEY (`userId`) REFERENCES `User` (`userId`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Session`
--

LOCK TABLES `Session` WRITE;
/*!40000 ALTER TABLE `Session` DISABLE KEYS */;
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
-- Table structure for table `User`
--

DROP TABLE IF EXISTS `User`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `User` (
  `userId` bigint NOT NULL AUTO_INCREMENT,
  `userEmail` varchar(320) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `logonSecret` blob,
  `newUserSecret` varchar(36) DEFAULT NULL,
  `lostSecret` varchar(36) DEFAULT NULL,
  PRIMARY KEY (`userId`),
  UNIQUE KEY `UI_userEmail` (`userEmail`)
) ENGINE=InnoDB AUTO_INCREMENT=68 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `User`
--

LOCK TABLES `User` WRITE;
/*!40000 ALTER TABLE `User` DISABLE KEYS */;
/*!40000 ALTER TABLE `User` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'JSONDB'
--
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
      WHERE  settingCode = @settingCode
   );
   
   RETURN @settingValue;
      
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
   DECLARE emailExists INT;
   
   SET          emailExists = (
      SELECT   COUNT(*)
      FROM     User
      WHERE  UserEmail = email
   );
   
   RETURN emailExists; 
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
   sessionId VARCHAR(36),
   ipAddress VARCHAR(16)
)
BEGIN

   SET @sessionId = sessionId,
           @ipAddress = ipAddress,
           @timeout = CAST(
                 getSetting(N'SESSION_TIMEOUT')
                 AS UNSIGNED
            );
       
    IF EXISTS(
       SELECT *
       FROM    Session
       WHERE sessionId = @sessionId
       AND        ipAddress = @ipAddress
    ) THEN
       SET   @lastAccessedDate = (
          SELECT   lastAccessedDate
          FROM      Session
          WHERE   sessionId = @sessionId
       );
       
       SET @expiryDate = DATE_ADD(
          @lastAccessedDate,
          INTERVAL @timeout SECOND
       );
       
       IF @expiryDate > NOW() THEN
          UPDATE   Session
          SET            lastAccessedDate = NOW()
          WHERE   sessionId =  @sessionId;
       ELSE
          SET @sessionId = NULL;
       END IF;
       
    ELSE
       SET @sessionId = NULL;
    END IF;
    
    SELECT  sessionId,
                       userId,
                       DATE_ADD(
                          lastAccessedDate,
                          INTERVAL @timeout SECOND
                       ) as expiryDate
   FROM      Session
   WHERE   sessionId = @sessionId;
   
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
   secret BLOB
)
BEGIN

   START TRANSACTION;
   
   SET @email = email;
   SET @secret = secret;
   SET @userId = NULL;
   
   IF NOT EXISTS(
         SELECT *
         FROM    User
         WHERE   userEmail = @email) THEN
         
      INSERT INTO User(
         userEmail,
         logonSecret,
         newUserSecret )
      VALUES  ( @email, @secret, UUID() );
      
      SET   @userId = (
         SELECT   userId
         FROM      User
         WHERE   userEmail = @email
      );
     
   END IF;
   
   COMMIT;
   
   SELECT   userId,
                      newUserSecret
   FROM     User
   WHERE  userId = @userId;
      
   
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
   sessionId VARCHAR(36),
   ipAddress VARCHAR(15)
)
BEGIN
   SET @sessionId = sessionId,
            @ipAddress = ipAddress;

   DELETE
   FROM      Session
   WHERE   sessionId = @sessionId
   AND          ipAddress = @ipAddress;
   
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
   secret BLOB,
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
   
   SET @sessionId = uuid();
   
   IF @userId IS NOT NULL 
   THEN
      /* clear out existing sessions */
      DELETE
      FROM      Session
      WHERE   Session.userId = @userId;
      
      INSERT
      INTO      Session(
                          sessionId,
                          userId,
                          ipAddress,
                          createdDate,
                          lastAccessedDate
                       )
      VALUES (
                      @sessionId, 
                      @userId, 
                      @ipAddress,
                      NOW(),
                      NOW()
                   );
      
   ELSE
      SET @sessionId = NULL;
   END IF;
   
   SELECT @userId as userId,
                    @sessionId as sessionId,
                    DATE_ADD(
                       NOW(),
                       INTERVAL @timeout SECOND
                    ) as expiryDate;
                    
   COMMIT; 
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
   SET             lostSecret = UUID()
   WHERE    userEmail = @email;
   
   SELECT   lostSecret
   FROM     User
   WHERE   userEmail = @email;
    
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
   lostSecret VARCHAR(36),
   newSecret BLOB
)
BEGIN

   START TRANSACTION;
   
   SET @email = email;
   SET @lostSecret = lostSecret;
   SET @newSecret = newSecret;
   
   SET   @userId = (
      SELECT   userId
      FROM     User
      WHERE  userEmail = @email
      AND        lostSecret = @lostSecret
   );
  
   IF NOT ISNULL( @userId) THEN
      UPDATE   User
      SET             logonSecret = @newSecret,
                           lostSecret = NULL
      WHERE   userId = @userId;
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
   newUserSecret VARCHAR(36)
)
BEGIN

   START TRANSACTION;
   
   SET @email = email;
   SET @newUserSecret = newUserSecret;
   SET @userId = (
      SELECT   userId
      FROM      User
      WHERE   User.userEmail = @email
      AND         User.newUserSecret = @newUserSecret
   );
   
   IF NOT ISNULL(@userId) THEN
      UPDATE   User
      SET             newUserSecret = NULL
      WHERE    userId = @userId;
   END IF;
   
   
   SELECT NOT ISNULL(@userId)
   AS            validated;
   
   COMMIT;
   
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

-- Dump completed on 2025-02-16 14:02:44
