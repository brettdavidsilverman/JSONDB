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
) ENGINE=InnoDB AUTO_INCREMENT=731 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Session`
--

LOCK TABLES `Session` WRITE;
/*!40000 ALTER TABLE `Session` DISABLE KEYS */;
INSERT INTO `Session` VALUES (730,'b86ebb4c26b09ce8c0f5211186e095f7',118,'2025-08-21 12:39:06','49.183.112.147','2025-08-21 13:50:59');
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
) ENGINE=InnoDB AUTO_INCREMENT=9546 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SessionStatus`
--

LOCK TABLES `SessionStatus` WRITE;
/*!40000 ALTER TABLE `SessionStatus` DISABLE KEYS */;
INSERT INTO `SessionStatus` VALUES (9545,730,'{\"label\":\"Logged in\",\"percentage\":0,\"done\":true,\"error\":null}',0);
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
INSERT INTO `User` VALUES (118,'brettdavidsilverman@gmail.com','29alyvJDJvHiE/w99Ov/Afr/YJWAHkhBUrDAUZYQ4LDxNMCUoAKrnlrBm++vzrKsWJvla/tuXjHC7VDg3cdo2g==',NULL,NULL,1);
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
  `locked` tinyint NOT NULL,
  `type` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `objectIndex` bigint NOT NULL,
  `objectKey` text,
  `lowerObjectKey` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `numericValue` double DEFAULT NULL,
  `stringValue` text,
  `boolValue` tinyint DEFAULT NULL,
  `isNull` tinyint NOT NULL,
  PRIMARY KEY (`valueId`),
  UNIQUE KEY `UI_Value_ownerId_parentValueId_objectIndex_locked` (`ownerId`,`parentValueId`,`objectIndex`,`locked`) USING BTREE,
  KEY `I_Value_stringValue` (`stringValue`(100)) USING BTREE,
  KEY `I_Value_ownerId` (`ownerId`),
  KEY `I_Value_parentValueId` (`parentValueId`),
  KEY `I_Value_lowerObjectKey_numericValue` (`lowerObjectKey`(20),`numericValue`) USING BTREE,
  KEY `I_Value_lowerObjectKey_stringValue` (`lowerObjectKey`(20),`stringValue`(20)) USING BTREE,
  KEY `I_Value_parentValueId_lowerObjectKey` (`parentValueId`,`lowerObjectKey`(100)) USING BTREE,
  CONSTRAINT `FK_Value_ownerId` FOREIGN KEY (`ownerId`) REFERENCES `User` (`userId`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7494646 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Value`
--

LOCK TABLES `Value` WRITE;
/*!40000 ALTER TABLE `Value` DISABLE KEYS */;
INSERT INTO `Value` VALUES (7494637,NULL,118,0,'object',0,NULL,NULL,NULL,NULL,NULL,0),(7494638,7494637,118,0,'array',0,'boo','boo',NULL,NULL,NULL,0),(7494639,7494638,118,0,'object',0,NULL,NULL,NULL,NULL,NULL,0),(7494640,7494639,118,0,'object',0,'boo2','boo2',NULL,NULL,NULL,0),(7494641,7494640,118,0,'array',0,'boo','boo',NULL,NULL,NULL,0),(7494642,7494641,118,0,'object',0,NULL,NULL,NULL,NULL,NULL,0),(7494643,7494642,118,0,'string',0,'boo2','boo2',NULL,'hi',NULL,0),(7494644,7494637,118,0,'string',1,'one','one',NULL,'Hello world',NULL,0),(7494645,7494637,118,0,'string',2,'two','two',NULL,'💕',NULL,0);
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
) ENGINE=InnoDB AUTO_INCREMENT=18378156 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
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
  `word` text NOT NULL,
  PRIMARY KEY (`wordId`),
  UNIQUE KEY `UI_Word_word` (`word`(100)) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=586715 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Word`
--

LOCK TABLES `Word` WRITE;
/*!40000 ALTER TABLE `Word` DISABLE KEYS */;
INSERT INTO `Word` VALUES (583635,'data'),(583636,'hello'),(583638,'hello2'),(583639,'test'),(583640,'jobs'),(583641,'label'),(583642,'uploading'),(583643,'done'),(583644,'path'),(583645,'/my/data'),(583646,'cancel'),(583647,'progress'),(583648,'indexing'),(583649,'words'),(583650,'view'),(583651,'id'),(583652,'rybz-nyjw'),(583653,'name'),(583654,'accidental'),(583655,'drug'),(583656,'related'),(583657,'deaths'),(583658,'2012-2018'),(583659,'attribution'),(583660,'office'),(583661,'of'),(583662,'the'),(583663,'chief'),(583664,'medical'),(583665,'examiner'),(583666,'attributionlink'),(583667,'http'),(583668,'//www'),(583669,'ct'),(583670,'gov/ocme'),(583671,'averagerating'),(583672,'category'),(583673,'health'),(583674,'and'),(583675,'human'),(583676,'services'),(583677,'createdat'),(583678,'description'),(583679,'a'),(583680,'listing'),(583681,'each'),(583682,'death'),(583683,'associated'),(583684,'with'),(583685,'overdose'),(583686,'in'),(583687,'connecticut'),(583688,'from'),(583689,'2012'),(583690,'to'),(583691,'2018'),(583692,'y'),(583693,'value'),(583694,'under'),(583695,'different'),(583696,'substance'),(583697,'columns'),(583698,'indicates'),(583699,'that'),(583700,'particular'),(583701,'was'),(583702,'detected'),(583703,'are'),(583704,'derived'),(583705,'an'),(583706,'investigation'),(583707,'by'),(583708,'which'),(583709,'includes'),(583710,'toxicity'),(583711,'report'),(583712,'certificate'),(583713,'as'),(583714,'well'),(583715,'scene'),(583716,'morphine'),(583717,'not'),(583718,'heroin'),(583719,'values'),(583720,'differences'),(583721,'between'),(583722,'how'),(583723,'metabolized'),(583724,'therefor'),(583725,'results'),(583726,'metabolizes'),(583727,'6-mam'),(583728,'then'),(583729,'is'),(583730,'unique'),(583731,'has'),(583732,'short'),(583733,'half-life'),(583734,'does'),(583735,'itself'),(583736,'thus'),(583737,'some'),(583738,'will'),(583739,'indicate'),(583740,'whether'),(583741,'or'),(583742,'prescription'),(583743,'these'),(583744,'cases'),(583745,'may'),(583746,'be'),(583747,'able'),(583748,'determine'),(583749,'cause'),(583750,'based'),(583751,'on'),(583752,'such'),(583753,'finding'),(583754,'needles'),(583755,'if'),(583756,'they'),(583757,'find'),(583758,'at'),(583759,'it'),(583760,'certified'),(583761,'but'),(583762,'indicated'),(583763,'any'),(583764,'opioid'),(583765,'–'),(583766,'cannot'),(583767,'conclude'),(583768,'it’s'),(583769,'rx'),(583770,'column'),(583771,'checked'),(583772,'displaytype'),(583773,'table'),(583774,'downloadcount'),(583775,'hidefromcatalog'),(583776,'hidefromdatajson'),(583777,'indexupdatedat'),(583778,'licenseid'),(583779,'public_domain'),(583780,'newbackend'),(583781,'numberofcomments'),(583782,'oid'),(583783,'provenance'),(583784,'official'),(583785,'publicationappendenabled'),(583786,'publicationdate'),(583787,'publicationgroup'),(583788,'publicationstage'),(583789,'published'),(583790,'resourcename'),(583791,'rowsupdatedat'),(583792,'tableid'),(583793,'totaltimesrated'),(583794,'viewcount'),(583795,'viewlastmodified'),(583796,'viewtype'),(583797,'tabular'),(583798,'approvals'),(583799,'reviewedat'),(583800,'reviewedautomatically'),(583801,'state'),(583802,'approved'),(583803,'submissionid'),(583804,'submissionobject'),(583805,'public_audience_request'),(583806,'submissionoutcome'),(583807,'change_audience'),(583808,'submittedat'),(583809,'workflowid'),(583810,'submissiondetails'),(583811,'permissiontype'),(583812,'read'),(583813,'submissionoutcomeapplication'),(583814,'failurecount'),(583815,'status'),(583816,'success'),(583817,'submitter'),(583818,'cvy9-n6sb'),(583819,'displayname'),(583820,'tyler'),(583821,'kleykamp'),(583822,'sid'),(583823,'datatypename'),(583824,'meta_data'),(583825,'fieldname'),(583826,'position'),(583827,'rendertypename'),(583828,'format'),(583829,'flags'),(583830,'hidden'),(583831,'created_at'),(583832,'created_meta'),(583833,'updated_at'),(583834,'updated_meta'),(583835,'meta'),(583836,'text'),(583837,'tablecolumnid'),(583838,'cachedcontents'),(583839,'largest'),(583840,'18-1018'),(583841,'non_null'),(583842,'null'),(583843,'top'),(583844,'item'),(583845,'12-0002'),(583846,'count'),(583847,'12-0003'),(583848,'12-0004'),(583849,'12-0005'),(583850,'12-0006'),(583851,'12-0007'),(583852,'12-0008'),(583853,'12-0009'),(583854,'12-0010'),(583855,'12-0011'),(583856,'12-0012'),(583857,'12-0013'),(583858,'12-0014'),(583859,'12-0015'),(583860,'12-0016'),(583861,'12-0017'),(583862,'12-0018'),(583863,'12-0019'),(583864,'12-0020'),(583865,'12-0021'),(583866,'smallest'),(583867,'12-0001'),(583868,'cardinality'),(583869,'date'),(583870,'calendar_date'),(583871,'width'),(583872,'2018-12-31t00'),(583873,'00'),(583874,'000'),(583875,'2017-08-18t00'),(583876,'2017-06-18t00'),(583877,'2017-06-02t00'),(583878,'2017-05-29t00'),(583879,'2018-12-17t00'),(583880,'2016-11-13t00'),(583881,'2017-03-05t00'),(583882,'2013-09-21t00'),(583883,'2016-10-03t00'),(583884,'2018-08-05t00'),(583885,'2018-05-13t00'),(583886,'2018-05-12t00'),(583887,'2017-02-11t00'),(583888,'2018-07-03t00'),(583889,'2016-02-26t00'),(583890,'2018-06-02t00'),(583891,'2017-12-27t00'),(583892,'2017-05-05t00'),(583893,'2018-06-28t00'),(583894,'2016-11-18t00'),(583895,'2012-01-01t00'),(583896,'datetype'),(583897,'datereported'),(583898,'dateofdeath'),(583899,'age'),(583900,'number'),(583901,'sex'),(583902,'unknown'),(583903,'male'),(583904,'female'),(583905,'race'),(583906,'white'),(583907,'hispanic'),(583908,'black'),(583909,'asian'),(583910,'other'),(583911,'indian'),(583912,'chinese'),(583913,'hawaiian'),(583914,'native'),(583915,'american'),(583916,'residencecity'),(583917,'zionsville'),(583918,'hartford'),(583919,'waterbury'),(583920,'bridgeport'),(583921,'new'),(583922,'haven'),(583923,'britain'),(583924,'bristol'),(583925,'meriden'),(583926,'norwich'),(583927,'manchester'),(583928,'torrington'),(583929,'west'),(583930,'east'),(583931,'middletown'),(583932,'danbury'),(583933,'london'),(583934,'enfield'),(583935,'stratford'),(583936,'stamford'),(583937,'milford'),(583938,'hamden'),(583939,'alfred'),(583940,'station'),(583941,'residencecounty'),(583942,'yankton'),(583943,'fairfield'),(583944,'litchfield'),(583945,'middlesex'),(583946,'windham'),(583947,'tolland'),(583948,'westchester'),(583949,'dutchess'),(583950,'hampden'),(583951,'essex'),(583952,'suffolk'),(583953,'washington'),(583954,'orange'),(583955,'harris'),(583956,'berkshire'),(583957,'york'),(583958,'aroostook'),(583959,'gloucester'),(583960,'residencestate'),(583961,'vt'),(583962,'ny'),(583963,'ma'),(583964,'fl'),(583965,'nj'),(583966,'ri'),(583967,'pa'),(583968,'tx'),(583969,'me'),(583970,'ca'),(583971,'co'),(583972,'il'),(583973,'mi'),(583974,'ga'),(583975,'md'),(583976,'mn'),(583977,'oh'),(583978,'la'),(583979,'ok'),(583980,'nc'),(583981,'al'),(583982,'deathcity'),(583983,'woodstock'),(583984,'norwalk'),(583985,'derby'),(583986,'deathcounty'),(583987,'usa'),(583988,'location'),(583989,'residence'),(583990,'hospital'),(583991,'convalescent'),(583992,'home'),(583993,'nursing'),(583994,'hospice'),(583995,'locationifother'),(583996,'ymca-parking'),(583997,'lot'),(583998,'friend'),(583999,'s'),(584000,'house'),(584001,'vehicle'),(584002,'friends'),(584003,'parking'),(584004,'boyfriend'),(584005,'motel'),(584006,'mother'),(584007,'hotel/motel'),(584008,'girlfriend'),(584009,'roadway'),(584010,'hotel'),(584011,'residential'),(584012,'building'),(584013,'wooded'),(584014,'area'),(584015,'apartment'),(584016,'sober'),(584017,'abandoned'),(584018,'descriptionofinjury'),(584019,'used'),(584020,'oxymorphone'),(584021,'abuse'),(584022,'use'),(584023,'ingestion'),(584024,'injection'),(584025,'inhalation'),(584026,'multiple'),(584027,'took'),(584028,'medications'),(584029,'acute'),(584030,'chronic'),(584031,'opiates'),(584032,'medicine'),(584033,'cocaine'),(584034,'injuryplace'),(584035,'yard'),(584036,'automobile'),(584037,'outdoor'),(584038,'halfway'),(584039,'restaurant'),(584040,'indoor'),(584041,'public'),(584042,'buildings'),(584043,'park'),(584044,'driveway'),(584045,'alleyway'),(584046,'injurycity'),(584047,'wtby'),(584048,'naugatuck'),(584049,'amston'),(584050,'injurycounty'),(584051,'putnam'),(584052,'injurystate'),(584053,'cod'),(584054,'tramadol'),(584055,'diphenhydramine'),(584056,'hydrocodone'),(584057,'intoxication'),(584058,'fentanyl'),(584059,'due'),(584060,'combined'),(584061,'effects'),(584062,'opiate'),(584063,'methadone'),(584064,'toxicities'),(584065,'oxycodone'),(584066,'1'),(584067,'1-difluoroethane'),(584068,'othersignifican'),(584069,'seizure'),(584070,'disorder'),(584071,'hypertensive'),(584072,'atherosclerotic'),(584073,'cardiovascular'),(584074,'disease'),(584075,'recent'),(584076,'coronary'),(584077,'artery'),(584078,'cardiac'),(584079,'hypertrophy'),(584080,'alcoholism'),(584081,'ascvd'),(584082,'cardiomegaly'),(584083,'arteriosclerotic'),(584084,'heart'),(584085,'atherosclerosis'),(584086,'obstructive'),(584087,'pulmonary'),(584088,'diabetes'),(584089,'mellitus'),(584090,'alprazolam'),(584091,'obesity'),(584092,'ptch'),(584093,'y-a'),(584094,'pops'),(584095,'fentanylanalogue'),(584096,'ethanol'),(584097,'benzodiazepine'),(584098,'amphet'),(584099,'tramad'),(584100,'morphine_notheroin'),(584101,'yes'),(584102,'no'),(584103,'straws'),(584104,'pcp'),(584105,'neg'),(584106,'stole'),(584107,'meds'),(584108,'hydromorphone'),(584109,'zolpidem'),(584110,'hydromorph'),(584111,'bupren'),(584112,'u-47700'),(584113,'morph'),(584114,'buprenor'),(584115,'mdma'),(584116,'carfentanil'),(584117,'ketamine'),(584118,'bupreno'),(584119,'2-a'),(584120,'opiatenos'),(584121,'anyopioid'),(584122,'n'),(584123,'mannerofdeath'),(584124,'pending'),(584125,'accident'),(584126,'natural'),(584127,'deathcitygeo'),(584128,'subcolumntypes'),(584129,'human_address'),(584130,'latitude'),(584131,'longitude'),(584132,'machine_address'),(584133,'needs_recoding'),(584134,'residencecitygeo'),(584135,'injurycitygeo'),(584136,'town'),(584137,'index'),(584138,'@computed_region_m4y2_whse'),(584139,'computationstrategy'),(584140,'source_columns'),(584141,'type'),(584142,'georegion_match_on_point'),(584143,'parameters'),(584144,'region'),(584145,'_m4y2-whse'),(584146,'primary_key'),(584147,'_feature_id'),(584148,'grants'),(584149,'inherited'),(584150,'viewer'),(584151,'license'),(584152,'domain'),(584153,'metadata'),(584154,'rdfsubject'),(584155,'custom_fields'),(584156,'agency'),(584157,'rowlabel'),(584158,'availabledisplaytypes'),(584159,'fatrow'),(584160,'page'),(584161,'rendertypeconfig'),(584162,'visible'),(584163,'owner'),(584164,'rfiw-8538'),(584165,'pauline'),(584166,'zaldonis'),(584167,'screenname'),(584168,'interactive'),(584169,'usersegment'),(584170,'site_member'),(584171,'acceptedeula'),(584172,'maybestoriescoowner'),(584173,'query'),(584174,'rights'),(584175,'tableauthor'),(584176,'tags'),(584177,'default'),(584178,'restorable'),(584179,'restorepossiblefortype'),(584180,'unsaved'),(584674,'newpath'),(584675,'jobpath'),(584676,'/my/jobs/0'),(584677,'timetaken'),(584678,'committing'),(584679,'/my/jobs/1'),(584680,'cancelled'),(584681,'/my/jobs/2'),(584683,'cancelling'),(584684,'/my/jobs/3'),(584685,'2'),(584686,'/my/jobs'),(584687,'message'),(584688,'syntaxerror'),(584689,'unexpected'),(584690,'end'),(584691,'json'),(584692,'input'),(584693,'url'),(584694,'method'),(584695,'post'),(584696,'where'),(584697,'authentication'),(584698,'fetch'),(584699,'parse'),(584702,'get'),(584703,'check'),(584704,'set'),(584705,'4'),(584706,'7822983583155'),(584708,'0'),(584709,'00031523167952287'),(584711,'40917072002068'),(584712,'93497716146482'),(584713,'3397346379722'),(584714,'7325133106577'),(584715,'0821052432485'),(584716,'426023005608'),(584717,'7387328316947'),(584718,'3'),(584719,'0284307451762'),(584721,'2998452212454'),(584722,'5731510873917'),(584723,'8278582844462'),(584724,'0608144956136'),(584725,'28778130487'),(584726,'5065520904589'),(584727,'7076699019945'),(584728,'8914499711563'),(584729,'027425156118489'),(584730,'43186740094633'),(584731,'0181983248589'),(584732,'4579465177933'),(584733,'8475728736835'),(584734,'178250905503'),(584735,'4922216583078'),(584736,'43249786430537'),(584737,'0077956794346'),(584738,'4664577731404'),(584739,'8516708855173'),(584740,'2015780497877'),(584741,'5237448262601'),(584742,'8225844584477'),(584743,'1053472749797'),(584744,'3795988361646'),(584745,'6336755698601'),(584746,'8653708543094'),(584747,'0904462734887'),(584748,'3044885838847'),(584749,'5169547358831'),(584750,'7256381077273'),(584751,'9226579074291'),(584752,'5'),(584753,'1061227449114'),(584755,'2974683743818'),(584756,'4774656633893'),(584757,'6533649405631'),(584758,'8103503169655'),(584759,'9818363506259'),(584760,'6'),(584761,'1564747010816'),(584763,'3330044416144'),(584764,'4874679645806'),(584765,'6498122795348'),(584766,'8143632162458'),(584767,'962206873942'),(584768,'7'),(584769,'1087896049201'),(584771,'244339227115'),(584772,'3928133481702'),(584773,'5308848238013'),(584774,'6563470322514'),(584775,'7837006307786'),(584776,'9009668155611'),(584777,'8'),(584778,'037777364474'),(584780,'1604024878084'),(584781,'2905931714514'),(584782,'4157401482219'),(584783,'5371043448382'),(584784,'6625665532883'),(584785,'7798327380708'),(584786,'9062406415595'),(584787,'9'),(584788,'0219306679444'),(584790,'1417187061631'),(584791,'2555173424708'),(584792,'3841318677162'),(584793,'4881583219587'),(584794,'6098377502545'),(584795,'7280496300756'),(584796,'8396416446267'),(584797,'9584839878068'),(584798,'10'),(584799,'066293222204'),(584801,'164645506215'),(584802,'265834875342'),(584803,'371752719661'),(584804,'477670563981'),(584805,'593360590366'),(584806,'692658569416'),(584807,'794793633581'),(584808,'898189624465'),(584809,'11'),(584810,'003792237105'),(584812,'110340544783'),(584813,'193876939857'),(584814,'288446443714'),(584815,'385222569327'),(584816,'481052999902'),(584817,'572154955284'),(584818,'665463532423'),(584819,'765707206511'),(584820,'859961478689'),(584821,'949802507353'),(584822,'12'),(584823,'044687242889'),(584825,'141148136823'),(584826,'231304397167'),(584827,'327450059421'),(584828,'425171880073'),(584829,'510914896903'),(584830,'610212875953'),(584831,'700369136297'),(584832,'787057848166'),(584833,'874692255073'),(584834,'95570679671'),(584835,'13'),(584836,'044286898656'),(584838,'122464355178'),(584839,'20663121361'),(584840,'286700060209'),(584841,'375280162155'),(584842,'462914569063'),(584843,'548027122534'),(584844,'629356895851'),(584845,'704697267257'),(584846,'785711808894'),(584847,'863889265416'),(584848,'942066721937'),(584849,'14'),(584850,'026548812049'),(584852,'107878585366'),(584853,'182903725093'),(584854,'262657340012'),(584855,'340834796534'),(584856,'421218874812'),(584857,'503809574847'),(584858,'585769811523'),(584859,'670251901635'),(584860,'742124724566'),(584861,'826922046358'),(584862,'902892881123'),(584863,'975396167413'),(584864,'15'),(584865,'051682233858'),(584867,'12922922702'),(584868,'216863633928'),(584869,'2881059935'),(584870,'363761596585'),(584871,'441939053107'),(584872,'517909887872'),(584873,'592619795919'),(584874,'673003874197'),(584875,'752127025758'),(584876,'827467397164'),(584877,'905960085365'),(584878,'974680591501'),(584879,'16'),(584880,'045607719393'),(584882,'116534847286'),(584883,'183363963345'),(584884,'251454006122'),(584885,'330577157682'),(584886,'403080443972'),(584887,'474638035224'),(584888,'553445955105'),(584889,'618383681086'),(584890,'690256504018'),(584891,'764966412065'),(584892,'831165064764'),(584893,'90020080258'),(584894,'952214029701'),(584895,'17'),(584896,'017151755683'),(584898,'097535833961'),(584899,'167517266815'),(584900,'226150359206'),(584901,'291088085188'),(584902,'353503957734'),(584903,'412137050125'),(584904,'470770142516'),(584905,'537284026896'),(584906,'603797911275'),(584907,'664637625423'),(584908,'73241243652'),(584909,'795143540745'),(584910,'85787464497'),(584911,'916507737362'),(584912,'972618976317'),(584913,'18'),(584914,'023686508399'),(584916,'087048075983'),(584917,'157029508838'),(584918,'215977832908'),(584919,'268306291709'),(584920,'334820176088'),(584921,'405116840622'),(584922,'463749933013'),(584923,'522383025405'),(584924,'581016117796'),(584925,'639333978508'),(584926,'69702137586'),(584927,'76353526024'),(584928,'828157754542'),(584929,'880801445022'),(584930,'937858379016'),(584931,'19'),(584932,'006894116831'),(584934,'064581514184'),(584935,'124475533293'),(584936,'193511271109'),(584937,'246785424948'),(584938,'305418517339'),(584939,'35774697614'),(584940,'416380068531'),(584941,'464925747178'),(584942,'521982681172'),(584943,'586920407153'),(584944,'64839058466'),(584945,'70828460377'),(584946,'771330939674'),(584947,'830594495424'),(584948,'882922954225'),(584949,'940610351578'),(584950,'995775895494'),(584951,'20'),(584952,'054724219565'),(584954,'112411616918'),(584955,'166631465796'),(584956,'221797009712'),(584957,'270342688359'),(584958,'317942671967'),(584959,'372792984204'),(584960,'440567795301'),(584961,'490059168986'),(584962,'554051199929'),(584963,'604803500333'),(584964,'664067056083'),(584965,'728689550385'),(584966,'779757082468'),(584967,'838705406539'),(584968,'893870950455'),(584969,'945253714217'),(584970,'21'),(584971,'008930513481'),(584973,'060943740602'),(584974,'118000674596'),(584975,'178209925385'),(584976,'228962225788'),(584977,'283497306345'),(584978,'33298868003'),(584979,'393197930819'),(584980,'443634999543'),(584981,'498800543459'),(584982,'55112900226'),(584983,'606609777856'),(584984,'659568700016'),(584985,'725452121036'),(584986,'78219382335'),(584987,'830424270317'),(584988,'883383192477'),(584989,'930983176085'),(584990,'987724878399'),(584991,'22'),(584992,'039738105521'),(584994,'098371197912'),(584995,'147547339917'),(584996,'201136725436'),(584997,'25157379416'),(584998,'303902252961'),(584999,'359698260236'),(585000,'409504865601'),(585001,'460257166004'),(585002,'507226686253'),(585003,'563022693529'),(585004,'608731287059'),(585005,'671147159605'),(585006,'7143338997'),(585007,'768238516898'),(585008,'81993651234'),(585009,'870688812743'),(585010,'923962966582'),(585011,'979758973858'),(585012,'23'),(585013,'024206640671'),(585015,'068654307483'),(585016,'122243693002'),(585017,'177094005239'),(585018,'22942246404'),(585019,'278598606046'),(585020,'327144284692'),(585021,'382309828609'),(585022,'427072727101'),(585023,'48034688094'),(585024,'531099181343'),(585025,'586895188619'),(585026,'630397160393'),(585027,'684617009271'),(585028,'725597127609'),(585029,'768153404345'),(585030,'820797094825'),(585031,'872810321946'),(585032,'92324739067'),(585033,'970532142598'),(585034,'24'),(585035,'017186431168'),(585037,'069830121648'),(585038,'115853946858'),(585039,'165975783902'),(585040,'216728084306'),(585041,'263697604554'),(585042,'309090966406'),(585043,'359528035129'),(585044,'39893199507'),(585045,'449684295473'),(585046,'490349182131'),(585047,'53763393406'),(585048,'582396832552'),(585049,'62369218257'),(585050,'671292166178'),(585051,'722044466581'),(585052,'770590145227'),(585053,'816298738758'),(585054,'858224552135'),(585055,'905194072383'),(585056,'950272202555'),(585057,'994404637688'),(585058,'25'),(585059,'036330451065'),(585061,'083299971314'),(585062,'129639028204'),(585063,'169358219824'),(585064,'218534361829'),(585065,'269917125591'),(585066,'309951548891'),(585067,'357236300819'),(585068,'401053504273'),(585069,'441403159252'),(585070,'491209764617'),(585071,'540701138302'),(585072,'588931585269'),(585073,'639683885672'),(585074,'686653405921'),(585075,'732046767772'),(585076,'776494434585'),(585077,'823463954834'),(585078,'870748706762'),(585079,'91141359342'),(585080,'950817553361'),(585081,'989275818263'),(585082,'26'),(585083,'029940704921'),(585085,'077540688529'),(585086,'11662941679'),(585087,'162022778641'),(585088,'204263823697'),(585089,'245243942035'),(585090,'294104852361'),(585091,'337606824135'),(585092,'382369722628'),(585093,'429339242877'),(585094,'470004129535'),(585095,'516343186425'),(585096,'554170987968'),(585097,'597357728062'),(585098,'636446456323'),(585099,'675535184584'),(585100,'720928546435'),(585101,'760017274696'),(585102,'795953686162'),(585103,'839770889615'),(585104,'880435776274'),(585105,'919524504535'),(585106,'965548329745'),(585107,'27'),(585108,'005267521365'),(585110,'043725786267'),(585111,'085966831323'),(585112,'134512509969'),(585113,'172025079832'),(585114,'214581356568'),(585115,'255246243226'),(585116,'294334971487'),(585117,'337206479902'),(585118,'374403818086'),(585119,'415383936424'),(585120,'456048823083'),(585121,'495137551343'),(585122,'534856742963'),(585123,'581195799853'),(585124,'623752076589'),(585125,'659373256375'),(585126,'690896424327'),(585127,'735974554499'),(585128,'77506328276'),(585129,'813836779341'),(585130,'854816897679'),(585131,'90052549121'),(585132,'942136072907'),(585133,'983746654604'),(585134,'28'),(585135,'023781077903'),(585137,'069804903114'),(585138,'108893631374'),(585139,'146406201238'),(585140,'193375721487'),(585141,'237823388299'),(585142,'283216750151'),(585143,'325457795207'),(585144,'366437913545'),(585145,'409939885319'),(585146,'442723979989'),(585147,'478345159775'),(585148,'519325278113'),(585149,'556207384617'),(585150,'595611344558'),(585151,'631862987703'),(585152,'674104032759'),(585153,'716345077815'),(585154,'752281489281'),(585155,'792946375939'),(585156,'824154312212'),(585157,'861982113755'),(585158,'902331768733'),(585159,'941420496994'),(585160,'981139688614'),(585161,'29'),(585162,'025902587106'),(585164,'068143632162'),(585165,'107232360423'),(585166,'143168771889'),(585167,'175952866559'),(585168,'222922386808'),(585169,'263587273467'),(585170,'309926330356'),(585171,'347754131899'),(585172,'385581933442'),(585173,'428138210178'),(585174,'474792498747'),(585175,'514511690367'),(585176,'553285186948'),(585177,'586384513298'),(585178,'624212314841'),(585179,'660463957986'),(585180,'697030832811'),(585181,'731391085879'),(585182,'768903655742'),(585183,'8095685424'),(585184,'847396343943'),(585185,'878289048536'),(585186,'923997642067'),(585187,'95520557834'),(585188,'989565831408'),(585189,'30'),(585190,'032122108143'),(585192,'068058519609'),(585193,'106201552831'),(585194,'144029354374'),(585195,'180280997519'),(585196,'224413432652'),(585197,'262556465875'),(585198,'301960425815'),(585199,'333168362088'),(585200,'378876955619'),(585201,'411345818609'),(585202,'45043454687'),(585203,'489523275131'),(585204,'519470284686'),(585205,'559189476306'),(585206,'593549729374'),(585207,'633584152673'),(585208,'671411954216'),(585209,'70797882904'),(585210,'745176167224'),(585211,'78111257869'),(585212,'820201306951'),(585213,'852985401621'),(585214,'891128434843'),(585215,'928325773027'),(585216,'962055562736'),(585217,'99925290092'),(585218,'31'),(585219,'034874080706'),(585221,'067973407056'),(585222,'107062135316'),(585223,'144889936859'),(585224,'17735879985'),(585225,'211088589559'),(585226,'248916391102'),(585227,'28958127776'),(585228,'328670006021'),(585229,'367758734282'),(585230,'405271304145'),(585231,'445936190803'),(585232,'476198432038'),(585233,'513711001901'),(585234,'549962645046'),(585235,'584322898114'),(585236,'630346723324'),(585237,'660924196238'),(585238,'700012924499'),(585239,'731536092451'),(585240,'766526808878'),(585241,'803724147062'),(585242,'836823473412'),(585243,'868031409685'),(585244,'906174442907'),(585245,'942426086052'),(585246,'975210180722'),(585247,'32'),(585248,'019027384176'),(585250,'051811478846'),(585251,'08932404871'),(585252,'12210814338'),(585253,'156783628127'),(585254,'188622027759'),(585255,'22771075602'),(585256,'257342533895'),(585257,'292648482002'),(585258,'317551784684'),(585259,'355379586227'),(585260,'392576924411'),(585261,'429459030915'),(585262,'462243125585'),(585263,'49219013514'),(585264,'528757009964'),(585265,'560280177917'),(585266,'59779274778'),(585267,'627739757335'),(585268,'658001998569'),(585269,'695514568432'),(585270,'726722504705'),(585271,'754147660823'),(585272,'785355597096'),(585273,'819085386805'),(585274,'851869481475'),(585275,'889382051339'),(585276,'92784031624'),(585277,'96125487427'),(585278,'997821749094'),(585279,'33'),(585280,'031236307124'),(585282,'0731621205'),(585283,'104370056773'),(585284,'137154151444'),(585285,'180656123218'),(585286,'210918364452'),(585287,'250637556072'),(585288,'289411052653'),(585289,'327554085875'),(585290,'367273277495'),(585291,'397850750409'),(585292,'43693947867'),(585293,'468147414943'),(585294,'497148729459'),(585295,'533085140924'),(585296,'569967247428'),(585297,'604012268817'),(585298,'638372521885'),(585299,'673048006632'),(585300,'708669186419'),(585301,'741768512768'),(585302,'777074460875'),(585303,'814902262418'),(585304,'847371125409'),(585305,'878579061681'),(585306,'917667789942'),(585307,'953288969728'),(585308,'99174723463'),(585309,'34'),(585310,'02484656098'),(585312,'054163107176'),(585313,'090729982'),(585314,'128242551863'),(585315,'16354849997'),(585316,'200745838154'),(585317,'230377616029'),(585318,'263792174058'),(585319,'296891500408'),(585320,'328099436681'),(585321,'362144458069'),(585322,'39461332106'),(585323,'437169597796'),(585324,'479410642852'),(585325,'509042420727'),(585326,'533945723409'),(585327,'572719219991'),(585328,'606764241379'),(585329,'640494031088'),(585330,'674539052477'),(585331,'706377452108'),(585332,'742313863574'),(585333,'781402591835'),(585334,'820491320096'),(585335,'848862171253'),(585336,'880700570885'),(585337,'911908507157'),(585338,'945953528546'),(585339,'973063452985'),(585340,'35'),(585341,'001434304142'),(585343,'038631642326'),(585344,'067002493483'),(585345,'099471356473'),(585346,'127211744271'),(585347,'16094153398'),(585348,'191834238574'),(585349,'222096479808'),(585350,'255511037837'),(585351,'289240827546'),(585352,'316981215344'),(585353,'341884518027'),(585354,'376560002774'),(585355,'408398402406'),(585356,'445910972269'),(585357,'477118908542'),(585358,'506120223058'),(585359,'537328159331'),(585360,'571373180719'),(585361,'598483105158'),(585362,'631897663188'),(585363,'655855270831'),(585364,'68990029222'),(585365,'72268438689'),(585366,'758620798356'),(585367,'787622112872'),(585368,'815992964029'),(585369,'848777058699'),(585370,'883767775126'),(585371,'916867101476'),(585372,'952803512942'),(585373,'984011449215'),(585374,'36'),(585375,'019317397321'),(585377,'052101491992'),(585378,'083309428264'),(585379,'110734584383'),(585380,'141942520656'),(585381,'175672310365'),(585382,'201206076406'),(585383,'245968974898'),(585384,'278753069568'),(585385,'312482859277'),(585386,'348734502423'),(585387,'377735816939'),(585388,'411465606648'),(585389,'435107982612'),(585390,'464109297128'),(585391,'493741075003'),(585392,'531253644866'),(585393,'560254959382'),(585394,'591462895655'),(585395,'624877453685'),(585396,'656400621637'),(585397,'684141009435'),(585398,'714403250669'),(585399,'747817808698'),(585400,'779025744971'),(585401,'807396596128'),(585402,'837658837363'),(585403,'871388627071'),(585404,'900389941588'),(585405,'935065426335'),(585406,'962805814133'),(585407,'991807128649'),(585408,'37'),(585409,'021438906524'),(585411,'055483927913'),(585412,'078811072198'),(585413,'110964703509'),(585414,'148162041693'),(585415,'177793819568'),(585416,'214045462713'),(585417,'245883862345'),(585418,'27551564022'),(585419,'310191124967'),(585420,'342029524599'),(585421,'379542094462'),(585422,'408228177299'),(585423,'439751345251'),(585424,'467491733049'),(585425,'501851986117'),(585426,'529592373915'),(585427,'564583090342'),(585428,'594530099897'),(585429,'6191181709'),(585430,'653163192288'),(585431,'680588348407'),(585432,'714948601475'),(585433,'745841306068'),(585434,'779886327456'),(585435,'809518105332'),(585436,'83725849313'),(585437,'86972735612'),(585438,'896837280559'),(585439,'929936606909'),(585440,'957992226387'),(585441,'9885696993'),(585442,'38'),(585443,'018201477176'),(585445,'051931266885'),(585446,'076834569567'),(585447,'104259725685'),(585448,'132945808522'),(585449,'166360366551'),(585450,'199144461222'),(585451,'228776239097'),(585452,'259038480331'),(585453,'288985489886'),(585454,'317671572722'),(585455,'348249045636'),(585456,'376304665114'),(585457,'403414589553'),(585458,'436513915902'),(585459,'465830462098'),(585460,'493570849896'),(585461,'522256932733'),(585462,'550943015569'),(585463,'588455585433'),(585464,'619348290026'),(585465,'650556226299'),(585466,'676720455699'),(585467,'70918931869'),(585468,'745125730155'),(585469,'772550886274'),(585470,'803758822547'),(585471,'832444905383'),(585472,'857348208066'),(585473,'886979985941'),(585474,'921025007329'),(585475,'950026321845'),(585476,'97965809972'),(585477,'39'),(585478,'002354780646'),(585480,'038291192112'),(585481,'070129591743'),(585482,'096924284503'),(585483,'124349440621'),(585484,'155557376894'),(585485,'18455869141'),(585486,'207885835695'),(585487,'241930857083'),(585488,'274399720074'),(585489,'301509644513'),(585490,'330510959029'),(585491,'358566578507'),(585492,'383785112869'),(585493,'411210268987'),(585494,'44241820526'),(585495,'468267202981'),(585496,'496007590779'),(585497,'520595661782'),(585498,'555271146529'),(585499,'585533387763'),(585500,'612958543882'),(585501,'637861846564'),(585502,'665287002683'),(585503,'696494938955'),(585504,'727702875228'),(585505,'753551872949'),(585506,'784129345863'),(585507,'814391587097'),(585508,'847490913447'),(585509,'880590239797'),(585510,'916526651262'),(585511,'939223332188'),(585512,'966963719986'),(585513,'995019339464'),(585514,'40'),(585515,'022129263903'),(585517,'046717334905'),(585518,'073196795985'),(585519,'101252415463'),(585520,'130253729979'),(585521,'160200739534'),(585522,'18888682237'),(585523,'218518600245'),(585524,'249096073159'),(585525,'278727851034'),(585526,'305837775473'),(585527,'330741078155'),(585528,'358481465953'),(585529,'38748278047'),(585530,'417114558345'),(585531,'444539714463'),(585532,'477008577454'),(585533,'509477440445'),(585534,'533435048089'),(585535,'561805899246'),(585536,'591437677121'),(585537,'627058856907'),(585538,'656690634782'),(585539,'689474729452'),(585540,'715323727173'),(585541,'742748883292'),(585542,'773641587885'),(585543,'795077342093'),(585544,'818089254698'),(585545,'850873349368'),(585546,'880820358923'),(585547,'904462734887'),(585548,'93567067116'),(585549,'962465363919'),(585550,'990520983397'),(585551,'41'),(585552,'02109845631'),(585554,'049154075788'),(585555,'078470621984'),(585556,'107787168179'),(585557,'138995104452'),(585558,'167996418968'),(585559,'196682501805'),(585560,'223792426244'),(585561,'251532814042'),(585562,'280849360237'),(585563,'307013589638'),(585564,'33191689232'),(585565,'359342048438'),(585566,'389289057993'),(585567,'427432091215'),(585568,'458640027488'),(585569,'488271805363'),(585570,'527360533624'),(585571,'55636184814'),(585572,'585993626015'),(585573,'614994940532'),(585574,'643681023368'),(585575,'672051874525'),(585576,'70199888408'),(585577,'728793576839'),(585578,'756533964637'),(585579,'78143726732'),(585580,'810438581836'),(585581,'836287579557'),(585582,'865919357432'),(585583,'89334451355'),(585584,'917617352873'),(585585,'945988204031'),(585586,'974359055188'),(585587,'995164346036'),(585588,'42'),(585589,'022589502155'),(585591,'050329889953'),(585592,'07838550943'),(585593,'101082190356'),(585594,'128822578154'),(585595,'156562965952'),(585596,'179574878557'),(585597,'210152351471'),(585598,'244512604539'),(585599,'272568224016'),(585600,'299362916776'),(585601,'324896682817'),(585602,'357365545808'),(585603,'383529775208'),(585604,'412531089724'),(585605,'4421628676'),(585606,'475577425629'),(585607,'510252910376'),(585608,'541776078329'),(585609,'568886002768'),(585610,'598202548963'),(585611,'623736315005'),(585612,'650531007764'),(585613,'675434310446'),(585614,'704435624963'),(585615,'729654159324'),(585616,'753611766968'),(585617,'781036923087'),(585618,'800581287217'),(585619,'821701809745'),(585620,'85133358762'),(585621,'880334902136'),(585622,'907129594896'),(585623,'935500446053'),(585624,'964816992248'),(585625,'996024928521'),(585626,'43'),(585627,'021558694563'),(585629,'046777228924'),(585630,'074202385043'),(585631,'103203699559'),(585632,'124954685446'),(585633,'152379841565'),(585634,'180120229363'),(585635,'20187121525'),(585636,'230872529766'),(585637,'259243380923'),(585638,'286353305362'),(585639,'309049986287'),(585640,'333322825611'),(585641,'364530761883'),(585642,'385651284411'),(585643,'411500282132'),(585644,'442708218405'),(585645,'462252582536'),(585646,'483373105064'),(585647,'506385017669'),(585648,'534125405467'),(585649,'567539963496'),(585650,'592758497858'),(585651,'623651202451'),(585652,'651391590249'),(585653,'678816746368'),(585654,'704665744089'),(585655,'729569046771'),(585656,'755418044492'),(585657,'778114725417'),(585658,'802387564741'),(585659,'827290867423'),(585660,'853139865144'),(585661,'884347801417'),(585662,'911457725856'),(585663,'934469638461'),(585664,'959688172823'),(585665,'991526572454'),(585666,'44'),(585667,'017060338496'),(585669,'04101794614'),(585670,'071280187374'),(585671,'098390111813'),(585672,'119195402661'),(585673,'144413937023'),(585674,'167741081308'),(585675,'19232915231'),(585676,'221960930186'),(585677,'250331781343'),(585678,'274289388986'),(585679,'300138386707'),(585680,'319682750838'),(585681,'342379431763'),(585682,'372011209639'),(585683,'404480072629'),(585684,'431274765389'),(585685,'4634283967'),(585686,'495897259691'),(585687,'525844269246'),(585688,'554530352082'),(585689,'580379349803'),(585690,'611587286076'),(585691,'639012442194'),(585692,'671796536865'),(585693,'697645534586'),(585694,'72097267887'),(585695,'747136908271'),(585696,'779921002941'),(585697,'808922317457'),(585698,'844858728923'),(585699,'867555409848'),(585700,'892458712531'),(585701,'921775258726'),(585702,'951722268281'),(585703,'974734180886'),(585704,'45'),(585705,'003105032043'),(585707,'032736809918'),(585708,'068357989705'),(585709,'094837450784'),(585710,'125099692019'),(585711,'147165909585'),(585712,'169547358831'),(585713,'19697251495'),(585714,'224397671068'),(585715,'255605607341'),(585716,'283345995139'),(585717,'305096981026'),(585718,'332206905465'),(585719,'354903586391'),(585720,'380752584112'),(585721,'404079728396'),(585722,'437809518105'),(585723,'462712820788'),(585724,'488561818509'),(585725,'511258499434'),(585726,'535531338757'),(585727,'566424043351'),(585728,'586283639161'),(585729,'613708795279'),(585730,'636090244525'),(585731,'663830632323'),(585732,'687157776608'),(585733,'713637237688'),(585734,'734442528536'),(585735,'755878282744'),(585736,'78487959726'),(585737,'81104382666'),(585738,'834055739266'),(585739,'859904736986'),(585740,'882601417912'),(585741,'91065703739'),(585742,'9305166332'),(585743,'959202716036'),(585744,'982214628641'),(585745,'46'),(585746,'010585479798'),(585748,'040847721033'),(585749,'067327182112'),(585750,'094437106551'),(585751,'119340409234'),(585752,'146765565352'),(585753,'17450595315'),(585754,'201931109269'),(585755,'222421168438'),(585756,'243226459286'),(585757,'270651615405'),(585758,'296500613126'),(585759,'317936367333'),(585760,'340948279938'),(585761,'369949594454'),(585762,'396744287214'),(585763,'422278053255'),(585764,'448127050976'),(585765,'473030353658'),(585766,'502346899854'),(585767,'526934970857'),(585768,'550892578501'),(585769,'580524356376'),(585770,'609840902571'),(585771,'632852815177'),(585772,'661854129693'),(585773,'691170675888'),(585774,'708508418262'),(585775,'736879269419'),(585776,'757999791947'),(585777,'781326936232'),(585778,'80875209235'),(585779,'834916321751'),(585780,'862341477869'),(585781,'891973255744'),(585782,'919398411863'),(585783,'944301714545'),(585784,'973303029061'),(585785,'999467258462'),(585786,'47'),(585787,'021533476028'),(585789,'045175851992'),(585790,'069448691316'),(585791,'097819542473'),(585792,'123668540194'),(585793,'153930781428'),(585794,'175051303956'),(585795,'204683081831'),(585796,'233369164668'),(585797,'263000942543'),(585798,'286012855148'),(585799,'314068474625'),(585800,'335188997153'),(585801,'362614153272'),(585802,'388147919313'),(585803,'407692283444'),(585804,'43007373269'),(585805,'460335973924'),(585806,'486500203324'),(585807,'511088274327'),(585808,'538513430446'),(585809,'559633952974'),(585810,'586428645733'),(585811,'608810094979'),(585812,'636235251098'),(585813,'657355773626'),(585814,'684465698065'),(585815,'706531915631'),(585816,'732065681673'),(585817,'76012130115'),(585818,'792590164141'),(585819,'815602076746'),(585820,'839244452711'),(585821,'861310670277'),(585822,'882431192805'),(585823,'909856348924'),(585824,'930976871452'),(585825,'955564942454'),(585826,'97857685506'),(585827,'999697377588'),(585828,'48'),(585829,'025546375309'),(585831,'052971531427'),(585832,'072515895557'),(585833,'09741919824'),(585834,'123268195961'),(585835,'144388718489'),(585836,'17023771621'),(585837,'193880092174'),(585838,'217837699817'),(585839,'243686697538'),(585840,'273318475414'),(585841,'293808534582'),(585842,'320287995662'),(585843,'34140851819'),(585844,'369464137668'),(585845,'396889293786'),(585846,'421792596469'),(585847,'449217752587'),(585848,'483262773976'),(585849,'504383296504'),(585850,'524873355673'),(585851,'546939573239'),(585852,'575940887755'),(585853,'597691873643'),(585854,'620073322889'),(585855,'650966027482'),(585856,'6783911836'),(585857,'701718327885'),(585858,'722838850413'),(585859,'748687848134'),(585860,'77138452906'),(585861,'798494453499'),(585862,'819299744347'),(585863,'846094437107'),(585864,'867530191314'),(585865,'893063957355'),(585866,'924587125308'),(585867,'946338111195'),(585868,'974078498993'),(585869,'99582948488'),(585870,'49'),(585871,'024200336037'),(585873,'049418870399'),(585874,'079681111633'),(585875,'100801634161'),(585876,'121922156689'),(585877,'143357910897'),(585878,'167000286861'),(585879,'190642662825'),(585880,'218067818944'),(585881,'244232048344'),(585882,'26661349759'),(585883,'288364483477'),(585884,'317365797993'),(585885,'344475722432'),(585886,'372846573589'),(585887,'393967096117'),(585888,'413511460248'),(585889,'440621384687'),(585890,'461426675535'),(585891,'482547198063'),(585892,'513439902656'),(585893,'538973668698'),(585894,'559778959546'),(585895,'586573652306'),(585896,'607694174834'),(585897,'628814697362'),(585898,'656870316839'),(585899,'678621302726'),(585900,'710459702358'),(585901,'731895456566'),(585902,'754907369171'),(585903,'783908683687'),(585904,'810072913087'),(585905,'833084825693'),(585906,'858618591734'),(585907,'880054345942'),(585908,'906218575342'),(585909,'929860951306'),(585910,'956655644066'),(585911,'97998278835'),(585912,'997635762404'),(585913,'50'),(585914,'021908601727'),(585916,'044290050973'),(585917,'07266090213'),(585918,'100086058249'),(585919,'124989360931'),(585920,'152414517049'),(585921,'173535039577'),(585922,'195286025464'),(585923,'217667474711'),(585924,'243516472431'),(585925,'268104543434'),(585926,'29080122436'),(585927,'312552210247'),(585928,'33714028125'),(585929,'358576035457'),(585930,'379066094626'),(585931,'408697872501'),(585932,'432025016786'),(585933,'45598262443'),(585934,'483407780548'),(585935,'506419693153'),(585936,'534160080951'),(585937,'560009078672'),(585938,'5811296012'),(585939,'606978598921'),(585940,'628729584808'),(585941,'651426265734'),(585942,'679166653532'),(585943,'700917639419'),(585944,'72676663714'),(585945,'750409013104'),(585946,'775312315786'),(585947,'802422240225'),(585948,'824803689472'),(585949,'851913613911'),(585950,'876501684913'),(585951,'901404987596'),(585952,'922210278444'),(585953,'943330800972'),(585954,'969179798693'),(585955,'990300321221'),(585956,'51'),(585957,'013312233826'),(585959,'038530768188'),(585960,'066901619345'),(585961,'088022141873'),(585962,'109142664401'),(585963,'133100272045'),(585964,'152959867855'),(585965,'176602243819'),(585966,'205288326656'),(585967,'226408849184'),(585968,'252573078584'),(585969,'271486979355'),(585970,'293868428602'),(585971,'313097561053'),(585972,'332957156862'),(585973,'352501520993'),(585974,'378350518714'),(585975,'399471041242'),(585976,'426265734001'),(585977,'449908109965'),(585978,'469767705775'),(585979,'497192861894'),(585980,'518313384422'),(585981,'537857748552'),(585982,'559608734439'),(585983,'583251110404'),(585984,'603741169573'),(585985,'623285533703'),(585986,'649449763103'),(585987,'673092139068'),(585988,'69799544175'),(585989,'722583512753'),(585990,'742127876883'),(585991,'769553033002'),(585992,'795402030722'),(585993,'825349040277'),(585994,'848045721203'),(585995,'867590085333'),(585996,'887134449464'),(585997,'914244373903'),(585998,'938832444905'),(585999,'963735747588'),(586000,'984856270116'),(586001,'52'),(586002,'008813877759'),(586004,'030249631967'),(586005,'049793996097'),(586006,'071860213664'),(586007,'104013844975'),(586008,'128917147658'),(586009,'147831048429'),(586010,'169582034316'),(586011,'191648251883'),(586012,'216236322885'),(586013,'238933003811'),(586014,'260368758019'),(586015,'282750207265'),(586016,'303870729793'),(586017,'325936947359'),(586018,'34548131149'),(586019,'365656138979'),(586020,'390244209982'),(586021,'410419037472'),(586022,'429963401602'),(586023,'45108392413'),(586024,'474095836735'),(586025,'497738212699'),(586026,'517913040189'),(586027,'53714217264'),(586028,'558262695168'),(586029,'581274607773'),(586030,'599558045185'),(586031,'626983201304'),(586032,'654408357422'),(586033,'67552887995'),(586034,'705160657825'),(586035,'724705021956'),(586036,'747716934561'),(586037,'775457322359'),(586038,'802882478478'),(586039,'822426842608'),(586040,'843547365136'),(586041,'869396362857'),(586042,'890516885385'),(586043,'918257273183'),(586044,'938116868993'),(586045,'959237391521'),(586046,'978781755651'),(586047,'999902278179'),(586048,'53'),(586049,'021653264066'),(586051,'055383053775'),(586052,'078079734701'),(586053,'097624098831'),(586054,'123157864873'),(586055,'141441302285'),(586056,'165083678249'),(586057,'191878371009'),(586058,'214890283614'),(586059,'234434647744'),(586060,'260598877145'),(586061,'281088936314'),(586062,'309459787471'),(586063,'329004151601'),(586064,'353592222604'),(586065,'373136586734'),(586066,'392996182544'),(586067,'410333924918'),(586068,'436182922639'),(586069,'459510066924'),(586070,'479054431054'),(586071,'498598795185'),(586072,'526023951303'),(586073,'549351095588'),(586074,'571732544834'),(586075,'590961677285'),(586076,'612397431492'),(586077,'635409344097'),(586078,'661258341818'),(586079,'680802705949'),(586080,'700347070079'),(586081,'723043751005'),(586082,'747316590328'),(586083,'764023869343'),(586084,'791764257141'),(586085,'820765571657'),(586086,'840309935787'),(586087,'864582775111'),(586088,'884127139241'),(586089,'908715210244'),(586090,'928574806054'),(586091,'955999962172'),(586092,'9771204847'),(586093,'54'),(586094,'001393324023'),(586096,'022829078231'),(586097,'042373442361'),(586098,'065385354967'),(586099,'091234352688'),(586100,'110778716818'),(586101,'130323080948'),(586102,'151443603476'),(586103,'174770747761'),(586104,'197782660366'),(586105,'221109804651'),(586106,'240338937102'),(586107,'260828996271'),(586108,'288254152389'),(586109,'309374674917'),(586110,'330810429125'),(586111,'350670024935'),(586112,'374312400899'),(586113,'397009081825'),(586114,'423488542905'),(586115,'450913699023'),(586116,'470458063154'),(586117,'487165342168'),(586118,'507024937978'),(586119,'529091155545'),(586120,'549896446393'),(586121,'579212992589'),(586122,'599387820078'),(586123,'61830172085'),(586124,'638476548339'),(586125,'661173229265'),(586126,'686391763627'),(586127,'706566591116'),(586128,'728317577003'),(586129,'747861941134'),(586130,'765514915187'),(586131,'786950669394'),(586132,'814375825513'),(586133,'830137409489'),(586134,'853464553774'),(586135,'878367856456'),(586136,'900749305702'),(586137,'920293669833'),(586138,'941414192361'),(586139,'964426104966'),(586140,'989959871007'),(586141,'55'),(586142,'014863173689'),(586144,'03440753782'),(586145,'058995608823'),(586146,'08043136303'),(586147,'101236653879'),(586148,'128661809997'),(586149,'153249881'),(586150,'174055171849'),(586151,'195175694377'),(586152,'225122703931'),(586153,'246243226459'),(586154,'264211432192'),(586155,'290060429913'),(586156,'313072342518'),(586157,'33198624329'),(586158,'357520009331'),(586159,'380531921936'),(586160,'40448952958'),(586161,'423718662031'),(586162,'445469647918'),(586163,'466590170446'),(586164,'488341156333'),(586165,'507885520463'),(586166,'535310676582'),(586167,'55643119911'),(586168,'57597556324'),(586169,'597726549127'),(586170,'621368925091'),(586171,'640598057542'),(586172,'658881494955'),(586173,'680947712521'),(586174,'703329161767'),(586175,'722873525898'),(586176,'744309280105'),(586177,'769843046147'),(586178,'795692043868'),(586179,'826584748461'),(586180,'848020502668'),(586181,'869141025196'),(586182,'895305254597'),(586183,'924621800792'),(586184,'945742323321'),(586185,'963710529053'),(586186,'984831051581'),(586187,'56'),(586188,'005951574109'),(586190,'030224413433'),(586191,'051029704281'),(586192,'072150226809'),(586193,'092009822619'),(586194,'112184650109'),(586195,'133935635996'),(586196,'159154170358'),(586197,'180274692886'),(586198,'201395215414'),(586199,'225983286416'),(586200,'246473345585'),(586201,'264756782998'),(586202,'295649487591'),(586203,'315509083401'),(586204,'335053447531'),(586205,'354913043341'),(586206,'380762041062'),(586207,'399991173513'),(586208,'424264012836'),(586209,'445384535364'),(586210,'464298436136'),(586211,'483842800266'),(586212,'502126237678'),(586213,'521670601809'),(586214,'542475892657'),(586215,'562020256788'),(586216,'587869254509'),(586217,'607413618639'),(586218,'62664275109'),(586219,'649654663695'),(586220,'669199027825'),(586221,'688743391956'),(586222,'7127009996'),(586223,'727832120217'),(586224,'75210495954'),(586225,'773225482068'),(586226,'792769846198'),(586227,'815781758804'),(586228,'834065196216'),(586229,'854240023705'),(586230,'872208229438'),(586231,'889861203492'),(586232,'91035126266'),(586233,'930841321829'),(586234,'951646612678'),(586235,'971190976808'),(586236,'997039974529'),(586237,'57'),(586238,'019736655455'),(586240,'041487641342'),(586241,'063553858909'),(586242,'080261137923'),(586243,'097914111977'),(586244,'1221869513'),(586245,'137002840237'),(586246,'158753826125'),(586247,'177982958575'),(586248,'200049176142'),(586249,'217071686836'),(586250,'236616050967'),(586251,'259312731892'),(586252,'27381338915'),(586253,'299977618551'),(586254,'321413372758'),(586255,'341272968568'),(586256,'362078259417'),(586257,'387927257138'),(586258,'407471621268'),(586259,'432059692271'),(586260,'457278226633'),(586261,'479344444199'),(586262,'50519344192'),(586263,'525683501089'),(586264,'545858328579'),(586265,'568870241184'),(586266,'593458312187'),(586267,'612372212958'),(586268,'640743064115'),(586269,'658396038168'),(586270,'679831792376'),(586271,'699376156506'),(586272,'718920520637'),(586273,'738464884767'),(586274,'76305295577'),(586275,'785434405016'),(586276,'804978769146'),(586277,'824523133277'),(586278,'846274119164'),(586279,'867709873371'),(586280,'887254237502'),(586281,'913103235223'),(586282,'935799916148'),(586283,'964170767305'),(586284,'991280691744'),(586285,'58'),(586286,'015868762747'),(586288,'0335217368'),(586289,'053066100931'),(586290,'072610465061'),(586291,'092154829192'),(586292,'118949521951'),(586293,'140700507838'),(586294,'160244871969'),(586295,'17947400442'),(586296,'199964063589'),(586297,'22518259795'),(586298,'24504219376'),(586299,'262064704455'),(586300,'283815690342'),(586301,'305566676229'),(586302,'326687198757'),(586303,'346231562887'),(586304,'372711023967'),(586305,'393516314816'),(586306,'421256702614'),(586307,'443953383539'),(586308,'465389137747'),(586309,'487455355313'),(586310,'508575877841'),(586311,'530011632049'),(586312,'556806324808'),(586313,'570676518707'),(586314,'589590419479'),(586315,'609134783609'),(586316,'62867914774'),(586317,'64822351187'),(586318,'674072509591'),(586319,'693616873721'),(586320,'716313554647'),(586321,'741847320688'),(586322,'763913538255'),(586323,'790077767655'),(586324,'811198290183'),(586325,'830742654314'),(586326,'853754566919'),(586327,'871407540972'),(586328,'895680380296'),(586329,'915224744426'),(586330,'935714803595'),(586331,'957150557802'),(586332,'975118763535'),(586333,'988673725755'),(586334,'59'),(586335,'008218089885'),(586337,'034067087606'),(586338,'052035293339'),(586339,'071579657469'),(586340,'0911240216'),(586341,'111614080769'),(586342,'132734603297'),(586343,'150702809029'),(586344,'165518697967'),(586345,'187900147213'),(586346,'202400804471'),(586347,'221945168602'),(586348,'243380922809'),(586349,'259457738465'),(586350,'279002102595'),(586351,'296970308328'),(586352,'316514672459'),(586353,'337635194987'),(586354,'358440485835'),(586355,'378300081645'),(586356,'397844445775'),(586357,'423062980137'),(586358,'440085490831'),(586359,'458368928244'),(586360,'476021902297'),(586361,'495566266428'),(586362,'519839105751'),(586363,'539383469881'),(586364,'560819224089'),(586365,'580678819899'),(586366,'59990795235'),(586367,'61283245121'),(586368,'637105290533'),(586369,'656649654664'),(586370,'671465543601'),(586371,'695738382925'),(586372,'717489368812'),(586373,'735142342865'),(586374,'754371475316'),(586375,'776752924562'),(586376,'798819142129'),(586377,'818363506259'),(586378,'8438972723'),(586379,'863441636431'),(586380,'87699659865'),(586381,'902845596371'),(586382,'916085326911'),(586383,'934683996003'),(586384,'955174055172'),(586385,'979762126175'),(586386,'60'),(586387,'000882648703'),(586389,'020427012833'),(586390,'039971376963'),(586391,'059515741094'),(586392,'080636263622'),(586393,'098604469355'),(586394,'119724991883'),(586395,'139269356013'),(586396,'160705110221'),(586397,'184977949544'),(586398,'202630923597'),(586399,'224697141164'),(586400,'245502432012'),(586401,'261264015989'),(586402,'278286526683'),(586403,'301928902647'),(586404,'317060023264'),(586405,'334712997317'),(586406,'358985836641'),(586407,'373801725578'),(586408,'395552711465'),(586409,'412890453839'),(586410,'430858659572'),(586411,'450403023702'),(586412,'469947387833'),(586413,'491067910361'),(586414,'509036116094'),(586415,'534885113814'),(586416,'549701002752'),(586417,'573658610396'),(586418,'593518206206'),(586419,'614953960413'),(586420,'63008508103'),(586421,'654042688674'),(586422,'672010894407'),(586423,'688402941742'),(586424,'702903599'),(586425,'724024121528'),(586426,'743568485659'),(586427,'763112849789'),(586428,'781081055522'),(586429,'803777736447'),(586430,'828050575771'),(586431,'847594939901'),(586432,'867454535711'),(586433,'881955192969'),(586434,'901499557099'),(586435,'919467762832'),(586436,'942479675437'),(586437,'968013441479'),(586438,'989133964007'),(586439,'61'),(586440,'007732633099'),(586442,'025700838831'),(586443,'044299507923'),(586444,'057854470143'),(586445,'07929022435'),(586446,'098834588481'),(586447,'121531269406'),(586448,'142021328575'),(586449,'162196156065'),(586450,'182055751875'),(586451,'202545811044'),(586452,'224296796931'),(586453,'2447868561'),(586454,'269690158782'),(586455,'289549754592'),(586456,'31067027712'),(586457,'336834506521'),(586458,'35732456569'),(586459,'378129856538'),(586460,'399565610746'),(586461,'418479511517'),(586462,'438023875647'),(586463,'457568239778'),(586464,'477112603908'),(586465,'498863589795'),(586466,'521245039041'),(586467,'536376159659'),(586468,'556235755468'),(586469,'581139058151'),(586470,'600683422281'),(586471,'62779334672'),(586472,'644815857414'),(586473,'668773465058'),(586474,'697144316215'),(586475,'71353636355'),(586476,'729928410886'),(586477,'749472775016'),(586478,'769017139146'),(586479,'786985344879'),(586480,'808105867407'),(586481,'827650231538'),(586482,'847194595668'),(586483,'866738959799'),(586484,'892587957519'),(586485,'913708480047'),(586486,'933252844178'),(586487,'958786610219'),(586488,'978646206029'),(586489,'999766728557'),(586490,'62'),(586491,'019311092688'),(586493,'039801151857'),(586494,'058715052628'),(586495,'07699849004'),(586496,'100010402645'),(586497,'119554766776'),(586498,'145403764497'),(586499,'164948128627'),(586500,'181340175962'),(586501,'197732223298'),(586502,'216646124069'),(586503,'235244793161'),(586504,'253528230573'),(586505,'274018289742'),(586506,'292616958834'),(586507,'311530859605'),(586508,'331705687095'),(586509,'349358661148'),(586510,'372370573753'),(586511,'391914937884'),(586512,'417448703925'),(586513,'432895056222'),(586514,'450548030275'),(586515,'476397027996'),(586516,'497517550524'),(586517,'517061914654'),(586518,'536606278785'),(586519,'554574484517'),(586520,'574118848648'),(586521,'590510895983'),(586522,'606902943318'),(586523,'626447307449'),(586524,'645991671579'),(586525,'673416827698'),(586526,'692961191828'),(586527,'712505555958'),(586528,'732049920089'),(586529,'75789891781'),(586530,'782171757133'),(586531,'8042379747'),(586532,'821890948753'),(586533,'840174386165'),(586534,'864762457168'),(586535,'885882979696'),(586536,'903851185429'),(586537,'924971707957'),(586538,'94293991369'),(586539,'95617964423'),(586540,'98202864195'),(586541,'63'),(586542,'000942542722'),(586544,'014812736621'),(586545,'034357100751'),(586546,'060206098472'),(586547,'081326621'),(586548,'102447143528'),(586549,'121991507659'),(586550,'146264346982'),(586551,'161080235919'),(586552,'18062460005'),(586553,'20710406113'),(586554,'219713328311'),(586555,'239257692441'),(586556,'260693446649'),(586557,'276770262304'),(586558,'297890784832'),(586559,'314282832167'),(586560,'328153026067'),(586561,'346121231799'),(586562,'364404669212'),(586563,'383949033342'),(586564,'403493397472'),(586565,'419570213128'),(586566,'442266894054'),(586567,'460550331466'),(586568,'478203305519'),(586569,'490497341021'),(586570,'511617863549'),(586571,'531162227679'),(586572,'549130433412'),(586573,'567098639145'),(586574,'580338369685'),(586575,'599882733815'),(586576,'624470804818'),(586577,'644015168948'),(586578,'666711849874'),(586579,'692560847595'),(586580,'710844285007'),(586581,'729758185779'),(586582,'751509171666'),(586583,'780510486182'),(586584,'795326375119'),(586585,'813609812532'),(586586,'839458810253'),(586587,'852698540793'),(586588,'872242904923'),(586589,'898091902644'),(586590,'917321035095'),(586591,'930875997314'),(586592,'949474666406'),(586593,'968703798857'),(586594,'98667200459'),(586595,'64'),(586596,'003694515284'),(586598,'027021659569'),(586599,'048142182097'),(586600,'067686546227'),(586601,'086285215319'),(586602,'101416335936'),(586603,'120960700067'),(586604,'137667979081'),(586605,'157212343212'),(586606,'177071939022'),(586607,'194409681395'),(586608,'213954045526'),(586609,'230030861181'),(586610,'249890456991'),(586611,'272587137917'),(586612,'292131502047'),(586613,'308523549383'),(586614,'328067913513'),(586615,'341307644053'),(586616,'360852008183'),(586617,'380711603993'),(586618,'399940736444'),(586619,'419485100575'),(586620,'439029464705'),(586621,'464878462426'),(586622,'478118192966'),(586623,'496401630378'),(586624,'514054604432'),(586625,'531392346805'),(586626,'546208235743'),(586627,'566383063232'),(586628,'585296964004'),(586629,'609885035006'),(586630,'629114167457'),(586631,'643930056395'),(586632,'661898262128'),(586633,'679866467861'),(586634,'701302222068'),(586635,'720846586199'),(586636,'742282340406'),(586637,'765609484691'),(586638,'784208153783'),(586639,'79902404272'),(586640,'816992248453'),(586641,'838112770981'),(586642,'857657135111'),(586643,'877201499242'),(586644,'896745863372'),(586645,'913137910707'),(586646,'934258433235'),(586647,'957270345841'),(586648,'974923319894'),(586649,'994467684024'),(586650,'65'),(586651,'012435889757'),(586653,'031980253888'),(586654,'4946466809422'),(586655,'347608850821'),(586656,'lock'),(586657,'wait'),(586658,'timeout'),(586659,'exceeded'),(586660,'try'),(586661,'restarting'),(586662,'transaction'),(586663,'071377587437545'),(586664,'file'),(586665,'/home/bee/jsondb/server/json/jsondblistener'),(586666,'php'),(586667,'line'),(586668,'trace'),(586669,'function'),(586670,'execute'),(586671,'class'),(586672,'mysqli_stmt'),(586673,'->'),(586674,'updatevalue'),(586675,'jsondblistener'),(586676,'createvalue'),(586677,'/home/bee/jsondb/server/json/parser'),(586678,'endstring'),(586679,'jsonstreamingparser'),(586680,'parser'),(586681,'consumechar'),(586682,'/home/bee/jsondb/server/json/functions'),(586683,'writetodatabase'),(586684,'writetodatabaseex'),(586685,'writetojob'),(586686,'/home/bee/jsondb/server/json/json'),(586687,'handlepost'),(586695,'/my'),(586696,'638829407566'),(586697,'rolling'),(586698,'back'),(586700,'276945039258'),(586701,'849393290507'),(586702,'endnumber'),(586703,'world'),(586704,'test2'),(586705,'💕'),(586706,'start'),(586707,'one'),(586708,'two'),(586709,'three'),(586710,'boo'),(586711,'hi'),(586712,'finished');
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
   WHERE   Value.valueId IN (
             WITH RECURSIVE parent(valueId) AS
             (
                 SELECT
                     @valueId
                 UNION
                 SELECT
                     children.valueId
                 FROM
                     parent
                 JOIN
                     Value AS
                          children
                 WHERE
                     children.parentValueId =
                        parent.valueId
               )
               SELECT * FROM parent
   )
   AND      Value.valueId != @valueId;
  
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
         Value.valueId IN (
             WITH RECURSIVE parent (valueId) AS
             (
                 SELECT
                     @lockedValueId
                 UNION
                 SELECT
                     children.valueId
                 FROM
                     parent
                 JOIN
                     Value AS
                          children
                 WHERE
                     children.parentValueId =
                        parent.valueId
               )
               SELECT * FROM parent
         );

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
    lockedValueId  BIGINT,
    parentValueId BIGINT,
    stagingValueId BIGINT,
    appendToArray BIGINT
)
BEGIN

    SET  @ownerId = ownerId,
              @lockedValueId = lockedValueId,
              @parentValueId = parentValueId,
              @stagingValueId = stagingValueId,
              @appendToArray = appendToArray,
              @objectIndex = NULL;
   
   IF (@appendToArray = 1) THEN
        SELECT
            MAX(Value.objectIndex) + 1
        INTO
            @objectIndex
        FROM
            Value
        WHERE
            Value.parentValueId = @parentValueId
        AND
            Value.locked = 0
        FOR UPDATE;
        
        IF (@objectIndex IS NULL) THEN
            SET @objectIndex = 0;
        END IF;
        
        UPDATE
            Value
        SET
            Value.objectIndex = @objectIndex
        WHERE
            Value.valueId = @stagingValueId;
   END IF;
   
   IF (@appendToArray = 0) THEN
       DELETE
       FROM      Value
       WHERE   Value.valueId IN (
             WITH RECURSIVE parentChild
              (valueId) AS
             (
                 SELECT
                     parent.valueId
                 FROM
                     Value AS parent,
                     Value AS locked
                 WHERE
                     locked.valueId = @lockedValueId
                 AND
                     parent.ownerId = @ownerId
                 AND (
                         (
                             parent.parentValueId =
                             locked.parentValueId
                         )
                         OR
                         (
                             parent.parentValueId IS NULL
                             AND
                             locked.parentValueId IS NULL
                         )
                 )
                 AND
                     parent.objectIndex =
                         locked.objectIndex
                 AND (
                     (
                         parent.objectKey = 
                         locked.objectKey
                     )
                     OR
                     (
                         parent.objectKey IS NULL
                         AND
                         locked.objectKey IS NULL
                     )
                 )
                 AND
                     parent.locked = 0
                 UNION
                 SELECT
                     children.valueId
                 FROM
                     parentChild
                 JOIN
                     Value AS children
                 WHERE
                     children.ownerId = @ownerId
                 AND
                     children.parentValueId =
                            parentChild.valueId
           )
           SELECT * FROM parentChild
       );

  END IF;
    
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
            @locked = NULL,
            @valueId = NULL;
            
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
        (
            (
               @parentValueId IS NULL
               AND
               v.parentValueId IS NULL
            )
           OR
               v.parentValueId = 
               @parentValueId
        )
       AND
           v.objectKey = @objectKey
       AND
           v.locked = 1;
       

       SELECT
            v.valueId
        INTO
            @valueId
        FROM
            Value AS v
        WHERE
            v.ownerId = @ownerId
         AND
         (
            (
               @parentValueId IS NULL
               AND
               v.parentValueId IS NULL
            )
           OR
               v.parentValueId = 
               @parentValueId
       )
       AND
           v.objectKey = @objectKey
       AND
           v.locked = 0
       FOR UPDATE;
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
        (
            (
               @parentValueId IS NULL
               AND
               v.parentValueId IS NULL
            )
           OR
               v.parentValueId = 
               @parentValueId
       )
       AND
              v.objectIndex = @objectIndex
       AND
              v.locked = 1;

       SELECT
            v.valueId
        INTO
            @valueId
        FROM
            Value AS v
        WHERE
            v.ownerId = @ownerId
        AND
        (
            (
               @parentValueId IS NULL
               AND
               v.parentValueId IS NULL
            )
           OR
               v.parentValueId = 
               @parentValueId
       )
       AND
              v.objectIndex = @objectIndex
       AND
              v.locked = 0
       FOR UPDATE;
   END IF;
   
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
           v.valueId = @valueId;
           
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
   valueId BIGINT
)
BEGIN
   SET @valueId = valueId;
            
   SELECT         Value.*,
                            (
                                  SELECT COUNT(*)
                                  FROM    Value
                                  WHERE  
                                        Value.locked = 0
                                  AND
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
                               AND
                                        Child.locked = 0
                            ) AS childCount
   FROM            Value
   WHERE         Value.locked = 0
   AND               Value.parentValueId = 
                            @parentValueId
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
             @locked = locked,
             @type = type,
             @objectIndex = objectIndex,
             @objectKey =  objectKey,
             @isNull =  isNull,
             @stringValue = stringValue,
             @numericValue = numericValue,
             @boolValue = boolValue;
    
    # get the parents child with object key
    # to get its object index
    IF @objectIndex IS NULL AND
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
        AND (
            (
                @locked = 1
            AND
                Value.locked = 0
            )
            OR
                @locked = 0
        )
        FOR UPDATE;
    END IF;
    
    IF @objectIndex IS NULL THEN
        SELECT
            MAX(Value.objectIndex) + 1
        INTO
            @objectIndex
        FROM
            Value
        WHERE 
            Value.ownerId = @ownerId
        AND 
             Value.parentValueId = @parentValueId
        AND (
            (
                @locked = 1
            AND
                Value.locked = 0
            )
            OR
                @locked = 0
        )
        FOR UPDATE;
    END IF;
    
    IF @objectIndex IS NULL THEN
        SET @objectIndex = 0;
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
   
   /*
   # Index words
   CALL createWords(@valueId, @objectKey);
   CALL createWords(@valueId, @stringValue);
   */
   SELECT
       @valueId AS  valueId,
       @objectIndex AS objectIndex;
       
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
             @isNull =  isNull,
             @stringValue = stringValue,
             @numericValue = numericValue,
             @boolValue = boolValue;
          

   CALL deleteChildValues(@valueId);
   
   UPDATE Value
   SET
           ownerId = @ownerId,
           locked = @locked,
           type = @type,
           isNull = @isNull,
           stringValue = @stringValue,
           numericValue = @numericValue,
           boolValue = @boolValue
   WHERE
        Value.valueId = @valueId;
   

   /*
   # Index words
   CALL createWords(@valueId, @objectKey);
   CALL createWords(@valueId, @stringValue);
   */

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

-- Dump completed on 2025-08-21 13:52:15
