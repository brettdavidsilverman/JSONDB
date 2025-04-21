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
) ENGINE=InnoDB AUTO_INCREMENT=284 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Session`
--

LOCK TABLES `Session` WRITE;
/*!40000 ALTER TABLE `Session` DISABLE KEYS */;
/*!40000 ALTER TABLE `Session` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SessionStatus`
--

DROP TABLE IF EXISTS `SessionStatus`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `SessionStatus` (
  `sessionStatusId` bigint NOT NULL AUTO_INCREMENT,
  `sessionId` bigint NOT NULL,
  `sessionStatus` blob,
  `cancelLastUpload` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`sessionStatusId`),
  UNIQUE KEY `UI_SessionStatus_sessionId` (`sessionId`) USING BTREE,
  CONSTRAINT `FK_SessionStatus_sessionId` FOREIGN KEY (`sessionId`) REFERENCES `Session` (`sessionId`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=42 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SessionStatus`
--

LOCK TABLES `SessionStatus` WRITE;
/*!40000 ALTER TABLE `SessionStatus` DISABLE KEYS */;
/*!40000 ALTER TABLE `SessionStatus` ENABLE KEYS */;
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
-- Table structure for table `UploadFile`
--

DROP TABLE IF EXISTS `UploadFile`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `UploadFile` (
  `uploadFileId` bigint NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`uploadFileId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `UploadFile`
--

LOCK TABLES `UploadFile` WRITE;
/*!40000 ALTER TABLE `UploadFile` DISABLE KEYS */;
/*!40000 ALTER TABLE `UploadFile` ENABLE KEYS */;
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
  `newUserSecret` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `lostSecret` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `validated` tinyint NOT NULL,
  PRIMARY KEY (`userId`),
  UNIQUE KEY `UI_userEmail` (`userEmail`)
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `User`
--

LOCK TABLES `User` WRITE;
/*!40000 ALTER TABLE `User` DISABLE KEYS */;
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
  `parentValueId` bigint DEFAULT NULL,
  `ownerId` bigint NOT NULL,
  `sessionId` bigint DEFAULT NULL,
  `type` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `objectIndex` bigint NOT NULL,
  `objectKey` blob,
  `lowerObjectKeyHash` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `numericValue` double DEFAULT NULL,
  `stringValue` blob,
  `boolValue` tinyint DEFAULT NULL,
  `isNull` tinyint NOT NULL,
  PRIMARY KEY (`valueId`),
  UNIQUE KEY `UI_Value_parentValueId_objectIndex` (`parentValueId`,`objectIndex`) USING BTREE,
  UNIQUE KEY `UI_Value_parentValueId_lowerObjectKeyHash` (`parentValueId`,`lowerObjectKeyHash`) USING BTREE,
  KEY `I_Value_parentValueId` (`parentValueId`) USING BTREE,
  KEY `I_Value_objectKey_numericValue` (`objectKey`(100),`numericValue`) USING BTREE,
  KEY `I_Value_objectKey_stringValue` (`objectKey`(100),`stringValue`(100)) USING BTREE,
  KEY `I_Value_stringValue` (`stringValue`(100)) USING BTREE,
  KEY `I_Value_ownerId` (`ownerId`),
  KEY `I_Value_sessionId` (`sessionId`) USING BTREE,
  CONSTRAINT `FK_Value_ownerId` FOREIGN KEY (`ownerId`) REFERENCES `User` (`userId`) ON DELETE CASCADE,
  CONSTRAINT `FK_Value_sessionId` FOREIGN KEY (`sessionId`) REFERENCES `Session` (`sessionId`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=47740430 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Value`
--

LOCK TABLES `Value` WRITE;
/*!40000 ALTER TABLE `Value` DISABLE KEYS */;
/*!40000 ALTER TABLE `Value` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ValueWord`
--

DROP TABLE IF EXISTS `ValueWord`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ValueWord` (
  `valueWordId` bigint NOT NULL AUTO_INCREMENT,
  `valueId` bigint NOT NULL,
  `wordId` bigint NOT NULL,
  PRIMARY KEY (`valueWordId`),
  UNIQUE KEY `UI_ValueWord_valueId_wordId` (`valueId`,`wordId`) USING BTREE,
  KEY `I_ValueWord_valueId` (`valueId`) USING BTREE,
  KEY `I_ValueWord_wordId` (`wordId`) USING BTREE,
  CONSTRAINT `FK_ValueWord_valueId` FOREIGN KEY (`valueId`) REFERENCES `Value` (`valueId`) ON DELETE CASCADE,
  CONSTRAINT `FK_ValueWord_wordId` FOREIGN KEY (`wordId`) REFERENCES `Word` (`wordId`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=733 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
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
  `word` blob NOT NULL,
  PRIMARY KEY (`wordId`),
  KEY `I_Word_word` (`word`(100)) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=368 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Word`
--

LOCK TABLES `Word` WRITE;
/*!40000 ALTER TABLE `Word` DISABLE KEYS */;
INSERT INTO `Word` VALUES (5,_binary '💕'),(6,_binary 'hello'),(7,_binary 'accidental drug related deaths 2012-2018'),(8,_binary 'office of the chief medical examiner'),(9,_binary 'http://www.ct.gov/ocme'),(10,_binary 'health and human services'),(11,_binary 'a listing of each accidental death associated with drug overdose in connecticut from 2012 to 2018. a \"y\" value under the different substance columns indicates that particular substance was detected.\n\ndata are derived from an investigation by the office of the chief medical examiner which includes the toxicity report, death certificate, as well as a scene investigation.\n\nthe “morphine (not heroin)” values are related to the differences between how morphine and heroin are metabolized and therefor detected in the toxicity results. heroin metabolizes to 6-mam which then metabolizes to morphine.  6-mam is unique to heroin, and has a short half-life (as does heroin itself). thus, in some heroin deaths, the toxicity results will not indicate whether the morphine is from heroin or prescription morphine. in these cases the medical examiner may be able to determine the cause based on the scene investigation (such as  finding heroin needles). if they find prescription morphine at the scene it is certified as “morphine (not heroin).”  therefor, the cause of death may indicate morphine, but the heroin or morphine (not heroin) may not be indicated.\n\n “any opioid” – if the medical examiner cannot conclude whether it’s rx morphine or heroin based morphine in the toxicity results, that column may be checked'),(12,_binary 'table'),(13,_binary 'public_domain'),(14,_binary 'official'),(15,_binary 'published'),(16,_binary 'deaths'),(17,_binary 'tabular'),(18,_binary 'approved'),(19,_binary 'public_audience_request'),(20,_binary 'change_audience'),(21,_binary 'read'),(22,_binary 'success'),(23,_binary 'cvy9-n6sb'),(24,_binary 'tyler kleykamp'),(25,_binary 'sid'),(26,_binary 'meta_data'),(27,_binary ':sid'),(28,_binary 'hidden'),(29,_binary 'id'),(30,_binary ':id'),(31,_binary 'position'),(32,_binary ':position'),(33,_binary 'created_at'),(34,_binary ':created_at'),(35,_binary 'created_meta'),(36,_binary ':created_meta'),(37,_binary 'updated_at'),(38,_binary ':updated_at'),(39,_binary 'updated_meta'),(40,_binary ':updated_meta'),(41,_binary 'meta'),(42,_binary ':meta'),(43,_binary 'text'),(44,''),(45,_binary '18-1018'),(46,_binary '12-0002'),(47,_binary '12-0003'),(48,_binary '12-0004'),(49,_binary '12-0005'),(50,_binary '12-0006'),(51,_binary '12-0007'),(52,_binary '12-0008'),(53,_binary '12-0009'),(54,_binary '12-0010'),(55,_binary '12-0011'),(56,_binary '12-0012'),(57,_binary '12-0013'),(58,_binary '12-0014'),(59,_binary '12-0015'),(60,_binary '12-0016'),(61,_binary '12-0017'),(62,_binary '12-0018'),(63,_binary '12-0019'),(64,_binary '12-0020'),(65,_binary '12-0021'),(66,_binary '12-0001'),(67,_binary 'date'),(68,_binary 'calendar_date'),(69,_binary '2018-12-31t00:00:00.000'),(70,_binary '2017-08-18t00:00:00.000'),(71,_binary '2017-06-18t00:00:00.000'),(72,_binary '2017-06-02t00:00:00.000'),(73,_binary '2017-05-29t00:00:00.000'),(74,_binary '2018-12-17t00:00:00.000'),(75,_binary '2016-11-13t00:00:00.000'),(76,_binary '2017-03-05t00:00:00.000'),(77,_binary '2013-09-21t00:00:00.000'),(78,_binary '2016-10-03t00:00:00.000'),(79,_binary '2018-08-05t00:00:00.000'),(80,_binary '2018-05-13t00:00:00.000'),(81,_binary '2018-05-12t00:00:00.000'),(82,_binary '2017-02-11t00:00:00.000'),(83,_binary '2018-07-03t00:00:00.000'),(84,_binary '2016-02-26t00:00:00.000'),(85,_binary '2018-06-02t00:00:00.000'),(86,_binary '2017-12-27t00:00:00.000'),(87,_binary '2017-05-05t00:00:00.000'),(88,_binary '2018-06-28t00:00:00.000'),(89,_binary '2016-11-18t00:00:00.000'),(90,_binary '2012-01-01t00:00:00.000'),(91,_binary 'datetype'),(92,_binary 'datereported'),(93,_binary 'dateofdeath'),(94,_binary 'age'),(95,_binary 'number'),(96,_binary 'sex'),(97,_binary 'unknown'),(98,_binary 'male'),(99,_binary 'female'),(100,_binary 'race'),(101,_binary 'white'),(102,_binary 'hispanic, white'),(103,_binary 'black'),(104,_binary 'hispanic, black'),(105,_binary 'asian, other'),(106,_binary 'asian indian'),(107,_binary 'other'),(108,_binary 'chinese'),(109,_binary 'hawaiian'),(110,_binary 'native american, other'),(111,_binary 'residencecity'),(112,_binary 'zionsville'),(113,_binary 'hartford'),(114,_binary 'waterbury'),(115,_binary 'bridgeport'),(116,_binary 'new haven'),(117,_binary 'new britain'),(118,_binary 'bristol'),(119,_binary 'meriden'),(120,_binary 'norwich'),(121,_binary 'manchester'),(122,_binary 'torrington'),(123,_binary 'west haven'),(124,_binary 'east hartford'),(125,_binary 'middletown'),(126,_binary 'danbury'),(127,_binary 'new london'),(128,_binary 'enfield'),(129,_binary 'stratford'),(130,_binary 'stamford'),(131,_binary 'milford'),(132,_binary 'hamden'),(133,_binary 'alfred station'),(134,_binary 'residencecounty'),(135,_binary 'yankton'),(136,_binary 'fairfield'),(137,_binary 'litchfield'),(138,_binary 'middlesex'),(139,_binary 'windham'),(140,_binary 'tolland'),(141,_binary 'westchester'),(142,_binary 'dutchess'),(143,_binary 'hampden'),(144,_binary 'essex'),(145,_binary 'suffolk'),(146,_binary 'washington'),(147,_binary 'orange'),(148,_binary 'harris'),(149,_binary 'berkshire'),(150,_binary 'new york'),(151,_binary 'aroostook'),(152,_binary 'gloucester'),(153,_binary 'residencestate'),(154,_binary 'vt'),(155,_binary 'ct'),(156,_binary 'ny'),(157,_binary 'ma'),(158,_binary 'fl'),(159,_binary 'nj'),(160,_binary 'ri'),(161,_binary 'pa'),(162,_binary 'tx'),(163,_binary 'me'),(164,_binary 'ca'),(165,_binary 'co'),(166,_binary 'il'),(167,_binary 'mi'),(168,_binary 'ga'),(169,_binary 'md'),(170,_binary 'mn'),(171,_binary 'oh'),(172,_binary 'la'),(173,_binary 'ok'),(174,_binary 'nc'),(175,_binary 'al'),(176,_binary 'deathcity'),(177,_binary 'woodstock'),(178,_binary 'norwalk'),(179,_binary 'derby'),(180,_binary 'deathcounty'),(181,_binary 'usa'),(182,_binary 'location'),(183,_binary 'residence'),(184,_binary 'hospital'),(185,_binary 'convalescent home'),(186,_binary 'nursing home'),(187,_binary 'hospice'),(188,_binary 'locationifother'),(189,_binary 'ymca-parking lot'),(190,_binary 'friend\'s residence'),(191,_binary 'friend\'s house'),(192,_binary 'friend\'s home'),(193,_binary 'in vehicle'),(194,_binary 'friends house'),(195,_binary 'parking lot'),(196,_binary 'boyfriend\'s residence'),(197,_binary 'motel'),(198,_binary 'mother\'s residence'),(199,_binary 'hotel/motel'),(200,_binary 'girlfriend\'s house'),(201,_binary 'roadway'),(202,_binary 'hotel or motel'),(203,_binary 'residential building'),(204,_binary 'wooded area'),(205,_binary 'friend\'s apartment'),(206,_binary 'sober house'),(207,_binary 'abandoned building'),(208,_binary 'descriptionofinjury'),(209,_binary 'used oxymorphone'),(210,_binary 'substance abuse'),(211,_binary 'drug use'),(212,_binary 'ingestion'),(213,_binary 'drug abuse'),(214,_binary 'injection'),(215,_binary 'inhalation'),(216,_binary 'used heroin'),(217,_binary 'multiple drug use'),(218,_binary 'took medications'),(219,_binary 'acute and chronic substance abuse'),(220,_binary 'used opiates'),(221,_binary 'used medications'),(222,_binary 'prescription medicine abuse'),(223,_binary 'used cocaine'),(224,_binary 'abuse'),(225,_binary 'injuryplace'),(226,_binary 'yard'),(227,_binary 'automobile'),(228,_binary 'other, other outdoor area'),(229,_binary 'halfway house'),(230,_binary 'house'),(231,_binary 'apartment'),(232,_binary 'restaurant'),(233,_binary 'other indoor area'),(234,_binary 'apartment house'),(235,_binary 'other, public buildings'),(236,_binary 'other (unknown)'),(237,_binary 'public park'),(238,_binary 'driveway'),(239,_binary 'alleyway'),(240,_binary 'injurycity'),(241,_binary 'wtby'),(242,_binary 'naugatuck'),(243,_binary 'amston'),(244,_binary 'injurycounty'),(245,_binary 'putnam'),(246,_binary 'injurystate'),(247,_binary 'connecticut'),(248,_binary 'cod'),(249,_binary 'tramadol, diphenhydramine and hydrocodone intoxication'),(250,_binary 'acute fentanyl intoxication'),(251,_binary 'multiple drug toxicity'),(252,_binary 'heroin intoxication'),(253,_binary 'acute heroin intoxication'),(254,_binary 'heroin toxicity'),(255,_binary 'acute heroin toxicity'),(256,_binary 'acute cocaine intoxication'),(257,_binary 'cocaine intoxication'),(258,_binary 'acute intoxication due to the combined effects of fentanyl and heroin'),(259,_binary 'cocaine toxicity'),(260,_binary 'opiate toxicity'),(261,_binary 'fentanyl toxicity'),(262,_binary 'methadone intoxication'),(263,_binary 'acute heroin and fentanyl toxicities'),(264,_binary 'fentanyl intoxication'),(265,_binary 'cocaine and heroin intoxication'),(266,_binary 'acute intoxication due to the combined effects of cocaine and fentanyl'),(267,_binary 'intoxication due to the combined effects of cocaine and heroin'),(268,_binary 'acute oxycodone intoxication'),(269,_binary '1,1-difluoroethane toxicity'),(270,_binary 'othersignifican'),(271,_binary 'seizure disorder'),(272,_binary 'hypertensive and atherosclerotic cardiovascular disease'),(273,_binary 'recent cocaine use'),(274,_binary 'coronary artery disease'),(275,_binary 'cardiac hypertrophy'),(276,_binary 'hypertensive cardiovascular disease'),(277,_binary 'chronic alcoholism'),(278,_binary 'ascvd'),(279,_binary 'atherosclerotic cardiovascular disease'),(280,_binary 'cardiomegaly'),(281,_binary 'cocaine use'),(282,_binary 'arteriosclerotic heart disease'),(283,_binary 'coronary atherosclerosis'),(284,_binary 'chronic cocaine abuse'),(285,_binary 'chronic cocaine use'),(286,_binary 'atherosclerotic coronary artery disease'),(287,_binary 'chronic obstructive pulmonary disease'),(288,_binary 'atherosclerotic coronary artery disease with cardiac hypertrophy'),(289,_binary 'diabetes mellitus'),(290,_binary 'acute alprazolam intoxication, obesity'),(291,_binary 'heroin'),(292,_binary 'y'),(293,_binary 'cocaine'),(294,_binary 'fentanyl'),(295,_binary 'y (ptch)'),(296,_binary 'y-a'),(297,_binary 'y pops'),(298,_binary 'fentanylanalogue'),(299,_binary 'oxycodone'),(300,_binary 'oxymorphone'),(301,_binary 'ethanol'),(302,_binary 'hydrocodone'),(303,_binary 'benzodiazepine'),(304,_binary 'methadone'),(305,_binary 'amphet'),(306,_binary 'tramad'),(307,_binary 'morphine_notheroin'),(308,_binary 'yes'),(309,_binary 'no rx but straws'),(310,_binary 'pcp neg'),(311,_binary 'stole meds'),(312,_binary 'hydromorphone'),(313,_binary 'zolpidem'),(314,_binary 'pcp'),(315,_binary 'morphine'),(316,_binary 'hydromorph'),(317,_binary 'bupren'),(318,_binary 'u-47700'),(319,_binary 'morph'),(320,_binary 'buprenor'),(321,_binary 'morphine rx'),(322,_binary 'opiate'),(323,_binary 'opiates'),(324,_binary 'mdma'),(325,_binary 'carfentanil'),(326,_binary 'ketamine'),(327,_binary 'bupreno'),(328,_binary '2-a'),(329,_binary 'opiatenos'),(330,_binary 'anyopioid'),(331,_binary 'n'),(332,_binary 'mannerofdeath'),(333,_binary 'pending'),(334,_binary 'accident'),(335,_binary 'natural'),(336,_binary 'deathcitygeo'),(337,_binary 'human_address'),(338,_binary 'latitude'),(339,_binary 'longitude'),(340,_binary 'machine_address'),(341,_binary 'needs_recoding'),(342,_binary 'residencecitygeo'),(343,_binary 'injurycitygeo'),(344,_binary 'town index'),(345,_binary ':@computed_region_m4y2_whse'),(346,_binary 'georegion_match_on_point'),(347,_binary '_m4y2-whse'),(348,_binary '_feature_id'),(349,_binary 'viewer'),(350,_binary 'public'),(351,_binary 'public domain'),(352,_binary 'death'),(353,_binary 'fatrow'),(354,_binary 'page'),(355,_binary 'rfiw-8538'),(356,_binary 'pauline zaldonis'),(357,_binary 'interactive'),(358,_binary 'site_member'),(359,_binary 'acceptedeula'),(360,_binary 'maybestoriescoowner'),(361,_binary 'drug'),(362,_binary 'overdose'),(363,_binary 'opioid'),(364,_binary 'default'),(365,_binary 'restorable'),(366,_binary 'restorepossiblefortype'),(367,_binary 'unsaved');
/*!40000 ALTER TABLE `Word` ENABLE KEYS */;
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
      WHERE Setting. settingCode = @settingCode
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
   ignoreExpires TINYINT
)
BEGIN

  
   SET @sessionKey = sessionKey,
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
   oldSecret BLOB,
   newSecret BLOB
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
   secret BLOB
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
           objectKey BLOB,
           lowerObjectKey BLOB,
           isNull TINYINT,
           stringValue BLOB,
           lowerStringValue BLOB,
           numericValue DOUBLE,
           boolValue TINYINT
)
BEGIN
   
   SET @sessionKey = sessionKey;
   SET @sessionId = (
              SELECT Session.sessionId
              FROM   Session
              WHERE Session.sessionKey =
                               @sessionKey
           );
           
   SET @lowerStringValue =
                  lowerStringValue;
   
   START TRANSACTION; 
   
   INSERT INTO Value(
           parentValueId,
           ownerId,
           sessionId,
           type,
           objectIndex,
           objectKey,
           lowerObjectKeyHash,
           isNull,
           stringValue,
           numericValue,
           boolValue
   )
   VALUES(
           parentValueId,
           ownerId,
           @sessionId,
           type,
           objectIndex,
           objectKey,
           MD5(lowerObjectKey),
           isNull,
           stringValue,
           numericValue,
           boolValue
   );
   
   SET @valueId = LAST_INSERT_ID();
   
   IF @lowerStringValue IS NOT NULL THEN
         CALL createValueWord(
               @valueId,
               @lowerStringValue
         );
   END IF;
   
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
      lowerWord BLOB
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
   
   INSERT
   INTO      ValueWord(valueId, wordId)
   VALUES (@valueId, @wordId);
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
   _valueId BIGINT
)
BEGIN
   DECLARE done INT DEFAULT FALSE;
   DECLARE childId BIGINT;
   
   DECLARE cur CURSOR FOR
   SELECT    Value.valueId
   FROM       Value
   WHERE    Value.parentValueId = _valueId;
  
   DECLARE CONTINUE HANDLER FOR NOT
   FOUND SET done = TRUE;

   SET  max_sp_recursion_depth = 255;
   
   OPEN cur;

   read_loop: LOOP
         FETCH cur INTO childId;
         IF done THEN
            LEAVE read_loop;
         END IF;
         CALL deleteValue(childId);
   END LOOP;

   CLOSE cur;

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
   _valueId BIGINT
)
BEGIN
   DECLARE done INT DEFAULT FALSE;
   DECLARE childId BIGINT;
   
   DECLARE cur CURSOR FOR
   SELECT    Value.valueId
   FROM       Value
   WHERE    Value.parentValueId = _valueId;
  
   DECLARE CONTINUE HANDLER FOR NOT
   FOUND SET done = TRUE;

   SET  max_sp_recursion_depth = 255;
   
   OPEN cur;

   read_loop: LOOP
         FETCH cur INTO childId;
         IF done THEN
            LEAVE read_loop;
         END IF;
         CALL deleteValue(childId);
   END LOOP;

   CLOSE cur;

   DELETE
   FROM      Value
   WHERE   Value.valueId = _valueId; 
  
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
   
   SELECT valueId
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
/*!50003 DROP PROCEDURE IF EXISTS `getValueByPath` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`brett`@`%` PROCEDURE `getValueByPath`(
   userId BIGINT,
   ownerId BIGINT,
   parentValueId BIGINT,
   objectIndex BIGINT,
   lowerObjectKey BLOB
)
BEGIN
   SET           @userId = userId,
                      @ownerId = ownerId,
                      @parentValueId = parentValueId,
                      @objectIndex = objectIndex,
                      @lowerObjectKeyHash =
                         MD5(lowerObjectKey);
   
   SELECT        Value.valueId
   FROM           Value
   WHERE      ( (@parentValueId IS NULL
                          AND
                        Value.parentValueId IS NULL) OR
                     (Value.parentValueId = @parentValueId))
   AND            (@objectIndex IS NULL
                         OR
                          Value.objectIndex = @objectIndex)
   AND            (@lowerObjectKeyHash IS NULL
                          OR
                         Value.lowerObjectKeyHash =
                           @lowerObjectKeyHash)
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
                            ) as childCount
   FROM            Value
   WHERE         Value.valueId = 
                            @valueId;
   
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
                            ) AS childCount
   FROM            Value
   WHERE         Value.parentValueId = 
                            @parentValueId
   ORDER BY   Value.objectIndex;
   
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
   sessionKey VARCHAR(32),
   ipAddress VARCHAR(15)
)
BEGIN
   SET @sessionKey = sessionKey,
            @ipAddress = ipAddress;

   DELETE
   FROM      Session
   WHERE   Session.sessionKey = @sessionKey
   OR         Session. ipAddress = @ipAddress;
   
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
   
   SET @sessionKey = MD5(UUID());
   
   IF @userId IS NOT NULL 
   THEN
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
   sessionStatus BLOB
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
   
   IF EXISTS(
            SELECT *
            FROM     SessionStatus
            WHERE  SessionStatus.sessionId =
                               @sessionId
   ) THEN
         UPDATE SessionStatus
         SET           SessionStatus.sessionStatus =
                            @sessionStatus
         WHERE   SessionStatus.sessionId =
                            @sessionId;
  ELSE
         INSERT
         INTO      SessionStatus(
                             sessionId,
                             sessionStatus
                          )
         VALUES (
                             @sessionId,
                             @sessionStatus
                          );
  END IF;
   
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
   existingValueId BIGINT
)
exit_procedure: BEGIN
   SET @sessionKey = sessionKey,
            @existingValueId = existingValueId;
 
   SET    @sessionId = (
                         SELECT   Session.sessionId
                         FROM      Session
                         WHERE   Session.sessionKey =
                                            @sessionKey
                      );

   SET      @userId = (
                       SELECT userId
                       FROM    Session
                       WHERE  Session.sessionKey = 
                                        @sessionKey
                 );
                
   SET     @tempValueId = (
          SELECT            Value.valueId
          FROM               Value
          WHERE            Value.parentValueId
                                       IS NULL
          AND                   Value.sessionId = 
                                       @sessionId
   );
         
   SET     @existingParentId = (
         SELECT          Value.valueId
         FROM             Value
         WHERE          Value.ownerId = @userId
         AND                 Value.valueId =
                                    @existingValueId
   );

  START TRANSACTION;
   
   IF @existingParentId IS NULL THEN
         INSERT
         INTO      Value(
                              type,
                              ownerId,
                              objectIndex,
                              isNull
                          )
         VALUES ( 'object', @userId, 0, 0);
         SET @existingParentId =
               LAST_INSERT_ID();
   END IF;

   IF  @userId IS NULL OR
         @sessionId IS NULL OR
         @existingParentId IS  NULL OR
         @tempValueId IS NULL
   THEN
         ROLLBACK;
         LEAVE exit_procedure;
   END IF;
   
   
   CALL deleteChildValues(@existingParentId);

   /* MIGRATE TEMP CHILD RECORD UP
        TO  EXISTING PARENT RECORD */
        
   UPDATE      Value AS ExistingValue,
                           Value AS TempValue
   SET                ExistingValue.type =
                              TempValue.type,
                           ExistingValue.numericValue =
                              TempValue.numericValue,
                           ExistingValue.stringValue =
                              TempValue.stringValue,
                           ExistingValue.boolValue =
                              TempValue.boolValue,
                           ExistingValue.isNull =
                              TempValue.isNull
   WHERE       ExistingValue.valueId =
                              @existingParentId
   AND              TempValue.valueId =
                              @tempValueId;
   
   UPDATE Value
   SET           Value.parentValueId = 
                         @existingParentId
   WHERE   Value.parentValueId =
                         @tempValueId;
                         
   DELETE
   FROM      Value
   WHERE   Value.valueId = @tempValueId;
   
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

-- Dump completed on 2025-04-21 10:30:22
