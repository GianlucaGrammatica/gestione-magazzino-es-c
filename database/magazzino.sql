-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Creato il: Mar 05, 2026 alle 09:41
-- Versione del server: 10.4.28-MariaDB
-- Versione PHP: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `magazzino`
--
CREATE DATABASE IF NOT EXISTS `magazzino` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `magazzino`;

-- --------------------------------------------------------

--
-- Struttura della tabella `avvisi_riordino`
--

DROP TABLE IF EXISTS `avvisi_riordino`;
CREATE TABLE IF NOT EXISTS `avvisi_riordino` (
  `idAvviso` int(11) NOT NULL AUTO_INCREMENT,
  `sku_prodotto` varchar(80) DEFAULT NULL,
  `quantita_attuale` int(11) DEFAULT NULL,
  `soglia_superata` int(11) DEFAULT NULL,
  `data_avviso` timestamp NOT NULL DEFAULT current_timestamp(),
  `stato` enum('da_gestire','ordinato','chiuso') DEFAULT 'da_gestire',
  PRIMARY KEY (`idAvviso`),
  KEY `sku_prodotto` (`sku_prodotto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struttura della tabella `fornitore`
--

DROP TABLE IF EXISTS `fornitore`;
CREATE TABLE IF NOT EXISTS `fornitore` (
  `nome` int(11) NOT NULL,
  `uid` varchar(85) NOT NULL,
  `indirizzo` text NOT NULL,
  `identificativo_statale` int(11) NOT NULL,
  PRIMARY KEY (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struttura della tabella `movimento`
--

DROP TABLE IF EXISTS `movimento`;
CREATE TABLE IF NOT EXISTS `movimento` (
  `sku` varchar(80) NOT NULL,
  `idMov` int(11) NOT NULL AUTO_INCREMENT,
  `tipo` enum('CARICO','SCARICO','IN ATTESA') NOT NULL,
  `quantita` int(11) NOT NULL,
  `dataOra` date NOT NULL DEFAULT current_timestamp(),
  `causale` text NOT NULL,
  PRIMARY KEY (`idMov`),
  UNIQUE KEY `idMov` (`idMov`),
  KEY `sku` (`sku`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struttura della tabella `prodotto`
--

DROP TABLE IF EXISTS `prodotto`;
CREATE TABLE IF NOT EXISTS `prodotto` (
  `sku` varchar(80) NOT NULL,
  `uid_fornitore` varchar(85) NOT NULL,
  `nome` varchar(80) NOT NULL,
  `quantitaDisponibile` int(11) NOT NULL DEFAULT 0,
  `sogliaRiordino` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`sku`),
  UNIQUE KEY `sku` (`sku`),
  KEY `uid_fornitore` (`uid_fornitore`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Trigger `prodotto`
--
DROP TRIGGER IF EXISTS `avviso_riordino`;
DELIMITER $$
CREATE TRIGGER `avviso_riordino` AFTER UPDATE ON `prodotto` FOR EACH ROW BEGIN

    IF NEW.quantitaDisponibile < NEW.sogliaRiordino THEN
        
        INSERT INTO avvisi_riordino (sku_prodotto, quantita_attuale, soglia_superata)
        VALUES (NEW.sku, NEW.quantitaDisponibile, NEW.sogliaRiordino);
        
    END IF;
END
$$
DELIMITER ;

--
-- Limiti per le tabelle scaricate
--

--
-- Limiti per la tabella `avvisi_riordino`
--
ALTER TABLE `avvisi_riordino`
  ADD CONSTRAINT `avvisi_riordino_ibfk_1` FOREIGN KEY (`sku_prodotto`) REFERENCES `prodotto` (`sku`);

--
-- Limiti per la tabella `movimento`
--
ALTER TABLE `movimento`
  ADD CONSTRAINT `movimento_ibfk_1` FOREIGN KEY (`sku`) REFERENCES `prodotto` (`sku`);

--
-- Limiti per la tabella `prodotto`
--
ALTER TABLE `prodotto`
  ADD CONSTRAINT `prodotto_ibfk_1` FOREIGN KEY (`uid_fornitore`) REFERENCES `fornitore` (`uid`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
