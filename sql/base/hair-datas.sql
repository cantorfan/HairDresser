-- MySQL dump 10.13  Distrib 5.5.16, for Win32 (x86)
--
-- Host: localhost    Database: hair1
-- ------------------------------------------------------
-- Server version	5.5.16

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping data for table `appointment`
--

LOCK TABLES `appointment` WRITE;
/*!40000 ALTER TABLE `appointment` DISABLE KEYS */;
/*!40000 ALTER TABLE `appointment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `booking`
--

LOCK TABLES `booking` WRITE;
/*!40000 ALTER TABLE `booking` DISABLE KEYS */;
/*!40000 ALTER TABLE `booking` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `brand`
--

LOCK TABLES `brand` WRITE;
/*!40000 ALTER TABLE `brand` DISABLE KEYS */;
/*!40000 ALTER TABLE `brand` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `cashio`
--

LOCK TABLES `cashio` WRITE;
/*!40000 ALTER TABLE `cashio` DISABLE KEYS */;
/*!40000 ALTER TABLE `cashio` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `category`
--

LOCK TABLES `category` WRITE;
/*!40000 ALTER TABLE `category` DISABLE KEYS */;
INSERT INTO `category` VALUES (6,'','Up Do');
/*!40000 ALTER TABLE `category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `customer`
--

LOCK TABLES `customer` WRITE;
/*!40000 ALTER TABLE `customer` DISABLE KEYS */;
INSERT INTO `customer` VALUES (1,'RO','BBY',NULL,NULL,NULL,NULL,1,1,0,0,'BD 45 min. $50',1,'',0,'','','','',NULL,NULL,'','',0);
/*!40000 ALTER TABLE `customer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `emailstemplate`
--

LOCK TABLES `emailstemplate` WRITE;
/*!40000 ALTER TABLE `emailstemplate` DISABLE KEYS */;
/*!40000 ALTER TABLE `emailstemplate` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `employee`
--

LOCK TABLES `employee` WRITE;
/*!40000 ALTER TABLE `employee` DISABLE KEYS */;
INSERT INTO `employee` VALUES (1,'Vera','V',NULL,'0000000',40.000,1,NULL,NULL,NULL,NULL,'',0,NULL,0,0,'','','','','','',NULL,NULL);
/*!40000 ALTER TABLE `employee` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `giftcard`
--

LOCK TABLES `giftcard` WRITE;
/*!40000 ALTER TABLE `giftcard` DISABLE KEYS */;
/*!40000 ALTER TABLE `giftcard` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `inventory`
--

LOCK TABLES `inventory` WRITE;
/*!40000 ALTER TABLE `inventory` DISABLE KEYS */;
/*!40000 ALTER TABLE `inventory` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `location`
--

LOCK TABLES `location` WRITE;
/*!40000 ALTER TABLE `location` DISABLE KEYS */;
INSERT INTO `location` VALUES (1,'Salon De Quartier','1032 2nd Ave. NY, NY 10022',0.000,NULL,'',NULL,'','','','','212-688-5460','','','1','http://www.twitter.com/','','http://www.blogger.com/','');
/*!40000 ALTER TABLE `location` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `log`
--

LOCK TABLES `log` WRITE;
/*!40000 ALTER TABLE `log` DISABLE KEYS */;
/*!40000 ALTER TABLE `log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `login`
--

LOCK TABLES `login` WRITE;
/*!40000 ALTER TABLE `login` DISABLE KEYS */;
INSERT INTO `login` VALUES (1,'salon','salon','salon','salon',NULL,1001,0,'*',NULL);
/*!40000 ALTER TABLE `login` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `logs`
--

LOCK TABLES `logs` WRITE;
/*!40000 ALTER TABLE `logs` DISABLE KEYS */;
/*!40000 ALTER TABLE `logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `notworkingtime_emp`
--

LOCK TABLES `notworkingtime_emp` WRITE;
/*!40000 ALTER TABLE `notworkingtime_emp` DISABLE KEYS */;
/*!40000 ALTER TABLE `notworkingtime_emp` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `promotion`
--

LOCK TABLES `promotion` WRITE;
/*!40000 ALTER TABLE `promotion` DISABLE KEYS */;
/*!40000 ALTER TABLE `promotion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `reconciliation`
--

LOCK TABLES `reconciliation` WRITE;
/*!40000 ALTER TABLE `reconciliation` DISABLE KEYS */;
/*!40000 ALTER TABLE `reconciliation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `serv_emp`
--

LOCK TABLES `serv_emp` WRITE;
/*!40000 ALTER TABLE `serv_emp` DISABLE KEYS */;
/*!40000 ALTER TABLE `serv_emp` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `service`
--

LOCK TABLES `service` WRITE;
/*!40000 ALTER TABLE `service` DISABLE KEYS */;
INSERT INTO `service` VALUES (1,'BLOW DRY SHORT',6,2,40.000,30,5.000,'BD1',''),(2,'BLOW DRY MEDIUM',6,2,45.000,30,5.000,'BD2','');
/*!40000 ALTER TABLE `service` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `theday`
--

LOCK TABLES `theday` WRITE;
/*!40000 ALTER TABLE `theday` DISABLE KEYS */;
/*!40000 ALTER TABLE `theday` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `ticket`
--

LOCK TABLES `ticket` WRITE;
/*!40000 ALTER TABLE `ticket` DISABLE KEYS */;
/*!40000 ALTER TABLE `ticket` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `trail`
--

LOCK TABLES `trail` WRITE;
/*!40000 ALTER TABLE `trail` DISABLE KEYS */;
/*!40000 ALTER TABLE `trail` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `transaction`
--

LOCK TABLES `transaction` WRITE;
/*!40000 ALTER TABLE `transaction` DISABLE KEYS */;
/*!40000 ALTER TABLE `transaction` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `transaction_cust`
--

LOCK TABLES `transaction_cust` WRITE;
/*!40000 ALTER TABLE `transaction_cust` DISABLE KEYS */;
/*!40000 ALTER TABLE `transaction_cust` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `vendor`
--

LOCK TABLES `vendor` WRITE;
/*!40000 ALTER TABLE `vendor` DISABLE KEYS */;
/*!40000 ALTER TABLE `vendor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `workingtime_emp`
--

LOCK TABLES `workingtime_emp` WRITE;
/*!40000 ALTER TABLE `workingtime_emp` DISABLE KEYS */;
/*!40000 ALTER TABLE `workingtime_emp` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `workingtime_loc`
--

LOCK TABLES `workingtime_loc` WRITE;
/*!40000 ALTER TABLE `workingtime_loc` DISABLE KEYS */;
INSERT INTO `workingtime_loc` VALUES (1,1,'00:00:00','00:00:00',1,NULL),(2,2,'09:00:00','18:00:00',1,NULL),(3,3,'09:00:00','18:00:00',1,NULL),(4,4,'09:00:00','18:00:00',1,NULL),(5,5,'09:00:00','18:00:00',1,NULL),(6,6,'09:00:00','18:00:00',1,NULL),(7,7,'09:00:00','18:00:00',1,NULL);
/*!40000 ALTER TABLE `workingtime_loc` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2015-04-21 14:08:59
