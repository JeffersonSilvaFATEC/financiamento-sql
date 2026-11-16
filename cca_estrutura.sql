-- MySQL dump 10.13  Distrib 5.7.9, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: cca
-- ------------------------------------------------------
-- Server version	5.5.5-10.4.32-MariaDB

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
-- Table structure for table `agencias`
--

DROP TABLE IF EXISTS `agencias`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `agencias` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` varchar(30) NOT NULL,
  `codigo_ag` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `clientes`
--

DROP TABLE IF EXISTS `clientes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `clientes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` varchar(30) NOT NULL,
  `cpf` varchar(14) NOT NULL,
  `telefone` varchar(20) DEFAULT NULL,
  `programa` enum('MCMV','SBPE','EGI') NOT NULL,
  `modalidade` enum('AQ. TERRENO E CONSTRUCAO','CONST. TERRENO PROPRIO','USADO','NOVO') DEFAULT NULL,
  `valor_imovel` decimal(12,2) DEFAULT NULL,
  `valor_financiamento` decimal(12,2) DEFAULT NULL,
  `responsavel_atendimento` varchar(20) DEFAULT NULL,
  `usa_fgts` enum('SIM','NÃO') DEFAULT NULL,
  `pedido_vistoria` date DEFAULT NULL,
  `credenciado_vistoria` varchar(30) DEFAULT NULL,
  `retorno_vistoria` date DEFAULT NULL,
  `os` int(30) DEFAULT NULL,
  `observacoes` tinytext DEFAULT NULL,
  `agencia` char(4) DEFAULT NULL,
  `dt_assinatura` date DEFAULT NULL,
  `parceiro_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_cpf` (`cpf`),
  KEY `parceiro_id` (`parceiro_id`),
  KEY `idx_clientes_agencia` (`agencia`),
  CONSTRAINT `clientes_ibfk_1` FOREIGN KEY (`parceiro_id`) REFERENCES `parceiros` (`id`),
  CONSTRAINT `chk_valor_positivo` CHECK (`valor_financiamento` >= 0 and `valor_financiamento` >= 0),
  CONSTRAINT `chk_fin_valido` CHECK (`valor_financiamento` <= `valor_imovel`),
  CONSTRAINT `chk_vistoria_valida` CHECK (`retorno_vistoria` >= `pedido_vistoria`)
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `parceiros`
--

DROP TABLE IF EXISTS `parceiros`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `parceiros` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` varchar(30) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary view structure for view `vw_fin_por_faixa`
--

DROP TABLE IF EXISTS `vw_fin_por_faixa`;
/*!50001 DROP VIEW IF EXISTS `vw_fin_por_faixa`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `vw_fin_por_faixa` AS SELECT 
 1 AS `faixa`,
 1 AS `contagem`,
 1 AS `somatoria`*/;
SET character_set_client = @saved_cs_client;

--
-- Dumping events for database 'cca'
--

--
-- Dumping routines for database 'cca'
--

--
-- Final view structure for view `vw_fin_por_faixa`
--

/*!50001 DROP VIEW IF EXISTS `vw_fin_por_faixa`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_fin_por_faixa` AS select case when `clientes`.`valor_financiamento` is null then 'Sem valor' when `clientes`.`valor_financiamento` <= 200000 then '1 - Até 200mil' when `clientes`.`valor_financiamento` <= 400000 then '2 - Até 400mil' when `clientes`.`valor_financiamento` > 400000 then '3 - Acima 400mil' else 'Sem Valor' end AS `faixa`,count(0) AS `contagem`,sum(`clientes`.`valor_financiamento`) AS `somatoria` from `clientes` group by case when `clientes`.`valor_financiamento` is null then 'Sem valor' when `clientes`.`valor_financiamento` <= 200000 then '1 - Até 200mil' when `clientes`.`valor_financiamento` <= 400000 then '2 - Até 400mil' when `clientes`.`valor_financiamento` > 400000 then '3 - Acima 400mil' else 'Sem Valor' end */;
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

-- Dump completed on 2026-11-16 19:25:36
