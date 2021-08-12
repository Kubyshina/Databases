-- MySQL dump 10.13  Distrib 8.0.25, for Win64 (x86_64)
--
-- Host: localhost    Database: skyscanner
-- ------------------------------------------------------
-- Server version	8.0.25

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
-- Table structure for table `airlines`
--

DROP TABLE IF EXISTS `airlines`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `airlines` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL COMMENT 'Название авиакомпании',
  `abbreviation` varchar(3) NOT NULL COMMENT 'Сокращенное название авиакомпании',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`),
  KEY `index_of_airline_name` (`name`),
  KEY `index_of_airline_abbreviation` (`abbreviation`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=cp1251 COMMENT='Справочник авиакомпаний';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `airlines`
--

LOCK TABLES `airlines` WRITE;
/*!40000 ALTER TABLE `airlines` DISABLE KEYS */;
INSERT INTO `airlines` VALUES (1,'Аэрофлот','SU'),(2,'Россия','FV'),(3,'Победа','DP'),(4,'S7 Airlines','S7'),(5,'Ural Airlines','U6');
/*!40000 ALTER TABLE `airlines` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `airlines_flights`
--

DROP TABLE IF EXISTS `airlines_flights`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `airlines_flights` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `airline_id` bigint unsigned NOT NULL COMMENT 'Авиакомпания',
  `flight_id` bigint unsigned NOT NULL COMMENT 'Рейс',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`),
  KEY `fk_af_airline_id` (`airline_id`),
  KEY `fk_af_flight_id` (`flight_id`),
  CONSTRAINT `fk_af_airline_id` FOREIGN KEY (`airline_id`) REFERENCES `airlines` (`id`),
  CONSTRAINT `fk_af_flight_id` FOREIGN KEY (`flight_id`) REFERENCES `flights` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=cp1251 COMMENT='Связь рейсов и авиакомпаний';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `airlines_flights`
--

LOCK TABLES `airlines_flights` WRITE;
/*!40000 ALTER TABLE `airlines_flights` DISABLE KEYS */;
INSERT INTO `airlines_flights` VALUES (1,1,1),(2,1,2),(3,1,3),(4,1,4),(5,4,5),(6,4,6);
/*!40000 ALTER TABLE `airlines_flights` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `airports`
--

DROP TABLE IF EXISTS `airports`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `airports` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL COMMENT 'Название аэропорта',
  `abbreviation` varchar(3) NOT NULL COMMENT 'Сокращенное название аэропорта',
  `city_id` bigint unsigned NOT NULL COMMENT 'Город',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`),
  KEY `index_of_airport_name` (`name`),
  KEY `index_of_airport_abbreviation` (`abbreviation`),
  KEY `fk_airports_city_id` (`city_id`),
  CONSTRAINT `fk_airports_city_id` FOREIGN KEY (`city_id`) REFERENCES `cities` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=cp1251 COMMENT='Справочник аэропортов';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `airports`
--

LOCK TABLES `airports` WRITE;
/*!40000 ALTER TABLE `airports` DISABLE KEYS */;
INSERT INTO `airports` VALUES (1,'Domodedovo','DME',1),(2,'Sheremetyevo','SVO',1),(3,'Vnukovo','VKO',1),(4,'Gorno-Altaysk','RGK',3),(5,'Adler-Sochi','AER',2),(6,'Hurghada','HRG',4);
/*!40000 ALTER TABLE `airports` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `airports_count` AFTER INSERT ON `airports` FOR EACH ROW BEGIN
  SELECT COUNT(*) INTO @airports_total FROM skyscanner.airports;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Temporary view structure for view `airports_cities_countries`
--

DROP TABLE IF EXISTS `airports_cities_countries`;
/*!50001 DROP VIEW IF EXISTS `airports_cities_countries`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `airports_cities_countries` AS SELECT 
 1 AS `airport_id`,
 1 AS `airport_name`,
 1 AS `airport_abbreviation`,
 1 AS `city_id`,
 1 AS `city_name`,
 1 AS `country_id`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `cities`
--

DROP TABLE IF EXISTS `cities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cities` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL COMMENT 'Город',
  `country_id` bigint unsigned NOT NULL COMMENT 'ID страны',
  `time_zone` varchar(10) DEFAULT NULL COMMENT 'Часовой пояс',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`),
  KEY `index_of_city_name` (`name`),
  KEY `fk_cities_country_id` (`country_id`),
  CONSTRAINT `fk_cities_country_id` FOREIGN KEY (`country_id`) REFERENCES `countries` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=cp1251 COMMENT='Справочник городов';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cities`
--

LOCK TABLES `cities` WRITE;
/*!40000 ALTER TABLE `cities` DISABLE KEYS */;
INSERT INTO `cities` VALUES (1,'Moscow',1,NULL),(2,'Sochi',1,NULL),(3,'Gorno-Altaysk',1,NULL),(4,'Bangkok',3,NULL),(5,'Hurghada',2,NULL);
/*!40000 ALTER TABLE `cities` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `cities_count` AFTER INSERT ON `cities` FOR EACH ROW BEGIN
  SELECT COUNT(*) INTO @cities_total FROM skyscanner.cities;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `countries`
--

DROP TABLE IF EXISTS `countries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `countries` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL COMMENT 'Страна',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`),
  KEY `index_of_country_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=cp1251 COMMENT='Справочник стран';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `countries`
--

LOCK TABLES `countries` WRITE;
/*!40000 ALTER TABLE `countries` DISABLE KEYS */;
INSERT INTO `countries` VALUES (2,'Egypt'),(1,'Russia'),(3,'Thailand');
/*!40000 ALTER TABLE `countries` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `countries_count` AFTER INSERT ON `countries` FOR EACH ROW BEGIN
  SELECT COUNT(*) INTO @countries_total FROM skyscanner.countries;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `flights`
--

DROP TABLE IF EXISTS `flights`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `flights` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `flight_number` varchar(5) NOT NULL COMMENT 'Номер рейса',
  `airport_from_id` bigint unsigned NOT NULL COMMENT 'Аэропорт вылета',
  `airport_to_id` bigint unsigned NOT NULL COMMENT 'Аэропорт прилёта',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`),
  KEY `index_of_flight_number` (`flight_number`),
  KEY `fk_flights_airport_from_id` (`airport_from_id`),
  KEY `fk_flights_airport_to_id` (`airport_to_id`),
  CONSTRAINT `fk_flights_airport_from_id` FOREIGN KEY (`airport_from_id`) REFERENCES `airports` (`id`),
  CONSTRAINT `fk_flights_airport_to_id` FOREIGN KEY (`airport_to_id`) REFERENCES `airports` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=cp1251 COMMENT='Справочник рейсов';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `flights`
--

LOCK TABLES `flights` WRITE;
/*!40000 ALTER TABLE `flights` DISABLE KEYS */;
INSERT INTO `flights` VALUES (1,'539',1,4),(2,'540',4,1),(3,'541',1,5),(4,'542',5,1),(5,'777',2,4),(6,'778',4,2);
/*!40000 ALTER TABLE `flights` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `flights_dates`
--

DROP TABLE IF EXISTS `flights_dates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `flights_dates` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `airline_flight_id` bigint unsigned NOT NULL COMMENT 'Рейс',
  `departure_time` datetime NOT NULL COMMENT 'Время отправление',
  `arrival_time` datetime NOT NULL COMMENT 'Время прибытия',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`),
  KEY `index_of_departure_time` (`departure_time`),
  KEY `index_of_arrival_time` (`arrival_time`),
  KEY `fk_fd_af_id` (`airline_flight_id`),
  CONSTRAINT `fk_fd_af_id` FOREIGN KEY (`airline_flight_id`) REFERENCES `airlines_flights` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=cp1251 COMMENT='Справочник рейсов по датам';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `flights_dates`
--

LOCK TABLES `flights_dates` WRITE;
/*!40000 ALTER TABLE `flights_dates` DISABLE KEYS */;
INSERT INTO `flights_dates` VALUES (1,1,'2021-01-01 14:30:00','2021-01-01 17:30:00'),(2,1,'2021-01-02 14:30:00','2021-01-02 17:30:00'),(3,1,'2021-01-05 14:30:00','2021-01-05 17:30:00'),(4,1,'2021-01-07 14:30:00','2021-01-07 17:30:00'),(5,2,'2021-01-01 20:30:00','2021-01-01 23:30:00'),(6,2,'2021-01-04 20:30:00','2021-01-04 23:30:00'),(7,2,'2021-01-06 20:30:00','2021-01-06 23:30:00'),(8,2,'2021-01-07 20:30:00','2021-01-07 23:30:00'),(9,3,'2021-01-01 15:15:00','2021-01-01 18:30:00'),(10,3,'2021-01-05 15:15:00','2021-01-05 18:30:00'),(11,4,'2021-01-02 09:35:00','2021-01-02 12:30:00'),(12,4,'2021-01-06 09:35:00','2021-01-06 12:30:00'),(13,5,'2021-01-01 08:05:00','2021-01-01 13:25:00'),(14,5,'2021-01-03 08:30:00','2021-01-03 13:50:00'),(15,5,'2021-01-05 08:05:00','2021-01-05 13:25:00'),(16,6,'2021-01-02 22:00:00','2021-01-03 01:00:00'),(17,6,'2021-01-04 22:00:00','2021-01-05 01:00:00'),(18,6,'2021-01-06 22:00:00','2021-01-07 01:00:00');
/*!40000 ALTER TABLE `flights_dates` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `flights_tickets`
--

DROP TABLE IF EXISTS `flights_tickets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `flights_tickets` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `retailers_flights_id` bigint unsigned NOT NULL COMMENT 'Рейс у продавца билетов',
  `ticket_class_id` bigint unsigned NOT NULL COMMENT 'Класс  билета',
  `price` decimal(11,2) NOT NULL COMMENT 'Цена',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`),
  KEY `fk_ft_rf_id` (`retailers_flights_id`),
  KEY `fk_ft_flight_id` (`ticket_class_id`),
  CONSTRAINT `fk_ft_flight_id` FOREIGN KEY (`ticket_class_id`) REFERENCES `tickets_classes` (`id`),
  CONSTRAINT `fk_ft_rf_id` FOREIGN KEY (`retailers_flights_id`) REFERENCES `retailers_flights` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=cp1251 COMMENT='Справочник цен на билеты у продавца';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `flights_tickets`
--

LOCK TABLES `flights_tickets` WRITE;
/*!40000 ALTER TABLE `flights_tickets` DISABLE KEYS */;
INSERT INTO `flights_tickets` VALUES (1,1,1,900.00),(2,2,1,1000.00),(3,3,2,1500.00),(4,4,2,1500.00),(5,5,1,1000.00),(6,6,1,1000.00),(7,7,2,1500.00),(8,8,1,900.00),(9,9,1,900.00),(10,10,2,3000.00),(11,11,2,3000.00);
/*!40000 ALTER TABLE `flights_tickets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `full_flight_info`
--

DROP TABLE IF EXISTS `full_flight_info`;
/*!50001 DROP VIEW IF EXISTS `full_flight_info`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `full_flight_info` AS SELECT 
 1 AS `flight_id`,
 1 AS `departure`,
 1 AS `airline`,
 1 AS `flight_number`,
 1 AS `city_from`,
 1 AS `airport_from`,
 1 AS `city_to`,
 1 AS `airport_to`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `retailers`
--

DROP TABLE IF EXISTS `retailers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `retailers` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL COMMENT 'Название продвца авиабилетов',
  `web_site` varchar(100) NOT NULL COMMENT 'Сайт продавца авиабилетов',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`),
  KEY `index_of_retailer_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=cp1251 COMMENT='Справочник продавцов авиабилетов';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `retailers`
--

LOCK TABLES `retailers` WRITE;
/*!40000 ALTER TABLE `retailers` DISABLE KEYS */;
INSERT INTO `retailers` VALUES (1,'Аэрофлот','https://www.aeroflot.ru/'),(2,'City.Travel','https://city.travel/'),(3,'Tickets.ru','https://tickets.ru/'),(4,'Pobeda','https://www.pobeda.aero/'),(5,'MEGO.travel','https://mego.travel/');
/*!40000 ALTER TABLE `retailers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `retailers_flights`
--

DROP TABLE IF EXISTS `retailers_flights`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `retailers_flights` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `retailer_id` bigint unsigned NOT NULL COMMENT 'Продавец билетов',
  `flight_id` bigint unsigned NOT NULL COMMENT 'Рейс',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`),
  KEY `fk_rf_retailer_id` (`retailer_id`),
  KEY `fk_rf_flight_id` (`flight_id`),
  CONSTRAINT `fk_rf_flight_id` FOREIGN KEY (`flight_id`) REFERENCES `flights_dates` (`id`),
  CONSTRAINT `fk_rf_retailer_id` FOREIGN KEY (`retailer_id`) REFERENCES `retailers` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=cp1251 COMMENT='Справочник наличия билетов на рейс у продавцов';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `retailers_flights`
--

LOCK TABLES `retailers_flights` WRITE;
/*!40000 ALTER TABLE `retailers_flights` DISABLE KEYS */;
INSERT INTO `retailers_flights` VALUES (1,1,1),(2,1,2),(3,2,1),(4,2,2),(5,3,1),(6,3,2),(7,1,3),(8,1,4),(9,3,5),(10,3,6),(11,5,5),(12,5,6);
/*!40000 ALTER TABLE `retailers_flights` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tickets_classes`
--

DROP TABLE IF EXISTS `tickets_classes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tickets_classes` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `class` varchar(20) DEFAULT NULL COMMENT 'Класс билета',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`),
  KEY `index_of_ticket_class` (`class`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=cp1251 COMMENT='Справочник классов билетов';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tickets_classes`
--

LOCK TABLES `tickets_classes` WRITE;
/*!40000 ALTER TABLE `tickets_classes` DISABLE KEYS */;
INSERT INTO `tickets_classes` VALUES (3,'Бизнес'),(1,'Промо'),(2,'Эконом');
/*!40000 ALTER TABLE `tickets_classes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Final view structure for view `airports_cities_countries`
--

/*!50001 DROP VIEW IF EXISTS `airports_cities_countries`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `airports_cities_countries` AS select `a`.`id` AS `airport_id`,`a`.`name` AS `airport_name`,`a`.`abbreviation` AS `airport_abbreviation`,(select `cities`.`name` from `cities` where (`cities`.`id` = `a`.`city_id`)) AS `city_id`,(select `cities`.`name` from `cities` where (`cities`.`id` = `a`.`city_id`)) AS `city_name`,(select `cities`.`country_id` from `cities` where (`cities`.`id` = `a`.`city_id`)) AS `country_id` from `airports` `a` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `full_flight_info`
--

/*!50001 DROP VIEW IF EXISTS `full_flight_info`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `full_flight_info` AS select `fd`.`id` AS `flight_id`,`fd`.`departure_time` AS `departure`,`al`.`name` AS `airline`,concat_ws(' ',`al`.`abbreviation`,`f`.`flight_number`) AS `flight_number`,(select `airports_cities_countries`.`city_name` from `airports_cities_countries` where (`airports_cities_countries`.`airport_id` = `f`.`airport_from_id`)) AS `city_from`,(select `airports_cities_countries`.`airport_abbreviation` from `airports_cities_countries` where (`airports_cities_countries`.`airport_id` = `f`.`airport_from_id`)) AS `airport_from`,(select `airports_cities_countries`.`city_name` from `airports_cities_countries` where (`airports_cities_countries`.`airport_id` = `f`.`airport_to_id`)) AS `city_to`,(select `airports_cities_countries`.`airport_abbreviation` from `airports_cities_countries` where (`airports_cities_countries`.`airport_id` = `f`.`airport_to_id`)) AS `airport_to` from (((`flights_dates` `fd` left join `airlines_flights` `af` on((`fd`.`airline_flight_id` = `af`.`flight_id`))) left join `flights` `f` on((`af`.`flight_id` = `f`.`id`))) left join `airlines` `al` on((`af`.`airline_id` = `al`.`id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2021-08-12 14:02:50
