-- phpMyAdmin SQL Dump
-- version 4.5.1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Aug 07, 2017 at 04:14 AM
-- Server version: 10.1.8-MariaDB
-- PHP Version: 5.6.14

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `dbujian`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `createPeserta` (IN `nm_peserta` VARCHAR(50))  BEGIN
insert into tbpeserta (nm_peserta) VALUE (nm_peserta);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `createPesertaUjian` (IN `id_ujian` VARCHAR(7), IN `id_peserta` INT(11))  BEGIN
insert into tbpeserta_ujian (id_ujian,id_peserta) values (id_ujian,id_peserta);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `createSoal` (IN `nm_soal` VARCHAR(750), IN `jawaban` VARCHAR(5), OUT `hasil` VARCHAR(9))  BEGIN
declare id_soal varchar(7);
declare id_pg varchar(9);
set id_soal= genIdSoal();
set id_pg = concat('PG',id_soal);
insert into tbsoal values(id_soal,nm_soal,id_pg,jawaban);
select id_pg into hasil;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `createSoalUjian` (IN `id_ujian` VARCHAR(7), IN `id_soal` VARCHAR(7))  BEGIN
insert into tbsoal_ujian(id_ujian,id_soal) values(id_ujian,id_soal);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `createUjian` (IN `nm_ujian` VARCHAR(30))  BEGIN
declare id varchar(7);
set id = genIdUjian();
INSERT into tbujian values (id,nm_ujian);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `deletePeserta` (IN `id` INT(11))  BEGIN
delete from tbpeserta where id_peserta=id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `deletePesertaUjian` (IN `id_pu` INT(11))  BEGIN
delete from tbpeserta_ujian where id=id_pu;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteSoal` (IN `id` VARCHAR(7))  BEGIN
declare id_pg varchar(9);
set id_pg=CONCAT('PG',id);
delete from tbsoal where id_soal=id;
delete from tbpilihan_ganda where id_pilihan_ganda=id_pg;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteSoalUjian` (IN `id_ujian` INT(11))  BEGIN
delete from tbsoal_ujian where id=id_ujian;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteUjian` (IN `id` INT(11))  BEGIN
delete from tbujian where id_ujian=id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getNotPesertaUjian` (IN `id` VARCHAR(7))  BEGIN
select * from tbpeserta where id_peserta not in (select id_peserta from tbpeserta_ujian where id_ujian=id);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getNotSoalUjian` (IN `id` VARCHAR(7))  BEGIN
select * from tbsoal where id_soal not in (select id_soal from tbsoal_ujian where id_ujian=id);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getPeserta` (IN `id` INT(11))  BEGIN
if(id = 0) then select * from tbpeserta;
else select * from tbpeserta where id_peserta=id;
end if;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getPesertaUjian` (IN `id` VARCHAR(7), IN `id_peserta` INT)  BEGIN
CASE
when(id_peserta = 0) then
select tbpeserta_ujian.id,tbpeserta_ujian.id_peserta,tbpeserta.nm_peserta,tbpeserta_ujian.status from tbpeserta_ujian left join tbpeserta on tbpeserta_ujian.id_peserta=tbpeserta.id_peserta where tbpeserta_ujian.id_ujian=id;
ELSE
select tbpeserta_ujian.id,tbpeserta_ujian.id_peserta,tbpeserta.nm_peserta,tbpeserta_ujian.status from tbpeserta_ujian left join tbpeserta on tbpeserta_ujian.id_peserta=tbpeserta.id_peserta where tbpeserta_ujian.id_ujian=id and tbpeserta_ujian.id_peserta=id_peserta;
end case;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getSoal` (IN `id` VARCHAR(7))  BEGIN
if(id = "0000000") THEN select * from tbsoal;
else select * from tbsoal where id_soal=id;
end if;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getSoalUjian` (IN `id_su` CHAR(7))  BEGIN
select * from tbsoal_ujian inner join tbsoal on tbsoal_ujian.id_soal=tbsoal.id_soal and tbsoal_ujian.id_ujian=id_su;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getUjian` (IN `id` VARCHAR(7))  BEGIN
if(id = '0000000') then SELECT * FROM tbujian;
else SELECT * from tbujian where id_ujian=id;
END iF;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `updatePeserta` (IN `id` INT(11), `nm_peserta` VARCHAR(30))  BEGIN
update tbpeserta set nm_peserta=nm_peserta where id_peserta=id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `updatePesertaUjian` (IN `id` INT(11), IN `id_peserta` INT(11), IN `id_ujian` VARCHAR(7))  BEGIN
update tbpeserta_ujian set id_peserta=id_peserta,id_ujian=id_ujian where id=id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `updateSoal` (IN `id` VARCHAR(7), IN `soal` VARCHAR(750), IN `jawaban` VARCHAR(5))  BEGIN
declare id_pg varchar(9);
set id_pg = concat('PG',id);
update tbsoal set isi_soal=soal,jawaban=jawaban where id_soal=id;
delete from tbpilihan_ganda where id_pilihan_ganda=id_pg;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `updateUjian` (IN `id` VARCHAR(7), IN `nm_ujian` VARCHAR(30))  BEGIN
UPDATE tbujian set nm_ujian=nm_ujian WHERE id_ujian=id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getPesertaUjianOLD` (IN `id_ujian` VARCHAR(7), IN `id_peserta` INT(11))  BEGIN
CASE
when(id_peserta = 0 AND id_ujian !='0000000') then select * from tbpeserta_ujian left join tbujian on tbpeserta_ujian.id_ujian=tbujian.id_ujian left join tbpeserta on tbpeserta_ujian.id_peserta=tbpeserta.id_peserta where tbpeserta_ujian.id_ujian=tbujian.id_ujian;

when(id_peserta != 0 AND  id_ujian='0000000') then select * from tbpeserta_ujian left join tbujian on tbpeserta_ujian.id_ujian=tbujian.id_ujian left join tbpeserta on tbpeserta_ujian.id_peserta=tbpeserta.id_peserta WHERE tbpeserta_ujian.id_peserta=id_peserta;

when(id_peserta = 0 AND  id_ujian='0000000') then select * from tbpeserta_ujian left join tbujian on tbpeserta_ujian.id_ujian=tbujian.id_ujian left join tbpeserta on tbpeserta_ujian.id_peserta=tbpeserta.id_peserta;
else select * from tbpeserta_ujian left join tbujian on tbpeserta_ujian.id_ujian=tbujian.id_ujian left join tbpeserta on tbpeserta_ujian.id_peserta=tbpeserta.id_peserta where tbpeserta_ujian.id_ujian=id_ujian and tbpeserta_ujian.id_peserta=id_peserta;
end case;
END$$

--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `genIdLjk` () RETURNS VARCHAR(7) CHARSET latin1 BEGIN
declare id_tmp int;
SELECT max(id_ljk) into id_tmp from tbljk_ujian;
if(id_tmp IS NULL) then set id_tmp=1;
else set id_tmp=id_tmp+1;
end if;
CASE
when (id_tmp <= 9 ) then RETURN CONCAT('000000',id_tmp);
when (id_tmp >= 10 AND id_tmp <= 99 ) then RETURN CONCAT('00000',id_tmp);
when (id_tmp >= 100 AND id_tmp <= 999 ) then RETURN CONCAT('0000',id_tmp);
when (id_tmp >= 1000 AND id_tmp <= 9999 ) then RETURN CONCAT('000',id_tmp);
when (id_tmp >= 10000 AND id_tmp <= 99999 ) then RETURN CONCAT('00',id_tmp);
when (id_tmp >= 100000 AND id_tmp <= 999999 ) then RETURN CONCAT('0',id_tmp);
ELSE RETURN id_tmp;
END CASE;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `genIdSoal` () RETURNS VARCHAR(7) CHARSET latin1 BEGIN
declare id_tmp int;
SELECT max(id_soal) into id_tmp from tbsoal;
if(id_tmp IS NULL) then set id_tmp=1;
else SET id_tmp=id_tmp+1;
end if;
CASE
when (id_tmp <= 9 ) then RETURN CONCAT('000000',id_tmp);
when (id_tmp >= 10 AND id_tmp <= 99 ) then RETURN CONCAT('00000',id_tmp);
when (id_tmp >= 100 AND id_tmp <= 999 ) then RETURN CONCAT('0000',id_tmp);
when (id_tmp >= 1000 AND id_tmp <= 9999 ) then RETURN CONCAT('000',id_tmp);
when (id_tmp >= 10000 AND id_tmp <= 99999 ) then RETURN CONCAT('00',id_tmp);
when (id_tmp >= 100000 AND id_tmp <= 999999 ) then RETURN CONCAT('0',id_tmp);
ELSE RETURN id_tmp;
END CASE;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `genIdUjian` () RETURNS VARCHAR(7) CHARSET latin1 BEGIN
declare id_tmp int;
SELECT max(id_ujian) into id_tmp from tbujian;
if(id_tmp IS NULL) then set id_tmp=1;
else SET id_tmp=id_tmp+1;
end if;
CASE
when (id_tmp <= 9 ) then RETURN CONCAT('000000',id_tmp);
when (id_tmp >= 10 AND id_tmp <= 99 ) then RETURN CONCAT('00000',id_tmp);
when (id_tmp >= 100 AND id_tmp <= 999 ) then RETURN CONCAT('0000',id_tmp);
when (id_tmp >= 1000 AND id_tmp <= 9999 ) then RETURN CONCAT('000',id_tmp);
when (id_tmp >= 10000 AND id_tmp <= 99999 ) then RETURN CONCAT('00',id_tmp);
when (id_tmp >= 100000 AND id_tmp <= 999999 ) then RETURN CONCAT('0',id_tmp);
ELSE RETURN id_tmp;
END CASE;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `tbhasil_ujian`
--

CREATE TABLE `tbhasil_ujian` (
  `id_hasil` int(11) NOT NULL,
  `id_ujian` int(11) NOT NULL,
  `id_peserta` int(11) NOT NULL,
  `betul` int(3) NOT NULL,
  `salah` int(3) NOT NULL,
  `nilai` int(4) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `tbjawaban_ljk`
--

CREATE TABLE `tbjawaban_ljk` (
  `id` int(11) NOT NULL,
  `id_jawaban_ljk` varchar(9) NOT NULL,
  `id_soal` varchar(7) NOT NULL,
  `jawaban` varchar(5) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `tbljk_ujian`
--

CREATE TABLE `tbljk_ujian` (
  `id_ljk` varchar(7) NOT NULL,
  `id_ujian` varchar(7) NOT NULL,
  `id_peserta` int(11) NOT NULL,
  `id_jawaban_ljk` varchar(9) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `tbpeserta`
--

CREATE TABLE `tbpeserta` (
  `id_peserta` int(11) NOT NULL,
  `nm_peserta` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tbpeserta`
--

INSERT INTO `tbpeserta` (`id_peserta`, `nm_peserta`) VALUES
(1, 'Semvak Anoa'),
(2, 'Peserta Baru');

-- --------------------------------------------------------

--
-- Table structure for table `tbpeserta_ujian`
--

CREATE TABLE `tbpeserta_ujian` (
  `id` int(11) NOT NULL,
  `id_peserta` int(11) NOT NULL,
  `id_ujian` varchar(7) NOT NULL,
  `status` enum('Sudah','Belum') NOT NULL DEFAULT 'Belum'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tbpeserta_ujian`
--

INSERT INTO `tbpeserta_ujian` (`id`, `id_peserta`, `id_ujian`, `status`) VALUES
(1, 1, '0000001', 'Belum'),
(2, 2, '0000001', 'Belum');

-- --------------------------------------------------------

--
-- Table structure for table `tbpilihan_ganda`
--

CREATE TABLE `tbpilihan_ganda` (
  `id` int(11) NOT NULL,
  `id_pilihan_ganda` varchar(9) NOT NULL,
  `huruf` varchar(5) NOT NULL,
  `isi_pilihan` varchar(300) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tbpilihan_ganda`
--

INSERT INTO `tbpilihan_ganda` (`id`, `id_pilihan_ganda`, `huruf`, `isi_pilihan`) VALUES
(36, 'PG0000008', 'A', 'Hiperteks markup language'),
(37, 'PG0000008', 'B', 'Hypertex Markup Language'),
(38, 'PG0000008', 'C', 'Hypertext Markup Language'),
(43, 'PG0000010', 'A', 'Firefly'),
(44, 'PG0000010', 'B', 'Jagdpanzer'),
(45, 'PG0000010', 'C', 'Churchil'),
(46, 'PG0000010', 'D', 'Sherman'),
(47, 'PG0000010', 'E', 'Jumbo'),
(48, 'PG0000011', 'A', '45mm'),
(49, 'PG0000011', 'B', '76.2mm'),
(50, 'PG0000011', 'C', '88mm'),
(51, 'PG0000011', 'D', '105mm'),
(52, 'PG0000012', 'A', 'Tiger II'),
(53, 'PG0000012', 'B', 'Jagdpanther'),
(54, 'PG0000012', 'C', 'T26E3'),
(55, 'PG0000012', 'D', 'JS-2'),
(56, 'PG0000013', 'A', 'High Explosive Anti-Tank'),
(57, 'PG0000013', 'B', 'High Endurance Anti-Tank'),
(58, 'PG0000013', 'C', 'High Explosive Anti-Torsion'),
(64, 'PG0000015', 'A', '7.5cm kwk40L/48'),
(65, 'PG0000015', 'B', '7.5cm kwk42L/70'),
(66, 'PG0000015', 'C', '8.8cm kwk36L/56'),
(67, 'PG0000015', 'D', '8.8cm flak'),
(68, 'PG0000016', 'A', 'Armour Piercing Composite Rigid'),
(69, 'PG0000016', 'B', 'Armour Point Complex Reaction'),
(70, 'PG0000016', 'C', 'Agregate Point Compound Run');

-- --------------------------------------------------------

--
-- Table structure for table `tbsoal`
--

CREATE TABLE `tbsoal` (
  `id_soal` varchar(7) NOT NULL,
  `isi_soal` varchar(750) NOT NULL,
  `id_pilihan_ganda` varchar(9) NOT NULL,
  `jawaban` varchar(5) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tbsoal`
--

INSERT INTO `tbsoal` (`id_soal`, `isi_soal`, `id_pilihan_ganda`, `jawaban`) VALUES
('0000008', 'Kepanjangan dari HTML adalah ?', 'PG0000008', 'C'),
('0000010', 'Nama panggilan untuk tank perang dunia ke II milik Amerika Serikat M4 yaitu ?', 'PG0000010', 'D'),
('0000011', 'Kaliber peluru dari tank T-34 (1942) milik Rusia pada perang dunia ke II adalah?', 'PG0000011', 'B'),
('0000012', 'Salah satu MBT (Main Battle Tank) milik Russia pada perang dunia ke II adalah ?', 'PG0000012', 'D'),
('0000013', 'Kepanjangan HEAT dalam istilah tank adalah ?', 'PG0000013', 'A'),
('0000015', 'Jenis peluru (armament) yang digunakan tank Jerman Panther adalah?', 'PG0000015', 'B'),
('0000016', 'Kepanjangan dari APCR adalah ?', 'PG0000016', 'A');

-- --------------------------------------------------------

--
-- Table structure for table `tbsoal_ujian`
--

CREATE TABLE `tbsoal_ujian` (
  `id` int(11) NOT NULL,
  `id_ujian` varchar(7) NOT NULL,
  `id_soal` varchar(7) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tbsoal_ujian`
--

INSERT INTO `tbsoal_ujian` (`id`, `id_ujian`, `id_soal`) VALUES
(2, '0000001', '0000012'),
(3, '0000001', '0000011'),
(4, '0000001', '0000010'),
(5, '0000001', '0000015'),
(6, '0000001', '0000013'),
(7, '0000002', '0000008');

-- --------------------------------------------------------

--
-- Table structure for table `tbujian`
--

CREATE TABLE `tbujian` (
  `id_ujian` varchar(7) NOT NULL,
  `nm_ujian` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tbujian`
--

INSERT INTO `tbujian` (`id_ujian`, `nm_ujian`) VALUES
('0000001', 'WWII'),
('0000002', 'TI');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `tbhasil_ujian`
--
ALTER TABLE `tbhasil_ujian`
  ADD PRIMARY KEY (`id_hasil`);

--
-- Indexes for table `tbjawaban_ljk`
--
ALTER TABLE `tbjawaban_ljk`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbljk_ujian`
--
ALTER TABLE `tbljk_ujian`
  ADD PRIMARY KEY (`id_ljk`);

--
-- Indexes for table `tbpeserta`
--
ALTER TABLE `tbpeserta`
  ADD PRIMARY KEY (`id_peserta`);

--
-- Indexes for table `tbpeserta_ujian`
--
ALTER TABLE `tbpeserta_ujian`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbpilihan_ganda`
--
ALTER TABLE `tbpilihan_ganda`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbsoal`
--
ALTER TABLE `tbsoal`
  ADD PRIMARY KEY (`id_soal`);

--
-- Indexes for table `tbsoal_ujian`
--
ALTER TABLE `tbsoal_ujian`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbujian`
--
ALTER TABLE `tbujian`
  ADD PRIMARY KEY (`id_ujian`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `tbhasil_ujian`
--
ALTER TABLE `tbhasil_ujian`
  MODIFY `id_hasil` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `tbjawaban_ljk`
--
ALTER TABLE `tbjawaban_ljk`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `tbpeserta`
--
ALTER TABLE `tbpeserta`
  MODIFY `id_peserta` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
--
-- AUTO_INCREMENT for table `tbpeserta_ujian`
--
ALTER TABLE `tbpeserta_ujian`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT for table `tbpilihan_ganda`
--
ALTER TABLE `tbpilihan_ganda`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=71;
--
-- AUTO_INCREMENT for table `tbsoal_ujian`
--
ALTER TABLE `tbsoal_ujian`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
