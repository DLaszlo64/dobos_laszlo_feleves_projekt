-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Gép: 127.0.0.1:3307
-- Létrehozás ideje: 2026. Nov 27. 10:16
-- Kiszolgáló verziója: 10.4.28-MariaDB
-- PHP verzió: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Adatbázis: `the_united_flame`
--
CREATE DATABASE IF NOT EXISTS `the_united_flame` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_hungarian_ci;
USE `the_united_flame`;

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `coach`
--

CREATE TABLE `coach` (
  `COACH_ID` int(11) NOT NULL,
  `USER_ID` int(11) NOT NULL,
  `TEAM_ID` int(11) DEFAULT NULL,
  `GAMER_ID` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_hungarian_ci;

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `games`
--

CREATE TABLE `games` (
  `GAME_ID` int(11) NOT NULL,
  `GAMENAME` varchar(100) NOT NULL,
  `DEVELOPER` varchar(100) NOT NULL,
  `STYLE` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_hungarian_ci;

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `team`
--

CREATE TABLE `team` (
  `TEAM_ID` int(11) NOT NULL,
  `TEAMNAME` varchar(100) NOT NULL,
  `RANK` varchar(50) DEFAULT NULL,
  `GAME_ID` int(11) NOT NULL,
  `USER_ID` int(11) NOT NULL,
  `COACH_ID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_hungarian_ci;

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `team_members`
--

CREATE TABLE `team_members` (
  `TEAM_ID` int(11) NOT NULL,
  `GAME_ID` int(11) NOT NULL,
  `USER_ID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_hungarian_ci;

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `user`
--

CREATE TABLE `user` (
  `USER_ID` int(11) NOT NULL,
  `USERNAME` varchar(50) NOT NULL,
  `FIRSTNAME` varchar(50) NOT NULL,
  `LASTNAME` varchar(50) NOT NULL,
  `E-MAIL` varchar(100) NOT NULL,
  `PHONE` varchar(20) DEFAULT NULL,
  `COUNTRY` varchar(50) NOT NULL,
  `PASSWORD` varchar(255) NOT NULL,
  `GAME_ID` int(11) DEFAULT NULL,
  `TEAM_ID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_hungarian_ci;

--
-- Indexek a kiírt táblákhoz
--

--
-- A tábla indexei `coach`
--
ALTER TABLE `coach`
  ADD PRIMARY KEY (`COACH_ID`),
  ADD KEY `FK_COACH_USER` (`USER_ID`),
  ADD KEY `FK_COACH_TEAM` (`TEAM_ID`);

--
-- A tábla indexei `games`
--
ALTER TABLE `games`
  ADD PRIMARY KEY (`GAME_ID`),
  ADD UNIQUE KEY `UQ_GAMES_GAMENAME` (`GAMENAME`);

--
-- A tábla indexei `team`
--
ALTER TABLE `team`
  ADD PRIMARY KEY (`TEAM_ID`),
  ADD UNIQUE KEY `UQ_TEAM_TEAMNAME` (`TEAMNAME`),
  ADD KEY `FK_TEAM_GAME` (`GAME_ID`),
  ADD KEY `FK_TEAM_CAPTAIN` (`USER_ID`),
  ADD KEY `FK_TEAM_COACH` (`COACH_ID`);

--
-- A tábla indexei `team_members`
--
ALTER TABLE `team_members`
  ADD PRIMARY KEY (`TEAM_ID`,`USER_ID`),
  ADD KEY `FK_TM_GAME` (`GAME_ID`),
  ADD KEY `FK_TM_USER` (`USER_ID`);

--
-- A tábla indexei `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`USER_ID`),
  ADD UNIQUE KEY `UQ_USER_USERNAME` (`USERNAME`),
  ADD UNIQUE KEY `UQ_USER_EMAIL` (`E-MAIL`),
  ADD KEY `FK_USER_GAME` (`GAME_ID`),
  ADD KEY `FK_USER_TEAM` (`TEAM_ID`);

--
-- A kiírt táblák AUTO_INCREMENT értéke
--

--
-- AUTO_INCREMENT a táblához `coach`
--
ALTER TABLE `coach`
  MODIFY `COACH_ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT a táblához `games`
--
ALTER TABLE `games`
  MODIFY `GAME_ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT a táblához `team`
--
ALTER TABLE `team`
  MODIFY `TEAM_ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT a táblához `user`
--
ALTER TABLE `user`
  MODIFY `USER_ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- Megkötések a kiírt táblákhoz
--

--
-- Megkötések a táblához `coach`
--
ALTER TABLE `coach`
  ADD CONSTRAINT `FK_COACH_TEAM` FOREIGN KEY (`TEAM_ID`) REFERENCES `team` (`TEAM_ID`) ON DELETE SET NULL,
  ADD CONSTRAINT `FK_COACH_USER` FOREIGN KEY (`USER_ID`) REFERENCES `user` (`USER_ID`) ON DELETE CASCADE;

--
-- Megkötések a táblához `team`
--
ALTER TABLE `team`
  ADD CONSTRAINT `FK_TEAM_CAPTAIN` FOREIGN KEY (`USER_ID`) REFERENCES `user` (`USER_ID`),
  ADD CONSTRAINT `FK_TEAM_COACH` FOREIGN KEY (`COACH_ID`) REFERENCES `coach` (`COACH_ID`) ON DELETE SET NULL,
  ADD CONSTRAINT `FK_TEAM_GAME` FOREIGN KEY (`GAME_ID`) REFERENCES `games` (`GAME_ID`);

--
-- Megkötések a táblához `team_members`
--
ALTER TABLE `team_members`
  ADD CONSTRAINT `FK_TM_GAME` FOREIGN KEY (`GAME_ID`) REFERENCES `games` (`GAME_ID`),
  ADD CONSTRAINT `FK_TM_TEAM` FOREIGN KEY (`TEAM_ID`) REFERENCES `team` (`TEAM_ID`) ON DELETE CASCADE,
  ADD CONSTRAINT `FK_TM_USER` FOREIGN KEY (`USER_ID`) REFERENCES `user` (`USER_ID`) ON DELETE CASCADE;

--
-- Megkötések a táblához `user`
--
ALTER TABLE `user`
  ADD CONSTRAINT `FK_USER_GAME` FOREIGN KEY (`GAME_ID`) REFERENCES `games` (`GAME_ID`) ON DELETE SET NULL,
  ADD CONSTRAINT `FK_USER_TEAM` FOREIGN KEY (`TEAM_ID`) REFERENCES `team` (`TEAM_ID`) ON DELETE SET NULL;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
