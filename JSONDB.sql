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
) ENGINE=InnoDB AUTO_INCREMENT=1017 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Session`
--

LOCK TABLES `Session` WRITE;
/*!40000 ALTER TABLE `Session` DISABLE KEYS */;
INSERT INTO `Session` VALUES (1016,'d9788a2c5fda38a5fb79a276d541cc20',118,'2025-11-21 01:14:21','49.184.167.77','2025-11-21 03:21:50');
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
INSERT INTO `StagingValue` VALUES (2654894,-1,118,'object',0,NULL,NULL,NULL,NULL,NULL,0),(2654895,2654894,118,'object',0,'meta','meta',NULL,NULL,NULL,0),(2654896,NULL,118,'object',0,'my','view',NULL,NULL,NULL,0),(2654897,NULL,118,'string',0,'my','id',NULL,'rybz-nyjw',NULL,0),(2654898,NULL,118,'string',0,'my','name',NULL,'Accidental Drug Related Deaths 2012-2018',NULL,0),(2654899,NULL,118,'string',0,'my','attribution',NULL,'Office of the Chief Medical Examiner',NULL,0),(2654900,2654896,118,'string',3,'attributionLink','attributionlink',NULL,'http://www.ct.gov/ocme',NULL,0),(2654901,NULL,118,'number',0,'my','averagerating',0,NULL,NULL,0),(2654902,NULL,118,'string',0,'my','category',NULL,'Health and Human Services',NULL,0),(2654903,2654896,118,'number',6,'createdAt','createdat',1444407518,NULL,NULL,0),(2654904,2654896,118,'string',7,'description','description',NULL,'A listing of each accidental death associated with drug overdose in Connecticut from 2012 to 2018. A \"Y\" value under the different substance columns indicates that particular substance was detected.\n\nData are derived from an investigation by the Office of the Chief Medical Examiner which includes the toxicity report, death certificate, as well as a scene investigation.\n\nThe “Morphine (Not Heroin)” values are related to the differences between how Morphine and Heroin are metabolized and therefor detected in the toxicity results. Heroin metabolizes to 6-MAM which then metabolizes to morphine.  6-MAM is unique to heroin, and has a short half-life (as does heroin itself). Thus, in some heroin deaths, the toxicity results will not indicate whether the morphine is from heroin or prescription morphine. In these cases the Medical Examiner may be able to determine the cause based on the scene investigation (such as  finding heroin needles). If they find prescription morphine at the scene it is certified as “Morphine (not heroin).”  Therefor, the Cause of Death may indicate Morphine, but the Heroin or Morphine (Not Heroin) may not be indicated.\n\n “Any Opioid” – If the Medical Examiner cannot conclude whether it’s RX Morphine or heroin based morphine in the toxicity results, that column may be checked',NULL,0),(2654905,NULL,118,'string',0,'my','displaytype',NULL,'table',NULL,0),(2654906,2654906,118,'number',2,'done','downloadcount',106093,NULL,NULL,0),(2654907,2654896,118,'bool',10,'hideFromCatalog','hidefromcatalog',NULL,NULL,0,0),(2654908,2654896,118,'bool',11,'hideFromDataJson','hidefromdatajson',NULL,NULL,0,0),(2654909,2654896,118,'number',12,'indexUpdatedAt','indexupdatedat',1557088571,NULL,NULL,0),(2654910,2654896,118,'string',13,'licenseId','licenseid',NULL,'PUBLIC_DOMAIN',NULL,0),(2654911,2654896,118,'bool',14,'newBackend','newbackend',NULL,NULL,1,0),(2654912,2654896,118,'number',15,'numberOfComments','numberofcomments',0,NULL,NULL,0),(2654913,2654896,118,'number',16,'oid','oid',31432840,NULL,NULL,0),(2654914,2654896,118,'string',17,'provenance','provenance',NULL,'official',NULL,0),(2654915,2654896,118,'bool',18,'publicationAppendEnabled','publicationappendenabled',NULL,NULL,0,0),(2654916,2654896,118,'number',19,'publicationDate','publicationdate',1557088625,NULL,NULL,0),(2654917,2654896,118,'number',20,'publicationGroup','publicationgroup',4729826,NULL,NULL,0),(2654918,2654896,118,'string',21,'publicationStage','publicationstage',NULL,'published',NULL,0),(2654919,2654896,118,'string',22,'resourceName','resourcename',NULL,'deaths',NULL,0),(2654920,2654896,118,'number',23,'rowsUpdatedAt','rowsupdatedat',1553870650,NULL,NULL,0),(2654921,2654896,118,'number',24,'tableId','tableid',16175801,NULL,NULL,0),(2654922,2654896,118,'number',25,'totalTimesRated','totaltimesrated',0,NULL,NULL,0),(2654923,2654896,118,'number',26,'viewCount','viewcount',28575,NULL,NULL,0),(2654924,2654896,118,'number',27,'viewLastModified','viewlastmodified',1593009314,NULL,NULL,0),(2654925,2654896,118,'string',28,'viewType','viewtype',NULL,'tabular',NULL,0),(2654926,2654896,118,'array',29,'approvals','approvals',NULL,NULL,NULL,0),(2654927,2654926,118,'object',0,NULL,NULL,NULL,NULL,NULL,0),(2654928,2654927,118,'number',0,'reviewedAt','reviewedat',1557088625,NULL,NULL,0),(2654929,2654927,118,'bool',1,'reviewedAutomatically','reviewedautomatically',NULL,NULL,1,0),(2654930,2654927,118,'string',2,'state','state',NULL,'approved',NULL,0),(2654931,2654927,118,'number',3,'submissionId','submissionid',819766,NULL,NULL,0),(2654932,2654927,118,'string',4,'submissionObject','submissionobject',NULL,'public_audience_request',NULL,0),(2654933,2654927,118,'string',5,'submissionOutcome','submissionoutcome',NULL,'change_audience',NULL,0),(2654934,2654927,118,'number',6,'submittedAt','submittedat',1557088625,NULL,NULL,0),(2654935,2654927,118,'number',7,'workflowId','workflowid',2184,NULL,NULL,0),(2654936,2654927,118,'object',8,'submissionDetails','submissiondetails',NULL,NULL,NULL,0),(2654937,2654936,118,'string',0,'permissionType','permissiontype',NULL,'READ',NULL,0),(2654938,2654927,118,'object',9,'submissionOutcomeApplication','submissionoutcomeapplication',NULL,NULL,NULL,0),(2654939,2654938,118,'number',0,'failureCount','failurecount',0,NULL,NULL,0),(2654940,2654938,118,'string',1,'status','status',NULL,'success',NULL,0),(2654941,2654927,118,'object',10,'submitter','submitter',NULL,NULL,NULL,0),(2654942,2654941,118,'string',0,'id','id',NULL,'cvy9-n6sb',NULL,0),(2654943,2654941,118,'string',1,'displayName','displayname',NULL,'Tyler Kleykamp',NULL,0),(2654944,2654896,118,'array',30,'columns','columns',NULL,NULL,NULL,0),(2654945,2654944,118,'object',0,NULL,NULL,NULL,NULL,NULL,0),(2654946,2654945,118,'number',0,'id','id',-1,NULL,NULL,0),(2654947,2654945,118,'string',1,'name','name',NULL,'sid',NULL,0),(2654948,2654945,118,'string',2,'dataTypeName','datatypename',NULL,'meta_data',NULL,0),(2654949,2654945,118,'string',3,'fieldName','fieldname',NULL,':sid',NULL,0),(2654950,2654945,118,'number',4,'position','position',0,NULL,NULL,0),(2654951,2654945,118,'string',5,'renderTypeName','rendertypename',NULL,'meta_data',NULL,0),(2654952,2654945,118,'object',6,'format','format',NULL,NULL,NULL,0),(2654953,2654945,118,'array',7,'flags','flags',NULL,NULL,NULL,0),(2654954,2654953,118,'string',0,NULL,NULL,NULL,'hidden',NULL,0),(2654955,2654944,118,'object',1,NULL,NULL,NULL,NULL,NULL,0),(2654956,2654955,118,'number',0,'id','id',-1,NULL,NULL,0),(2654957,2654955,118,'string',1,'name','name',NULL,'id',NULL,0),(2654958,2654955,118,'string',2,'dataTypeName','datatypename',NULL,'meta_data',NULL,0),(2654959,2654955,118,'string',3,'fieldName','fieldname',NULL,':id',NULL,0),(2654960,2654955,118,'number',4,'position','position',0,NULL,NULL,0),(2654961,NULL,118,'string',0,'boo','rendertypename',NULL,'meta_data',NULL,0),(2654962,NULL,118,'object',0,'my','format',NULL,NULL,NULL,0),(2654963,NULL,118,'array',0,'my','flags',NULL,NULL,NULL,0),(2654964,NULL,118,'string',0,'my',NULL,NULL,'hidden',NULL,0),(2654965,NULL,118,'object',0,'my',NULL,NULL,NULL,NULL,0),(2654966,2654965,118,'number',0,'id','id',-1,NULL,NULL,0),(2654967,NULL,118,'string',0,'my','name',NULL,'position',NULL,0),(2654968,2654967,118,'string',0,'my','datatypename',NULL,'meta_data',NULL,0),(2654969,2654965,118,'string',3,'fieldName','fieldname',NULL,':position',NULL,0),(2654970,NULL,118,'number',0,'my','position',0,NULL,NULL,0),(2654971,NULL,118,'string',0,'my','rendertypename',NULL,'meta_data',NULL,0),(2654972,NULL,118,'object',0,'my','format',NULL,NULL,NULL,0),(2654973,2654972,118,'array',0,'boo','flags',NULL,NULL,NULL,0),(2654974,2654973,118,'string',0,NULL,NULL,NULL,'hidden',NULL,0),(2654975,NULL,118,'object',0,'my',NULL,NULL,NULL,NULL,0),(2654976,2654975,118,'number',0,'id','id',-1,NULL,NULL,0),(2654977,2654975,118,'string',0,'boo','name',NULL,'created_at',NULL,0),(2654978,2654975,118,'string',2,'dataTypeName','datatypename',NULL,'meta_data',NULL,0),(2654979,NULL,118,'string',0,'my','fieldname',NULL,':created_at',NULL,0),(2654980,NULL,118,'number',0,'my','position',0,NULL,NULL,0),(2654981,2654980,118,'string',0,'boo','rendertypename',NULL,'meta_data',NULL,0),(2654982,2654975,118,'object',6,'format','format',NULL,NULL,NULL,0),(2654983,2654975,118,'array',7,'flags','flags',NULL,NULL,NULL,0),(2654984,NULL,118,'string',0,'my',NULL,NULL,'hidden',NULL,0),(2654985,NULL,118,'object',0,'my',NULL,NULL,NULL,NULL,0),(2654986,2654985,118,'number',0,'boo','id',-1,NULL,NULL,0),(2654987,2654985,118,'string',1,'boo2','name',NULL,'created_meta',NULL,0),(2654988,2654985,118,'string',2,'dataTypeName','datatypename',NULL,'meta_data',NULL,0),(2654989,2654988,118,'string',0,'boo','fieldname',NULL,':created_meta',NULL,0),(2654990,NULL,118,'number',0,'my','position',0,NULL,NULL,0),(2654991,2654985,118,'string',5,'renderTypeName','rendertypename',NULL,'meta_data',NULL,0),(2654992,2654991,118,'object',0,'boo2','format',NULL,NULL,NULL,0),(2654993,2654985,118,'array',7,'flags','flags',NULL,NULL,NULL,0),(2654994,2654993,118,'string',0,NULL,NULL,NULL,'hidden',NULL,0),(2654995,2654944,118,'object',5,NULL,NULL,NULL,NULL,NULL,0),(2654996,2654995,118,'number',0,'id','id',-1,NULL,NULL,0),(2654997,2654995,118,'string',1,'name','name',NULL,'updated_at',NULL,0),(2654998,2654995,118,'string',2,'dataTypeName','datatypename',NULL,'meta_data',NULL,0),(2654999,2654995,118,'string',3,'fieldName','fieldname',NULL,':updated_at',NULL,0),(2655000,2654995,118,'number',4,'position','position',0,NULL,NULL,0),(2655001,2654995,118,'string',5,'renderTypeName','rendertypename',NULL,'meta_data',NULL,0),(2655002,2654995,118,'object',6,'format','format',NULL,NULL,NULL,0),(2655003,2654995,118,'array',7,'flags','flags',NULL,NULL,NULL,0),(2655004,2655003,118,'string',0,NULL,NULL,NULL,'hidden',NULL,0),(2655005,2654944,118,'object',6,NULL,NULL,NULL,NULL,NULL,0),(2655006,2655005,118,'number',0,'id','id',-1,NULL,NULL,0),(2655007,2655005,118,'string',1,'name','name',NULL,'updated_meta',NULL,0),(2655008,2655005,118,'string',2,'dataTypeName','datatypename',NULL,'meta_data',NULL,0),(2655009,2655005,118,'string',3,'fieldName','fieldname',NULL,':updated_meta',NULL,0),(2655010,2655005,118,'number',4,'position','position',0,NULL,NULL,0),(2655011,2655005,118,'string',5,'renderTypeName','rendertypename',NULL,'meta_data',NULL,0),(2655012,2655005,118,'object',6,'format','format',NULL,NULL,NULL,0),(2655013,2655005,118,'array',7,'flags','flags',NULL,NULL,NULL,0),(2655014,2655013,118,'string',0,NULL,NULL,NULL,'hidden',NULL,0),(2655015,2654944,118,'object',7,NULL,NULL,NULL,NULL,NULL,0),(2655016,2655015,118,'number',0,'id','id',-1,NULL,NULL,0),(2655017,2655015,118,'string',1,'name','name',NULL,'meta',NULL,0),(2655018,2655015,118,'string',2,'dataTypeName','datatypename',NULL,'meta_data',NULL,0),(2655019,2655015,118,'string',3,'fieldName','fieldname',NULL,':meta',NULL,0),(2655020,2655015,118,'number',4,'position','position',0,NULL,NULL,0),(2655021,2655015,118,'string',5,'renderTypeName','rendertypename',NULL,'meta_data',NULL,0),(2655022,2655015,118,'object',6,'format','format',NULL,NULL,NULL,0),(2655023,2655015,118,'array',7,'flags','flags',NULL,NULL,NULL,0),(2655024,2655023,118,'string',0,NULL,NULL,NULL,'hidden',NULL,0),(2655025,2654944,118,'object',8,NULL,NULL,NULL,NULL,NULL,0),(2655026,2655025,118,'number',0,'id','id',407211176,NULL,NULL,0),(2655027,2655025,118,'string',1,'name','name',NULL,'ID',NULL,0),(2655028,2655025,118,'string',2,'dataTypeName','datatypename',NULL,'text',NULL,0),(2655029,2655025,118,'string',3,'description','description',NULL,'',NULL,0),(2655030,2655025,118,'string',4,'fieldName','fieldname',NULL,'id',NULL,0),(2655031,2655025,118,'number',5,'position','position',1,NULL,NULL,0),(2655032,2655025,118,'string',6,'renderTypeName','rendertypename',NULL,'text',NULL,0),(2655033,2655025,118,'number',7,'tableColumnId','tablecolumnid',73628883,NULL,NULL,0),(2655034,2655025,118,'object',8,'cachedContents','cachedcontents',NULL,NULL,NULL,0),(2655035,2655034,118,'string',0,'largest','largest',NULL,'18-1018',NULL,0),(2655036,2655034,118,'number',1,'non_null','non_null',5105,NULL,NULL,0),(2655037,2655034,118,'number',2,'null','null',0,NULL,NULL,0),(2655038,2655034,118,'array',3,'top','top',NULL,NULL,NULL,0),(2655039,2655038,118,'object',0,NULL,NULL,NULL,NULL,NULL,0),(2655040,2655039,118,'string',0,'item','item',NULL,'12-0002',NULL,0),(2655041,2655039,118,'number',1,'count','count',1,NULL,NULL,0),(2655042,2655038,118,'object',1,NULL,NULL,NULL,NULL,NULL,0),(2655043,2655042,118,'string',0,'item','item',NULL,'12-0003',NULL,0),(2655044,2655042,118,'number',1,'count','count',1,NULL,NULL,0),(2655045,2655038,118,'object',2,NULL,NULL,NULL,NULL,NULL,0),(2655046,2655045,118,'string',0,'item','item',NULL,'12-0004',NULL,0),(2655047,2655045,118,'number',1,'count','count',1,NULL,NULL,0),(2655048,2655038,118,'object',3,NULL,NULL,NULL,NULL,NULL,0),(2655049,2655048,118,'string',0,'item','item',NULL,'12-0005',NULL,0),(2655050,2655048,118,'number',1,'count','count',1,NULL,NULL,0),(2655051,2655038,118,'object',4,NULL,NULL,NULL,NULL,NULL,0),(2655052,2655051,118,'string',0,'item','item',NULL,'12-0006',NULL,0),(2655053,2655051,118,'number',1,'count','count',1,NULL,NULL,0),(2655054,2655038,118,'object',5,NULL,NULL,NULL,NULL,NULL,0),(2655055,2655054,118,'string',0,'item','item',NULL,'12-0007',NULL,0),(2655056,2655054,118,'number',1,'count','count',1,NULL,NULL,0),(2655057,2655038,118,'object',6,NULL,NULL,NULL,NULL,NULL,0),(2655058,2655057,118,'string',0,'item','item',NULL,'12-0008',NULL,0),(2655059,2655057,118,'number',1,'count','count',1,NULL,NULL,0),(2655060,2655038,118,'object',7,NULL,NULL,NULL,NULL,NULL,0),(2655061,2655060,118,'string',0,'item','item',NULL,'12-0009',NULL,0),(2655062,2655060,118,'number',1,'count','count',1,NULL,NULL,0),(2655063,2655038,118,'object',8,NULL,NULL,NULL,NULL,NULL,0),(2655064,2655063,118,'string',0,'item','item',NULL,'12-0010',NULL,0),(2655065,2655063,118,'number',1,'count','count',1,NULL,NULL,0),(2655066,2655038,118,'object',9,NULL,NULL,NULL,NULL,NULL,0),(2655067,2655066,118,'string',0,'item','item',NULL,'12-0011',NULL,0),(2655068,2655066,118,'number',1,'count','count',1,NULL,NULL,0),(2655069,2655038,118,'object',10,NULL,NULL,NULL,NULL,NULL,0),(2655070,2655069,118,'string',0,'item','item',NULL,'12-0012',NULL,0),(2655071,2655069,118,'number',1,'count','count',1,NULL,NULL,0),(2655072,2655038,118,'object',11,NULL,NULL,NULL,NULL,NULL,0),(2655073,2655072,118,'string',0,'item','item',NULL,'12-0013',NULL,0),(2655074,2655072,118,'number',1,'count','count',1,NULL,NULL,0),(2655075,2655038,118,'object',12,NULL,NULL,NULL,NULL,NULL,0),(2655076,2655075,118,'string',0,'item','item',NULL,'12-0014',NULL,0),(2655077,2655075,118,'number',1,'count','count',1,NULL,NULL,0),(2655078,2655038,118,'object',13,NULL,NULL,NULL,NULL,NULL,0),(2655079,2655078,118,'string',0,'item','item',NULL,'12-0015',NULL,0),(2655080,2655078,118,'number',1,'count','count',1,NULL,NULL,0),(2655081,2655038,118,'object',14,NULL,NULL,NULL,NULL,NULL,0),(2655082,2655081,118,'string',0,'item','item',NULL,'12-0016',NULL,0),(2655083,2655081,118,'number',1,'count','count',1,NULL,NULL,0),(2655084,2655038,118,'object',15,NULL,NULL,NULL,NULL,NULL,0),(2655085,2655084,118,'string',0,'item','item',NULL,'12-0017',NULL,0),(2655086,2655084,118,'number',1,'count','count',1,NULL,NULL,0),(2655087,2655038,118,'object',16,NULL,NULL,NULL,NULL,NULL,0),(2655088,2655087,118,'string',0,'item','item',NULL,'12-0018',NULL,0),(2655089,2655087,118,'number',1,'count','count',1,NULL,NULL,0),(2655090,2655038,118,'object',17,NULL,NULL,NULL,NULL,NULL,0),(2655091,2655090,118,'string',0,'item','item',NULL,'12-0019',NULL,0),(2655092,2655090,118,'number',1,'count','count',1,NULL,NULL,0),(2655093,2655038,118,'object',18,NULL,NULL,NULL,NULL,NULL,0),(2655094,2655093,118,'string',0,'item','item',NULL,'12-0020',NULL,0),(2655095,2655093,118,'number',1,'count','count',1,NULL,NULL,0),(2655096,2655038,118,'object',19,NULL,NULL,NULL,NULL,NULL,0),(2655097,2655096,118,'string',0,'item','item',NULL,'12-0021',NULL,0),(2655098,2655096,118,'number',1,'count','count',1,NULL,NULL,0),(2655099,2655034,118,'string',4,'smallest','smallest',NULL,'12-0001',NULL,0),(2655100,2655034,118,'number',5,'cardinality','cardinality',5105,NULL,NULL,0),(2655101,2655025,118,'object',9,'format','format',NULL,NULL,NULL,0),(2655102,2654944,118,'object',9,NULL,NULL,NULL,NULL,NULL,0),(2655103,2655102,118,'number',0,'id','id',407211177,NULL,NULL,0),(2655104,2655102,118,'string',1,'name','name',NULL,'Date',NULL,0),(2655105,2655102,118,'string',2,'dataTypeName','datatypename',NULL,'calendar_date',NULL,0),(2655106,2655102,118,'string',3,'description','description',NULL,'',NULL,0),(2655107,2655102,118,'string',4,'fieldName','fieldname',NULL,'date',NULL,0),(2655108,2655102,118,'number',5,'position','position',2,NULL,NULL,0),(2655109,2655102,118,'string',6,'renderTypeName','rendertypename',NULL,'calendar_date',NULL,0),(2655110,2655102,118,'number',7,'tableColumnId','tablecolumnid',31952055,NULL,NULL,0),(2655111,2655102,118,'number',8,'width','width',100,NULL,NULL,0),(2655112,2655102,118,'object',9,'cachedContents','cachedcontents',NULL,NULL,NULL,0),(2655113,2655112,118,'string',0,'largest','largest',NULL,'2018-12-31T00:00:00.000',NULL,0),(2655114,2655112,118,'number',1,'non_null','non_null',5103,NULL,NULL,0),(2655115,2655112,118,'number',2,'null','null',2,NULL,NULL,0),(2655116,2655112,118,'array',3,'top','top',NULL,NULL,NULL,0),(2655117,2655116,118,'object',0,NULL,NULL,NULL,NULL,NULL,0),(2655118,2655117,118,'string',0,'item','item',NULL,'2017-08-18T00:00:00.000',NULL,0),(2655119,2655117,118,'number',1,'count','count',9,NULL,NULL,0),(2655120,2655116,118,'object',1,NULL,NULL,NULL,NULL,NULL,0),(2655121,2655120,118,'string',0,'item','item',NULL,'2017-06-18T00:00:00.000',NULL,0),(2655122,2655120,118,'number',1,'count','count',9,NULL,NULL,0),(2655123,2655116,118,'object',2,NULL,NULL,NULL,NULL,NULL,0),(2655124,2655123,118,'string',0,'item','item',NULL,'2017-06-02T00:00:00.000',NULL,0),(2655125,2655123,118,'number',1,'count','count',8,NULL,NULL,0),(2655126,2655116,118,'object',3,NULL,NULL,NULL,NULL,NULL,0),(2655127,2655126,118,'string',0,'item','item',NULL,'2017-05-29T00:00:00.000',NULL,0),(2655128,2655126,118,'number',1,'count','count',8,NULL,NULL,0),(2655129,2655116,118,'object',4,NULL,NULL,NULL,NULL,NULL,0),(2655130,2655129,118,'string',0,'item','item',NULL,'2018-12-17T00:00:00.000',NULL,0),(2655131,2655129,118,'number',1,'count','count',8,NULL,NULL,0),(2655132,2655116,118,'object',5,NULL,NULL,NULL,NULL,NULL,0),(2655133,2655132,118,'string',0,'item','item',NULL,'2016-11-13T00:00:00.000',NULL,0),(2655134,2655132,118,'number',1,'count','count',8,NULL,NULL,0),(2655135,2655116,118,'object',6,NULL,NULL,NULL,NULL,NULL,0),(2655136,2655135,118,'string',0,'item','item',NULL,'2017-03-05T00:00:00.000',NULL,0),(2655137,2655135,118,'number',1,'count','count',8,NULL,NULL,0),(2655138,2655116,118,'object',7,NULL,NULL,NULL,NULL,NULL,0),(2655139,2655138,118,'string',0,'item','item',NULL,'2013-09-21T00:00:00.000',NULL,0),(2655140,2655138,118,'number',1,'count','count',8,NULL,NULL,0),(2655141,2655116,118,'object',8,NULL,NULL,NULL,NULL,NULL,0),(2655142,2655141,118,'string',0,'item','item',NULL,'2016-10-03T00:00:00.000',NULL,0),(2655143,2655141,118,'number',1,'count','count',7,NULL,NULL,0),(2655144,2655116,118,'object',9,NULL,NULL,NULL,NULL,NULL,0),(2655145,2655144,118,'string',0,'item','item',NULL,'2018-08-05T00:00:00.000',NULL,0),(2655146,2655144,118,'number',1,'count','count',7,NULL,NULL,0),(2655147,2655116,118,'object',10,NULL,NULL,NULL,NULL,NULL,0),(2655148,2655147,118,'string',0,'item','item',NULL,'2018-05-13T00:00:00.000',NULL,0),(2655149,2655147,118,'number',1,'count','count',7,NULL,NULL,0),(2655150,2655116,118,'object',11,NULL,NULL,NULL,NULL,NULL,0),(2655151,2655150,118,'string',0,'item','item',NULL,'2018-05-12T00:00:00.000',NULL,0),(2655152,2655150,118,'number',1,'count','count',7,NULL,NULL,0),(2655153,2655116,118,'object',12,NULL,NULL,NULL,NULL,NULL,0),(2655154,2655153,118,'string',0,'item','item',NULL,'2017-02-11T00:00:00.000',NULL,0),(2655155,2655153,118,'number',1,'count','count',7,NULL,NULL,0),(2655156,2655116,118,'object',13,NULL,NULL,NULL,NULL,NULL,0),(2655157,2655156,118,'string',0,'item','item',NULL,'2018-07-03T00:00:00.000',NULL,0),(2655158,2655156,118,'number',1,'count','count',7,NULL,NULL,0),(2655159,2655116,118,'object',14,NULL,NULL,NULL,NULL,NULL,0),(2655160,2655159,118,'string',0,'item','item',NULL,'2016-02-26T00:00:00.000',NULL,0),(2655161,2655159,118,'number',1,'count','count',7,NULL,NULL,0),(2655162,2655116,118,'object',15,NULL,NULL,NULL,NULL,NULL,0),(2655163,2655162,118,'string',0,'item','item',NULL,'2018-06-02T00:00:00.000',NULL,0),(2655164,2655162,118,'number',1,'count','count',7,NULL,NULL,0),(2655165,2655116,118,'object',16,NULL,NULL,NULL,NULL,NULL,0),(2655166,2655165,118,'string',0,'item','item',NULL,'2017-12-27T00:00:00.000',NULL,0),(2655167,2655165,118,'number',1,'count','count',7,NULL,NULL,0),(2655168,2655116,118,'object',17,NULL,NULL,NULL,NULL,NULL,0),(2655169,2655168,118,'string',0,'item','item',NULL,'2017-05-05T00:00:00.000',NULL,0),(2655170,2655168,118,'number',1,'count','count',7,NULL,NULL,0),(2655171,2655116,118,'object',18,NULL,NULL,NULL,NULL,NULL,0),(2655172,2655171,118,'string',0,'item','item',NULL,'2018-06-28T00:00:00.000',NULL,0),(2655173,2655171,118,'number',1,'count','count',7,NULL,NULL,0),(2655174,2655116,118,'object',19,NULL,NULL,NULL,NULL,NULL,0),(2655175,2655174,118,'string',0,'item','item',NULL,'2016-11-18T00:00:00.000',NULL,0),(2655176,2655174,118,'number',1,'count','count',7,NULL,NULL,0),(2655177,2655112,118,'string',4,'smallest','smallest',NULL,'2012-01-01T00:00:00.000',NULL,0),(2655178,2655112,118,'number',5,'cardinality','cardinality',2098,NULL,NULL,0),(2655179,2655102,118,'object',10,'format','format',NULL,NULL,NULL,0),(2655180,2654944,118,'object',10,NULL,NULL,NULL,NULL,NULL,0),(2655181,2655180,118,'number',0,'id','id',407211178,NULL,NULL,0),(2655182,2655180,118,'string',1,'name','name',NULL,'DateType',NULL,0),(2655183,2655180,118,'string',2,'dataTypeName','datatypename',NULL,'text',NULL,0),(2655184,2655180,118,'string',3,'description','description',NULL,'',NULL,0),(2655185,2655180,118,'string',4,'fieldName','fieldname',NULL,'datetype',NULL,0),(2655186,2655180,118,'number',5,'position','position',3,NULL,NULL,0),(2655187,2655180,118,'string',6,'renderTypeName','rendertypename',NULL,'text',NULL,0),(2655188,2655180,118,'number',7,'tableColumnId','tablecolumnid',73628884,NULL,NULL,0),(2655189,2655180,118,'object',8,'cachedContents','cachedcontents',NULL,NULL,NULL,0),(2655190,2655189,118,'string',0,'largest','largest',NULL,'DateReported',NULL,0),(2655191,2655189,118,'number',1,'non_null','non_null',5103,NULL,NULL,0),(2655192,2655189,118,'number',2,'null','null',2,NULL,NULL,0),(2655193,2655189,118,'array',3,'top','top',NULL,NULL,NULL,0),(2655194,2655193,118,'object',0,NULL,NULL,NULL,NULL,NULL,0),(2655195,2655194,118,'string',0,'item','item',NULL,'DateofDeath',NULL,0),(2655196,2655194,118,'number',1,'count','count',2822,NULL,NULL,0),(2655197,2655193,118,'object',1,NULL,NULL,NULL,NULL,NULL,0),(2655198,2655197,118,'string',0,'item','item',NULL,'DateReported',NULL,0),(2655199,2655197,118,'number',1,'count','count',2281,NULL,NULL,0),(2655200,2655189,118,'string',4,'smallest','smallest',NULL,'DateofDeath',NULL,0),(2655201,2655189,118,'number',5,'cardinality','cardinality',2,NULL,NULL,0),(2655202,2655180,118,'object',9,'format','format',NULL,NULL,NULL,0),(2655203,2654944,118,'object',11,NULL,NULL,NULL,NULL,NULL,0),(2655204,2655203,118,'number',0,'id','id',407211179,NULL,NULL,0),(2655205,2655203,118,'string',1,'name','name',NULL,'Age',NULL,0),(2655206,2655203,118,'string',2,'dataTypeName','datatypename',NULL,'number',NULL,0),(2655207,2655203,118,'string',3,'description','description',NULL,'',NULL,0),(2655208,2655203,118,'string',4,'fieldName','fieldname',NULL,'age',NULL,0),(2655209,2655203,118,'number',5,'position','position',4,NULL,NULL,0),(2655210,2655203,118,'string',6,'renderTypeName','rendertypename',NULL,'number',NULL,0),(2655211,2655203,118,'number',7,'tableColumnId','tablecolumnid',31936576,NULL,NULL,0),(2655212,2655203,118,'number',8,'width','width',136,NULL,NULL,0),(2655213,2655203,118,'object',9,'cachedContents','cachedcontents',NULL,NULL,NULL,0),(2655214,2655213,118,'number',0,'largest','largest',87,NULL,NULL,0),(2655215,2655213,118,'number',1,'non_null','non_null',5102,NULL,NULL,0),(2655216,2655213,118,'number',2,'null','null',3,NULL,NULL,0),(2655217,2655213,118,'array',3,'top','top',NULL,NULL,NULL,0),(2655218,2655217,118,'object',0,NULL,NULL,NULL,NULL,NULL,0),(2655219,2655218,118,'number',0,'item','item',29,NULL,NULL,0),(2655220,2655218,118,'number',1,'count','count',152,NULL,NULL,0),(2655221,2655217,118,'object',1,NULL,NULL,NULL,NULL,NULL,0),(2655222,2655221,118,'number',0,'item','item',44,NULL,NULL,0),(2655223,2655221,118,'number',1,'count','count',147,NULL,NULL,0),(2655224,2655217,118,'object',2,NULL,NULL,NULL,NULL,NULL,0),(2655225,2655224,118,'number',0,'item','item',33,NULL,NULL,0),(2655226,2655224,118,'number',1,'count','count',147,NULL,NULL,0),(2655227,2655217,118,'object',3,NULL,NULL,NULL,NULL,NULL,0),(2655228,2655227,118,'number',0,'item','item',50,NULL,NULL,0),(2655229,2655227,118,'number',1,'count','count',145,NULL,NULL,0),(2655230,2655217,118,'object',4,NULL,NULL,NULL,NULL,NULL,0),(2655231,2655230,118,'number',0,'item','item',54,NULL,NULL,0),(2655232,2655230,118,'number',1,'count','count',144,NULL,NULL,0),(2655233,2655217,118,'object',5,NULL,NULL,NULL,NULL,NULL,0),(2655234,2655233,118,'number',0,'item','item',51,NULL,NULL,0),(2655235,2655233,118,'number',1,'count','count',143,NULL,NULL,0),(2655236,2655217,118,'object',6,NULL,NULL,NULL,NULL,NULL,0),(2655237,2655236,118,'number',0,'item','item',49,NULL,NULL,0),(2655238,2655236,118,'number',1,'count','count',141,NULL,NULL,0),(2655239,2655217,118,'object',7,NULL,NULL,NULL,NULL,NULL,0),(2655240,2655239,118,'number',0,'item','item',48,NULL,NULL,0),(2655241,2655239,118,'number',1,'count','count',137,NULL,NULL,0),(2655242,2655217,118,'object',8,NULL,NULL,NULL,NULL,NULL,0),(2655243,2655242,118,'number',0,'item','item',34,NULL,NULL,0),(2655244,2655242,118,'number',1,'count','count',136,NULL,NULL,0),(2655245,2655217,118,'object',9,NULL,NULL,NULL,NULL,NULL,0),(2655246,2655245,118,'number',0,'item','item',35,NULL,NULL,0),(2655247,2655245,118,'number',1,'count','count',134,NULL,NULL,0),(2655248,2655217,118,'object',10,NULL,NULL,NULL,NULL,NULL,0),(2655249,2655248,118,'number',0,'item','item',36,NULL,NULL,0),(2655250,2655248,118,'number',1,'count','count',133,NULL,NULL,0),(2655251,2655217,118,'object',11,NULL,NULL,NULL,NULL,NULL,0),(2655252,2655251,118,'number',0,'item','item',28,NULL,NULL,0),(2655253,2655251,118,'number',1,'count','count',130,NULL,NULL,0),(2655254,2655217,118,'object',12,NULL,NULL,NULL,NULL,NULL,0),(2655255,2655254,118,'number',0,'item','item',30,NULL,NULL,0),(2655256,2655254,118,'number',1,'count','count',130,NULL,NULL,0),(2655257,2655217,118,'object',13,NULL,NULL,NULL,NULL,NULL,0),(2655258,2655257,118,'number',0,'item','item',52,NULL,NULL,0),(2655259,2655257,118,'number',1,'count','count',130,NULL,NULL,0),(2655260,2655217,118,'object',14,NULL,NULL,NULL,NULL,NULL,0),(2655261,2655260,118,'number',0,'item','item',47,NULL,NULL,0),(2655262,2655260,118,'number',1,'count','count',127,NULL,NULL,0),(2655263,2655217,118,'object',15,NULL,NULL,NULL,NULL,NULL,0),(2655264,2655263,118,'number',0,'item','item',37,NULL,NULL,0),(2655265,2655263,118,'number',1,'count','count',123,NULL,NULL,0),(2655266,2655217,118,'object',16,NULL,NULL,NULL,NULL,NULL,0),(2655267,2655266,118,'number',0,'item','item',41,NULL,NULL,0),(2655268,2655266,118,'number',1,'count','count',122,NULL,NULL,0),(2655269,2655217,118,'object',17,NULL,NULL,NULL,NULL,NULL,0),(2655270,2655269,118,'number',0,'item','item',45,NULL,NULL,0),(2655271,2655269,118,'number',1,'count','count',122,NULL,NULL,0),(2655272,2655217,118,'object',18,NULL,NULL,NULL,NULL,NULL,0),(2655273,2655272,118,'number',0,'item','item',26,NULL,NULL,0),(2655274,2655272,118,'number',1,'count','count',119,NULL,NULL,0),(2655275,2655217,118,'object',19,NULL,NULL,NULL,NULL,NULL,0),(2655276,2655275,118,'number',0,'item','item',55,NULL,NULL,0),(2655277,2655275,118,'number',1,'count','count',119,NULL,NULL,0),(2655278,2655213,118,'number',4,'smallest','smallest',14,NULL,NULL,0),(2655279,2655213,118,'number',5,'cardinality','cardinality',65,NULL,NULL,0),(2655280,2655203,118,'object',10,'format','format',NULL,NULL,NULL,0),(2655281,2654944,118,'object',12,NULL,NULL,NULL,NULL,NULL,0),(2655282,2655281,118,'number',0,'id','id',407211180,NULL,NULL,0),(2655283,2655281,118,'string',1,'name','name',NULL,'Sex',NULL,0),(2655284,2655281,118,'string',2,'dataTypeName','datatypename',NULL,'text',NULL,0),(2655285,2655281,118,'string',3,'description','description',NULL,'',NULL,0),(2655286,2655281,118,'string',4,'fieldName','fieldname',NULL,'sex',NULL,0),(2655287,2655281,118,'number',5,'position','position',5,NULL,NULL,0),(2655288,2655281,118,'string',6,'renderTypeName','rendertypename',NULL,'text',NULL,0),(2655289,2655281,118,'number',7,'tableColumnId','tablecolumnid',31936574,NULL,NULL,0),(2655290,2655281,118,'number',8,'width','width',136,NULL,NULL,0),(2655291,2655281,118,'object',9,'cachedContents','cachedcontents',NULL,NULL,NULL,0),(2655292,2655291,118,'string',0,'largest','largest',NULL,'Unknown',NULL,0),(2655293,2655291,118,'number',1,'non_null','non_null',5099,NULL,NULL,0),(2655294,2655291,118,'number',2,'null','null',6,NULL,NULL,0),(2655295,2655291,118,'array',3,'top','top',NULL,NULL,NULL,0),(2655296,2655295,118,'object',0,NULL,NULL,NULL,NULL,NULL,0),(2655297,2655296,118,'string',0,'item','item',NULL,'Male',NULL,0),(2655298,2655296,118,'number',1,'count','count',3773,NULL,NULL,0),(2655299,2655295,118,'object',1,NULL,NULL,NULL,NULL,NULL,0),(2655300,2655299,118,'string',0,'item','item',NULL,'Female',NULL,0),(2655301,2655299,118,'number',1,'count','count',1325,NULL,NULL,0),(2655302,2655295,118,'object',2,NULL,NULL,NULL,NULL,NULL,0),(2655303,2655302,118,'string',0,'item','item',NULL,'Unknown',NULL,0),(2655304,2655302,118,'number',1,'count','count',1,NULL,NULL,0),(2655305,2655291,118,'string',4,'smallest','smallest',NULL,'Female',NULL,0),(2655306,2655291,118,'number',5,'cardinality','cardinality',3,NULL,NULL,0),(2655307,2655281,118,'object',10,'format','format',NULL,NULL,NULL,0),(2655308,2654944,118,'object',13,NULL,NULL,NULL,NULL,NULL,0),(2655309,2655308,118,'number',0,'id','id',407211181,NULL,NULL,0),(2655310,2655308,118,'string',1,'name','name',NULL,'Race',NULL,0),(2655311,2655308,118,'string',2,'dataTypeName','datatypename',NULL,'text',NULL,0),(2655312,2655308,118,'string',3,'description','description',NULL,'',NULL,0),(2655313,2655308,118,'string',4,'fieldName','fieldname',NULL,'race',NULL,0),(2655314,2655308,118,'number',5,'position','position',6,NULL,NULL,0),(2655315,2655308,118,'string',6,'renderTypeName','rendertypename',NULL,'text',NULL,0),(2655316,2655308,118,'number',7,'tableColumnId','tablecolumnid',31936575,NULL,NULL,0),(2655317,2655308,118,'number',8,'width','width',148,NULL,NULL,0),(2655318,2655308,118,'object',9,'cachedContents','cachedcontents',NULL,NULL,NULL,0),(2655319,2655318,118,'string',0,'largest','largest',NULL,'White',NULL,0),(2655320,2655318,118,'number',1,'non_null','non_null',5092,NULL,NULL,0),(2655321,2655318,118,'number',2,'null','null',13,NULL,NULL,0),(2655322,2655318,118,'array',3,'top','top',NULL,NULL,NULL,0),(2655323,2655322,118,'object',0,NULL,NULL,NULL,NULL,NULL,0),(2655324,2655323,118,'string',0,'item','item',NULL,'White',NULL,0),(2655325,2655323,118,'number',1,'count','count',4004,NULL,NULL,0),(2655326,2655322,118,'object',1,NULL,NULL,NULL,NULL,NULL,0),(2655327,2655326,118,'string',0,'item','item',NULL,'Hispanic, White',NULL,0),(2655328,2655326,118,'number',1,'count','count',561,NULL,NULL,0),(2655329,2655322,118,'object',2,NULL,NULL,NULL,NULL,NULL,0),(2655330,2655329,118,'string',0,'item','item',NULL,'Black',NULL,0),(2655331,2655329,118,'number',1,'count','count',433,NULL,NULL,0),(2655332,2655322,118,'object',3,NULL,NULL,NULL,NULL,NULL,0),(2655333,2655332,118,'string',0,'item','item',NULL,'Hispanic, Black',NULL,0),(2655334,2655332,118,'number',1,'count','count',24,NULL,NULL,0),(2655335,2655322,118,'object',4,NULL,NULL,NULL,NULL,NULL,0),(2655336,2655335,118,'string',0,'item','item',NULL,'Unknown',NULL,0),(2655337,2655335,118,'number',1,'count','count',23,NULL,NULL,0),(2655338,2655322,118,'object',5,NULL,NULL,NULL,NULL,NULL,0),(2655339,2655338,118,'string',0,'item','item',NULL,'Asian, Other',NULL,0),(2655340,2655338,118,'number',1,'count','count',18,NULL,NULL,0),(2655341,2655322,118,'object',6,NULL,NULL,NULL,NULL,NULL,0),(2655342,2655341,118,'string',0,'item','item',NULL,'Asian Indian',NULL,0),(2655343,2655341,118,'number',1,'count','count',14,NULL,NULL,0),(2655344,2655322,118,'object',7,NULL,NULL,NULL,NULL,NULL,0),(2655345,2655344,118,'string',0,'item','item',NULL,'Other',NULL,0),(2655346,2655344,118,'number',1,'count','count',11,NULL,NULL,0),(2655347,2655322,118,'object',8,NULL,NULL,NULL,NULL,NULL,0),(2655348,2655347,118,'string',0,'item','item',NULL,'Chinese',NULL,0),(2655349,2655347,118,'number',1,'count','count',2,NULL,NULL,0),(2655350,2655322,118,'object',9,NULL,NULL,NULL,NULL,NULL,0),(2655351,2655350,118,'string',0,'item','item',NULL,'Hawaiian',NULL,0),(2655352,2655350,118,'number',1,'count','count',1,NULL,NULL,0),(2655353,2655322,118,'object',10,NULL,NULL,NULL,NULL,NULL,0),(2655354,2655353,118,'string',0,'item','item',NULL,'Native American, Other',NULL,0),(2655355,2655353,118,'number',1,'count','count',1,NULL,NULL,0),(2655356,2655318,118,'string',4,'smallest','smallest',NULL,'Asian Indian',NULL,0),(2655357,2655318,118,'number',5,'cardinality','cardinality',11,NULL,NULL,0),(2655358,2655308,118,'object',10,'format','format',NULL,NULL,NULL,0),(2655359,2654944,118,'object',14,NULL,NULL,NULL,NULL,NULL,0),(2655360,2655359,118,'number',0,'id','id',407211182,NULL,NULL,0),(2655361,2655359,118,'string',1,'name','name',NULL,'ResidenceCity',NULL,0),(2655362,2655359,118,'string',2,'dataTypeName','datatypename',NULL,'text',NULL,0),(2655363,2655359,118,'string',3,'description','description',NULL,'',NULL,0),(2655364,2655359,118,'string',4,'fieldName','fieldname',NULL,'residencecity',NULL,0),(2655365,2655359,118,'number',5,'position','position',7,NULL,NULL,0),(2655366,2655359,118,'string',6,'renderTypeName','rendertypename',NULL,'text',NULL,0),(2655367,2655359,118,'number',7,'tableColumnId','tablecolumnid',73628891,NULL,NULL,0),(2655368,2655359,118,'object',8,'cachedContents','cachedcontents',NULL,NULL,NULL,0),(2655369,2655368,118,'string',0,'largest','largest',NULL,'ZIONSVILLE',NULL,0),(2655370,2655368,118,'number',1,'non_null','non_null',4932,NULL,NULL,0),(2655371,2655368,118,'number',2,'null','null',173,NULL,NULL,0),(2655372,2655368,118,'array',3,'top','top',NULL,NULL,NULL,0),(2655373,2655372,118,'object',0,NULL,NULL,NULL,NULL,NULL,0),(2655374,2655373,118,'string',0,'item','item',NULL,'HARTFORD',NULL,0),(2655375,2655373,118,'number',1,'count','count',296,NULL,NULL,0),(2655376,2655372,118,'object',1,NULL,NULL,NULL,NULL,NULL,0),(2655377,2655376,118,'string',0,'item','item',NULL,'WATERBURY',NULL,0),(2655378,2655376,118,'number',1,'count','count',269,NULL,NULL,0),(2655379,2655372,118,'object',2,NULL,NULL,NULL,NULL,NULL,0),(2655380,2655379,118,'string',0,'item','item',NULL,'BRIDGEPORT',NULL,0),(2655381,2655379,118,'number',1,'count','count',241,NULL,NULL,0),(2655382,2655372,118,'object',3,NULL,NULL,NULL,NULL,NULL,0),(2655383,2655382,118,'string',0,'item','item',NULL,'NEW HAVEN',NULL,0),(2655384,2655382,118,'number',1,'count','count',224,NULL,NULL,0),(2655385,2655372,118,'object',4,NULL,NULL,NULL,NULL,NULL,0),(2655386,2655385,118,'string',0,'item','item',NULL,'NEW BRITAIN',NULL,0),(2655387,2655385,118,'number',1,'count','count',192,NULL,NULL,0),(2655388,2655372,118,'object',5,NULL,NULL,NULL,NULL,NULL,0),(2655389,2655388,118,'string',0,'item','item',NULL,'BRISTOL',NULL,0),(2655390,2655388,118,'number',1,'count','count',134,NULL,NULL,0),(2655391,2655372,118,'object',6,NULL,NULL,NULL,NULL,NULL,0),(2655392,2655391,118,'string',0,'item','item',NULL,'MERIDEN',NULL,0),(2655393,2655391,118,'number',1,'count','count',127,NULL,NULL,0),(2655394,2655372,118,'object',7,NULL,NULL,NULL,NULL,NULL,0),(2655395,2655394,118,'string',0,'item','item',NULL,'NORWICH',NULL,0),(2655396,2655394,118,'number',1,'count','count',109,NULL,NULL,0),(2655397,2655372,118,'object',8,NULL,NULL,NULL,NULL,NULL,0),(2655398,2655397,118,'string',0,'item','item',NULL,'MANCHESTER',NULL,0),(2655399,2655397,118,'number',1,'count','count',103,NULL,NULL,0),(2655400,2655372,118,'object',9,NULL,NULL,NULL,NULL,NULL,0),(2655401,2655400,118,'string',0,'item','item',NULL,'TORRINGTON',NULL,0),(2655402,2655400,118,'number',1,'count','count',100,NULL,NULL,0),(2655403,2655372,118,'object',10,NULL,NULL,NULL,NULL,NULL,0),(2655404,2655403,118,'string',0,'item','item',NULL,'WEST HAVEN',NULL,0),(2655405,2655403,118,'number',1,'count','count',91,NULL,NULL,0),(2655406,2655372,118,'object',11,NULL,NULL,NULL,NULL,NULL,0),(2655407,2655406,118,'string',0,'item','item',NULL,'EAST HARTFORD',NULL,0),(2655408,2655406,118,'number',1,'count','count',89,NULL,NULL,0),(2655409,2655372,118,'object',12,NULL,NULL,NULL,NULL,NULL,0),(2655410,2655409,118,'string',0,'item','item',NULL,'MIDDLETOWN',NULL,0),(2655411,2655409,118,'number',1,'count','count',88,NULL,NULL,0),(2655412,2654892,118,'number',0,NULL,NULL,0.1163204897439373,NULL,NULL,0),(2655413,-3,118,'object',0,NULL,NULL,NULL,NULL,NULL,0),(2655414,2655413,118,'object',0,'label','label',NULL,NULL,NULL,0),(2655415,2655414,118,'string',0,'label','label',NULL,'Duplicate entry \'-1-0\' for key \'Value.UI_Value_parentValueId_objectIndex\'',NULL,0),(2655416,2655414,118,'string',1,'path','path',NULL,'/my',NULL,0),(2655417,2655414,118,'string',2,'jobPath','jobpath',NULL,'/my/jobs/0',NULL,0),(2655418,2655414,118,'number',3,'timeTaken','timetaken',2,NULL,NULL,0),(2655419,2655414,118,'string',4,'file','file',NULL,'/home/bee/JSONDB/server/json/JSONDBListener.php',NULL,0),(2655420,2655414,118,'number',5,'line','line',205,NULL,NULL,0),(2655421,2655414,118,'array',6,'trace','trace',NULL,NULL,NULL,0),(2655422,2655421,118,'object',0,NULL,NULL,NULL,NULL,NULL,0),(2655423,2655422,118,'string',0,'file','file',NULL,'/home/bee/JSONDB/server/json/JSONDBListener.php',NULL,0),(2655424,2655422,118,'number',1,'line','line',205,NULL,NULL,0),(2655425,2655422,118,'string',2,'function','function',NULL,'execute',NULL,0),(2655426,2655422,118,'string',3,'class','class',NULL,'mysqli_stmt',NULL,0),(2655427,2655422,118,'string',4,'type','type',NULL,'->',NULL,0),(2655428,2655421,118,'object',1,NULL,NULL,NULL,NULL,NULL,0),(2655429,2655428,118,'string',0,'file','file',NULL,'/home/bee/JSONDB/server/json/Parser.php',NULL,0),(2655430,2655428,118,'number',1,'line','line',666,NULL,NULL,0),(2655431,2655428,118,'string',2,'function','function',NULL,'endDocument',NULL,0),(2655432,2655428,118,'string',3,'class','class',NULL,'JSONDBListener',NULL,0),(2655433,2655428,118,'string',4,'type','type',NULL,'->',NULL,0),(2655434,2655421,118,'object',2,NULL,NULL,NULL,NULL,NULL,0),(2655435,2655434,118,'string',0,'file','file',NULL,'/home/bee/JSONDB/server/json/Parser.php',NULL,0),(2655436,2655434,118,'number',1,'line','line',194,NULL,NULL,0),(2655437,2655434,118,'string',2,'function','function',NULL,'endDocument',NULL,0),(2655438,2655434,118,'string',3,'class','class',NULL,'JsonStreamingParser\\Parser',NULL,0),(2655439,2655434,118,'string',4,'type','type',NULL,'->',NULL,0),(2655440,2655421,118,'object',3,NULL,NULL,NULL,NULL,NULL,0),(2655441,2655440,118,'string',0,'file','file',NULL,'/home/bee/JSONDB/server/json/JSONDBListener.php',NULL,0),(2655442,2655440,118,'number',1,'line','line',77,NULL,NULL,0),(2655443,2655440,118,'string',2,'function','function',NULL,'parse',NULL,0),(2655444,2655440,118,'string',3,'class','class',NULL,'JsonStreamingParser\\Parser',NULL,0),(2655445,2655440,118,'string',4,'type','type',NULL,'->',NULL,0),(2655446,2655421,118,'object',4,NULL,NULL,NULL,NULL,NULL,0),(2655447,2655446,118,'string',0,'file','file',NULL,'/home/bee/JSONDB/server/json/functions.php',NULL,0),(2655448,2655446,118,'number',1,'line','line',148,NULL,NULL,0),(2655449,2655446,118,'string',2,'function','function',NULL,'writeToDatabase',NULL,0),(2655450,2655446,118,'string',3,'class','class',NULL,'JSONDBListener',NULL,0),(2655451,2655446,118,'string',4,'type','type',NULL,'->',NULL,0),(2655452,2655421,118,'object',5,NULL,NULL,NULL,NULL,NULL,0),(2655453,2655452,118,'string',0,'file','file',NULL,'/home/bee/JSONDB/server/json/functions.php',NULL,0),(2655454,2655452,118,'number',1,'line','line',102,NULL,NULL,0),(2655455,2655452,118,'string',2,'function','function',NULL,'writeToDatabaseEx',NULL,0),(2655456,2655421,118,'object',6,NULL,NULL,NULL,NULL,NULL,0),(2655457,2655456,118,'string',0,'file','file',NULL,'/home/bee/JSONDB/server/json/JSONDBListener.php',NULL,0),(2655458,2655456,118,'number',1,'line','line',93,NULL,NULL,0),(2655459,2655456,118,'string',2,'function','function',NULL,'writeToDatabase',NULL,0),(2655460,2655421,118,'object',7,NULL,NULL,NULL,NULL,NULL,0),(2655461,2655460,118,'string',0,'file','file',NULL,'/home/bee/JSONDB/server/json/JSONDBListener.php',NULL,0),(2655462,2655460,118,'number',1,'line','line',580,NULL,NULL,0),(2655463,2655460,118,'string',2,'function','function',NULL,'writeToJob',NULL,0),(2655464,2655460,118,'string',3,'class','class',NULL,'JSONDBListener',NULL,0),(2655465,2655460,118,'string',4,'type','type',NULL,'->',NULL,0),(2655466,2655421,118,'object',8,NULL,NULL,NULL,NULL,NULL,0),(2655467,2655466,118,'string',0,'file','file',NULL,'/home/bee/JSONDB/server/json/Parser.php',NULL,0),(2655468,2655466,118,'number',1,'line','line',531,NULL,NULL,0),(2655469,2655466,118,'string',2,'function','function',NULL,'value',NULL,0),(2655470,2655466,118,'string',3,'class','class',NULL,'JSONDBListener',NULL,0),(2655471,2655466,118,'string',4,'type','type',NULL,'->',NULL,0),(2655472,2655421,118,'object',9,NULL,NULL,NULL,NULL,NULL,0),(2655473,2655472,118,'string',0,'file','file',NULL,'/home/bee/JSONDB/server/json/Parser.php',NULL,0),(2655474,2655472,118,'number',1,'line','line',234,NULL,NULL,0),(2655475,2655472,118,'string',2,'function','function',NULL,'endString',NULL,0),(2655476,2655472,118,'string',3,'class','class',NULL,'JsonStreamingParser\\Parser',NULL,0),(2655477,2655472,118,'string',4,'type','type',NULL,'->',NULL,0),(2655478,2655421,118,'object',10,NULL,NULL,NULL,NULL,NULL,0),(2655479,2655478,118,'string',0,'file','file',NULL,'/home/bee/JSONDB/server/json/Parser.php',NULL,0),(2655480,2655478,118,'number',1,'line','line',176,NULL,NULL,0),(2655481,2655478,118,'string',2,'function','function',NULL,'consumeChar',NULL,0),(2655482,2655478,118,'string',3,'class','class',NULL,'JsonStreamingParser\\Parser',NULL,0),(2655483,2655478,118,'string',4,'type','type',NULL,'->',NULL,0),(2655484,2655421,118,'object',11,NULL,NULL,NULL,NULL,NULL,0),(2655485,2655484,118,'string',0,'file','file',NULL,'/home/bee/JSONDB/server/json/JSONDBListener.php',NULL,0),(2655486,2655484,118,'number',1,'line','line',77,NULL,NULL,0),(2655487,2655484,118,'string',2,'function','function',NULL,'parse',NULL,0),(2655488,2655484,118,'string',3,'class','class',NULL,'JsonStreamingParser\\Parser',NULL,0),(2655489,2655484,118,'string',4,'type','type',NULL,'->',NULL,0),(2655490,2655421,118,'object',12,NULL,NULL,NULL,NULL,NULL,0),(2655491,2655490,118,'string',0,'file','file',NULL,'/home/bee/JSONDB/server/json/functions.php',NULL,0),(2655492,2655490,118,'number',1,'line','line',148,NULL,NULL,0),(2655493,2655490,118,'string',2,'function','function',NULL,'writeToDatabase',NULL,0),(2655494,2655490,118,'string',3,'class','class',NULL,'JSONDBListener',NULL,0),(2655495,2655490,118,'string',4,'type','type',NULL,'->',NULL,0),(2655496,2655421,118,'object',13,NULL,NULL,NULL,NULL,NULL,0),(2655497,2655496,118,'string',0,'file','file',NULL,'/home/bee/JSONDB/server/json/functions.php',NULL,0),(2655498,2655496,118,'number',1,'line','line',259,NULL,NULL,0),(2655499,2655496,118,'string',2,'function','function',NULL,'writeToDatabaseEx',NULL,0),(2655500,2655421,118,'object',14,NULL,NULL,NULL,NULL,NULL,0),(2655501,2655500,118,'string',0,'file','file',NULL,'/home/bee/JSONDB/server/json/JSON.php',NULL,0),(2655502,2655500,118,'number',1,'line','line',11,NULL,NULL,0),(2655503,2655500,118,'string',2,'function','function',NULL,'handlePost',NULL,0),(2655504,2655413,118,'string',1,'path','path',NULL,'/my/',NULL,0),(2655505,2655413,118,'bool',2,'done','done',NULL,NULL,0,0);
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
) ENGINE=InnoDB AUTO_INCREMENT=119 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `User`
--

LOCK TABLES `User` WRITE;
/*!40000 ALTER TABLE `User` DISABLE KEYS */;
INSERT INTO `User` VALUES (118,'brettdavidsilverman@gmail.com','ilFE96NS+qLxpnjkzQ9gktwDKsZNWim8ud/lv/QMeaT6lV8OP/Xhv6M2I74K0pyK/DKpJBEOiJILRvjo1H0TnQ==',NULL,'d77b04a8ce0d52f891919ed036174308',1);
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
  CONSTRAINT `FK_Value_objectKeyWordId` FOREIGN KEY (`objectKeyWordId`) REFERENCES `Word` (`wordId`),
  CONSTRAINT `FK_Value_ownerId` FOREIGN KEY (`ownerId`) REFERENCES `User` (`userId`) ON DELETE CASCADE,
  CONSTRAINT `FK_Value_parentValueId` FOREIGN KEY (`parentValueId`) REFERENCES `Value` (`valueId`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=33464175 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
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
) ENGINE=InnoDB AUTO_INCREMENT=1104816 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
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
    DETERMINISTIC
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
            
    END IF;
    
    IF @stringValue IS NOT NULL THEN
        CALL insertWord(
            @stringValue,
            @stringValueWordId
        );
        CALL insertValueWords(
            @stringValue,
            null,
            1
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
            @valueId,
            0
        );
    END IF;
    
    IF @stringValue IS NOT NULL THEN
        CALL insertValueWords(
            @stringValue,
            @valueId,
            0
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
    valueId BIGINT,
    insertWordsOnly TINYINT
)
exit_procedure: BEGIN
  
   IF text IS NULL THEN
       LEAVE exit_procedure;
   END IF;
   
   
   SET @lowerText = LOWER(text),
            @word = NULL,
            @start = 1,
            @length = LENGTH(@lowerText),
            @insertWordsOnly = insertWordsOnly;

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
                    @valueId,
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
    END IF;
    
    IF @stringValue IS NOT NULL THEN
        CALL insertWord(
            @stringValue,
            @stringValueWordId
        );
        CALL insertValueWords(
            @stringValue,
            null,
            1
        );
    END IF;
    
   START TRANSACTION;
    
   CALL deleteChildValues(@valueId);
   
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
            @valueId,
            0
        );
    END IF;
    
    IF @stringValue IS NOT NULL THEN
        CALL insertValueWords(
            @stringValue,
            @valueId,
            0
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

-- Dump completed on 2025-11-21  4:32:47
