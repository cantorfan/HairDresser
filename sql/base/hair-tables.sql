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
-- Table structure for table `appointment`
--

DROP TABLE IF EXISTS `appointment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `appointment` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `customer_id` int(11) NOT NULL DEFAULT '0',
  `appt_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `service_id` int(11) DEFAULT NULL,
  `price` decimal(10,3) DEFAULT NULL,
  `employee_id` int(11) NOT NULL DEFAULT '0',
  `location_id` int(11) DEFAULT NULL,
  `category_id` int(11) DEFAULT NULL,
  `st_time` time NOT NULL DEFAULT '00:00:00',
  `et_time` time DEFAULT NULL,
  `state` tinyint(1) DEFAULT '0',
  `comment` varchar(255) NOT NULL,
  `request` tinyint(4) DEFAULT '0',
  `ticket_id` int(11) DEFAULT '0',
  `is_send_appointment_mail` tinyint(1) DEFAULT '0',
  `is_send_reminder_mail` tinyint(1) DEFAULT '0',
  `batchId` varchar(80) DEFAULT NULL,
  `batchType` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `appointment_appt_date` (`appt_date`),
  KEY `appointment_service_id` (`service_id`),
  KEY `appointment_employee_id` (`employee_id`),
  KEY `appointment_location_id` (`location_id`),
  KEY `appointment_customer_id` (`customer_id`)
) ENGINE=MyISAM AUTO_INCREMENT=71018 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `booking`
--

DROP TABLE IF EXISTS `booking`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `booking` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `location_id` int(11) NOT NULL DEFAULT '1',
  `customer_id` int(11) DEFAULT '0',
  `employee_id` int(11) DEFAULT '0',
  `product_id` int(11) DEFAULT '0',
  `service_id` int(11) DEFAULT '0',
  `date` date DEFAULT NULL,
  `time` time DEFAULT NULL,
  `state` int(1) DEFAULT '0',
  `deleted` int(11) DEFAULT '0',
  `appointment_id` int(11) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `brand`
--

DROP TABLE IF EXISTS `brand`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `brand` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `vendor_id` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `cash_drawing`
--

DROP TABLE IF EXISTS `cash_drawing`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cash_drawing` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `employeeID` int(11) NOT NULL DEFAULT '0',
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `pennies` int(11) NOT NULL DEFAULT '0',
  `nickels` int(11) NOT NULL DEFAULT '0',
  `dimes` int(11) NOT NULL DEFAULT '0',
  `quarters` int(11) NOT NULL DEFAULT '0',
  `half_dollars` int(11) NOT NULL DEFAULT '0',
  `dollars` int(11) NOT NULL DEFAULT '0',
  `singles` int(11) NOT NULL DEFAULT '0',
  `fives` int(11) NOT NULL DEFAULT '0',
  `tens` int(11) NOT NULL DEFAULT '0',
  `twenties` int(11) NOT NULL DEFAULT '0',
  `fifties` int(11) NOT NULL DEFAULT '0',
  `hundreds` int(11) NOT NULL DEFAULT '0',
  `openClose` int(11) NOT NULL DEFAULT '0',
  `location_id` int(11) NOT NULL DEFAULT '0',
  `amex` decimal(10,3) DEFAULT '0.000',
  `visa` decimal(10,3) DEFAULT '0.000',
  `mastercard` decimal(10,3) DEFAULT '0.000',
  `cheque` decimal(10,3) DEFAULT '0.000',
  `cash` decimal(10,3) DEFAULT '0.000',
  `gift` decimal(10,3) DEFAULT '0.000',
  `card_over` decimal(10,3) DEFAULT '0.000',
  `cheque_over` decimal(10,3) DEFAULT '0.000',
  `cash_over` decimal(10,3) DEFAULT '0.000',
  `gift_over` decimal(10,3) DEFAULT '0.000',
  `card_short` decimal(10,3) DEFAULT '0.000',
  `cheque_short` decimal(10,3) DEFAULT '0.000',
  `cash_short` decimal(10,3) DEFAULT '0.000',
  `gift_short` decimal(10,3) DEFAULT '0.000',
  `creditcard` decimal(10,3) DEFAULT '0.000',
  `userID` int(11) DEFAULT '0',
  `userIP` varchar(255) DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=3272 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `cashio`
--

DROP TABLE IF EXISTS `cashio`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cashio` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_dt` datetime DEFAULT NULL,
  `cout` decimal(10,3) DEFAULT NULL,
  `cin` decimal(10,3) DEFAULT NULL,
  `reconcilation_id` int(11) DEFAULT NULL,
  `vendor` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1992 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `category`
--

DROP TABLE IF EXISTS `category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `category` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL DEFAULT '',
  `details` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=33 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `customer`
--

DROP TABLE IF EXISTS `customer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `customer` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `fname` varchar(50) DEFAULT NULL,
  `lname` varchar(50) NOT NULL DEFAULT '',
  `email` varchar(255) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `cell_phone` varchar(20) DEFAULT NULL,
  `type` varchar(50) DEFAULT NULL,
  `location_id` int(11) NOT NULL DEFAULT '0',
  `req` tinyint(4) DEFAULT NULL,
  `reminder` tinyint(4) NOT NULL DEFAULT '0',
  `remdays` int(11) NOT NULL DEFAULT '0',
  `comment` varchar(255) NOT NULL DEFAULT '',
  `employee_id` int(11) NOT NULL DEFAULT '0',
  `work_phone_ext` varchar(20) DEFAULT '',
  `male_female` tinyint(1) DEFAULT '0',
  `address` varchar(255) DEFAULT '',
  `city` varchar(50) DEFAULT '',
  `state` varchar(50) DEFAULT '',
  `zip_code` varchar(20) DEFAULT '',
  `picture` longblob,
  `date_of_birth` date DEFAULT NULL,
  `login` varchar(255) DEFAULT '',
  `pwd` varchar(255) DEFAULT '',
  `country` int(11) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `customer_location_id` (`location_id`)
) ENGINE=MyISAM AUTO_INCREMENT=11292 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `emailstemplate`
--

DROP TABLE IF EXISTS `emailstemplate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `emailstemplate` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `location_id` int(11) NOT NULL DEFAULT '1',
  `type` int(11) DEFAULT '-1',
  `text` varchar(50000) DEFAULT '',
  `description` varchar(300) DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=10 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `employee`
--

DROP TABLE IF EXISTS `employee`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `employee` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `fname` varchar(50) DEFAULT NULL,
  `lname` varchar(50) NOT NULL DEFAULT '',
  `login_id` int(11) DEFAULT NULL,
  `schedule` varchar(7) NOT NULL DEFAULT '0000000',
  `commission` decimal(10,3) DEFAULT NULL,
  `location_id` int(11) NOT NULL DEFAULT '1',
  `picture` longblob,
  `s_security` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `salary` varchar(255) DEFAULT NULL,
  `comment` varchar(255) NOT NULL DEFAULT '',
  `deleted` int(11) NOT NULL DEFAULT '0',
  `delete_date` datetime DEFAULT NULL,
  `oneday` tinyint(4) DEFAULT '0',
  `male_female` tinyint(1) DEFAULT '0',
  `description` varchar(800) DEFAULT '',
  `address` varchar(100) DEFAULT '',
  `city` varchar(100) DEFAULT '',
  `postcode` varchar(10) DEFAULT '',
  `homephone` varchar(20) DEFAULT '',
  `cellphone` varchar(20) DEFAULT '',
  `hiredate` date DEFAULT NULL,
  `termdate` date DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=88 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `giftcard`
--

DROP TABLE IF EXISTS `giftcard`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `giftcard` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(10) NOT NULL DEFAULT '',
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `amount` decimal(10,3) NOT NULL DEFAULT '0.000',
  `payment` varchar(20) DEFAULT NULL,
  `startamount` decimal(10,2) DEFAULT '0.00',
  `id_customer` int(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`)
) ENGINE=MyISAM AUTO_INCREMENT=111 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `inventory`
--

DROP TABLE IF EXISTS `inventory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `inventory` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL DEFAULT '',
  `vendor` varchar(255) DEFAULT NULL,
  `cost_price` decimal(10,3) DEFAULT NULL,
  `sale_price` decimal(10,3) DEFAULT NULL,
  `category_id` int(11) DEFAULT NULL,
  `taxes` decimal(10,3) DEFAULT NULL,
  `qty` int(11) DEFAULT '0',
  `sku` varchar(255) DEFAULT '',
  `vendor_id` int(11) DEFAULT NULL,
  `upc` varchar(255) DEFAULT '',
  `brand_id` int(11) DEFAULT NULL,
  `description` varchar(800) DEFAULT '',
  `picture` longblob,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=118 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `location`
--

DROP TABLE IF EXISTS `location`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `location` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL DEFAULT '',
  `address` varchar(255) DEFAULT NULL,
  `taxes` decimal(10,3) DEFAULT NULL,
  `businesshours` varchar(255) DEFAULT NULL,
  `address2` varchar(255) NOT NULL DEFAULT '',
  `logo` longblob,
  `country` varchar(100) DEFAULT '',
  `state` varchar(100) DEFAULT '',
  `city` varchar(100) DEFAULT '',
  `zipcode` varchar(100) DEFAULT '',
  `phone` varchar(100) DEFAULT '',
  `fax` varchar(100) DEFAULT '',
  `email` varchar(100) DEFAULT '',
  `currency` varchar(20) DEFAULT '',
  `facebook` varchar(800) DEFAULT '',
  `twitter` varchar(800) DEFAULT '',
  `blogger` varchar(800) DEFAULT '',
  `timezone` varchar(100) DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=9 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `log`
--

DROP TABLE IF EXISTS `log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `log` (
  `ts` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `thingID` bigint(20) DEFAULT NULL,
  `msg` text
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `login`
--

DROP TABLE IF EXISTS `login`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `login` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `fname` varchar(50) DEFAULT NULL,
  `lname` varchar(50) NOT NULL DEFAULT '',
  `user` varchar(50) NOT NULL DEFAULT '',
  `pwd` varchar(50) NOT NULL DEFAULT '',
  `email` varchar(255) DEFAULT NULL,
  `permission` int(11) NOT NULL DEFAULT '0',
  `send_email` int(1) DEFAULT '0',
  `ips` varchar(3000) DEFAULT NULL,
  `employees` varchar(3000) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user` (`user`)
) ENGINE=MyISAM AUTO_INCREMENT=21 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `logs`
--

DROP TABLE IF EXISTS `logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` date NOT NULL DEFAULT '0000-00-00',
  `employeeId` int(11) DEFAULT NULL,
  `eventDescription` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `notworkingtime_emp`
--

DROP TABLE IF EXISTS `notworkingtime_emp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `notworkingtime_emp` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `employee_id` int(11) NOT NULL,
  `hfrom` time DEFAULT NULL,
  `hto` time DEFAULT NULL,
  `comment` varchar(255) DEFAULT NULL,
  `w_date` date NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2537 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `promotion`
--

DROP TABLE IF EXISTS `promotion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `promotion` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_dt` datetime DEFAULT NULL,
  `created_by` int(11) NOT NULL DEFAULT '0',
  `content` text,
  `from_dt` datetime DEFAULT NULL,
  `to_dt` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `reconciliation`
--

DROP TABLE IF EXISTS `reconciliation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `reconciliation` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_location` int(11) NOT NULL,
  `code_transaction` varchar(20) DEFAULT '',
  `id_customer` int(11) DEFAULT '0',
  `sub_total` decimal(10,3) DEFAULT '0.000',
  `taxe` decimal(10,3) DEFAULT '0.000',
  `total` decimal(10,3) DEFAULT '0.000',
  `payment` varchar(200) DEFAULT '',
  `status` int(11) DEFAULT '0',
  `created_dt` datetime DEFAULT NULL,
  `amex` decimal(10,3) DEFAULT '0.000',
  `visa` decimal(10,3) DEFAULT '0.000',
  `mastercard` decimal(10,3) DEFAULT '0.000',
  `cheque` decimal(10,3) DEFAULT '0.000',
  `cashe` decimal(10,3) DEFAULT '0.000',
  `chg` decimal(10,3) DEFAULT '0.000',
  `giftcard` decimal(10,3) DEFAULT '0.000',
  `giftcard_pay` varchar(255) DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `reconciliation_code_transaction` (`code_transaction`),
  KEY `reconciliation_id_location` (`id_location`),
  KEY `reconciliation_payment` (`payment`),
  KEY `reconciliation_status` (`status`),
  KEY `reconciliation_created_dt` (`created_dt`),
  KEY `rec_cust_id` (`id_customer`)
) ENGINE=MyISAM AUTO_INCREMENT=39433 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `serv_emp`
--

DROP TABLE IF EXISTS `serv_emp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `serv_emp` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `service_id` int(11) NOT NULL DEFAULT '0',
  `employee_id` int(11) NOT NULL DEFAULT '0',
  `price` decimal(10,3) DEFAULT NULL,
  `duration` int(11) DEFAULT NULL,
  `taxes` decimal(10,3) DEFAULT NULL,
  `commission` decimal(10,2) DEFAULT '0.00',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=418 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `service`
--

DROP TABLE IF EXISTS `service`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `service` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL DEFAULT '',
  `category_id` int(11) NOT NULL DEFAULT '0',
  `type_id` int(11) NOT NULL,
  `price` decimal(10,3) DEFAULT '0.000',
  `duration` int(11) DEFAULT '0',
  `taxes` decimal(10,3) DEFAULT '0.000',
  `code` varchar(255) DEFAULT '0',
  `description` varchar(255) DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=85 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `theday`
--

DROP TABLE IF EXISTS `theday`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `theday` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `start` decimal(10,0) DEFAULT NULL,
  `amex` decimal(10,0) DEFAULT NULL,
  `mastercard` decimal(10,0) DEFAULT NULL,
  `visa` decimal(10,0) DEFAULT NULL,
  `creditcard` decimal(10,0) DEFAULT NULL,
  `giftcard` decimal(10,0) DEFAULT NULL,
  `expenses` decimal(10,0) DEFAULT NULL,
  `totalcash` decimal(10,0) DEFAULT NULL,
  `endoftheday` decimal(10,0) DEFAULT NULL,
  `ajustment` decimal(10,0) DEFAULT NULL,
  `putintheenvelop` decimal(10,0) DEFAULT NULL,
  `created` date DEFAULT NULL,
  `ended` char(1) DEFAULT NULL,
  `cheque` decimal(10,0) DEFAULT NULL,
  `created_dt` datetime DEFAULT NULL,
  `cash` decimal(10,3) DEFAULT NULL,
  `card` decimal(10,3) DEFAULT NULL,
  `beginning` decimal(10,3) DEFAULT NULL,
  `cash_end` decimal(10,3) DEFAULT NULL,
  `cash_drawer` decimal(10,3) DEFAULT NULL,
  `location_id` decimal(10,3) DEFAULT NULL,
  `cashin` decimal(10,3) DEFAULT NULL,
  `cashout` decimal(10,3) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ticket`
--

DROP TABLE IF EXISTS `ticket`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ticket` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `location_id` int(11) NOT NULL,
  `code_transaction` varchar(20) DEFAULT '',
  `employee_id` int(11) DEFAULT '0',
  `product_id` int(11) DEFAULT '0',
  `service_id` int(11) DEFAULT '0',
  `qty` int(11) DEFAULT '0',
  `discount` int(11) DEFAULT '0',
  `price` decimal(10,3) DEFAULT '0.000',
  `taxe` decimal(10,3) DEFAULT '0.000',
  `status` int(11) DEFAULT '0',
  `giftcard` varchar(255) NOT NULL DEFAULT '-1',
  `refundtrans_id` int(11) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `ticket_location_id` (`location_id`),
  KEY `ticket_code_transaction` (`code_transaction`),
  KEY `ticket_employee_id` (`employee_id`),
  KEY `ticket_product_id` (`product_id`),
  KEY `ticket_service_id` (`service_id`),
  KEY `ticket_status` (`status`)
) ENGINE=MyISAM AUTO_INCREMENT=48623 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `trail`
--

DROP TABLE IF EXISTS `trail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `trail` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `table_name` varchar(20) DEFAULT NULL,
  `action` varchar(50) DEFAULT NULL,
  `row_id` int(11) DEFAULT '0',
  `notes` varchar(1600) DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=139454 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `transaction`
--

DROP TABLE IF EXISTS `transaction`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `transaction` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_dt` datetime DEFAULT NULL,
  `customer_id` int(11) NOT NULL DEFAULT '0',
  `service_id` int(11) DEFAULT NULL,
  `product_id` int(11) DEFAULT NULL,
  `employee_id` int(11) DEFAULT NULL,
  `payment` varchar(50) DEFAULT '''Cash''',
  `location_id` int(11) DEFAULT NULL,
  `discount` decimal(10,3) DEFAULT NULL,
  `price` decimal(10,3) DEFAULT NULL,
  `code` varchar(10) NOT NULL DEFAULT '',
  `prod_qty` int(11) DEFAULT '0',
  `sn` varchar(20) DEFAULT NULL,
  `tax` decimal(10,3) DEFAULT '0.000',
  `remainder` decimal(10,3) DEFAULT '0.000',
  `change_f` decimal(10,3) DEFAULT '0.000',
  `deleted` tinyint(4) DEFAULT '0',
  `note` varchar(200) DEFAULT '',
  `amex` decimal(10,3) DEFAULT NULL,
  `visa` decimal(10,3) DEFAULT NULL,
  `mastercard` decimal(10,3) DEFAULT NULL,
  `cheque` decimal(10,3) DEFAULT NULL,
  `cashe` decimal(10,3) DEFAULT NULL,
  `giftcard` decimal(10,3) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=113 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `transaction_cust`
--

DROP TABLE IF EXISTS `transaction_cust`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `transaction_cust` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `customer_id` int(11) NOT NULL DEFAULT '0',
  `service_id` int(11) DEFAULT NULL,
  `product_id` int(11) DEFAULT NULL,
  `employee_id` int(11) DEFAULT NULL,
  `location_id` int(11) DEFAULT NULL,
  `prod_qty` int(11) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `vendor`
--

DROP TABLE IF EXISTS `vendor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `vendor` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `address` varchar(100) DEFAULT NULL,
  `city` varchar(100) DEFAULT NULL,
  `zip` varchar(100) DEFAULT NULL,
  `country` varchar(100) DEFAULT NULL,
  `phone_number` varchar(100) DEFAULT NULL,
  `email_address` varchar(100) DEFAULT NULL,
  `contact_name` varchar(255) DEFAULT '',
  `ph_num_contact` varchar(255) DEFAULT '',
  `website` varchar(255) DEFAULT '',
  `state` varchar(255) DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `workingtime_emp`
--

DROP TABLE IF EXISTS `workingtime_emp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `workingtime_emp` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `daynumber` int(11) DEFAULT NULL,
  `hfrom` time DEFAULT NULL,
  `hto` time DEFAULT NULL,
  `employee_id` int(11) DEFAULT NULL,
  `comment` varchar(255) DEFAULT NULL,
  `work_date` date DEFAULT NULL,
  `type` int(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=981 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `workingtime_loc`
--

DROP TABLE IF EXISTS `workingtime_loc`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `workingtime_loc` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `daynumber` int(11) DEFAULT NULL,
  `hfrom` time DEFAULT NULL,
  `hto` time DEFAULT NULL,
  `location_id` int(11) DEFAULT NULL,
  `comment` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=180 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2015-04-21 14:08:35
