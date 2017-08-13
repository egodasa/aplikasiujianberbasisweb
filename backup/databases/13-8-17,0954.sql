-- phpMyAdmin SQL Dump
-- version 4.5.1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Aug 12, 2017 at 05:59 PM
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

CREATE PROCEDURE `createSoal` (IN `nm_soal` VARCHAR(750), IN `jawaban` VARCHAR(5), OUT `hasil` VARCHAR(9))  BEGIN
declare id_soal varchar(7);
declare id_pg varchar(9);
set id_soal= genIdSoal();
set id_pg = concat('PG',id_soal);
insert into tbsoal values(id_soal,nm_soal,id_pg,jawaban);
select id_pg into hasil;
end$$

CREATE PROCEDURE `createSoalUjian` (IN `id_ujian` VARCHAR(7), IN `id_soal` VARCHAR(7))  BEGIN
insert into tbsoal_ujian(id_ujian,id_soal) values(id_ujian,id_soal);
END$$

CREATE PROCEDURE `createUjian` (IN `nm_ujian` VARCHAR(30), IN `jam` TINYINT(2), IN `menit` TINYINT(2))  BEGIN
declare id varchar(7);
set id = genIdUjian();
INSERT into tbujian values (id,nm_ujian,stringToTime(jam,menit));
END$$

CREATE PROCEDURE `deletePeserta` (IN `id` INT(11))  BEGIN
delete from tbpeserta where id_peserta=id;
END$$

CREATE PROCEDURE `deletePesertaUjian` (IN `id_pu` INT(11))  BEGIN
delete from tbpeserta_ujian where id=id_pu;
END$$

CREATE PROCEDURE `deleteSoal` (IN `id` VARCHAR(7))  BEGIN
declare id_pg varchar(9);
set id_pg=CONCAT('PG',id);
delete from tbsoal where id_soal=id;
delete from tbpilihan_ganda where id_pilihan_ganda=id_pg;
END$$

CREATE PROCEDURE `deleteSoalUjian` (IN `id_ujian` INT(11))  BEGIN
delete from tbsoal_ujian where id=id_ujian;
END$$

CREATE PROCEDURE `deleteUjian` (IN `id` INT(11))  BEGIN
delete from tbujian where id_ujian=id;
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

CREATE PROCEDURE `getPeserta` (IN `id` INT(11))  BEGIN
if(id = 0) then select * from tbpeserta;
else select * from tbpeserta where id_peserta=id;
end if;
END$$

CREATE PROCEDURE `getPesertaUjian` (IN `id` VARCHAR(7), IN `id_peserta` INT)  BEGIN
CASE
when(id_peserta = 0) then
select tbpeserta_ujian.id,tbpeserta_ujian.id_peserta,tbpeserta.nm_peserta,tbpeserta_ujian.status from tbpeserta_ujian left join tbpeserta on tbpeserta_ujian.id_peserta=tbpeserta.id_peserta where tbpeserta_ujian.id_ujian=id;
ELSE
select tbpeserta_ujian.id,tbpeserta_ujian.id_peserta,tbpeserta.nm_peserta,tbpeserta_ujian.status from tbpeserta_ujian left join tbpeserta on tbpeserta_ujian.id_peserta=tbpeserta.id_peserta where tbpeserta_ujian.id_ujian=id and tbpeserta_ujian.id_peserta=id_peserta;
end case;
end$$

CREATE PROCEDURE `getSoal` (IN `id` VARCHAR(7))  BEGIN
if(id = "0000000") THEN select * from tbsoal;
else select * from tbsoal where id_soal=id;
end if;
END$$

CREATE PROCEDURE `getPesertaUjianOLD` (IN `id_ujian` VARCHAR(7), IN `id_peserta` INT(11))  BEGIN
CASE
when(id_peserta = 0 AND id_ujian !='0000000') then select * from tbpeserta_ujian left join tbujian on tbpeserta_ujian.id_ujian=tbujian.id_ujian left join tbpeserta on tbpeserta_ujian.id_peserta=tbpeserta.id_peserta where tbpeserta_ujian.id_ujian=tbujian.id_ujian;

when(id_peserta != 0 AND  id_ujian='0000000') then select * from tbpeserta_ujian left join tbujian on tbpeserta_ujian.id_ujian=tbujian.id_ujian left join tbpeserta on tbpeserta_ujian.id_peserta=tbpeserta.id_peserta WHERE tbpeserta_ujian.id_peserta=id_peserta;

when(id_peserta = 0 AND  id_ujian='0000000') then select * from tbpeserta_ujian left join tbujian on tbpeserta_ujian.id_ujian=tbujian.id_ujian left join tbpeserta on tbpeserta_ujian.id_peserta=tbpeserta.id_peserta;
else select * from tbpeserta_ujian left join tbujian on tbpeserta_ujian.id_ujian=tbujian.id_ujian left join tbpeserta on tbpeserta_ujian.id_peserta=tbpeserta.id_peserta where tbpeserta_ujian.id_ujian=id_ujian and tbpeserta_ujian.id_peserta=id_peserta;
end case;
END$$

CREATE PROCEDURE `getSoalUjian` (IN `id_su` CHAR(7))  BEGIN
select * from tbsoal_ujian inner join tbsoal on tbsoal_ujian.id_soal=tbsoal.id_soal and tbsoal_ujian.id_ujian=id_su;
END$$

CREATE PROCEDURE `getUjian` (IN `id` VARCHAR(7))  BEGIN
if(id = '0000000') then SELECT id_ujian,nm_ujian,miliToJam(durasi_ujian) as 'jam',miliToMenit(durasi_ujian) as 'menit' FROM tbujian;
else SELECT id_ujian,nm_ujian,miliToJam(durasi_ujian) as 'jam',miliToMenit(durasi_ujian) as 'menit' from tbujian where id_ujian=id;
END iF;
end$$

CREATE PROCEDURE `updatePeserta` (IN `id` INT(11), `nm_peserta` VARCHAR(30))  BEGIN
update tbpeserta set nm_peserta=nm_peserta where id_peserta=id;
END$$

CREATE PROCEDURE `updatePesertaUjian` (IN `id` INT(11), IN `id_peserta` INT(11), IN `id_ujian` VARCHAR(7))  BEGIN
update tbpeserta_ujian set id_peserta=id_peserta,id_ujian=id_ujian where id=id;
END$$

CREATE PROCEDURE `updateSoal` (IN `id` VARCHAR(7), IN `soal` VARCHAR(750), IN `jawaban` VARCHAR(5))  BEGIN
declare id_pg varchar(9);
set id_pg = concat('PG',id);
update tbsoal set isi_soal=soal,jawaban=jawaban where id_soal=id;
delete from tbpilihan_ganda where id_pilihan_ganda=id_pg;
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
(1, 1, 1, 4, 1, '80.00'),
(2, 1, 2, 4, 1, '80.00'),
(3, 1, 3, 5, 0, '99.99'),
(4, 1, 4, 4, 1, '80.00'),
(5, 1, 5, 0, 5, '0.00'),
(6, 2, 1, 0, 1, '0.00'),
(7, 2, 2, 1, 0, '99.99'),
(8, 1, 7, 2, 3, '40.00'),
(9, 1, 8, 3, 2, '60.00'),
(10, 1, 9, 5, 0, '99.99'),
(11, 1, 11, 4, 1, '80.00'),
(12, 1, 12, 1, 4, '20.00'),
(13, 1, 13, 2, 3, '40.00'),
(14, 1, 14, 3, 2, '60.00');

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
(2, 'Peserta Baru'),
(3, 'Kudil'),
(4, 'Biji Onta'),
(5, 'Admin'),
(6, 'Suhu'),
(7, 'Archlinux'),
(8, 'Ubuntu'),
(9, 'Fedora'),
(10, 'Tinycore Linux'),
(11, 'Elementary'),
(12, 'Redhat'),
(13, 'Slackware'),
(14, 'KDE'),
(16, 'dssdc');

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
(1, 1, '0000001', 'Sudah'),
(2, 2, '0000001', 'Sudah'),
(3, 3, '0000001', 'Sudah'),
(4, 4, '0000001', 'Sudah'),
(5, 5, '0000001', 'Sudah'),
(6, 1, '0000002', 'Sudah'),
(7, 6, '0000001', 'Belum'),
(8, 2, '0000002', 'Sudah'),
(9, 7, '0000001', 'Sudah'),
(10, 8, '0000001', 'Sudah'),
(11, 9, '0000001', 'Sudah'),
(12, 10, '0000001', 'Belum'),
(13, 11, '0000001', 'Sudah'),
(14, 12, '0000001', 'Sudah'),
(15, 13, '0000001', 'Sudah'),
(16, 14, '0000001', 'Sudah'),
(18, 7, '0000003', 'Belum'),
(19, 8, '0000003', 'Belum'),
(20, 9, '0000003', 'Belum'),
(21, 11, '0000003', 'Belum'),
(22, 10, '0000003', 'Belum'),
(23, 14, '0000003', 'Belum'),
(25, 13, '0000003', 'Belum'),
(26, 12, '0000003', 'Belum');

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
(70, 'PG0000016', 'C', 'Agregate Point Compound Run'),
(74, 'PGundefin', 'A', 'asd'),
(75, 'PGundefin', 'B', 'asddwd'),
(76, 'PGundefin', 'C', 'daw'),
(77, 'PGundefin', 'A', ''),
(78, 'PGundefin', 'B', ''),
(79, 'PGundefin', 'C', ''),
(94, 'PG0000010', 'A', 'Firefly'),
(95, 'PG0000010', 'B', 'Jagdpanzer'),
(96, 'PG0000010', 'C', 'Churchil'),
(97, 'PG0000010', 'D', 'Sherman'),
(101, 'PG0000017', 'A', 'Ryan Dhal'),
(102, 'PG0000017', 'B', 'Linus Trovaldis'),
(103, 'PG0000017', 'C', 'IanMurdock'),
(110, 'PG0000018', 'A', 'Windows mobile 6.5.3'),
(111, 'PG0000018', 'B', 'Windows mobile 6.5'),
(112, 'PG0000018', 'C', 'Windows mobile 6.0'),
(113, 'PG0000019', 'A', 'Progress With Automatic'),
(114, 'PG0000019', 'B', 'Progressive Web Applicaton'),
(115, 'PG0000019', 'C', 'Progress Web Acquire'),
(121, 'PG0000020', 'A', 'Typescript'),
(122, 'PG0000020', 'B', 'ASP.NET'),
(123, 'PG0000020', 'C', 'C#'),
(124, 'PG0000020', 'D', 'C++'),
(128, 'PG0000021', 'A', 'AngularJS'),
(129, 'PG0000021', 'B', 'VueJS'),
(130, 'PG0000021', 'C', 'BackboneJS');

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
('0000010', 'Berikut adalah tank buatan Jerman pada perang dunia ke II ?', 'PG0000010', 'B'),
('0000011', 'Kaliber peluru dari tank T-34 (1942) milik Rusia pada perang dunia ke II adalah?', 'PG0000011', 'B'),
('0000012', 'Salah satu MBT (Main Battle Tank) milik Russia pada perang dunia ke II adalah ?', 'PG0000012', 'D'),
('0000013', 'Kepanjangan HEAT dalam istilah tank adalah ?', 'PG0000013', 'A'),
('0000015', 'Jenis peluru (armament) yang digunakan tank Jerman Panther adalah?', 'PG0000015', 'B'),
('0000016', 'Kepanjangan dari APCR adalah ?', 'PG0000016', 'A'),
('0000017', 'Bahasa pemrograman NodeJS diciptakan oleh?', 'PG0000017', 'A'),
('0000018', 'Successor dari sistem operasi windows mobile 5 adalah ?', 'PG0000018', 'C'),
('0000019', 'Kepanjangan dari PWA adalah ?', 'PG0000019', 'B'),
('0000020', 'Berikut adalah bahasa pemrograman yang dibuat oleh microsoft, KECUALI?', 'PG0000020', 'D'),
('0000021', 'Framework javscript dibawah ini yang dibuat oleh Google adalah ?', 'PG0000021', 'A');

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
(7, '0000002', '0000008'),
(8, '0000003', '0000008'),
(9, '0000003', '0000020'),
(10, '0000003', '0000019'),
(11, '0000003', '0000017'),
(13, '0000003', '0000018');

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
('0000001', 'WWII', 120000),
('0000002', 'TI', 180000),
('0000003', 'Sistem Informasi', 180000);

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
  MODIFY `id_hasil` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;
--
-- AUTO_INCREMENT for table `tbjawaban_ljk`
--
ALTER TABLE `tbjawaban_ljk`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `tbpeserta`
--
ALTER TABLE `tbpeserta`
  MODIFY `id_peserta` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;
--
-- AUTO_INCREMENT for table `tbpeserta_ujian`
--
ALTER TABLE `tbpeserta_ujian`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;
--
-- AUTO_INCREMENT for table `tbpilihan_ganda`
--
ALTER TABLE `tbpilihan_ganda`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=131;
--
-- AUTO_INCREMENT for table `tbsoal_ujian`
--
ALTER TABLE `tbsoal_ujian`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
