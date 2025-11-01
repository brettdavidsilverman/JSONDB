-- MySQL dump 10.13  Distrib 8.4.6, for Linux (x86_64)
--
-- Host: localhost    Database: JSONDB
-- ------------------------------------------------------
-- Server version	8.4.6

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
-- Table structure for table `Job`
--

DROP TABLE IF EXISTS `Job`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Job` (
  `jobId` bigint NOT NULL AUTO_INCREMENT,
  `userId` bigint NOT NULL,
  `jobStatus` text,
  `jobPath` text NOT NULL,
  PRIMARY KEY (`jobId`),
  KEY `I_Job_userId` (`userId`) USING BTREE,
  CONSTRAINT `FK_Job_User_userId` FOREIGN KEY (`userId`) REFERENCES `User` (`userId`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=41558 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Job`
--

LOCK TABLES `Job` WRITE;
/*!40000 ALTER TABLE `Job` DISABLE KEYS */;
INSERT INTO `Job` VALUES (41541,118,NULL,'/my/a'),(41543,118,NULL,'/my/a'),(41545,118,NULL,'/my/a'),(41547,118,NULL,'/my/a'),(41550,118,NULL,'/my'),(41551,118,NULL,'/my'),(41553,118,NULL,'/my/a'),(41555,118,NULL,'/my/a'),(41557,118,NULL,'/my/a');
/*!40000 ALTER TABLE `Job` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SearchValue`
--

DROP TABLE IF EXISTS `SearchValue`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `SearchValue` (
  `valueId` bigint NOT NULL,
  PRIMARY KEY (`valueId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SearchValue`
--

LOCK TABLES `SearchValue` WRITE;
/*!40000 ALTER TABLE `SearchValue` DISABLE KEYS */;
/*!40000 ALTER TABLE `SearchValue` ENABLE KEYS */;
UNLOCK TABLES;

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
) ENGINE=InnoDB AUTO_INCREMENT=932 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Session`
--

LOCK TABLES `Session` WRITE;
/*!40000 ALTER TABLE `Session` DISABLE KEYS */;
INSERT INTO `Session` VALUES (928,'7ecb8709c5a6339a7e376221763ee5b8',118,'2025-11-01 21:43:36','35.187.132.10','2025-11-01 21:44:17'),(930,'bd2fa49a64d6cf1e073f659d65ccaf65',118,'2025-11-01 21:50:58','49.185.199.16','2025-11-01 22:44:21'),(931,'cdc449be8fdf0282ac9411faeec7a01a',118,'2025-11-01 22:43:28','34.116.22.44','2025-11-01 22:50:36');
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
  `sessionStatus` text,
  `cancelLastUpload` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`sessionStatusId`),
  UNIQUE KEY `UI_SessionStatus_sessionId` (`sessionId`) USING BTREE,
  CONSTRAINT `FK_SessionStatus_sessionId` FOREIGN KEY (`sessionId`) REFERENCES `Session` (`sessionId`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=9548 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
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
INSERT INTO `StagingValue` VALUES (2654894,-1,118,'object',0,NULL,NULL,NULL,NULL,NULL,0),(2654895,2654894,118,'object',0,'meta','meta',NULL,NULL,NULL,0),(2654896,NULL,118,'object',0,'my','view',NULL,NULL,NULL,0),(2654897,NULL,118,'string',0,'my','id',NULL,'rybz-nyjw',NULL,0),(2654898,NULL,118,'string',0,'my','name',NULL,'Accidental Drug Related Deaths 2012-2018',NULL,0),(2654899,NULL,118,'string',0,'my','attribution',NULL,'Office of the Chief Medical Examiner',NULL,0),(2654900,2654896,118,'string',3,'attributionLink','attributionlink',NULL,'http://www.ct.gov/ocme',NULL,0),(2654901,NULL,118,'number',0,'my','averagerating',0,NULL,NULL,0),(2654902,NULL,118,'string',0,'my','category',NULL,'Health and Human Services',NULL,0),(2654903,2654896,118,'number',6,'createdAt','createdat',1444407518,NULL,NULL,0),(2654904,2654896,118,'string',7,'description','description',NULL,'A listing of each accidental death associated with drug overdose in Connecticut from 2012 to 2018. A \"Y\" value under the different substance columns indicates that particular substance was detected.\n\nData are derived from an investigation by the Office of the Chief Medical Examiner which includes the toxicity report, death certificate, as well as a scene investigation.\n\nThe “Morphine (Not Heroin)” values are related to the differences between how Morphine and Heroin are metabolized and therefor detected in the toxicity results. Heroin metabolizes to 6-MAM which then metabolizes to morphine.  6-MAM is unique to heroin, and has a short half-life (as does heroin itself). Thus, in some heroin deaths, the toxicity results will not indicate whether the morphine is from heroin or prescription morphine. In these cases the Medical Examiner may be able to determine the cause based on the scene investigation (such as  finding heroin needles). If they find prescription morphine at the scene it is certified as “Morphine (not heroin).”  Therefor, the Cause of Death may indicate Morphine, but the Heroin or Morphine (Not Heroin) may not be indicated.\n\n “Any Opioid” – If the Medical Examiner cannot conclude whether it’s RX Morphine or heroin based morphine in the toxicity results, that column may be checked',NULL,0),(2654905,NULL,118,'string',0,'my','displaytype',NULL,'table',NULL,0),(2654906,2654906,118,'number',2,'done','downloadcount',106093,NULL,NULL,0),(2654907,2654896,118,'bool',10,'hideFromCatalog','hidefromcatalog',NULL,NULL,0,0),(2654908,2654896,118,'bool',11,'hideFromDataJson','hidefromdatajson',NULL,NULL,0,0),(2654909,2654896,118,'number',12,'indexUpdatedAt','indexupdatedat',1557088571,NULL,NULL,0),(2654910,2654896,118,'string',13,'licenseId','licenseid',NULL,'PUBLIC_DOMAIN',NULL,0),(2654911,2654896,118,'bool',14,'newBackend','newbackend',NULL,NULL,1,0),(2654912,2654896,118,'number',15,'numberOfComments','numberofcomments',0,NULL,NULL,0),(2654913,2654896,118,'number',16,'oid','oid',31432840,NULL,NULL,0),(2654914,2654896,118,'string',17,'provenance','provenance',NULL,'official',NULL,0),(2654915,2654896,118,'bool',18,'publicationAppendEnabled','publicationappendenabled',NULL,NULL,0,0),(2654916,2654896,118,'number',19,'publicationDate','publicationdate',1557088625,NULL,NULL,0),(2654917,2654896,118,'number',20,'publicationGroup','publicationgroup',4729826,NULL,NULL,0),(2654918,2654896,118,'string',21,'publicationStage','publicationstage',NULL,'published',NULL,0),(2654919,2654896,118,'string',22,'resourceName','resourcename',NULL,'deaths',NULL,0),(2654920,2654896,118,'number',23,'rowsUpdatedAt','rowsupdatedat',1553870650,NULL,NULL,0),(2654921,2654896,118,'number',24,'tableId','tableid',16175801,NULL,NULL,0),(2654922,2654896,118,'number',25,'totalTimesRated','totaltimesrated',0,NULL,NULL,0),(2654923,2654896,118,'number',26,'viewCount','viewcount',28575,NULL,NULL,0),(2654924,2654896,118,'number',27,'viewLastModified','viewlastmodified',1593009314,NULL,NULL,0),(2654925,2654896,118,'string',28,'viewType','viewtype',NULL,'tabular',NULL,0),(2654926,2654896,118,'array',29,'approvals','approvals',NULL,NULL,NULL,0),(2654927,2654926,118,'object',0,NULL,NULL,NULL,NULL,NULL,0),(2654928,2654927,118,'number',0,'reviewedAt','reviewedat',1557088625,NULL,NULL,0),(2654929,2654927,118,'bool',1,'reviewedAutomatically','reviewedautomatically',NULL,NULL,1,0),(2654930,2654927,118,'string',2,'state','state',NULL,'approved',NULL,0),(2654931,2654927,118,'number',3,'submissionId','submissionid',819766,NULL,NULL,0),(2654932,2654927,118,'string',4,'submissionObject','submissionobject',NULL,'public_audience_request',NULL,0),(2654933,2654927,118,'string',5,'submissionOutcome','submissionoutcome',NULL,'change_audience',NULL,0),(2654934,2654927,118,'number',6,'submittedAt','submittedat',1557088625,NULL,NULL,0),(2654935,2654927,118,'number',7,'workflowId','workflowid',2184,NULL,NULL,0),(2654936,2654927,118,'object',8,'submissionDetails','submissiondetails',NULL,NULL,NULL,0),(2654937,2654936,118,'string',0,'permissionType','permissiontype',NULL,'READ',NULL,0),(2654938,2654927,118,'object',9,'submissionOutcomeApplication','submissionoutcomeapplication',NULL,NULL,NULL,0),(2654939,2654938,118,'number',0,'failureCount','failurecount',0,NULL,NULL,0),(2654940,2654938,118,'string',1,'status','status',NULL,'success',NULL,0),(2654941,2654927,118,'object',10,'submitter','submitter',NULL,NULL,NULL,0),(2654942,2654941,118,'string',0,'id','id',NULL,'cvy9-n6sb',NULL,0),(2654943,2654941,118,'string',1,'displayName','displayname',NULL,'Tyler Kleykamp',NULL,0),(2654944,2654896,118,'array',30,'columns','columns',NULL,NULL,NULL,0),(2654945,2654944,118,'object',0,NULL,NULL,NULL,NULL,NULL,0),(2654946,2654945,118,'number',0,'id','id',-1,NULL,NULL,0),(2654947,2654945,118,'string',1,'name','name',NULL,'sid',NULL,0),(2654948,2654945,118,'string',2,'dataTypeName','datatypename',NULL,'meta_data',NULL,0),(2654949,2654945,118,'string',3,'fieldName','fieldname',NULL,':sid',NULL,0),(2654950,2654945,118,'number',4,'position','position',0,NULL,NULL,0),(2654951,2654945,118,'string',5,'renderTypeName','rendertypename',NULL,'meta_data',NULL,0),(2654952,2654945,118,'object',6,'format','format',NULL,NULL,NULL,0),(2654953,2654945,118,'array',7,'flags','flags',NULL,NULL,NULL,0),(2654954,2654953,118,'string',0,NULL,NULL,NULL,'hidden',NULL,0),(2654955,2654944,118,'object',1,NULL,NULL,NULL,NULL,NULL,0),(2654956,2654955,118,'number',0,'id','id',-1,NULL,NULL,0),(2654957,2654955,118,'string',1,'name','name',NULL,'id',NULL,0),(2654958,2654955,118,'string',2,'dataTypeName','datatypename',NULL,'meta_data',NULL,0),(2654959,2654955,118,'string',3,'fieldName','fieldname',NULL,':id',NULL,0),(2654960,2654955,118,'number',4,'position','position',0,NULL,NULL,0),(2654961,NULL,118,'string',0,'boo','rendertypename',NULL,'meta_data',NULL,0),(2654962,NULL,118,'object',0,'my','format',NULL,NULL,NULL,0),(2654963,NULL,118,'array',0,'my','flags',NULL,NULL,NULL,0),(2654964,NULL,118,'string',0,'my',NULL,NULL,'hidden',NULL,0),(2654965,NULL,118,'object',0,'my',NULL,NULL,NULL,NULL,0),(2654966,2654965,118,'number',0,'id','id',-1,NULL,NULL,0),(2654967,NULL,118,'string',0,'my','name',NULL,'position',NULL,0),(2654968,2654967,118,'string',0,'my','datatypename',NULL,'meta_data',NULL,0),(2654969,2654965,118,'string',3,'fieldName','fieldname',NULL,':position',NULL,0),(2654970,NULL,118,'number',0,'my','position',0,NULL,NULL,0),(2654971,NULL,118,'string',0,'my','rendertypename',NULL,'meta_data',NULL,0),(2654972,NULL,118,'object',0,'my','format',NULL,NULL,NULL,0),(2654973,2654972,118,'array',0,'boo','flags',NULL,NULL,NULL,0),(2654974,2654973,118,'string',0,NULL,NULL,NULL,'hidden',NULL,0),(2654975,NULL,118,'object',0,'my',NULL,NULL,NULL,NULL,0),(2654976,2654975,118,'number',0,'id','id',-1,NULL,NULL,0),(2654977,2654975,118,'string',0,'boo','name',NULL,'created_at',NULL,0),(2654978,2654975,118,'string',2,'dataTypeName','datatypename',NULL,'meta_data',NULL,0),(2654979,NULL,118,'string',0,'my','fieldname',NULL,':created_at',NULL,0),(2654980,NULL,118,'number',0,'my','position',0,NULL,NULL,0),(2654981,2654980,118,'string',0,'boo','rendertypename',NULL,'meta_data',NULL,0),(2654982,2654975,118,'object',6,'format','format',NULL,NULL,NULL,0),(2654983,2654975,118,'array',7,'flags','flags',NULL,NULL,NULL,0),(2654984,NULL,118,'string',0,'my',NULL,NULL,'hidden',NULL,0),(2654985,NULL,118,'object',0,'my',NULL,NULL,NULL,NULL,0),(2654986,2654985,118,'number',0,'boo','id',-1,NULL,NULL,0),(2654987,2654985,118,'string',1,'boo2','name',NULL,'created_meta',NULL,0),(2654988,2654985,118,'string',2,'dataTypeName','datatypename',NULL,'meta_data',NULL,0),(2654989,2654988,118,'string',0,'boo','fieldname',NULL,':created_meta',NULL,0),(2654990,NULL,118,'number',0,'my','position',0,NULL,NULL,0),(2654991,2654985,118,'string',5,'renderTypeName','rendertypename',NULL,'meta_data',NULL,0),(2654992,2654991,118,'object',0,'boo2','format',NULL,NULL,NULL,0),(2654993,2654985,118,'array',7,'flags','flags',NULL,NULL,NULL,0),(2654994,2654993,118,'string',0,NULL,NULL,NULL,'hidden',NULL,0),(2654995,2654944,118,'object',5,NULL,NULL,NULL,NULL,NULL,0),(2654996,2654995,118,'number',0,'id','id',-1,NULL,NULL,0),(2654997,2654995,118,'string',1,'name','name',NULL,'updated_at',NULL,0),(2654998,2654995,118,'string',2,'dataTypeName','datatypename',NULL,'meta_data',NULL,0),(2654999,2654995,118,'string',3,'fieldName','fieldname',NULL,':updated_at',NULL,0),(2655000,2654995,118,'number',4,'position','position',0,NULL,NULL,0),(2655001,2654995,118,'string',5,'renderTypeName','rendertypename',NULL,'meta_data',NULL,0),(2655002,2654995,118,'object',6,'format','format',NULL,NULL,NULL,0),(2655003,2654995,118,'array',7,'flags','flags',NULL,NULL,NULL,0),(2655004,2655003,118,'string',0,NULL,NULL,NULL,'hidden',NULL,0),(2655005,2654944,118,'object',6,NULL,NULL,NULL,NULL,NULL,0),(2655006,2655005,118,'number',0,'id','id',-1,NULL,NULL,0),(2655007,2655005,118,'string',1,'name','name',NULL,'updated_meta',NULL,0),(2655008,2655005,118,'string',2,'dataTypeName','datatypename',NULL,'meta_data',NULL,0),(2655009,2655005,118,'string',3,'fieldName','fieldname',NULL,':updated_meta',NULL,0),(2655010,2655005,118,'number',4,'position','position',0,NULL,NULL,0),(2655011,2655005,118,'string',5,'renderTypeName','rendertypename',NULL,'meta_data',NULL,0),(2655012,2655005,118,'object',6,'format','format',NULL,NULL,NULL,0),(2655013,2655005,118,'array',7,'flags','flags',NULL,NULL,NULL,0),(2655014,2655013,118,'string',0,NULL,NULL,NULL,'hidden',NULL,0),(2655015,2654944,118,'object',7,NULL,NULL,NULL,NULL,NULL,0),(2655016,2655015,118,'number',0,'id','id',-1,NULL,NULL,0),(2655017,2655015,118,'string',1,'name','name',NULL,'meta',NULL,0),(2655018,2655015,118,'string',2,'dataTypeName','datatypename',NULL,'meta_data',NULL,0),(2655019,2655015,118,'string',3,'fieldName','fieldname',NULL,':meta',NULL,0),(2655020,2655015,118,'number',4,'position','position',0,NULL,NULL,0),(2655021,2655015,118,'string',5,'renderTypeName','rendertypename',NULL,'meta_data',NULL,0),(2655022,2655015,118,'object',6,'format','format',NULL,NULL,NULL,0),(2655023,2655015,118,'array',7,'flags','flags',NULL,NULL,NULL,0),(2655024,2655023,118,'string',0,NULL,NULL,NULL,'hidden',NULL,0),(2655025,2654944,118,'object',8,NULL,NULL,NULL,NULL,NULL,0),(2655026,2655025,118,'number',0,'id','id',407211176,NULL,NULL,0),(2655027,2655025,118,'string',1,'name','name',NULL,'ID',NULL,0),(2655028,2655025,118,'string',2,'dataTypeName','datatypename',NULL,'text',NULL,0),(2655029,2655025,118,'string',3,'description','description',NULL,'',NULL,0),(2655030,2655025,118,'string',4,'fieldName','fieldname',NULL,'id',NULL,0),(2655031,2655025,118,'number',5,'position','position',1,NULL,NULL,0),(2655032,2655025,118,'string',6,'renderTypeName','rendertypename',NULL,'text',NULL,0),(2655033,2655025,118,'number',7,'tableColumnId','tablecolumnid',73628883,NULL,NULL,0),(2655034,2655025,118,'object',8,'cachedContents','cachedcontents',NULL,NULL,NULL,0),(2655035,2655034,118,'string',0,'largest','largest',NULL,'18-1018',NULL,0),(2655036,2655034,118,'number',1,'non_null','non_null',5105,NULL,NULL,0),(2655037,2655034,118,'number',2,'null','null',0,NULL,NULL,0),(2655038,2655034,118,'array',3,'top','top',NULL,NULL,NULL,0),(2655039,2655038,118,'object',0,NULL,NULL,NULL,NULL,NULL,0),(2655040,2655039,118,'string',0,'item','item',NULL,'12-0002',NULL,0),(2655041,2655039,118,'number',1,'count','count',1,NULL,NULL,0),(2655042,2655038,118,'object',1,NULL,NULL,NULL,NULL,NULL,0),(2655043,2655042,118,'string',0,'item','item',NULL,'12-0003',NULL,0),(2655044,2655042,118,'number',1,'count','count',1,NULL,NULL,0),(2655045,2655038,118,'object',2,NULL,NULL,NULL,NULL,NULL,0),(2655046,2655045,118,'string',0,'item','item',NULL,'12-0004',NULL,0),(2655047,2655045,118,'number',1,'count','count',1,NULL,NULL,0),(2655048,2655038,118,'object',3,NULL,NULL,NULL,NULL,NULL,0),(2655049,2655048,118,'string',0,'item','item',NULL,'12-0005',NULL,0),(2655050,2655048,118,'number',1,'count','count',1,NULL,NULL,0),(2655051,2655038,118,'object',4,NULL,NULL,NULL,NULL,NULL,0),(2655052,2655051,118,'string',0,'item','item',NULL,'12-0006',NULL,0),(2655053,2655051,118,'number',1,'count','count',1,NULL,NULL,0),(2655054,2655038,118,'object',5,NULL,NULL,NULL,NULL,NULL,0),(2655055,2655054,118,'string',0,'item','item',NULL,'12-0007',NULL,0),(2655056,2655054,118,'number',1,'count','count',1,NULL,NULL,0),(2655057,2655038,118,'object',6,NULL,NULL,NULL,NULL,NULL,0),(2655058,2655057,118,'string',0,'item','item',NULL,'12-0008',NULL,0),(2655059,2655057,118,'number',1,'count','count',1,NULL,NULL,0),(2655060,2655038,118,'object',7,NULL,NULL,NULL,NULL,NULL,0),(2655061,2655060,118,'string',0,'item','item',NULL,'12-0009',NULL,0),(2655062,2655060,118,'number',1,'count','count',1,NULL,NULL,0),(2655063,2655038,118,'object',8,NULL,NULL,NULL,NULL,NULL,0),(2655064,2655063,118,'string',0,'item','item',NULL,'12-0010',NULL,0),(2655065,2655063,118,'number',1,'count','count',1,NULL,NULL,0),(2655066,2655038,118,'object',9,NULL,NULL,NULL,NULL,NULL,0),(2655067,2655066,118,'string',0,'item','item',NULL,'12-0011',NULL,0),(2655068,2655066,118,'number',1,'count','count',1,NULL,NULL,0),(2655069,2655038,118,'object',10,NULL,NULL,NULL,NULL,NULL,0),(2655070,2655069,118,'string',0,'item','item',NULL,'12-0012',NULL,0),(2655071,2655069,118,'number',1,'count','count',1,NULL,NULL,0),(2655072,2655038,118,'object',11,NULL,NULL,NULL,NULL,NULL,0),(2655073,2655072,118,'string',0,'item','item',NULL,'12-0013',NULL,0),(2655074,2655072,118,'number',1,'count','count',1,NULL,NULL,0),(2655075,2655038,118,'object',12,NULL,NULL,NULL,NULL,NULL,0),(2655076,2655075,118,'string',0,'item','item',NULL,'12-0014',NULL,0),(2655077,2655075,118,'number',1,'count','count',1,NULL,NULL,0),(2655078,2655038,118,'object',13,NULL,NULL,NULL,NULL,NULL,0),(2655079,2655078,118,'string',0,'item','item',NULL,'12-0015',NULL,0),(2655080,2655078,118,'number',1,'count','count',1,NULL,NULL,0),(2655081,2655038,118,'object',14,NULL,NULL,NULL,NULL,NULL,0),(2655082,2655081,118,'string',0,'item','item',NULL,'12-0016',NULL,0),(2655083,2655081,118,'number',1,'count','count',1,NULL,NULL,0),(2655084,2655038,118,'object',15,NULL,NULL,NULL,NULL,NULL,0),(2655085,2655084,118,'string',0,'item','item',NULL,'12-0017',NULL,0),(2655086,2655084,118,'number',1,'count','count',1,NULL,NULL,0),(2655087,2655038,118,'object',16,NULL,NULL,NULL,NULL,NULL,0),(2655088,2655087,118,'string',0,'item','item',NULL,'12-0018',NULL,0),(2655089,2655087,118,'number',1,'count','count',1,NULL,NULL,0),(2655090,2655038,118,'object',17,NULL,NULL,NULL,NULL,NULL,0),(2655091,2655090,118,'string',0,'item','item',NULL,'12-0019',NULL,0),(2655092,2655090,118,'number',1,'count','count',1,NULL,NULL,0),(2655093,2655038,118,'object',18,NULL,NULL,NULL,NULL,NULL,0),(2655094,2655093,118,'string',0,'item','item',NULL,'12-0020',NULL,0),(2655095,2655093,118,'number',1,'count','count',1,NULL,NULL,0),(2655096,2655038,118,'object',19,NULL,NULL,NULL,NULL,NULL,0),(2655097,2655096,118,'string',0,'item','item',NULL,'12-0021',NULL,0),(2655098,2655096,118,'number',1,'count','count',1,NULL,NULL,0),(2655099,2655034,118,'string',4,'smallest','smallest',NULL,'12-0001',NULL,0),(2655100,2655034,118,'number',5,'cardinality','cardinality',5105,NULL,NULL,0),(2655101,2655025,118,'object',9,'format','format',NULL,NULL,NULL,0),(2655102,2654944,118,'object',9,NULL,NULL,NULL,NULL,NULL,0),(2655103,2655102,118,'number',0,'id','id',407211177,NULL,NULL,0),(2655104,2655102,118,'string',1,'name','name',NULL,'Date',NULL,0),(2655105,2655102,118,'string',2,'dataTypeName','datatypename',NULL,'calendar_date',NULL,0),(2655106,2655102,118,'string',3,'description','description',NULL,'',NULL,0),(2655107,2655102,118,'string',4,'fieldName','fieldname',NULL,'date',NULL,0),(2655108,2655102,118,'number',5,'position','position',2,NULL,NULL,0),(2655109,2655102,118,'string',6,'renderTypeName','rendertypename',NULL,'calendar_date',NULL,0),(2655110,2655102,118,'number',7,'tableColumnId','tablecolumnid',31952055,NULL,NULL,0),(2655111,2655102,118,'number',8,'width','width',100,NULL,NULL,0),(2655112,2655102,118,'object',9,'cachedContents','cachedcontents',NULL,NULL,NULL,0),(2655113,2655112,118,'string',0,'largest','largest',NULL,'2018-12-31T00:00:00.000',NULL,0),(2655114,2655112,118,'number',1,'non_null','non_null',5103,NULL,NULL,0),(2655115,2655112,118,'number',2,'null','null',2,NULL,NULL,0),(2655116,2655112,118,'array',3,'top','top',NULL,NULL,NULL,0),(2655117,2655116,118,'object',0,NULL,NULL,NULL,NULL,NULL,0),(2655118,2655117,118,'string',0,'item','item',NULL,'2017-08-18T00:00:00.000',NULL,0),(2655119,2655117,118,'number',1,'count','count',9,NULL,NULL,0),(2655120,2655116,118,'object',1,NULL,NULL,NULL,NULL,NULL,0),(2655121,2655120,118,'string',0,'item','item',NULL,'2017-06-18T00:00:00.000',NULL,0),(2655122,2655120,118,'number',1,'count','count',9,NULL,NULL,0),(2655123,2655116,118,'object',2,NULL,NULL,NULL,NULL,NULL,0),(2655124,2655123,118,'string',0,'item','item',NULL,'2017-06-02T00:00:00.000',NULL,0),(2655125,2655123,118,'number',1,'count','count',8,NULL,NULL,0),(2655126,2655116,118,'object',3,NULL,NULL,NULL,NULL,NULL,0),(2655127,2655126,118,'string',0,'item','item',NULL,'2017-05-29T00:00:00.000',NULL,0),(2655128,2655126,118,'number',1,'count','count',8,NULL,NULL,0),(2655129,2655116,118,'object',4,NULL,NULL,NULL,NULL,NULL,0),(2655130,2655129,118,'string',0,'item','item',NULL,'2018-12-17T00:00:00.000',NULL,0),(2655131,2655129,118,'number',1,'count','count',8,NULL,NULL,0),(2655132,2655116,118,'object',5,NULL,NULL,NULL,NULL,NULL,0),(2655133,2655132,118,'string',0,'item','item',NULL,'2016-11-13T00:00:00.000',NULL,0),(2655134,2655132,118,'number',1,'count','count',8,NULL,NULL,0),(2655135,2655116,118,'object',6,NULL,NULL,NULL,NULL,NULL,0),(2655136,2655135,118,'string',0,'item','item',NULL,'2017-03-05T00:00:00.000',NULL,0),(2655137,2655135,118,'number',1,'count','count',8,NULL,NULL,0),(2655138,2655116,118,'object',7,NULL,NULL,NULL,NULL,NULL,0),(2655139,2655138,118,'string',0,'item','item',NULL,'2013-09-21T00:00:00.000',NULL,0),(2655140,2655138,118,'number',1,'count','count',8,NULL,NULL,0),(2655141,2655116,118,'object',8,NULL,NULL,NULL,NULL,NULL,0),(2655142,2655141,118,'string',0,'item','item',NULL,'2016-10-03T00:00:00.000',NULL,0),(2655143,2655141,118,'number',1,'count','count',7,NULL,NULL,0),(2655144,2655116,118,'object',9,NULL,NULL,NULL,NULL,NULL,0),(2655145,2655144,118,'string',0,'item','item',NULL,'2018-08-05T00:00:00.000',NULL,0),(2655146,2655144,118,'number',1,'count','count',7,NULL,NULL,0),(2655147,2655116,118,'object',10,NULL,NULL,NULL,NULL,NULL,0),(2655148,2655147,118,'string',0,'item','item',NULL,'2018-05-13T00:00:00.000',NULL,0),(2655149,2655147,118,'number',1,'count','count',7,NULL,NULL,0),(2655150,2655116,118,'object',11,NULL,NULL,NULL,NULL,NULL,0),(2655151,2655150,118,'string',0,'item','item',NULL,'2018-05-12T00:00:00.000',NULL,0),(2655152,2655150,118,'number',1,'count','count',7,NULL,NULL,0),(2655153,2655116,118,'object',12,NULL,NULL,NULL,NULL,NULL,0),(2655154,2655153,118,'string',0,'item','item',NULL,'2017-02-11T00:00:00.000',NULL,0),(2655155,2655153,118,'number',1,'count','count',7,NULL,NULL,0),(2655156,2655116,118,'object',13,NULL,NULL,NULL,NULL,NULL,0),(2655157,2655156,118,'string',0,'item','item',NULL,'2018-07-03T00:00:00.000',NULL,0),(2655158,2655156,118,'number',1,'count','count',7,NULL,NULL,0),(2655159,2655116,118,'object',14,NULL,NULL,NULL,NULL,NULL,0),(2655160,2655159,118,'string',0,'item','item',NULL,'2016-02-26T00:00:00.000',NULL,0),(2655161,2655159,118,'number',1,'count','count',7,NULL,NULL,0),(2655162,2655116,118,'object',15,NULL,NULL,NULL,NULL,NULL,0),(2655163,2655162,118,'string',0,'item','item',NULL,'2018-06-02T00:00:00.000',NULL,0),(2655164,2655162,118,'number',1,'count','count',7,NULL,NULL,0),(2655165,2655116,118,'object',16,NULL,NULL,NULL,NULL,NULL,0),(2655166,2655165,118,'string',0,'item','item',NULL,'2017-12-27T00:00:00.000',NULL,0),(2655167,2655165,118,'number',1,'count','count',7,NULL,NULL,0),(2655168,2655116,118,'object',17,NULL,NULL,NULL,NULL,NULL,0),(2655169,2655168,118,'string',0,'item','item',NULL,'2017-05-05T00:00:00.000',NULL,0),(2655170,2655168,118,'number',1,'count','count',7,NULL,NULL,0),(2655171,2655116,118,'object',18,NULL,NULL,NULL,NULL,NULL,0),(2655172,2655171,118,'string',0,'item','item',NULL,'2018-06-28T00:00:00.000',NULL,0),(2655173,2655171,118,'number',1,'count','count',7,NULL,NULL,0),(2655174,2655116,118,'object',19,NULL,NULL,NULL,NULL,NULL,0),(2655175,2655174,118,'string',0,'item','item',NULL,'2016-11-18T00:00:00.000',NULL,0),(2655176,2655174,118,'number',1,'count','count',7,NULL,NULL,0),(2655177,2655112,118,'string',4,'smallest','smallest',NULL,'2012-01-01T00:00:00.000',NULL,0),(2655178,2655112,118,'number',5,'cardinality','cardinality',2098,NULL,NULL,0),(2655179,2655102,118,'object',10,'format','format',NULL,NULL,NULL,0),(2655180,2654944,118,'object',10,NULL,NULL,NULL,NULL,NULL,0),(2655181,2655180,118,'number',0,'id','id',407211178,NULL,NULL,0),(2655182,2655180,118,'string',1,'name','name',NULL,'DateType',NULL,0),(2655183,2655180,118,'string',2,'dataTypeName','datatypename',NULL,'text',NULL,0),(2655184,2655180,118,'string',3,'description','description',NULL,'',NULL,0),(2655185,2655180,118,'string',4,'fieldName','fieldname',NULL,'datetype',NULL,0),(2655186,2655180,118,'number',5,'position','position',3,NULL,NULL,0),(2655187,2655180,118,'string',6,'renderTypeName','rendertypename',NULL,'text',NULL,0),(2655188,2655180,118,'number',7,'tableColumnId','tablecolumnid',73628884,NULL,NULL,0),(2655189,2655180,118,'object',8,'cachedContents','cachedcontents',NULL,NULL,NULL,0),(2655190,2655189,118,'string',0,'largest','largest',NULL,'DateReported',NULL,0),(2655191,2655189,118,'number',1,'non_null','non_null',5103,NULL,NULL,0),(2655192,2655189,118,'number',2,'null','null',2,NULL,NULL,0),(2655193,2655189,118,'array',3,'top','top',NULL,NULL,NULL,0),(2655194,2655193,118,'object',0,NULL,NULL,NULL,NULL,NULL,0),(2655195,2655194,118,'string',0,'item','item',NULL,'DateofDeath',NULL,0),(2655196,2655194,118,'number',1,'count','count',2822,NULL,NULL,0),(2655197,2655193,118,'object',1,NULL,NULL,NULL,NULL,NULL,0),(2655198,2655197,118,'string',0,'item','item',NULL,'DateReported',NULL,0),(2655199,2655197,118,'number',1,'count','count',2281,NULL,NULL,0),(2655200,2655189,118,'string',4,'smallest','smallest',NULL,'DateofDeath',NULL,0),(2655201,2655189,118,'number',5,'cardinality','cardinality',2,NULL,NULL,0),(2655202,2655180,118,'object',9,'format','format',NULL,NULL,NULL,0),(2655203,2654944,118,'object',11,NULL,NULL,NULL,NULL,NULL,0),(2655204,2655203,118,'number',0,'id','id',407211179,NULL,NULL,0),(2655205,2655203,118,'string',1,'name','name',NULL,'Age',NULL,0),(2655206,2655203,118,'string',2,'dataTypeName','datatypename',NULL,'number',NULL,0),(2655207,2655203,118,'string',3,'description','description',NULL,'',NULL,0),(2655208,2655203,118,'string',4,'fieldName','fieldname',NULL,'age',NULL,0),(2655209,2655203,118,'number',5,'position','position',4,NULL,NULL,0),(2655210,2655203,118,'string',6,'renderTypeName','rendertypename',NULL,'number',NULL,0),(2655211,2655203,118,'number',7,'tableColumnId','tablecolumnid',31936576,NULL,NULL,0),(2655212,2655203,118,'number',8,'width','width',136,NULL,NULL,0),(2655213,2655203,118,'object',9,'cachedContents','cachedcontents',NULL,NULL,NULL,0),(2655214,2655213,118,'number',0,'largest','largest',87,NULL,NULL,0),(2655215,2655213,118,'number',1,'non_null','non_null',5102,NULL,NULL,0),(2655216,2655213,118,'number',2,'null','null',3,NULL,NULL,0),(2655217,2655213,118,'array',3,'top','top',NULL,NULL,NULL,0),(2655218,2655217,118,'object',0,NULL,NULL,NULL,NULL,NULL,0),(2655219,2655218,118,'number',0,'item','item',29,NULL,NULL,0),(2655220,2655218,118,'number',1,'count','count',152,NULL,NULL,0),(2655221,2655217,118,'object',1,NULL,NULL,NULL,NULL,NULL,0),(2655222,2655221,118,'number',0,'item','item',44,NULL,NULL,0),(2655223,2655221,118,'number',1,'count','count',147,NULL,NULL,0),(2655224,2655217,118,'object',2,NULL,NULL,NULL,NULL,NULL,0),(2655225,2655224,118,'number',0,'item','item',33,NULL,NULL,0),(2655226,2655224,118,'number',1,'count','count',147,NULL,NULL,0),(2655227,2655217,118,'object',3,NULL,NULL,NULL,NULL,NULL,0),(2655228,2655227,118,'number',0,'item','item',50,NULL,NULL,0),(2655229,2655227,118,'number',1,'count','count',145,NULL,NULL,0),(2655230,2655217,118,'object',4,NULL,NULL,NULL,NULL,NULL,0),(2655231,2655230,118,'number',0,'item','item',54,NULL,NULL,0),(2655232,2655230,118,'number',1,'count','count',144,NULL,NULL,0),(2655233,2655217,118,'object',5,NULL,NULL,NULL,NULL,NULL,0),(2655234,2655233,118,'number',0,'item','item',51,NULL,NULL,0),(2655235,2655233,118,'number',1,'count','count',143,NULL,NULL,0),(2655236,2655217,118,'object',6,NULL,NULL,NULL,NULL,NULL,0),(2655237,2655236,118,'number',0,'item','item',49,NULL,NULL,0),(2655238,2655236,118,'number',1,'count','count',141,NULL,NULL,0),(2655239,2655217,118,'object',7,NULL,NULL,NULL,NULL,NULL,0),(2655240,2655239,118,'number',0,'item','item',48,NULL,NULL,0),(2655241,2655239,118,'number',1,'count','count',137,NULL,NULL,0),(2655242,2655217,118,'object',8,NULL,NULL,NULL,NULL,NULL,0),(2655243,2655242,118,'number',0,'item','item',34,NULL,NULL,0),(2655244,2655242,118,'number',1,'count','count',136,NULL,NULL,0),(2655245,2655217,118,'object',9,NULL,NULL,NULL,NULL,NULL,0),(2655246,2655245,118,'number',0,'item','item',35,NULL,NULL,0),(2655247,2655245,118,'number',1,'count','count',134,NULL,NULL,0),(2655248,2655217,118,'object',10,NULL,NULL,NULL,NULL,NULL,0),(2655249,2655248,118,'number',0,'item','item',36,NULL,NULL,0),(2655250,2655248,118,'number',1,'count','count',133,NULL,NULL,0),(2655251,2655217,118,'object',11,NULL,NULL,NULL,NULL,NULL,0),(2655252,2655251,118,'number',0,'item','item',28,NULL,NULL,0),(2655253,2655251,118,'number',1,'count','count',130,NULL,NULL,0),(2655254,2655217,118,'object',12,NULL,NULL,NULL,NULL,NULL,0),(2655255,2655254,118,'number',0,'item','item',30,NULL,NULL,0),(2655256,2655254,118,'number',1,'count','count',130,NULL,NULL,0),(2655257,2655217,118,'object',13,NULL,NULL,NULL,NULL,NULL,0),(2655258,2655257,118,'number',0,'item','item',52,NULL,NULL,0),(2655259,2655257,118,'number',1,'count','count',130,NULL,NULL,0),(2655260,2655217,118,'object',14,NULL,NULL,NULL,NULL,NULL,0),(2655261,2655260,118,'number',0,'item','item',47,NULL,NULL,0),(2655262,2655260,118,'number',1,'count','count',127,NULL,NULL,0),(2655263,2655217,118,'object',15,NULL,NULL,NULL,NULL,NULL,0),(2655264,2655263,118,'number',0,'item','item',37,NULL,NULL,0),(2655265,2655263,118,'number',1,'count','count',123,NULL,NULL,0),(2655266,2655217,118,'object',16,NULL,NULL,NULL,NULL,NULL,0),(2655267,2655266,118,'number',0,'item','item',41,NULL,NULL,0),(2655268,2655266,118,'number',1,'count','count',122,NULL,NULL,0),(2655269,2655217,118,'object',17,NULL,NULL,NULL,NULL,NULL,0),(2655270,2655269,118,'number',0,'item','item',45,NULL,NULL,0),(2655271,2655269,118,'number',1,'count','count',122,NULL,NULL,0),(2655272,2655217,118,'object',18,NULL,NULL,NULL,NULL,NULL,0),(2655273,2655272,118,'number',0,'item','item',26,NULL,NULL,0),(2655274,2655272,118,'number',1,'count','count',119,NULL,NULL,0),(2655275,2655217,118,'object',19,NULL,NULL,NULL,NULL,NULL,0),(2655276,2655275,118,'number',0,'item','item',55,NULL,NULL,0),(2655277,2655275,118,'number',1,'count','count',119,NULL,NULL,0),(2655278,2655213,118,'number',4,'smallest','smallest',14,NULL,NULL,0),(2655279,2655213,118,'number',5,'cardinality','cardinality',65,NULL,NULL,0),(2655280,2655203,118,'object',10,'format','format',NULL,NULL,NULL,0),(2655281,2654944,118,'object',12,NULL,NULL,NULL,NULL,NULL,0),(2655282,2655281,118,'number',0,'id','id',407211180,NULL,NULL,0),(2655283,2655281,118,'string',1,'name','name',NULL,'Sex',NULL,0),(2655284,2655281,118,'string',2,'dataTypeName','datatypename',NULL,'text',NULL,0),(2655285,2655281,118,'string',3,'description','description',NULL,'',NULL,0),(2655286,2655281,118,'string',4,'fieldName','fieldname',NULL,'sex',NULL,0),(2655287,2655281,118,'number',5,'position','position',5,NULL,NULL,0),(2655288,2655281,118,'string',6,'renderTypeName','rendertypename',NULL,'text',NULL,0),(2655289,2655281,118,'number',7,'tableColumnId','tablecolumnid',31936574,NULL,NULL,0),(2655290,2655281,118,'number',8,'width','width',136,NULL,NULL,0),(2655291,2655281,118,'object',9,'cachedContents','cachedcontents',NULL,NULL,NULL,0),(2655292,2655291,118,'string',0,'largest','largest',NULL,'Unknown',NULL,0),(2655293,2655291,118,'number',1,'non_null','non_null',5099,NULL,NULL,0),(2655294,2655291,118,'number',2,'null','null',6,NULL,NULL,0),(2655295,2655291,118,'array',3,'top','top',NULL,NULL,NULL,0),(2655296,2655295,118,'object',0,NULL,NULL,NULL,NULL,NULL,0),(2655297,2655296,118,'string',0,'item','item',NULL,'Male',NULL,0),(2655298,2655296,118,'number',1,'count','count',3773,NULL,NULL,0),(2655299,2655295,118,'object',1,NULL,NULL,NULL,NULL,NULL,0),(2655300,2655299,118,'string',0,'item','item',NULL,'Female',NULL,0),(2655301,2655299,118,'number',1,'count','count',1325,NULL,NULL,0),(2655302,2655295,118,'object',2,NULL,NULL,NULL,NULL,NULL,0),(2655303,2655302,118,'string',0,'item','item',NULL,'Unknown',NULL,0),(2655304,2655302,118,'number',1,'count','count',1,NULL,NULL,0),(2655305,2655291,118,'string',4,'smallest','smallest',NULL,'Female',NULL,0),(2655306,2655291,118,'number',5,'cardinality','cardinality',3,NULL,NULL,0),(2655307,2655281,118,'object',10,'format','format',NULL,NULL,NULL,0),(2655308,2654944,118,'object',13,NULL,NULL,NULL,NULL,NULL,0),(2655309,2655308,118,'number',0,'id','id',407211181,NULL,NULL,0),(2655310,2655308,118,'string',1,'name','name',NULL,'Race',NULL,0),(2655311,2655308,118,'string',2,'dataTypeName','datatypename',NULL,'text',NULL,0),(2655312,2655308,118,'string',3,'description','description',NULL,'',NULL,0),(2655313,2655308,118,'string',4,'fieldName','fieldname',NULL,'race',NULL,0),(2655314,2655308,118,'number',5,'position','position',6,NULL,NULL,0),(2655315,2655308,118,'string',6,'renderTypeName','rendertypename',NULL,'text',NULL,0),(2655316,2655308,118,'number',7,'tableColumnId','tablecolumnid',31936575,NULL,NULL,0),(2655317,2655308,118,'number',8,'width','width',148,NULL,NULL,0),(2655318,2655308,118,'object',9,'cachedContents','cachedcontents',NULL,NULL,NULL,0),(2655319,2655318,118,'string',0,'largest','largest',NULL,'White',NULL,0),(2655320,2655318,118,'number',1,'non_null','non_null',5092,NULL,NULL,0),(2655321,2655318,118,'number',2,'null','null',13,NULL,NULL,0),(2655322,2655318,118,'array',3,'top','top',NULL,NULL,NULL,0),(2655323,2655322,118,'object',0,NULL,NULL,NULL,NULL,NULL,0),(2655324,2655323,118,'string',0,'item','item',NULL,'White',NULL,0),(2655325,2655323,118,'number',1,'count','count',4004,NULL,NULL,0),(2655326,2655322,118,'object',1,NULL,NULL,NULL,NULL,NULL,0),(2655327,2655326,118,'string',0,'item','item',NULL,'Hispanic, White',NULL,0),(2655328,2655326,118,'number',1,'count','count',561,NULL,NULL,0),(2655329,2655322,118,'object',2,NULL,NULL,NULL,NULL,NULL,0),(2655330,2655329,118,'string',0,'item','item',NULL,'Black',NULL,0),(2655331,2655329,118,'number',1,'count','count',433,NULL,NULL,0),(2655332,2655322,118,'object',3,NULL,NULL,NULL,NULL,NULL,0),(2655333,2655332,118,'string',0,'item','item',NULL,'Hispanic, Black',NULL,0),(2655334,2655332,118,'number',1,'count','count',24,NULL,NULL,0),(2655335,2655322,118,'object',4,NULL,NULL,NULL,NULL,NULL,0),(2655336,2655335,118,'string',0,'item','item',NULL,'Unknown',NULL,0),(2655337,2655335,118,'number',1,'count','count',23,NULL,NULL,0),(2655338,2655322,118,'object',5,NULL,NULL,NULL,NULL,NULL,0),(2655339,2655338,118,'string',0,'item','item',NULL,'Asian, Other',NULL,0),(2655340,2655338,118,'number',1,'count','count',18,NULL,NULL,0),(2655341,2655322,118,'object',6,NULL,NULL,NULL,NULL,NULL,0),(2655342,2655341,118,'string',0,'item','item',NULL,'Asian Indian',NULL,0),(2655343,2655341,118,'number',1,'count','count',14,NULL,NULL,0),(2655344,2655322,118,'object',7,NULL,NULL,NULL,NULL,NULL,0),(2655345,2655344,118,'string',0,'item','item',NULL,'Other',NULL,0),(2655346,2655344,118,'number',1,'count','count',11,NULL,NULL,0),(2655347,2655322,118,'object',8,NULL,NULL,NULL,NULL,NULL,0),(2655348,2655347,118,'string',0,'item','item',NULL,'Chinese',NULL,0),(2655349,2655347,118,'number',1,'count','count',2,NULL,NULL,0),(2655350,2655322,118,'object',9,NULL,NULL,NULL,NULL,NULL,0),(2655351,2655350,118,'string',0,'item','item',NULL,'Hawaiian',NULL,0),(2655352,2655350,118,'number',1,'count','count',1,NULL,NULL,0),(2655353,2655322,118,'object',10,NULL,NULL,NULL,NULL,NULL,0),(2655354,2655353,118,'string',0,'item','item',NULL,'Native American, Other',NULL,0),(2655355,2655353,118,'number',1,'count','count',1,NULL,NULL,0),(2655356,2655318,118,'string',4,'smallest','smallest',NULL,'Asian Indian',NULL,0),(2655357,2655318,118,'number',5,'cardinality','cardinality',11,NULL,NULL,0),(2655358,2655308,118,'object',10,'format','format',NULL,NULL,NULL,0),(2655359,2654944,118,'object',14,NULL,NULL,NULL,NULL,NULL,0),(2655360,2655359,118,'number',0,'id','id',407211182,NULL,NULL,0),(2655361,2655359,118,'string',1,'name','name',NULL,'ResidenceCity',NULL,0),(2655362,2655359,118,'string',2,'dataTypeName','datatypename',NULL,'text',NULL,0),(2655363,2655359,118,'string',3,'description','description',NULL,'',NULL,0),(2655364,2655359,118,'string',4,'fieldName','fieldname',NULL,'residencecity',NULL,0),(2655365,2655359,118,'number',5,'position','position',7,NULL,NULL,0),(2655366,2655359,118,'string',6,'renderTypeName','rendertypename',NULL,'text',NULL,0),(2655367,2655359,118,'number',7,'tableColumnId','tablecolumnid',73628891,NULL,NULL,0),(2655368,2655359,118,'object',8,'cachedContents','cachedcontents',NULL,NULL,NULL,0),(2655369,2655368,118,'string',0,'largest','largest',NULL,'ZIONSVILLE',NULL,0),(2655370,2655368,118,'number',1,'non_null','non_null',4932,NULL,NULL,0),(2655371,2655368,118,'number',2,'null','null',173,NULL,NULL,0),(2655372,2655368,118,'array',3,'top','top',NULL,NULL,NULL,0),(2655373,2655372,118,'object',0,NULL,NULL,NULL,NULL,NULL,0),(2655374,2655373,118,'string',0,'item','item',NULL,'HARTFORD',NULL,0),(2655375,2655373,118,'number',1,'count','count',296,NULL,NULL,0),(2655376,2655372,118,'object',1,NULL,NULL,NULL,NULL,NULL,0),(2655377,2655376,118,'string',0,'item','item',NULL,'WATERBURY',NULL,0),(2655378,2655376,118,'number',1,'count','count',269,NULL,NULL,0),(2655379,2655372,118,'object',2,NULL,NULL,NULL,NULL,NULL,0),(2655380,2655379,118,'string',0,'item','item',NULL,'BRIDGEPORT',NULL,0),(2655381,2655379,118,'number',1,'count','count',241,NULL,NULL,0),(2655382,2655372,118,'object',3,NULL,NULL,NULL,NULL,NULL,0),(2655383,2655382,118,'string',0,'item','item',NULL,'NEW HAVEN',NULL,0),(2655384,2655382,118,'number',1,'count','count',224,NULL,NULL,0),(2655385,2655372,118,'object',4,NULL,NULL,NULL,NULL,NULL,0),(2655386,2655385,118,'string',0,'item','item',NULL,'NEW BRITAIN',NULL,0),(2655387,2655385,118,'number',1,'count','count',192,NULL,NULL,0),(2655388,2655372,118,'object',5,NULL,NULL,NULL,NULL,NULL,0),(2655389,2655388,118,'string',0,'item','item',NULL,'BRISTOL',NULL,0),(2655390,2655388,118,'number',1,'count','count',134,NULL,NULL,0),(2655391,2655372,118,'object',6,NULL,NULL,NULL,NULL,NULL,0),(2655392,2655391,118,'string',0,'item','item',NULL,'MERIDEN',NULL,0),(2655393,2655391,118,'number',1,'count','count',127,NULL,NULL,0),(2655394,2655372,118,'object',7,NULL,NULL,NULL,NULL,NULL,0),(2655395,2655394,118,'string',0,'item','item',NULL,'NORWICH',NULL,0),(2655396,2655394,118,'number',1,'count','count',109,NULL,NULL,0),(2655397,2655372,118,'object',8,NULL,NULL,NULL,NULL,NULL,0),(2655398,2655397,118,'string',0,'item','item',NULL,'MANCHESTER',NULL,0),(2655399,2655397,118,'number',1,'count','count',103,NULL,NULL,0),(2655400,2655372,118,'object',9,NULL,NULL,NULL,NULL,NULL,0),(2655401,2655400,118,'string',0,'item','item',NULL,'TORRINGTON',NULL,0),(2655402,2655400,118,'number',1,'count','count',100,NULL,NULL,0),(2655403,2655372,118,'object',10,NULL,NULL,NULL,NULL,NULL,0),(2655404,2655403,118,'string',0,'item','item',NULL,'WEST HAVEN',NULL,0),(2655405,2655403,118,'number',1,'count','count',91,NULL,NULL,0),(2655406,2655372,118,'object',11,NULL,NULL,NULL,NULL,NULL,0),(2655407,2655406,118,'string',0,'item','item',NULL,'EAST HARTFORD',NULL,0),(2655408,2655406,118,'number',1,'count','count',89,NULL,NULL,0),(2655409,2655372,118,'object',12,NULL,NULL,NULL,NULL,NULL,0),(2655410,2655409,118,'string',0,'item','item',NULL,'MIDDLETOWN',NULL,0),(2655411,2655409,118,'number',1,'count','count',88,NULL,NULL,0),(2655412,2654892,118,'number',0,NULL,NULL,0.1163204897439373,NULL,NULL,0),(2655413,-3,118,'object',0,NULL,NULL,NULL,NULL,NULL,0),(2655414,2655413,118,'object',0,'label','label',NULL,NULL,NULL,0),(2655415,2655414,118,'string',0,'label','label',NULL,'Duplicate entry \'-1-0\' for key \'Value.UI_Value_parentValueId_objectIndex\'',NULL,0),(2655416,2655414,118,'string',1,'path','path',NULL,'/my',NULL,0),(2655417,2655414,118,'string',2,'jobPath','jobpath',NULL,'/my/jobs/0',NULL,0),(2655418,2655414,118,'number',3,'timeTaken','timetaken',2,NULL,NULL,0),(2655419,2655414,118,'string',4,'file','file',NULL,'/home/bee/JSONDB/server/json/JSONDBListener.php',NULL,0),(2655420,2655414,118,'number',5,'line','line',205,NULL,NULL,0),(2655421,2655414,118,'array',6,'trace','trace',NULL,NULL,NULL,0),(2655422,2655421,118,'object',0,NULL,NULL,NULL,NULL,NULL,0),(2655423,2655422,118,'string',0,'file','file',NULL,'/home/bee/JSONDB/server/json/JSONDBListener.php',NULL,0),(2655424,2655422,118,'number',1,'line','line',205,NULL,NULL,0),(2655425,2655422,118,'string',2,'function','function',NULL,'execute',NULL,0),(2655426,2655422,118,'string',3,'class','class',NULL,'mysqli_stmt',NULL,0),(2655427,2655422,118,'string',4,'type','type',NULL,'->',NULL,0),(2655428,2655421,118,'object',1,NULL,NULL,NULL,NULL,NULL,0),(2655429,2655428,118,'string',0,'file','file',NULL,'/home/bee/JSONDB/server/json/Parser.php',NULL,0),(2655430,2655428,118,'number',1,'line','line',666,NULL,NULL,0),(2655431,2655428,118,'string',2,'function','function',NULL,'endDocument',NULL,0),(2655432,2655428,118,'string',3,'class','class',NULL,'JSONDBListener',NULL,0),(2655433,2655428,118,'string',4,'type','type',NULL,'->',NULL,0),(2655434,2655421,118,'object',2,NULL,NULL,NULL,NULL,NULL,0),(2655435,2655434,118,'string',0,'file','file',NULL,'/home/bee/JSONDB/server/json/Parser.php',NULL,0),(2655436,2655434,118,'number',1,'line','line',194,NULL,NULL,0),(2655437,2655434,118,'string',2,'function','function',NULL,'endDocument',NULL,0),(2655438,2655434,118,'string',3,'class','class',NULL,'JsonStreamingParser\\Parser',NULL,0),(2655439,2655434,118,'string',4,'type','type',NULL,'->',NULL,0),(2655440,2655421,118,'object',3,NULL,NULL,NULL,NULL,NULL,0),(2655441,2655440,118,'string',0,'file','file',NULL,'/home/bee/JSONDB/server/json/JSONDBListener.php',NULL,0),(2655442,2655440,118,'number',1,'line','line',77,NULL,NULL,0),(2655443,2655440,118,'string',2,'function','function',NULL,'parse',NULL,0),(2655444,2655440,118,'string',3,'class','class',NULL,'JsonStreamingParser\\Parser',NULL,0),(2655445,2655440,118,'string',4,'type','type',NULL,'->',NULL,0),(2655446,2655421,118,'object',4,NULL,NULL,NULL,NULL,NULL,0),(2655447,2655446,118,'string',0,'file','file',NULL,'/home/bee/JSONDB/server/json/functions.php',NULL,0),(2655448,2655446,118,'number',1,'line','line',148,NULL,NULL,0),(2655449,2655446,118,'string',2,'function','function',NULL,'writeToDatabase',NULL,0),(2655450,2655446,118,'string',3,'class','class',NULL,'JSONDBListener',NULL,0),(2655451,2655446,118,'string',4,'type','type',NULL,'->',NULL,0),(2655452,2655421,118,'object',5,NULL,NULL,NULL,NULL,NULL,0),(2655453,2655452,118,'string',0,'file','file',NULL,'/home/bee/JSONDB/server/json/functions.php',NULL,0),(2655454,2655452,118,'number',1,'line','line',102,NULL,NULL,0),(2655455,2655452,118,'string',2,'function','function',NULL,'writeToDatabaseEx',NULL,0),(2655456,2655421,118,'object',6,NULL,NULL,NULL,NULL,NULL,0),(2655457,2655456,118,'string',0,'file','file',NULL,'/home/bee/JSONDB/server/json/JSONDBListener.php',NULL,0),(2655458,2655456,118,'number',1,'line','line',93,NULL,NULL,0),(2655459,2655456,118,'string',2,'function','function',NULL,'writeToDatabase',NULL,0),(2655460,2655421,118,'object',7,NULL,NULL,NULL,NULL,NULL,0),(2655461,2655460,118,'string',0,'file','file',NULL,'/home/bee/JSONDB/server/json/JSONDBListener.php',NULL,0),(2655462,2655460,118,'number',1,'line','line',580,NULL,NULL,0),(2655463,2655460,118,'string',2,'function','function',NULL,'writeToJob',NULL,0),(2655464,2655460,118,'string',3,'class','class',NULL,'JSONDBListener',NULL,0),(2655465,2655460,118,'string',4,'type','type',NULL,'->',NULL,0),(2655466,2655421,118,'object',8,NULL,NULL,NULL,NULL,NULL,0),(2655467,2655466,118,'string',0,'file','file',NULL,'/home/bee/JSONDB/server/json/Parser.php',NULL,0),(2655468,2655466,118,'number',1,'line','line',531,NULL,NULL,0),(2655469,2655466,118,'string',2,'function','function',NULL,'value',NULL,0),(2655470,2655466,118,'string',3,'class','class',NULL,'JSONDBListener',NULL,0),(2655471,2655466,118,'string',4,'type','type',NULL,'->',NULL,0),(2655472,2655421,118,'object',9,NULL,NULL,NULL,NULL,NULL,0),(2655473,2655472,118,'string',0,'file','file',NULL,'/home/bee/JSONDB/server/json/Parser.php',NULL,0),(2655474,2655472,118,'number',1,'line','line',234,NULL,NULL,0),(2655475,2655472,118,'string',2,'function','function',NULL,'endString',NULL,0),(2655476,2655472,118,'string',3,'class','class',NULL,'JsonStreamingParser\\Parser',NULL,0),(2655477,2655472,118,'string',4,'type','type',NULL,'->',NULL,0),(2655478,2655421,118,'object',10,NULL,NULL,NULL,NULL,NULL,0),(2655479,2655478,118,'string',0,'file','file',NULL,'/home/bee/JSONDB/server/json/Parser.php',NULL,0),(2655480,2655478,118,'number',1,'line','line',176,NULL,NULL,0),(2655481,2655478,118,'string',2,'function','function',NULL,'consumeChar',NULL,0),(2655482,2655478,118,'string',3,'class','class',NULL,'JsonStreamingParser\\Parser',NULL,0),(2655483,2655478,118,'string',4,'type','type',NULL,'->',NULL,0),(2655484,2655421,118,'object',11,NULL,NULL,NULL,NULL,NULL,0),(2655485,2655484,118,'string',0,'file','file',NULL,'/home/bee/JSONDB/server/json/JSONDBListener.php',NULL,0),(2655486,2655484,118,'number',1,'line','line',77,NULL,NULL,0),(2655487,2655484,118,'string',2,'function','function',NULL,'parse',NULL,0),(2655488,2655484,118,'string',3,'class','class',NULL,'JsonStreamingParser\\Parser',NULL,0),(2655489,2655484,118,'string',4,'type','type',NULL,'->',NULL,0),(2655490,2655421,118,'object',12,NULL,NULL,NULL,NULL,NULL,0),(2655491,2655490,118,'string',0,'file','file',NULL,'/home/bee/JSONDB/server/json/functions.php',NULL,0),(2655492,2655490,118,'number',1,'line','line',148,NULL,NULL,0),(2655493,2655490,118,'string',2,'function','function',NULL,'writeToDatabase',NULL,0),(2655494,2655490,118,'string',3,'class','class',NULL,'JSONDBListener',NULL,0),(2655495,2655490,118,'string',4,'type','type',NULL,'->',NULL,0),(2655496,2655421,118,'object',13,NULL,NULL,NULL,NULL,NULL,0),(2655497,2655496,118,'string',0,'file','file',NULL,'/home/bee/JSONDB/server/json/functions.php',NULL,0),(2655498,2655496,118,'number',1,'line','line',259,NULL,NULL,0),(2655499,2655496,118,'string',2,'function','function',NULL,'writeToDatabaseEx',NULL,0),(2655500,2655421,118,'object',14,NULL,NULL,NULL,NULL,NULL,0),(2655501,2655500,118,'string',0,'file','file',NULL,'/home/bee/JSONDB/server/json/JSON.php',NULL,0),(2655502,2655500,118,'number',1,'line','line',11,NULL,NULL,0),(2655503,2655500,118,'string',2,'function','function',NULL,'handlePost',NULL,0),(2655504,2655413,118,'string',1,'path','path',NULL,'/my/',NULL,0),(2655505,2655413,118,'bool',2,'done','done',NULL,NULL,0,0);
/*!40000 ALTER TABLE `StagingValue` ENABLE KEYS */;
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
  `logonSecret` text,
  `newUserSecret` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `lostSecret` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `validated` tinyint NOT NULL,
  PRIMARY KEY (`userId`),
  UNIQUE KEY `UI_userEmail` (`userEmail`)
) ENGINE=InnoDB AUTO_INCREMENT=119 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `User`
--

LOCK TABLES `User` WRITE;
/*!40000 ALTER TABLE `User` DISABLE KEYS */;
INSERT INTO `User` VALUES (118,'brettdavidsilverman@gmail.com','dOUFxqt9MIWH/iRD/CHBQkZuaCrv3lDCrfg9c7rxtPf5lDkX01RMFV4Km7SqGvwEHoR9lX9s83pDwoaozPLeEA==',NULL,NULL,1);
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
  `locked` tinyint DEFAULT NULL,
  `type` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `objectIndex` bigint DEFAULT NULL,
  `objectKey` text,
  `lowerObjectKey` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `numericValue` double DEFAULT NULL,
  `stringValue` text,
  `boolValue` tinyint DEFAULT NULL,
  `isNull` tinyint NOT NULL,
  PRIMARY KEY (`valueId`),
  UNIQUE KEY `UI_Value_ownerId_parentValueId_locked_objectIndex` (`ownerId`,`parentValueId`,`locked`,`objectIndex`) USING BTREE,
  KEY `I_Value_stringValue` (`stringValue`(100)) USING BTREE,
  KEY `I_Value_ownerId` (`ownerId`),
  KEY `I_Value_parentValueId` (`parentValueId`),
  KEY `I_Value_lowerObjectKey_numericValue` (`lowerObjectKey`(20),`numericValue`) USING BTREE,
  KEY `I_Value_lowerObjectKey_stringValue` (`lowerObjectKey`(20),`stringValue`(20)) USING BTREE,
  KEY `I_Value_parentValueId_objectKey` (`parentValueId`,`objectKey`(100)) USING BTREE,
  CONSTRAINT `FK_Value_ownerId` FOREIGN KEY (`ownerId`) REFERENCES `User` (`userId`) ON DELETE CASCADE,
  CONSTRAINT `FK_Value_parentValueId` FOREIGN KEY (`parentValueId`) REFERENCES `Value` (`valueId`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=26469901 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Value`
--

LOCK TABLES `Value` WRITE;
/*!40000 ALTER TABLE `Value` DISABLE KEYS */;
INSERT INTO `Value` VALUES (26469858,NULL,118,0,'object',1,NULL,NULL,NULL,NULL,NULL,0),(26469859,26469858,118,0,'string',1,'type','type',NULL,'function',NULL,0),(26469860,26469858,118,0,'object',2,'inputs','inputs',NULL,NULL,NULL,0),(26469861,26469860,118,0,'number',1,'count','count',100000,NULL,NULL,0),(26469862,26469858,118,0,'object',3,'variables','variables',NULL,NULL,NULL,0),(26469863,26469862,118,0,'number',1,'x','x',0,NULL,NULL,0),(26469864,26469858,118,0,'object',4,'processes','processes',NULL,NULL,NULL,0),(26469865,26469864,118,0,'object',1,'check','check',NULL,NULL,NULL,0),(26469866,26469865,118,0,'object',1,'if','if',NULL,NULL,NULL,0),(26469867,26469866,118,0,'string',1,'test','test',NULL,'x < count',NULL,0),(26469868,26469866,118,0,'string',2,'true','true',NULL,'increment',NULL,0),(26469869,26469866,118,0,'string',3,'false','false',NULL,'exit',NULL,0),(26469870,26469864,118,0,'object',2,'increment','increment',NULL,NULL,NULL,0),(26469871,26469870,118,0,'string',1,'code','code',NULL,'++x',NULL,0),(26469872,26469870,118,0,'string',2,'next','next',NULL,'check',NULL,0),(26469873,26469864,118,0,'object',3,'exit','exit',NULL,NULL,NULL,0),(26469874,26469873,118,0,'string',1,'code','code',NULL,'return x',NULL,0),(26469875,26469858,118,0,'object',5,'match','match',NULL,NULL,NULL,0),(26469876,26469875,118,0,'array',1,'assignment','assignment',NULL,NULL,NULL,0),(26469877,26469876,118,0,'string',1,NULL,NULL,NULL,'variable',NULL,0),(26469878,26469876,118,0,'string',2,NULL,NULL,NULL,'expression',NULL,0),(26469879,26469875,118,0,'array',2,'variable','variable',NULL,NULL,NULL,0),(26469880,26469875,118,0,'array',3,'expression','expression',NULL,NULL,NULL,0),(26469881,26469858,118,0,'object',6,'tests','tests',NULL,NULL,NULL,0),(26469882,26469881,118,0,'object',1,'/','/',NULL,NULL,NULL,0),(26469883,26469882,118,0,'number',1,'a','a',1,NULL,NULL,0),(26469884,26469881,118,0,'object',2,' ',' ',NULL,NULL,NULL,0),(26469885,26469884,118,0,'number',1,'b','b',2,NULL,NULL,0),(26469886,26469881,118,0,'object',3,'💓','💓',NULL,NULL,NULL,0),(26469887,26469886,118,0,'string',1,'c','c',NULL,'🌏',NULL,0),(26469888,26469881,118,0,'object',4,'\r','\r',NULL,NULL,NULL,0),(26469889,26469888,118,0,'number',1,'d','d',3,NULL,NULL,0),(26469894,26469881,118,0,'array',5,'array','array',NULL,NULL,NULL,0),(26469895,26469894,118,0,'string',1,NULL,NULL,NULL,'one',NULL,0),(26469896,26469894,118,0,'string',2,NULL,NULL,NULL,'two',NULL,0),(26469897,26469894,118,0,'number',3,NULL,NULL,3,NULL,NULL,0),(26469898,26469894,118,0,'number',4,NULL,NULL,4,NULL,NULL,0),(26469899,26469894,118,0,'object',5,NULL,NULL,NULL,NULL,NULL,0),(26469900,26469899,118,0,'string',1,'🐝','🐝',NULL,'💓',NULL,0);
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
INSERT INTO `ValueParentChild` VALUES (26469858,26469858),(26469858,26469859),(26469858,26469860),(26469858,26469861),(26469858,26469862),(26469858,26469863),(26469858,26469864),(26469858,26469865),(26469858,26469866),(26469858,26469867),(26469858,26469868),(26469858,26469869),(26469858,26469870),(26469858,26469871),(26469858,26469872),(26469858,26469873),(26469858,26469874),(26469858,26469875),(26469858,26469876),(26469858,26469877),(26469858,26469878),(26469858,26469879),(26469858,26469880),(26469858,26469881),(26469858,26469882),(26469858,26469883),(26469858,26469884),(26469858,26469885),(26469858,26469886),(26469858,26469887),(26469858,26469888),(26469858,26469889),(26469858,26469894),(26469858,26469895),(26469858,26469896),(26469858,26469897),(26469858,26469898),(26469858,26469899),(26469858,26469900),(26469859,26469859),(26469860,26469860),(26469860,26469861),(26469861,26469861),(26469862,26469862),(26469862,26469863),(26469863,26469863),(26469864,26469864),(26469864,26469865),(26469864,26469866),(26469864,26469867),(26469864,26469868),(26469864,26469869),(26469864,26469870),(26469864,26469871),(26469864,26469872),(26469864,26469873),(26469864,26469874),(26469865,26469865),(26469865,26469866),(26469865,26469867),(26469865,26469868),(26469865,26469869),(26469866,26469866),(26469866,26469867),(26469866,26469868),(26469866,26469869),(26469867,26469867),(26469868,26469868),(26469869,26469869),(26469870,26469870),(26469870,26469871),(26469870,26469872),(26469871,26469871),(26469872,26469872),(26469873,26469873),(26469873,26469874),(26469874,26469874),(26469875,26469875),(26469875,26469876),(26469875,26469877),(26469875,26469878),(26469875,26469879),(26469875,26469880),(26469876,26469876),(26469876,26469877),(26469876,26469878),(26469877,26469877),(26469878,26469878),(26469879,26469879),(26469880,26469880),(26469881,26469881),(26469881,26469882),(26469881,26469883),(26469881,26469884),(26469881,26469885),(26469881,26469886),(26469881,26469887),(26469881,26469888),(26469881,26469889),(26469881,26469894),(26469881,26469895),(26469881,26469896),(26469881,26469897),(26469881,26469898),(26469881,26469899),(26469881,26469900),(26469882,26469882),(26469882,26469883),(26469883,26469883),(26469884,26469884),(26469884,26469885),(26469885,26469885),(26469886,26469886),(26469886,26469887),(26469887,26469887),(26469888,26469888),(26469888,26469889),(26469889,26469889),(26469894,26469894),(26469894,26469895),(26469894,26469896),(26469894,26469897),(26469894,26469898),(26469894,26469899),(26469894,26469900),(26469895,26469895),(26469896,26469896),(26469897,26469897),(26469898,26469898),(26469899,26469899),(26469899,26469900),(26469900,26469900);
/*!40000 ALTER TABLE `ValueParentChild` ENABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=4288755 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ValueWord`
--

LOCK TABLES `ValueWord` WRITE;
/*!40000 ALTER TABLE `ValueWord` DISABLE KEYS */;
INSERT INTO `ValueWord` VALUES (4288624,26469859,776111),(4288625,26469859,776112),(4288626,26469860,776113),(4288627,26469861,776113),(4288628,26469861,776114),(4288629,26469862,776115),(4288630,26469863,776115),(4288631,26469863,776116),(4288632,26469864,776117),(4288633,26469865,776117),(4288634,26469865,776118),(4288635,26469866,776117),(4288636,26469866,776118),(4288638,26469866,776119),(4288643,26469867,776114),(4288645,26469867,776116),(4288639,26469867,776117),(4288640,26469867,776118),(4288641,26469867,776119),(4288642,26469867,776120),(4288644,26469867,776121),(4288646,26469868,776117),(4288647,26469868,776118),(4288648,26469868,776119),(4288649,26469868,776122),(4288650,26469868,776123),(4288651,26469869,776117),(4288652,26469869,776118),(4288653,26469869,776119),(4288654,26469869,776124),(4288655,26469869,776125),(4288656,26469870,776117),(4288657,26469870,776122),(4288658,26469871,776117),(4288659,26469871,776122),(4288661,26469871,776126),(4288662,26469871,776127),(4288663,26469872,776117),(4288666,26469872,776118),(4288664,26469872,776122),(4288667,26469872,776128),(4288668,26469873,776117),(4288669,26469873,776124),(4288675,26469874,776116),(4288670,26469874,776117),(4288671,26469874,776124),(4288673,26469874,776127),(4288674,26469874,776129),(4288676,26469875,776141),(4288677,26469876,776141),(4288678,26469876,776144),(4288679,26469877,776141),(4288680,26469877,776144),(4288682,26469877,776145),(4288683,26469878,776141),(4288686,26469878,776142),(4288684,26469878,776144),(4288687,26469879,776141),(4288688,26469879,776145),(4288689,26469880,776141),(4288690,26469880,776142),(4288691,26469881,776140),(4288693,26469882,776134),(4288692,26469882,776140),(4288697,26469883,776133),(4288694,26469883,776134),(4288695,26469883,776140),(4288699,26469884,776135),(4288698,26469884,776140),(4288703,26469885,776130),(4288700,26469885,776135),(4288701,26469885,776140),(4288705,26469886,776136),(4288704,26469886,776140),(4288706,26469887,776136),(4288709,26469887,776137),(4288710,26469887,776138),(4288707,26469887,776140),(4288712,26469888,776139),(4288711,26469888,776140),(4288716,26469889,776131),(4288713,26469889,776139),(4288714,26469889,776140),(4288731,26469894,776140),(4288732,26469894,776146),(4288733,26469895,776140),(4288734,26469895,776146),(4288736,26469895,776147),(4288737,26469896,776140),(4288738,26469896,776146),(4288740,26469896,776148),(4288741,26469897,776140),(4288742,26469897,776146),(4288744,26469898,776140),(4288745,26469898,776146),(4288747,26469899,776140),(4288748,26469899,776146),(4288754,26469900,776136),(4288750,26469900,776140),(4288751,26469900,776146),(4288753,26469900,776149);
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
  UNIQUE KEY `UI_Word_word` (`word`(100)) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=776150 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Word`
--

LOCK TABLES `Word` WRITE;
/*!40000 ALTER TABLE `Word` DISABLE KEYS */;
INSERT INTO `Word` VALUES (776111,_binary 'function'),(776112,_binary 'type'),(776113,_binary 'inputs'),(776114,_binary 'count'),(776115,_binary 'variables'),(776116,_binary 'x'),(776117,_binary 'processes'),(776118,_binary 'check'),(776119,_binary 'if'),(776120,_binary '<'),(776121,_binary 'test'),(776122,_binary 'increment'),(776123,_binary 'true'),(776124,_binary 'exit'),(776125,_binary 'false'),(776126,_binary '++x'),(776127,_binary 'code'),(776128,_binary 'next'),(776129,_binary 'return'),(776130,_binary 'b'),(776131,_binary 'd'),(776132,_binary 's'),(776133,_binary 'a'),(776134,_binary '/'),(776135,_binary ' '),(776136,_binary '💓'),(776137,_binary 'c'),(776138,_binary '🌏'),(776139,_binary '\r'),(776140,_binary 'tests'),(776141,_binary 'match'),(776142,_binary 'expression'),(776143,_binary 'and'),(776144,_binary 'assignment'),(776145,_binary 'variable'),(776146,_binary 'array'),(776147,_binary 'one'),(776148,_binary 'two'),(776149,_binary '\�');
/*!40000 ALTER TABLE `Word` ENABLE KEYS */;
UNLOCK TABLES;

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
         CONCAT('/', @path)
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
   
   /* Remove trailing slash 
   SET @path = SUBSTR(@path, 1, LENGTH(@path) - 1);
   */
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
BEGIN

    SET @valueId = valueId,
             @userId = userId;
    
    IF @valueId IS NULL THEN
       RETURN '';
    END IF;
    
    SET @objectKey = (
       SELECT   objectKey
       FROM     Value
       WHERE   Value.valueId = @valueId
       AND         Value.ownerId = @userId
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
     #  AND       Session.ipAddress = @ipAddress
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
          SET              lastAccessedDate = NOW(),
                               ipAddress = @ipAddress
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
/*!50003 DROP PROCEDURE IF EXISTS `createJob` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`brett`@`%` PROCEDURE `createJob`(
    ownerId BIGINT,
    path TEXT
)
BEGIN
    SET    @ownerId = ownerId,
                @path = path;
                
    INSERT
    INTO
        Job(
            userId,
            path
        )
    VALUES
        (
            @ownerId,
            @path
        );
    
    SET @jobId = LAST_INSERT_ID();
    
    SELECT @jobId as jobId;
    
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
   SET  @ownerId = ownerId,
             @parentValueId = parentValueId,
             @valueId = null;
   
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
           locked,
           type,
           objectKey,
           objectIndex,
           isNull
       )
       VALUES(
           @ownerId,
           @parentValueId,
           1, #locked
           'null', #type
           NULL, #objectKey,
           @objectIndex,
           1 # isNull
        );
       
   SET @valueId = LAST_INSERT_ID();
       
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
              

  START TRANSACTION;
  
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
           
    COMMIT;
    
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
            @valueId = NULL,
            @type = NULL,
            @locked = NULL;
        
            
    IF @objectKey IS NOT NULL THEN
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
           v.objectKey = @objectKey
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
           v.objectKey = @objectKey
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
            v.objectKey
       INTO
           @type,
           @objectIndex,
           @objectKey
       FROM
           Value AS v
       WHERE
           v.valueId = @valueId
       FOR UPDATE;
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

   
   SET           @userId = userId,
                      @ownerId = ownerId,
                      @parentValueId = parentValueId,
                      @objectIndex = objectIndex,
                      @lowerObjectKey =
                         LOWER(objectKey);
   
   SELECT        Value.valueId,
                           Value.type
   FROM           Value
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
   AND            (@lowerObjectKey IS NULL
                          OR
                         Value.lowerObjectKey =
                           @lowerObjectKey)
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
                                  SELECT COUNT(*)
                                  FROM    Value
                                  WHERE  
                                       Value.ownerId = 
                                       @ownerId
                                 AND
                                       Value.parentValueId = 
                                        @valueId
                                  AND
                                        Value.locked = 0
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
   ownerId BIGINT,
   parentValueId BIGINT
)
BEGIN
   SET @parentValueId = parentValueId,
            @ownerId = ownerId;
   
   SELECT         Value.*,
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

    START TRANSACTION;
    
    SET @valueId = valueId;
    
    INSERT
    INTO
            ValueWord(
                valueId,
                wordId
            )
    SELECT DISTINCT
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
               ValueWord AS vw
            WHERE
                vw.valueId = @valueId
            AND
                vw.wordId = ValueWord.wordId
        );
        
    COMMIT;
    
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `insertStagingValue` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`brett`@`%` PROCEDURE `insertStagingValue`(
           ownerId BIGINT,
           parentValueId BIGINT,
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
             @type = type,
             @objectIndex = objectIndex,
             @objectKey =  objectKey,
             @isNull =  isNull,
             @stringValue = stringValue,
             @numericValue = numericValue,
             @boolValue = boolValue;
          

    INSERT INTO StagingValue(
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
/*
   # Insert this values parents
   INSERT
   INTO
       StagingValueParentChild
       (parentValueId, childValueId)
   SELECT
       svpc.parentValueId,
       @valueId
   FROM
       StagingValueParentChild as svpc
   WHERE
       svpc.childValueId = @parentValueId;
       
   # Insert this value
   INSERT
   INTO
       StagingValueParentChild
       (parentValueId, childValueId)
   VALUES
       (@valueId, @valueId);
       */
   /*
   # Index words
   CALL createWords(@valueId, @objectKey);
   CALL createWords(@valueId, @stringValue);
   */
   SELECT
       @valueId AS  valueId;
       
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

   START TRANSACTION;
    
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
             @boolValue = boolValue;
    
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
    ELSEIF @objectIndex IS NULL AND
         @objectKey IS NOT NULL
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
            Value.objectKey = @objectKey
        FOR UPDATE;
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
           @locked,
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
  
   SET @stagingValueId = @valueId;
       
   COMMIT;
   
   CALL insertValueParentChild(
        @stagingValueId,
        @parentValueId
   );
   
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
    valueId BIGINT,
    word BLOB
)
BEGIN

   START TRANSACTION;
    
    SET @valueId = valueId,
             @word = word,
             @wordId = NULL;
             
    SELECT
        Word.wordId
    INTO
        @wordId
    FROM
        Word
    WHERE
        Word.word = @word
    FOR UPDATE;
     
    IF @wordId IS NULL THEN
       INSERT
       INTO
           Word(word)
       VALUES(
           @word
        );
        
        SET @wordId = LAST_INSERT_ID();
        
    END IF;
    
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
       
   COMMIT;
    
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
)
BEGIN

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
  
    START TRANSACTION;
    
    SET @valueId = valueId,
             @ownerId = ownerId,
             @locked = locked,
             @type = type,
             @objecyKey = objectKey,
             @isNull =  isNull,
             @stringValue = stringValue,
             @numericValue = numericValue,
             @boolValue = boolValue;
          

   CALL deleteChildValues(@valueId);
   
   UPDATE Value
   SET
           Value.ownerId = @ownerId,
           Value.locked = @locked,
           Value.type = @type,
           Value.objectKey = @objectKey,
           Value.isNull = @isNull,
           Value.stringValue = @stringValue,
           Value.numericValue = @numericValue,
           Value.boolValue = @boolValue
   WHERE
        Value.valueId = @valueId;
   

   DELETE
   FROM
       ValueWord
   WHERE
       ValueWord.valueId = @valueId;
    
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

-- Dump completed on 2025-11-01 22:53:23
