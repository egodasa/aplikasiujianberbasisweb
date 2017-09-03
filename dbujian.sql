-- phpMyAdmin SQL Dump
-- version 4.7.0
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Sep 03, 2017 at 10:00 AM
-- Server version: 10.1.21-MariaDB
-- PHP Version: 5.6.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
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
CREATE PROCEDURE `createHasilUjian` (IN `idujian` VARCHAR(7), IN `idpeserta` INT, IN `b` TINYINT, IN `s` TINYINT)  BEGIN
declare total_soal tinyint;
declare nilai float;
declare point float;
set total_soal = b+s;
set point = 100/total_soal;
set nilai = b*point;
insert into tbhasil_ujian(id_ujian,id_peserta,benar,salah,nilai) value (idujian,idpeserta,b,s,TRUNCATE(nilai,2));
update tbpeserta_ujian set tbpeserta_ujian.status = 'Sudah' where tbpeserta_ujian.id_ujian=idujian and tbpeserta_ujian.id_peserta=idpeserta;
end$$

CREATE PROCEDURE `createPeserta` (IN `nm_peserta` VARCHAR(50))  BEGIN
insert into tbpeserta (nm_peserta) VALUE (nm_peserta);
END$$

CREATE PROCEDURE `createPesertaUjian` (IN `id_ujian` VARCHAR(7), IN `id_peserta` INT(11))  BEGIN
insert into tbpeserta_ujian (id_ujian,id_peserta) values (id_ujian,id_peserta);
END$$

CREATE PROCEDURE `createSoal` (IN `id` CHAR(7), IN `nm_soal` VARCHAR(750), IN `jawaban` VARCHAR(5))  BEGIN
insert into tbsoal values(id,nm_soal,jawaban);
end$$

CREATE PROCEDURE `createSoalUjian` (IN `id_ujian` VARCHAR(7), IN `id_soal` VARCHAR(7))  BEGIN
insert into tbsoal_ujian(id_ujian,id_soal) values(id_ujian,id_soal);
END$$

CREATE PROCEDURE `createUjian` (IN `nm_ujian` VARCHAR(30), IN `jam` TINYINT(2), IN `menit` TINYINT(2))  BEGIN
declare id varchar(7);
set id = genIdUjian();
INSERT into tbujian values (id,nm_ujian,stringToTime(jam,menit));
END$$

CREATE PROCEDURE `deletePeserta` (IN `id` TEXT)  BEGIN
delete from tbpeserta where FIND_IN_SET(id_peserta,id) > 0;
END$$

CREATE PROCEDURE `deletePesertaUjian` (IN `id_pu` TEXT)  BEGIN
delete from tbpeserta_ujian where FIND_IN_SET(id,id_pu) > 0;
END$$

CREATE PROCEDURE `deleteSoal` (IN `id` TEXT)  BEGIN
delete from tbsoal where FIND_IN_SET(id_soal,id) > 0;
END$$

CREATE PROCEDURE `deleteSoalUjian` (IN `id_ujian` TEXT)  BEGIN
delete from tbsoal_ujian where FIND_IN_SET(id,id_ujian) > 0;
END$$

CREATE PROCEDURE `deleteUjian` (IN `id` TEXT)  BEGIN
delete from tbujian where FIND_IN_SET(id_ujian,id) > 0;
END$$

CREATE PROCEDURE `getHasilUjian` (IN `idUjian` VARCHAR(7), IN `idPeserta` INT)  BEGIN
CASE
when(idUjian != '0000000' and idPeserta = 0)then select tbhasil_ujian.id_ujian,tbhasil_ujian.id_peserta,tbpeserta.nm_peserta,tbujian.nm_ujian,tbhasil_ujian.benar,tbhasil_ujian.salah,tbhasil_ujian.nilai from tbhasil_ujian left join tbpeserta on tbhasil_ujian.id_peserta =tbpeserta.id_peserta left join tbujian on tbhasil_ujian.id_ujian = tbujian.id_ujian where tbhasil_ujian.id_ujian = idUjian;
when(idUjian = '000000' and idPeserta!= 0)then select tbhasil_ujian.id_ujian,tbhasil_ujian.id_peserta,tbpeserta.nm_peserta,tbujian.nm_ujian,tbhasil_ujian.benar,tbhasil_ujian.salah,tbhasil_ujian.nilai from tbhasil_ujian left join tbpeserta on tbhasil_ujian.id_peserta =tbpeserta.id_peserta left join tbujian on tbhasil_ujian.id_ujian = tbujian.id_ujian where tbhasil_ujian.id_peserta=idPeserta;
else select tbhasil_ujian.id_ujian,tbhasil_ujian.id_peserta,tbpeserta.nm_peserta,tbujian.nm_ujian,tbhasil_ujian.benar,tbhasil_ujian.salah,tbhasil_ujian.nilai from tbhasil_ujian left join tbpeserta on tbhasil_ujian.id_peserta =tbpeserta.id_peserta left join tbujian on tbhasil_ujian.id_ujian = tbujian.id_ujian;
end case;
end$$

CREATE PROCEDURE `getNotPesertaUjian` (IN `id` VARCHAR(7))  BEGIN
select * from tbpeserta where id_peserta not in (select id_peserta from tbpeserta_ujian where id_ujian=id);
END$$

CREATE PROCEDURE `getNotSoalUjian` (IN `id` VARCHAR(7))  BEGIN
select * from tbsoal where id_soal not in (select id_soal from tbsoal_ujian where id_ujian=id);
END$$

CREATE PROCEDURE `getPeserta` (IN `id` INT(11), IN `lim` INT(5), IN `off` INT(5))  BEGIN
CASE
when(id = 0 and lim=0 and off=0) then select * from tbpeserta;
when(id=0 and lim!=0 or off!=0)then select * from tbpeserta limit lim offset off;
else select * from tbpeserta where id_peserta=id;
end case;
select count(*) as "jumlah" from tbpeserta;
END$$

CREATE PROCEDURE `getPesertaUjian` (IN `id` VARCHAR(7), IN `id_peserta` INT)  BEGIN
CASE
when(id_peserta = 0) then
select tbpeserta_ujian.id,tbpeserta_ujian.id_peserta,tbpeserta.nm_peserta,tbpeserta_ujian.status from tbpeserta_ujian left join tbpeserta on tbpeserta_ujian.id_peserta=tbpeserta.id_peserta where tbpeserta_ujian.id_ujian=id;
ELSE
select tbpeserta_ujian.id,tbpeserta_ujian.id_peserta,tbpeserta.nm_peserta,tbpeserta_ujian.status from tbpeserta_ujian left join tbpeserta on tbpeserta_ujian.id_peserta=tbpeserta.id_peserta where tbpeserta_ujian.id_ujian=id and tbpeserta_ujian.id_peserta=id_peserta;
end case;
end$$

CREATE PROCEDURE `getPesertaUjianOLD` (IN `id_ujian` VARCHAR(7), IN `id_peserta` INT(11))  BEGIN
CASE
when(id_peserta = 0 AND id_ujian !='0000000') then select * from tbpeserta_ujian left join tbujian on tbpeserta_ujian.id_ujian=tbujian.id_ujian left join tbpeserta on tbpeserta_ujian.id_peserta=tbpeserta.id_peserta where tbpeserta_ujian.id_ujian=tbujian.id_ujian;

when(id_peserta != 0 AND  id_ujian='0000000') then select * from tbpeserta_ujian left join tbujian on tbpeserta_ujian.id_ujian=tbujian.id_ujian left join tbpeserta on tbpeserta_ujian.id_peserta=tbpeserta.id_peserta WHERE tbpeserta_ujian.id_peserta=id_peserta;

when(id_peserta = 0 AND  id_ujian='0000000') then select * from tbpeserta_ujian left join tbujian on tbpeserta_ujian.id_ujian=tbujian.id_ujian left join tbpeserta on tbpeserta_ujian.id_peserta=tbpeserta.id_peserta;
else select * from tbpeserta_ujian left join tbujian on tbpeserta_ujian.id_ujian=tbujian.id_ujian left join tbpeserta on tbpeserta_ujian.id_peserta=tbpeserta.id_peserta where tbpeserta_ujian.id_ujian=id_ujian and tbpeserta_ujian.id_peserta=id_peserta;
end case;
END$$

CREATE PROCEDURE `getSoal` (IN `id` VARCHAR(7), IN `lim` INT(5), IN `off` INT(5))  BEGIN
CASE
when(id = "0000000" and lim=0 and off=0) THEN select * from tbsoal;
when(id="0000000" and lim!=0 or off!=0) then select * from tbsoal limit lim OFFSET off;
else select * from tbsoal where id_soal=id;
end case;
select COUNT(*) as 'jumlah' from tbsoal;
END$$

CREATE PROCEDURE `getSoalUjian` (IN `id_su` CHAR(7))  BEGIN
select * from tbsoal_ujian inner join tbsoal on tbsoal_ujian.id_soal=tbsoal.id_soal and tbsoal_ujian.id_ujian=id_su;
END$$

CREATE PROCEDURE `getUjian` (IN `id` VARCHAR(7), IN `lim` INT(5), IN `off` INT(5))  BEGIN
CASE
when(id = '0000000' and lim=0 and off=0) then SELECT tbujian.id_ujian,tbujian.nm_ujian,miliToJam(durasi_ujian) as 'jam',miliToMenit(durasi_ujian) as 'menit',(select count(tbsoal_ujian.id_ujian) from tbsoal_ujian where tbsoal_ujian.id_ujian = tbujian.id_ujian) as 'banyak_soal',(select count(tbpeserta_ujian.id_ujian) from tbpeserta_ujian where tbpeserta_ujian.id_ujian = tbujian.id_ujian) as 'banyak_peserta' FROM tbujian;
when(id = '0000000' and lim!=0 or off!=0) then SELECT tbujian.id_ujian,tbujian.nm_ujian,miliToJam(durasi_ujian) as 'jam',miliToMenit(durasi_ujian) as 'menit',(select count(tbsoal_ujian.id_ujian) from tbsoal_ujian where tbsoal_ujian.id_ujian = tbujian.id_ujian) as 'banyak_soal',(select count(tbpeserta_ujian.id_ujian) from tbpeserta_ujian where tbpeserta_ujian.id_ujian = tbujian.id_ujian) as 'banyak_peserta' FROM tbujian limit lim OFFSET off;
else SELECT id_ujian,nm_ujian,miliToJam(durasi_ujian) as 'jam',miliToMenit(durasi_ujian) as 'menit',(select count(tbsoal_ujian.id_ujian) from tbsoal_ujian where tbsoal_ujian.id_ujian = tbujian.id_ujian) as 'banyak_soal',(select count(tbpeserta_ujian.id_ujian) from tbpeserta_ujian where tbpeserta_ujian.id_ujian = tbujian.id_ujian) as 'banyak_peserta' from tbujian where id_ujian=id;
END CASE;
select count(*) as 'jumlah' from tbujian;
end$$

CREATE PROCEDURE `updatePeserta` (IN `id` INT(11), `nm_peserta` VARCHAR(30))  BEGIN
update tbpeserta set nm_peserta=nm_peserta where id_peserta=id;
END$$

CREATE PROCEDURE `updatePesertaUjian` (IN `id` INT(11), IN `id_peserta` INT(11), IN `id_ujian` VARCHAR(7))  BEGIN
update tbpeserta_ujian set id_peserta=id_peserta,id_ujian=id_ujian where id=id;
END$$

CREATE PROCEDURE `updateSoal` (IN `id` VARCHAR(7), IN `soal` VARCHAR(750), IN `jawaban` VARCHAR(5))  BEGIN
update tbsoal set isi_soal=soal,jawaban=jawaban where id_soal=id;
delete from tbpilihan_ganda where id_soal=id;
end$$

CREATE PROCEDURE `updateUjian` (IN `id` VARCHAR(7), IN `nm_ujian` VARCHAR(30), IN `jam` TINYINT, IN `menit` TINYINT)  BEGIN
UPDATE tbujian set nm_ujian=nm_ujian,durasi_ujian = stringToTime(jam,menit) WHERE id_ujian=id;
END$$

--
-- Functions
--
CREATE FUNCTION `genIdLjk` () RETURNS VARCHAR(7) CHARSET latin1 BEGIN
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

CREATE FUNCTION `genIdSoal` () RETURNS VARCHAR(7) CHARSET latin1 BEGIN
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

CREATE FUNCTION `genIdUjian` () RETURNS VARCHAR(7) CHARSET latin1 BEGIN
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

CREATE FUNCTION `miliToJam` (`mili` BIGINT) RETURNS TINYINT(4) BEGIN
declare hasil tinyint;
set hasil = floor(mili/3600000);
return hasil;
end$$

CREATE FUNCTION `miliToMenit` (`mili` BIGINT) RETURNS TINYINT(2) BEGIN
declare hasil tinyint;
set hasil = (mili mod 3600000)/60000;
return hasil;
end$$

CREATE FUNCTION `stringToTime` (`jam` TINYINT, `menit` TINYINT) RETURNS BIGINT(20) BEGIN
declare hasil bigint;
set hasil = jam*3600000+menit*60000;
return hasil;
end$$

CREATE FUNCTION `timeToString` (`mili` BIGINT) RETURNS VARCHAR(50) CHARSET latin1 BEGIN
declare hasil varchar(50);
declare jam tinyint;
declare menit tinyint;
declare ket_jam varchar(10);
declare ket_menit varchar(20);
set jam = miliToJam(mili);
set menit = miliToMenit(mili);
if(jam = 0) then set ket_jam='';
else set ket_jam=concat(jam,' Jam');
end if;

if(menit = 0) then set ket_jam ='';
else set ket_menit = concat(menit,' Menit');
end if;
set hasil = concat(ket_jam,' ',ket_menit);
return hasil;
end$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `tbhasil_ujian`
--

CREATE TABLE `tbhasil_ujian` (
  `id_hasil` int(11) NOT NULL,
  `id_ujian` int(11) NOT NULL,
  `id_peserta` int(11) NOT NULL,
  `benar` int(3) NOT NULL,
  `salah` int(3) NOT NULL,
  `nilai` decimal(4,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tbhasil_ujian`
--

INSERT INTO `tbhasil_ujian` (`id_hasil`, `id_ujian`, `id_peserta`, `benar`, `salah`, `nilai`) VALUES
(1, 1, 1, 1, 7, '12.50'),
(2, 1, 4, 2, 4, '33.33'),
(3, 1, 5, 5, 1, '83.33'),
(4, 1, 3, 1, 6, '14.28'),
(5, 2, 1, 1, 0, '99.99'),
(6, 2, 2, 0, 1, '0.00'),
(7, 2, 5, 0, 1, '0.00'),
(8, 1, 1, 3, 4, '42.85');

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
(1, 'Afwan'),
(2, 'Antum'),
(3, 'Archlinux'),
(4, 'Manjaro'),
(5, 'Adek');

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
(7, 4, '0000001', 'Sudah'),
(8, 5, '0000001', 'Sudah'),
(9, 3, '0000001', 'Sudah'),
(10, 5, '0000002', 'Sudah');

-- --------------------------------------------------------

--
-- Table structure for table `tbpilihan_ganda`
--

CREATE TABLE `tbpilihan_ganda` (
  `id` int(11) NOT NULL,
  `id_soal` char(7) NOT NULL,
  `huruf` varchar(5) NOT NULL,
  `isi_pilihan` varchar(300) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tbpilihan_ganda`
--

INSERT INTO `tbpilihan_ganda` (`id`, `id_soal`, `huruf`, `isi_pilihan`) VALUES
(15, '0000005', 'A', '2'),
(16, '0000005', 'B', '0'),
(17, '0000005', 'C', '13'),
(18, '0000006', 'A', '200'),
(19, '0000006', 'B', '2000'),
(20, '0000006', 'C', '20'),
(21, '0000007', 'A', '239'),
(22, '0000007', 'B', '91'),
(23, '0000007', 'C', '0'),
(24, '0000008', 'A', '49'),
(25, '0000008', 'B', '91'),
(26, '0000008', 'C', '81'),
(27, '0000009', 'A', '-9'),
(28, '0000009', 'B', '-1'),
(29, '0000009', 'C', '9'),
(30, '0000010', 'A', '15'),
(31, '0000010', 'B', '56'),
(32, '0000011', 'A', 'Hitam'),
(33, '0000011', 'B', 'Merah'),
(34, '0000011', 'C', 'Putih');

-- --------------------------------------------------------

--
-- Table structure for table `tbsoal`
--

CREATE TABLE `tbsoal` (
  `id_soal` varchar(7) NOT NULL,
  `isi_soal` varchar(750) NOT NULL,
  `jawaban` varchar(5) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tbsoal`
--

INSERT INTO `tbsoal` (`id_soal`, `isi_soal`, `jawaban`) VALUES
('0000005', '9 - 8 + 1', 'A'),
('0000006', '0,2kg = ? gr', 'A'),
('0000007', '500 - 499 - 1', 'C'),
('0000008', '9 * 9', 'C'),
('0000009', '0 * 98 - 1', 'B'),
('0000010', '8 + 7 =', 'A'),
('0000011', 'Berikut adalah warna kuciang kecuali', 'B');

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
(3, '0000001', '0000005'),
(4, '0000001', '0000006'),
(5, '0000001', '0000007'),
(6, '0000001', '0000008'),
(10, '0000002', '0000011'),
(11, '0000001', '0000009');

-- --------------------------------------------------------

--
-- Table structure for table `tbujian`
--

CREATE TABLE `tbujian` (
  `id_ujian` varchar(7) NOT NULL,
  `nm_ujian` varchar(30) NOT NULL,
  `durasi_ujian` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tbujian`
--

INSERT INTO `tbujian` (`id_ujian`, `nm_ujian`, `durasi_ujian`) VALUES
('0000001', 'Matematika', 300000),
('0000002', 'IPA', 3600000);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `tbhasil_ujian`
--
ALTER TABLE `tbhasil_ujian`
  ADD PRIMARY KEY (`id_hasil`),
  ADD KEY `id_peserta` (`id_peserta`),
  ADD KEY `id_ujian` (`id_ujian`);

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
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_peserta_hasil_ujian` (`id_peserta`) USING BTREE,
  ADD KEY `id_ujian` (`id_ujian`);

--
-- Indexes for table `tbpilihan_ganda`
--
ALTER TABLE `tbpilihan_ganda`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_soal` (`id_soal`);

--
-- Indexes for table `tbsoal`
--
ALTER TABLE `tbsoal`
  ADD PRIMARY KEY (`id_soal`);

--
-- Indexes for table `tbsoal_ujian`
--
ALTER TABLE `tbsoal_ujian`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_soal_soal_ujian` (`id_soal`),
  ADD KEY `id_ujian` (`id_ujian`);

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
  MODIFY `id_hasil` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;
--
-- AUTO_INCREMENT for table `tbjawaban_ljk`
--
ALTER TABLE `tbjawaban_ljk`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `tbpeserta`
--
ALTER TABLE `tbpeserta`
  MODIFY `id_peserta` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;
--
-- AUTO_INCREMENT for table `tbpeserta_ujian`
--
ALTER TABLE `tbpeserta_ujian`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;
--
-- AUTO_INCREMENT for table `tbpilihan_ganda`
--
ALTER TABLE `tbpilihan_ganda`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=35;
--
-- AUTO_INCREMENT for table `tbsoal_ujian`
--
ALTER TABLE `tbsoal_ujian`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;
--
-- Constraints for dumped tables
--

--
-- Constraints for table `tbhasil_ujian`
--
ALTER TABLE `tbhasil_ujian`
  ADD CONSTRAINT `id_peserta` FOREIGN KEY (`id_peserta`) REFERENCES `tbpeserta` (`id_peserta`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `tbpeserta_ujian`
--
ALTER TABLE `tbpeserta_ujian`
  ADD CONSTRAINT `id_peserta_peserta_ujian` FOREIGN KEY (`id_peserta`) REFERENCES `tbpeserta` (`id_peserta`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `id_soal_peserta_ujian` FOREIGN KEY (`id_ujian`) REFERENCES `tbujian` (`id_ujian`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `tbpilihan_ganda`
--
ALTER TABLE `tbpilihan_ganda`
  ADD CONSTRAINT `id_soal_pilihan_ganda` FOREIGN KEY (`id_soal`) REFERENCES `tbsoal` (`id_soal`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `tbsoal_ujian`
--
ALTER TABLE `tbsoal_ujian`
  ADD CONSTRAINT `id_soal_soal_ujian` FOREIGN KEY (`id_soal`) REFERENCES `tbsoal` (`id_soal`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `id_ujian_ujian` FOREIGN KEY (`id_ujian`) REFERENCES `tbujian` (`id_ujian`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
