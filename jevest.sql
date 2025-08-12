-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Aug 12, 2025 at 10:17 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `jevest`
--

-- --------------------------------------------------------

--
-- Table structure for table `msbudget`
--

CREATE TABLE `msbudget` (
  `id` int(11) NOT NULL,
  `userid` int(11) NOT NULL,
  `month` char(7) NOT NULL,
  `amount` decimal(15,2) NOT NULL,
  `remaining` decimal(15,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `mscategory`
--

CREATE TABLE `mscategory` (
  `id` int(11) NOT NULL,
  `category` varchar(100) NOT NULL,
  `type` enum('expense','income') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `mstransaction`
--

CREATE TABLE `mstransaction` (
  `id` int(11) NOT NULL,
  `userid` int(11) NOT NULL,
  `date` date NOT NULL,
  `categoryid` int(11) DEFAULT NULL,
  `amount` decimal(15,2) NOT NULL,
  `note` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `msuser`
--

CREATE TABLE `msuser` (
  `id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `useremail` varchar(150) NOT NULL,
  `userpassword` varchar(100) NOT NULL,
  `isloggedin` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `msuser`
--

INSERT INTO `msuser` (`id`, `username`, `useremail`, `userpassword`, `isloggedin`) VALUES
(1, 'jess', 'test', '12345678', 0),
(3, 'jess', 'test1', '$2b$10$JyFhIdiK2Ggr8OHP44ycOOhSaKAwgBI1L1VHxykIguH.xs.uNRMt6', 0),
(4, 'sejj', 'test2', '$2b$10$/FMgobLY/xeF3pTFMq/Si.MLlwhaqnKrAH08QIZy0StyZHb1D20qe', 0);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `msbudget`
--
ALTER TABLE `msbudget`
  ADD PRIMARY KEY (`id`),
  ADD KEY `userid` (`userid`);

--
-- Indexes for table `mscategory`
--
ALTER TABLE `mscategory`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `mstransaction`
--
ALTER TABLE `mstransaction`
  ADD PRIMARY KEY (`id`),
  ADD KEY `userid` (`userid`),
  ADD KEY `categoryid` (`categoryid`);

--
-- Indexes for table `msuser`
--
ALTER TABLE `msuser`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `useremail` (`useremail`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `msbudget`
--
ALTER TABLE `msbudget`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `mscategory`
--
ALTER TABLE `mscategory`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `mstransaction`
--
ALTER TABLE `mstransaction`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `msuser`
--
ALTER TABLE `msuser`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `msbudget`
--
ALTER TABLE `msbudget`
  ADD CONSTRAINT `msbudget_ibfk_1` FOREIGN KEY (`userid`) REFERENCES `msuser` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `mstransaction`
--
ALTER TABLE `mstransaction`
  ADD CONSTRAINT `mstransaction_ibfk_1` FOREIGN KEY (`userid`) REFERENCES `msuser` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `mstransaction_ibfk_2` FOREIGN KEY (`categoryid`) REFERENCES `mscategory` (`id`) ON DELETE SET NULL;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
