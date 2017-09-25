-- Adminer 4.3.1 MySQL dump

SET NAMES utf8;
SET time_zone = '+00:00';
SET foreign_key_checks = 0;
SET sql_mode = 'NO_AUTO_VALUE_ON_ZERO';

USE `dbujian`;

DROP TABLE IF EXISTS `tbhasil_ujian`;
CREATE TABLE `tbhasil_ujian` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_ujian` int(11) NOT NULL,
  `id_peserta` int(11) NOT NULL,
  `benar` int(3) NOT NULL,
  `salah` int(3) NOT NULL,
  `nilai` decimal(4,2) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `id_peserta` (`id_peserta`),
  KEY `id_ujian` (`id_ujian`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=latin1;

INSERT INTO `tbhasil_ujian` (`id`, `id_ujian`, `id_peserta`, `benar`, `salah`, `nilai`) VALUES
(1,	1,	1,	1,	7,	12.50),
(2,	1,	4,	2,	4,	33.33),
(4,	1,	3,	1,	6,	14.28),
(5,	2,	1,	1,	0,	99.99),
(6,	2,	2,	0,	1,	0.00),
(8,	1,	1,	3,	4,	42.85),
(9,	4,	6,	8,	3,	72.72),
(10,	2,	6,	8,	6,	57.14),
(11,	2,	6,	7,	4,	63.63),
(12,	1,	6,	3,	8,	27.27),
(13,	1,	9,	8,	4,	66.66);

DROP TABLE IF EXISTS `tbjawaban_ljk`;
CREATE TABLE `tbjawaban_ljk` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_jawaban_ljk` varchar(9) NOT NULL,
  `id_soal` varchar(7) NOT NULL,
  `jawaban` varchar(5) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `tbljk_ujian`;
CREATE TABLE `tbljk_ujian` (
  `id_ljk` varchar(7) NOT NULL,
  `id_ujian` varchar(7) NOT NULL,
  `id_peserta` int(11) NOT NULL,
  `id_jawaban_ljk` varchar(9) NOT NULL,
  PRIMARY KEY (`id_ljk`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `tbpeserta`;
CREATE TABLE `tbpeserta` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nm_peserta` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=latin1;

INSERT INTO `tbpeserta` (`id`, `nm_peserta`) VALUES
(1,	'Afwan'),
(2,	'Antum'),
(3,	'Archlinux'),
(4,	'Manjaro'),
(6,	'regiza dafma'),
(7,	'Ubuntu'),
(8,	'LXDE'),
(9,	'Gnome'),
(10,	'XFCE');

DROP TABLE IF EXISTS `tbpeserta_ujian`;
CREATE TABLE `tbpeserta_ujian` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_peserta` int(11) NOT NULL,
  `id_ujian` int(11) NOT NULL,
  `status` enum('Sudah','Belum') NOT NULL DEFAULT 'Belum',
  PRIMARY KEY (`id`),
  KEY `id_peserta_hasil_ujian` (`id_peserta`) USING BTREE,
  KEY `id_ujian` (`id_ujian`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=latin1;

INSERT INTO `tbpeserta_ujian` (`id`, `id_peserta`, `id_ujian`, `status`) VALUES
(7,	4,	1,	'Sudah'),
(9,	3,	1,	'Sudah'),
(11,	6,	1,	'Sudah'),
(16,	6,	2,	'Sudah'),
(18,	9,	1,	'Sudah');

DROP TABLE IF EXISTS `tbpilihan_ganda`;
CREATE TABLE `tbpilihan_ganda` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_soal` int(11) NOT NULL,
  `huruf` varchar(5) NOT NULL,
  `isi_pilihan` varchar(300) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `id_soal` (`id_soal`)
) ENGINE=InnoDB AUTO_INCREMENT=221 DEFAULT CHARSET=latin1;

INSERT INTO `tbpilihan_ganda` (`id`, `id_soal`, `huruf`, `isi_pilihan`) VALUES
(89,	1,	'A',	'12'),
(90,	1,	'B',	'11'),
(91,	1,	'C',	'10'),
(92,	2,	'A',	'20'),
(93,	2,	'B',	'16'),
(94,	2,	'C',	'18'),
(95,	3,	'A',	'100'),
(96,	3,	'B',	'1000'),
(97,	3,	'C',	'10000'),
(98,	4,	'A',	'12'),
(99,	4,	'B',	'144'),
(100,	4,	'C',	'200'),
(104,	6,	'A',	'2'),
(105,	6,	'B',	'20'),
(106,	6,	'C',	'10'),
(107,	7,	'A',	'24cm2'),
(108,	7,	'B',	'64cm2'),
(109,	7,	'C',	'128cm2'),
(110,	8,	'A',	'20cm2'),
(111,	8,	'B',	'45cm2'),
(112,	8,	'C',	'25m2'),
(113,	9,	'A',	'1230 gram'),
(114,	9,	'B',	'12300 gram'),
(115,	9,	'C',	'123000 gram'),
(116,	10,	'A',	'6.28'),
(117,	10,	'B',	'5.12'),
(118,	10,	'C',	'7.28'),
(119,	11,	'A',	'1600 detik'),
(120,	11,	'B',	'7200 detik'),
(121,	11,	'C',	'10800 detik'),
(122,	12,	'A',	'Tumbuhan'),
(123,	12,	'B',	'Daging'),
(124,	12,	'C',	'Segalanya'),
(125,	13,	'A',	'Gas'),
(126,	13,	'B',	'Cair'),
(127,	13,	'C',	'Padat'),
(128,	14,	'A',	'Trakea'),
(129,	14,	'B',	'Paru-paru'),
(130,	14,	'C',	'Bronkitis'),
(131,	15,	'A',	'Siput'),
(132,	15,	'B',	'Semut'),
(133,	15,	'C',	'Cicak'),
(134,	16,	'A',	'Kertas'),
(135,	16,	'B',	'Besi'),
(136,	16,	'C',	'Air'),
(137,	17,	'A',	'100C'),
(138,	17,	'B',	'80C'),
(139,	17,	'C',	'0C'),
(140,	18,	'A',	'Gaya gravitasi matahari'),
(141,	18,	'B',	'Gaya gravitasi bulan'),
(142,	18,	'C',	'Gaya gravitasi mars'),
(143,	19,	'A',	'Ilmu Pengetahuan Alam'),
(144,	19,	'B',	'Ilmu Pengetahuan Ayam'),
(145,	19,	'C',	'Ilmu Pengetahuan Anda'),
(146,	20,	'A',	'Kuping'),
(147,	20,	'B',	'Hidung'),
(148,	20,	'C',	'Lidah'),
(149,	21,	'A',	'Aides Properti'),
(150,	21,	'B',	'Aides Aigyepty'),
(151,	21,	'C',	'Aides Adios'),
(152,	22,	'A',	'Hati'),
(153,	22,	'B',	'Ginjal'),
(154,	22,	'C',	'Jantung'),
(185,	24,	'A',	'Hutan gundul'),
(186,	24,	'B',	'Saluran air tersumbat'),
(187,	24,	'C',	'Populasi jangkrik meningkat'),
(188,	5,	'A',	'144'),
(189,	5,	'B',	'12'),
(190,	5,	'C',	'6'),
(197,	26,	'A',	'40'),
(198,	26,	'B',	'50'),
(199,	26,	'C',	'60'),
(203,	28,	'A',	'1'),
(204,	28,	'B',	'2'),
(205,	28,	'C',	'3'),
(206,	29,	'A',	'3'),
(207,	29,	'B',	'4'),
(208,	29,	'C',	'5'),
(212,	30,	'A',	'3'),
(213,	30,	'B',	'5'),
(214,	30,	'C',	'96'),
(218,	36,	'A',	'menyiram kucing'),
(219,	36,	'B',	'menyiram anjing'),
(220,	36,	'C',	'menyiram teman sendiri');

DROP TABLE IF EXISTS `tbsoal`;
CREATE TABLE `tbsoal` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `isi_soal` varchar(750) NOT NULL,
  `jawaban` varchar(5) NOT NULL,
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=latin1;

INSERT INTO `tbsoal` (`id`, `isi_soal`, `jawaban`) VALUES
(1,	'100 - 89',	'B'),
(2,	'5 X 4 - 4',	'B'),
(3,	'1 ton = .... kg',	'B'),
(4,	'12 lusin = .... buah',	'B'),
(5,	'12 / 2',	'C'),
(6,	'100/50',	'B'),
(7,	'Luas dari persegi yang memiliki panjang sisi 8cm adalah',	'B'),
(8,	'Jika diketahui panjang alas dari sebuah segitiga 10m dan tingginya adalah 500cm, maka berapakah luas segitiga tersebut?',	'C'),
(9,	'123kg = .... gram',	'C'),
(10,	'3.14 X 2',	'A'),
(11,	'2 jam = .... detik',	'B'),
(12,	'Karnivora adalah sebutan untuk hewan pemakan?',	'B'),
(13,	'Pada suhu 0C, air akan berbubah wujud menjadi?',	'C'),
(14,	'Kucing bernafas menggunakan?',	'B'),
(15,	'Cacing hati biasanya menyebar melalui hewan lain yaitu?',	'A'),
(16,	'Berikut adalah benda penghantar panas yang buruk',	'A'),
(17,	'Panas akan mengubah air menjadi gas pada suhu?',	'A'),
(18,	'Air mengalami pasang surut akibat adanya?',	'B'),
(19,	'Kepanjangan dari IPA adalah?',	'A'),
(20,	'Alat indra manusia yang berguna untuk mengecap rasa adalah?',	'C'),
(21,	'Nyamuk yang menyebarkan penyakit DBD adalah?',	'B'),
(22,	'Bagian dalam tubuh manusia yang bertugas menyaring darah adalah?',	'B'),
(23,	'Salah satu penyebab banjir adalah KECUALI?',	'C'),
(24,	'120 : 2 = ....',	'C'),
(25,	'1 + 1 = ...',	'B'),
(26,	'2 + 2 = ...',	'B'),
(27,	'Bara anak si skil?',	'B'),
(28,	'Salah satu penyebab datangnya hujan adalah?',	'A'),
(29,	'Salah satu penyebab datangnya hujan adalah?',	'A'),
(30,	'Salah satu penyebab datangnya hujan adalah?',	'A'),
(31,	'Salah satu penyebab datangnya hujan adalah?',	'A'),
(32,	'Salah satu penyebab datangnya hujan adalah?',	'A'),
(33,	'Salah satu penyebab hujan adalah?',	'A');

DROP TABLE IF EXISTS `tbsoal_ujian`;
CREATE TABLE `tbsoal_ujian` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_ujian` int(11) NOT NULL,
  `id_soal` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `id_soal_soal_ujian` (`id_soal`),
  KEY `id_ujian` (`id_ujian`)
) ENGINE=InnoDB AUTO_INCREMENT=64 DEFAULT CHARSET=latin1;

INSERT INTO `tbsoal_ujian` (`id`, `id_ujian`, `id_soal`) VALUES
(40,	1,	1),
(41,	1,	2),
(42,	1,	3),
(43,	1,	4),
(44,	1,	5),
(45,	1,	6),
(46,	1,	7),
(47,	1,	8),
(48,	1,	9),
(51,	2,	12),
(52,	2,	13),
(53,	2,	14),
(54,	2,	15),
(55,	2,	16),
(56,	2,	17),
(57,	2,	18),
(58,	2,	19),
(59,	2,	20),
(60,	2,	21),
(61,	2,	22),
(63,	1,	26);

DROP TABLE IF EXISTS `tbujian`;
CREATE TABLE `tbujian` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nm_ujian` varchar(30) NOT NULL,
  `durasi_ujian` bigint(20) NOT NULL,
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

INSERT INTO `tbujian` (`id`, `nm_ujian`, `durasi_ujian`) VALUES
(1,	'Matematika',	300000),
(2,	'Ilmu Pengetahuan Alam',	300000);

-- 2017-09-25 12:54:38
