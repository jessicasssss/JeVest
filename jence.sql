-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Sep 07, 2025 at 10:29 AM
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
-- Database: `jence`
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

--
-- Dumping data for table `msbudget`
--

INSERT INTO `msbudget` (`id`, `userid`, `month`, `amount`, `remaining`) VALUES
(3, 1, '2025-09', 0.00, 0.00),
(4, 3, '2025-09', 800000.00, 800000.00),
(5, 4, '2025-09', 0.00, 0.00),
(7, 11, '2025-09', 0.00, 0.00),
(8, 12, '2025-09', 9000000.00, 8961400.00);

-- --------------------------------------------------------

--
-- Table structure for table `mscategory`
--

CREATE TABLE `mscategory` (
  `id` int(11) NOT NULL,
  `category` varchar(100) NOT NULL,
  `type` enum('expense','income') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `mscategory`
--

INSERT INTO `mscategory` (`id`, `category`, `type`) VALUES
(1, 'Food & Beverage', 'expense'),
(2, 'Transportation', 'expense'),
(3, 'Entertainment', 'expense'),
(4, 'Bills & Utilities', 'expense'),
(5, 'Shopping', 'expense'),
(6, 'Health', 'expense'),
(7, 'Education', 'expense'),
(8, 'Others', 'expense'),
(9, 'Salary', 'income'),
(10, 'Bonus', 'income'),
(11, 'Investment', 'income'),
(12, 'Gift', 'income'),
(13, 'Others', 'income');

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
  `note` text DEFAULT NULL,
  `remaining_after` decimal(15,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `mstransaction`
--

INSERT INTO `mstransaction` (`id`, `userid`, `date`, `categoryid`, `amount`, `note`, `remaining_after`) VALUES
(1, 3, '2025-08-01', 8, 1200000.00, 'Beli sepatu baru Puma Bella', 4800000.00),
(2, 3, '2025-08-08', 5, 143000.00, 'Earbuds Anker', 4657000.00),
(3, 3, '2025-09-02', 3, 50000.00, 'Netflix', 9950000.00),
(4, 3, '2025-09-01', 6, 100000.00, 'Tambal gigi', 9850000.00),
(5, 3, '2025-09-02', 3, 100000.00, 'Mala', 9750000.00),
(6, 3, '2025-09-09', 1, 100000.00, 'mala pt.2', 9650000.00),
(7, 3, '2025-09-02', 9, 1000000.00, 'Magang', 9650000.00),
(8, 3, '2025-09-02', 10, 200000.00, 'Saham', 9650000.00),
(9, 3, '2025-09-02', 9, 100000.00, 'saham', 9650000.00),
(10, 3, '2025-09-02', 9, 100000.00, 'sahammmm', 9650000.00),
(11, 3, '2025-09-02', 9, 100000.00, 'sahammmm', 9650000.00),
(12, 3, '2025-09-02', 9, 100000.00, 'sahammmm', 0.00),
(13, 3, '2025-09-02', 9, 100000.00, 'sahammmm', 100000.00),
(14, 3, '2025-09-02', 9, 100000.00, 'sahammmm', 200000.00),
(15, 3, '2025-09-02', 12, 20000.00, 'YEY', 9670000.00),
(16, 3, '2025-09-02', 2, 27500.00, 'gojek dari bca ke rumah', 9642500.00),
(21, 12, '2025-09-06', 2, 138600.00, 'CGK to Home', 10661400.00),
(22, 12, '2025-09-06', 12, 100000.00, 'Birthday Gift', 10761400.00);

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
(3, 'Jessica', 'test1@gmail.com', '$2b$10$m36P0ZdqMETFRmL9Sw9dJuaOjSLXVNATYne.SCHKHAnla8j29OC.y', 0),
(4, 'sejj', 'test2', '$2b$10$/FMgobLY/xeF3pTFMq/Si.MLlwhaqnKrAH08QIZy0StyZHb1D20qe', 0),
(11, 'jesbell', '2005jessicabella@gmail.com', '$2b$10$9YMcT0hG1schsEkUevhJsOgfCuAIokZuxcAjbbL9wx14UDag1UdU6', 0),
(12, 'JESBEL', 'bellsjs2005@gmail.com', '$2b$10$jkTZalQb2eVkNxCzWKsL7ujq4LtXBQYrGUyclYO4x./HPGfsSWMqK', 0);

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `mscategory`
--
ALTER TABLE `mscategory`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `mstransaction`
--
ALTER TABLE `mstransaction`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT for table `msuser`
--
ALTER TABLE `msuser`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

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
