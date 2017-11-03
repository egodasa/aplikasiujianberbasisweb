-- Adminer 4.3.1 PostgreSQL dump

DROP TABLE IF EXISTS "tbujian";
CREATE SEQUENCE tbujian_id_seq INCREMENT 1 MINVALUE 1 MAXVALUE 9223372036854775807 START 12 CACHE 1;

CREATE TABLE "public"."tbujian" (
    "id" integer DEFAULT nextval('tbujian_id_seq') NOT NULL,
    "nm_ujian" character varying(100) NOT NULL,
    "durasi_ujian" integer NOT NULL,
    "tipe_soal" smallint DEFAULT 1,
    CONSTRAINT "tbujian_id" PRIMARY KEY ("id")
) WITH (oids = false);

INSERT INTO "tbujian" ("id", "nm_ujian", "durasi_ujian", "tipe_soal") VALUES
(10,	'refesf',	7260000,	1),
(11,	'deefddsff',	3600000,	1);

DROP TABLE IF EXISTS "tbtipe_soal";
CREATE SEQUENCE tipe_ujian_id_seq INCREMENT 1 MINVALUE 1 MAXVALUE 9223372036854775807 START 2 CACHE 1;

CREATE TABLE "public"."tbtipe_soal" (
    "id" integer DEFAULT nextval('tipe_ujian_id_seq') NOT NULL,
    "nm_tipe" character varying(20),
    CONSTRAINT "tipe_ujian_pkey" PRIMARY KEY ("id")
) WITH (oids = false);

INSERT INTO "tbtipe_soal" ("id", "nm_tipe") VALUES
(1,	'Pilihan Ganda'),
(2,	'Essai');

DROP TABLE IF EXISTS "tbsoal";
CREATE SEQUENCE tbsoal_id_seq INCREMENT 1 MINVALUE 1 MAXVALUE 9223372036854775807 START 23 CACHE 1;

CREATE TABLE "public"."tbsoal" (
    "id" integer DEFAULT nextval('tbsoal_id_seq') NOT NULL,
    "isi_soal" text NOT NULL,
    "jawaban" text NOT NULL,
    "tipe_soal" smallint,
    CONSTRAINT "tbsoal_id" PRIMARY KEY ("id")
) WITH (oids = false);

INSERT INTO "tbsoal" ("id", "isi_soal", "jawaban", "tipe_soal") VALUES
(20,	'jelaskan tentang anu',	'anu adalah anu anu anu',	NULL),
(21,	'jelaskan tentang anu',	'anu adalah anu anu anu',	NULL),
(23,	'fdfecdcc',	'A',	1),
(22,	'essai gundulmu',	'gundulmu essai',	2);

DROP TABLE IF EXISTS "tbpilihan_ganda";
CREATE SEQUENCE tbpilihan_ganda_id_seq INCREMENT 1 MINVALUE 1 MAXVALUE 9223372036854775807 START 58 CACHE 1;

CREATE TABLE "public"."tbpilihan_ganda" (
    "id" integer DEFAULT nextval('tbpilihan_ganda_id_seq') NOT NULL,
    "id_soal" integer NOT NULL,
    "huruf" character varying(5) NOT NULL,
    "isi_pilihan" text NOT NULL,
    CONSTRAINT "tbpilihan_ganda_id" PRIMARY KEY ("id")
) WITH (oids = false);

CREATE INDEX "tbpilihan_ganda_id_soal" ON "public"."tbpilihan_ganda" USING btree ("id_soal");

INSERT INTO "tbpilihan_ganda" ("id", "id_soal", "huruf", "isi_pilihan") VALUES
(1,	3,	'A',	'10'),
(2,	3,	'B',	'12'),
(3,	3,	'C',	'13'),
(4,	4,	'A',	'10'),
(5,	4,	'B',	'12'),
(6,	4,	'C',	'13'),
(7,	5,	'A',	'asdas'),
(8,	5,	'B',	'asda'),
(9,	5,	'C',	'asd'),
(10,	6,	'A',	'vv'),
(11,	6,	'B',	'cd'),
(12,	6,	'C',	'ed'),
(13,	7,	'A',	'bb'),
(14,	7,	'B',	'cdbb'),
(15,	8,	'A',	'qq'),
(16,	8,	'B',	'cdwwe'),
(19,	9,	'B',	'mdms'),
(20,	9,	'C',	'ewe'),
(21,	10,	'A',	'cdcd'),
(22,	10,	'B',	'sxs'),
(23,	10,	'C',	'sxwwx'),
(26,	11,	'A',	'qww1'),
(27,	11,	'B',	's2w2'),
(28,	11,	'C',	'vf'),
(29,	12,	'A',	'fv'),
(30,	12,	'B',	'fv'),
(31,	12,	'C',	'vf'),
(32,	13,	'A',	'sdsa'),
(33,	13,	'B',	'cdc'),
(34,	13,	'C',	'dcds'),
(35,	14,	'A',	'adc'),
(36,	14,	'B',	'sd'),
(37,	14,	'C',	'cd'),
(38,	15,	'A',	'22'),
(39,	15,	'B',	'222'),
(40,	15,	'C',	'222'),
(46,	16,	'A',	'333'),
(47,	16,	'B',	'333'),
(48,	17,	'A',	'vfvfv'),
(49,	17,	'B',	'vfvfvf'),
(50,	18,	'A',	'vfvfvf'),
(51,	18,	'B',	'vfvff'),
(52,	18,	'C',	'vfvfv'),
(53,	18,	'D',	'vfvfv'),
(54,	19,	'A',	'fed'),
(55,	19,	'B',	'fed'),
(56,	19,	'C',	'fed'),
(57,	23,	'A',	'scds'),
(58,	23,	'B',	'cdc');

DROP TABLE IF EXISTS "books";
CREATE TABLE "public"."books" (
    "id" integer,
    "data" json
) WITH (oids = false);

INSERT INTO "books" ("id", "data") VALUES
(1,	'{ "name": "Book the First", "author": { "first_name": "Bob", "last_name": "White" } }'),
(2,	'{ "name": "Book the Second", "author": { "first_name": "Charles", "last_name": "Xavier" } }'),
(3,	'{ "name": "Book the Third", "author": { "first_name": "Jim", "last_name": "Brown" } }'),
(NULL,	NULL),
(5,	'{"pantek":"kau"}');

DROP TABLE IF EXISTS "tbmahasiswa";
CREATE SEQUENCE tbpeserta_id_seq INCREMENT 1 MINVALUE 1 MAXVALUE 9223372036854775807 START 20 CACHE 1;

CREATE TABLE "public"."tbmahasiswa" (
    "id" integer DEFAULT nextval('tbpeserta_id_seq') NOT NULL,
    "nm_mahasiswa" character varying(100) NOT NULL,
    "nobp" character(14) NOT NULL,
    "id_kelas" integer NOT NULL,
    CONSTRAINT "tbpeserta_id" PRIMARY KEY ("id")
) WITH (oids = false);

INSERT INTO "tbmahasiswa" ("id", "nm_mahasiswa", "nobp", "id_kelas") VALUES
(20,	'dasd',	'14101152610565',	1);

DROP TABLE IF EXISTS "tbpeserta_ujian";
CREATE SEQUENCE tbpeserta_ujian_id_seq INCREMENT 1 MINVALUE 1 MAXVALUE 9223372036854775807 START 95 CACHE 1;

CREATE TABLE "public"."tbpeserta_ujian" (
    "id" integer DEFAULT nextval('tbpeserta_ujian_id_seq') NOT NULL,
    "id_mahasiswa" integer NOT NULL,
    "id_ujian" integer NOT NULL,
    "status" character varying(10) DEFAULT Belum,
    CONSTRAINT "tbpeserta_ujian_pkey" PRIMARY KEY ("id")
) WITH (oids = false);

CREATE INDEX "tbpeserta_ujian_id_peserta" ON "public"."tbpeserta_ujian" USING btree ("id_mahasiswa");

CREATE INDEX "tbpeserta_ujian_id_ujian" ON "public"."tbpeserta_ujian" USING btree ("id_ujian");

INSERT INTO "tbpeserta_ujian" ("id", "id_mahasiswa", "id_ujian", "status") VALUES
(83,	1,	2,	'Belum'),
(84,	1,	3,	'Belum'),
(86,	2,	2,	'Belum'),
(87,	4,	3,	'Belum'),
(88,	1,	5,	'Belum'),
(89,	4,	5,	'Belum'),
(90,	2,	3,	'Belum'),
(91,	4,	2,	'Belum'),
(92,	6,	3,	'Belum'),
(93,	1,	9,	'Belum'),
(94,	2,	9,	'Belum'),
(95,	5,	3,	'Belum');

DROP TABLE IF EXISTS "tbsoal_ujian";
CREATE SEQUENCE tbsoal_ujian_id_seq INCREMENT 1 MINVALUE 1 MAXVALUE 9223372036854775807 START 5 CACHE 1;

CREATE TABLE "public"."tbsoal_ujian" (
    "id" integer DEFAULT nextval('tbsoal_ujian_id_seq') NOT NULL,
    "id_soal" integer NOT NULL,
    "id_ujian" integer NOT NULL,
    CONSTRAINT "tbsoal_ujian_pkey" PRIMARY KEY ("id")
) WITH (oids = false);

INSERT INTO "tbsoal_ujian" ("id", "id_soal", "id_ujian") VALUES
(1,	15,	2),
(2,	16,	3);

DROP TABLE IF EXISTS "tbkelas";
CREATE SEQUENCE tbkelas_id_seq INCREMENT 1 MINVALUE 1 MAXVALUE 9223372036854775807 START 3 CACHE 1;

CREATE TABLE "public"."tbkelas" (
    "id" integer DEFAULT nextval('tbkelas_id_seq') NOT NULL,
    "nm_kelas" character varying(10) NOT NULL,
    CONSTRAINT "tbkelas_id" PRIMARY KEY ("id")
) WITH (oids = false);

INSERT INTO "tbkelas" ("id", "nm_kelas") VALUES
(1,	'SI-10'),
(3,	'SI-1');

-- 2017-11-03 23:31:41.808285+07
