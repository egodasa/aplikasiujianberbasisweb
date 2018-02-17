-- phpMyAdmin SQL Dump
-- version 4.5.1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Aug 06, 2017 at 01:29 PM
-- Server version: 10.1.8-MariaDB
-- PHP Version: 5.6.14

-- ALASAN BACKUP DATABASE 6 AGUSTUS 2017 1130
-- PERUBAHAN STRUKTUR TABEL TBSOAL_UJIAN MENJADI SERUPA DENGAN STRUKTUR TABEL TBPESERTA_UJIAN


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

CREATE DEFINER=`root`@`localhost` PROCEDURE `createSoalUjian` (IN `id_ujian` VARCHAR(9), IN `id_soal` VARCHAR(7))  BEGIN
insert into tbsoal_ujian(id_soal_ujian,id_soal) values(id_ujian,id_soal);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `createUjian` (IN `nm_ujian` VARCHAR(30))  BEGIN
declare id_ujian varchar(7);
declare id_su varchar(9);
set id_ujian = genIdUjian();
set id_su = concat('SU',id_ujian);
INSERT into tbujian values (id_ujian,nm_ujian,id_su);
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `getPesertaUjianOLD` (IN `id_ujian` VARCHAR(7), IN `id_peserta` INT(11))  BEGIN
CASE
when(id_peserta = 0 AND id_ujian !='0000000') then select * from tbpeserta_ujian left join tbujian on tbpeserta_ujian.id_ujian=tbujian.id_ujian left join tbpeserta on tbpeserta_ujian.id_peserta=tbpeserta.id_peserta where tbpeserta_ujian.id_ujian=tbujian.id_ujian;

when(id_peserta != 0 AND  id_ujian='0000000') then select * from tbpeserta_ujian left join tbujian on tbpeserta_ujian.id_ujian=tbujian.id_ujian left join tbpeserta on tbpeserta_ujian.id_peserta=tbpeserta.id_peserta WHERE tbpeserta_ujian.id_peserta=id_peserta;

when(id_peserta = 0 AND  id_ujian='0000000') then select * from tbpeserta_ujian left join tbujian on tbpeserta_ujian.id_ujian=tbujian.id_ujian left join tbpeserta on tbpeserta_ujian.id_peserta=tbpeserta.id_peserta;
else select * from tbpeserta_ujian left join tbujian on tbpeserta_ujian.id_ujian=tbujian.id_ujian left join tbpeserta on tbpeserta_ujian.id_peserta=tbpeserta.id_peserta where tbpeserta_ujian.id_ujian=id_ujian and tbpeserta_ujian.id_peserta=id_peserta;
end case;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getSoal` (IN `id` VARCHAR(7))  BEGIN
if(id = "0000000") THEN select * from tbsoal;
else select * from tbsoal where id_soal=id;
end if;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getSoalUjian` (IN `id` CHAR(7))  BEGIN
declare id_su varchar(9);
set id_su = concat('SU',id);
select * from tbsoal_ujian inner join tbsoal on tbsoal_ujian.id_soal=tbsoal.id_soal and tbsoal_ujian.id_soal_ujian=id_su;
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `updateUjian` (IN `id` INT(11), IN `nm_ujian` VARCHAR(30))  BEGIN
UPDATE tbujian set nm_ujian=nm_ujian WHERE id_ujian=id;
END$$

--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `genIdLjk` () RETURNS VARCHAR(7) CHARSET latin1 BEGIN
declare id_tmp int;
SELECT max(id_ljk) into id_tmp from tbljk_ujian;
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
SET id_tmp=id_tmp+1;
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
SET id_tmp=id_tmp+1;
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
(1, 'Mandan'),
(3, 'Komandan'),
(9, 'Kudil'),
(10, 'Jay'),
(11, 'Lay'),
(12, 'Semvak'),
(13, 'untuak dihaspus');

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
(20, 12, '0000003', 'Belum'),
(22, 9, '0000003', 'Belum'),
(23, 12, '0000002', 'Belum'),
(24, 10, '0000002', 'Belum'),
(25, 1, '0000004', 'Belum'),
(26, 3, '0000004', 'Belum'),
(27, 9, '0000004', 'Belum'),
(28, 10, '0000004', 'Belum'),
(29, 1, '0000006', 'Belum'),
(31, 11, '0000006', 'Belum'),
(32, 1, '0000007', 'Belum'),
(34, 10, '0000003', 'Belum'),
(35, 1, '0000008', 'Belum');

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
(10, 'PG0000005', 'A', 'Pilihan a'),
(11, 'PG0000005', 'B', 'Pilihan b'),
(12, 'PG0000005', 'C', 'Pilihan c'),
(20, 'PG0000002', 'A', 'Pilihan Update'),
(21, 'PG0000002', 'B', 'Pilihan B'),
(22, 'PG0000002', 'C', 'Pilihan Update'),
(23, 'PG0000002', 'D', 'Pilihan C'),
(27, 'PG0000006', 'A', 'aaaa'),
(28, 'PG0000006', 'B', 'bbbbb'),
(29, 'PG0000006', 'C', 'ccccc'),
(30, 'PG0000007', 'A', 'AAA'),
(31, 'PG0000007', 'B', 'BBB'),
(32, 'PG0000007', 'C', 'CCC'),
(33, 'PG0000007', 'D', 'DDD'),
(34, 'PG0000007', 'E', 'EEE'),
(35, 'PG0000007', 'F', 'FFF'),
(36, 'PG0000008', 'A', 'Hiperteks markup language'),
(37, 'PG0000008', 'B', 'Hypertex Markup Language'),
(38, 'PG0000008', 'C', 'Hypertext Markup Language'),
(39, 'PG0000009', 'A', 'Mata'),
(40, 'PG0000009', 'B', 'Paru-paru'),
(41, 'PG0000009', 'C', 'Ekor'),
(42, 'PG0000009', 'D', 'Kuku'),
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
(59, 'PG0000014', 'A', 'KV-1C'),
(60, 'PG0000014', 'B', 'JS-2'),
(61, 'PG0000014', 'C', 'T-70'),
(62, 'PG0000014', 'D', 'T-34'),
(63, 'PG0000014', 'E', 'T-60');

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
('0000001', 'Soal pertama adalah?', 'PG0000001', 'C'),
('0000002', 'INI SOAL UPDATE', 'PG0000002', 'C'),
('0000005', 'Soal kedua adalah', 'PG0000005', 'A'),
('0000006', 'Soal angularjs', 'PG0000006', 'C'),
('0000007', 'SOAL TERBARU', 'PG0000007', 'F'),
('0000008', 'Kepanjangan dari HTML adalah ?', 'PG0000008', 'C'),
('0000009', 'Kucing bernafas menggunakan ?', 'PG0000009', 'B'),
('0000010', 'Nama panggilan untuk tank perang dunia ke II milik Amerika Serikat M4 yaitu ?', 'PG0000010', 'D'),
('0000011', 'Kaliber peluru dari tank T-34 (1942) milik Rusia pada perang dunia ke II adalah?', 'PG0000011', 'B'),
('0000012', 'Salah satu MBT (Main Battle Tank) milik Russia pada perang dunia ke II adalah ?', 'PG0000012', 'D'),
('0000013', 'Kepanjangan HEAT dalam istilah tank adalah ?', 'PG0000013', 'A'),
('0000014', 'Pada pertarungan kursk di perang dunia ke II, Russia mengirim tank dalam jumlah banyak. Dan salah satu tank terbanyak yang dimiliki Russia pada saat itu adalah ?', 'PG0000014', 'D');

-- --------------------------------------------------------

--
-- Table structure for table `tbsoal_ujian`
--

CREATE TABLE `tbsoal_ujian` (
  `id` int(11) NOT NULL,
  `id_soal_ujian` varchar(9) NOT NULL,
  `id_soal` varchar(7) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tbsoal_ujian`
--

INSERT INTO `tbsoal_ujian` (`id`, `id_soal_ujian`, `id_soal`) VALUES
(13, 'SU0000002', '0000003'),
(14, 'SU0000003', '0000001'),
(15, 'SU0000002', '0000006'),
(18, 'SU0000005', '0000004'),
(19, 'SU0000002', '0000007'),
(20, 'SU0000002', '0000006'),
(21, 'SU0000002', '0000002'),
(22, 'SU0000003', '0000002'),
(23, 'SU0000003', '0000003'),
(24, 'SU0000003', '0000006'),
(25, 'SU0000003', '0000007'),
(26, 'SU0000008', '0000008'),
(27, 'SU0000008', '0000009'),
(28, 'SU0000008', '0000010'),
(29, 'SU0000008', '0000011'),
(30, 'SU0000008', '0000012'),
(31, 'SU0000008', '0000013'),
(32, 'SU0000008', '0000014');

-- --------------------------------------------------------

--
-- Table structure for table `tbujian`
--

CREATE TABLE `tbujian` (
  `id_ujian` varchar(7) NOT NULL,
  `nm_ujian` varchar(30) NOT NULL,
  `id_soal_ujian` varchar(9) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tbujian`
--

INSERT INTO `tbujian` (`id_ujian`, `nm_ujian`, `id_soal_ujian`) VALUES
('0000002', 'VueJS', 'SU0000002'),
('0000003', 'ExpressJS', 'SU0000003'),
('0000004', 'NodeJS', 'SU0000004'),
('0000005', 'RailsJS', 'SU0000005'),
('0000006', 'Javascript', 'SU0000006'),
('0000007', 'Typescript', 'SU0000007'),
('0000008', 'Ujian Percobaan', 'SU0000008');

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
  MODIFY `id_peserta` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;
--
-- AUTO_INCREMENT for table `tbpeserta_ujian`
--
ALTER TABLE `tbpeserta_ujian`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=36;
--
-- AUTO_INCREMENT for table `tbpilihan_ganda`
--
ALTER TABLE `tbpilihan_ganda`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=64;
--
-- AUTO_INCREMENT for table `tbsoal_ujian`
--
ALTER TABLE `tbsoal_ujian`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=33;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
