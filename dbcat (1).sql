-- Adminer 4.3.1 PostgreSQL dump

\connect "dbcat";

DROP TABLE IF EXISTS "tbkelas";
CREATE SEQUENCE tbkelas_id_kelas_seq INCREMENT 1 MINVALUE 1 MAXVALUE 9223372036854775807 START 3 CACHE 1;

CREATE TABLE "public"."tbkelas" (
    "id_kelas" integer DEFAULT nextval('tbkelas_id_kelas_seq') NOT NULL,
    "nm_kelas" character varying(10) NOT NULL,
    CONSTRAINT "tbkelas_pkey" PRIMARY KEY ("id_kelas")
) WITH (oids = false);


DROP TABLE IF EXISTS "tbdosen";
CREATE SEQUENCE tbdosen_id_dosen_seq INCREMENT 1 MINVALUE 1 MAXVALUE 9223372036854775807 START 5 CACHE 1;

CREATE TABLE "public"."tbdosen" (
    "id_dosen" integer DEFAULT nextval('tbdosen_id_dosen_seq') NOT NULL,
    "nidn" character varying(10) NOT NULL,
    "nm_dosen" character varying(50) NOT NULL,
    CONSTRAINT "tbdosen_nidn_key" UNIQUE ("nidn"),
    CONSTRAINT "tbdosen_pkey" PRIMARY KEY ("id_dosen")
) WITH (oids = false);


DROP TABLE IF EXISTS "tbjenis_ujian";
CREATE SEQUENCE tbjenis_ujian_id_jujian_seq INCREMENT 1 MINVALUE 1 MAXVALUE 9223372036854775807 START 4 CACHE 1;

CREATE TABLE "public"."tbjenis_ujian" (
    "id_jujian" integer DEFAULT nextval('tbjenis_ujian_id_jujian_seq') NOT NULL,
    "nm_jenis" character varying(10) NOT NULL,
    CONSTRAINT "tbjenis_ujian_pkey" PRIMARY KEY ("id_jujian")
) WITH (oids = false);


DROP TABLE IF EXISTS "tbtipe_soal";
CREATE SEQUENCE tipe_soal_id_tsoal_seq INCREMENT 1 MINVALUE 1 MAXVALUE 9223372036854775807 START 3 CACHE 1;

CREATE TABLE "public"."tbtipe_soal" (
    "id_tsoal" integer DEFAULT nextval('tipe_soal_id_tsoal_seq') NOT NULL,
    "nm_tipe" character varying(15) NOT NULL,
    CONSTRAINT "tipe_soal_pkey" PRIMARY KEY ("id_tsoal")
) WITH (oids = false);


DROP TABLE IF EXISTS "tbsoal";
CREATE SEQUENCE mahasiswa_id_mahasiswa_seq INCREMENT 1 MINVALUE 1 MAXVALUE 9223372036854775807 START 17 CACHE 1;

CREATE TABLE "public"."tbsoal" (
    "id_soal" integer DEFAULT nextval('mahasiswa_id_mahasiswa_seq') NOT NULL,
    "isi_soal" text NOT NULL,
    "jawaban" text NOT NULL,
    "pilihanGanda" json,
    "id_tsoal" smallint DEFAULT 1 NOT NULL,
    "bobot" smallint DEFAULT 1 NOT NULL,
    CONSTRAINT "mahasiswa_pkey" PRIMARY KEY ("id_soal"),
    CONSTRAINT "tbsoal_id_tsoal_fkey" FOREIGN KEY (id_tsoal) REFERENCES tbtipe_soal(id_tsoal) ON UPDATE CASCADE ON DELETE CASCADE NOT DEFERRABLE
) WITH (oids = false);


DROP TABLE IF EXISTS "tbmatkul";
CREATE SEQUENCE matkul_id_matkul_seq INCREMENT 1 MINVALUE 1 MAXVALUE 9223372036854775807 START 3 CACHE 1;

CREATE TABLE "public"."tbmatkul" (
    "id_matkul" integer DEFAULT nextval('matkul_id_matkul_seq') NOT NULL,
    "nm_matkul" character varying(30) NOT NULL,
    "sks" smallint NOT NULL,
    CONSTRAINT "matkul_pkey" PRIMARY KEY ("id_matkul")
) WITH (oids = false);


DROP TABLE IF EXISTS "tbmahasiswa";
CREATE SEQUENCE tbmahasiswa_id_mahasiswa_seq INCREMENT 1 MINVALUE 1 MAXVALUE 9223372036854775807 START 2 CACHE 1;

CREATE TABLE "public"."tbmahasiswa" (
    "id_mahasiswa" integer DEFAULT nextval('tbmahasiswa_id_mahasiswa_seq') NOT NULL,
    "nobp" character(14) NOT NULL,
    "nm_mahasiswa" character varying(100) NOT NULL,
    "id_kelas" integer NOT NULL,
    CONSTRAINT "tbmahasiswa_nobp" UNIQUE ("nobp"),
    CONSTRAINT "tbmahasiswa_pkey" PRIMARY KEY ("id_mahasiswa"),
    CONSTRAINT "tbmahasiswa_id_kelas_fkey" FOREIGN KEY (id_kelas) REFERENCES tbkelas(id_kelas) ON UPDATE CASCADE ON DELETE CASCADE NOT DEFERRABLE
) WITH (oids = false);

CREATE INDEX "tbmahasiswa_id_kelas" ON "public"."tbmahasiswa" USING btree ("id_kelas");


DROP VIEW IF EXISTS "lap_mahasiswa";
CREATE TABLE "lap_mahasiswa" ("id_mahasiswa" integer, "nobp" character(14), "nm_mahasiswa" character varying(100), "nm_kelas" character varying(10));


DROP TABLE IF EXISTS "tbkuliah";
CREATE SEQUENCE tbkuliah_id_kuliah_seq INCREMENT 1 MINVALUE 1 MAXVALUE 9223372036854775807 START 4 CACHE 1;

CREATE TABLE "public"."tbkuliah" (
    "id_kuliah" integer DEFAULT nextval('tbkuliah_id_kuliah_seq') NOT NULL,
    "id_dosen" integer NOT NULL,
    "id_matkul" integer NOT NULL,
    "id_kelas" integer NOT NULL,
    CONSTRAINT "tbkuliah_id_kuliah" PRIMARY KEY ("id_kuliah"),
    CONSTRAINT "tbkuliah_id_dosen_fkey" FOREIGN KEY (id_dosen) REFERENCES tbdosen(id_dosen) ON UPDATE CASCADE ON DELETE CASCADE NOT DEFERRABLE,
    CONSTRAINT "tbkuliah_id_kelas_fkey" FOREIGN KEY (id_kelas) REFERENCES tbkelas(id_kelas) ON UPDATE CASCADE ON DELETE CASCADE NOT DEFERRABLE,
    CONSTRAINT "tbkuliah_id_matkul_fkey" FOREIGN KEY (id_matkul) REFERENCES tbmatkul(id_matkul) ON UPDATE CASCADE ON DELETE CASCADE NOT DEFERRABLE
) WITH (oids = false);

CREATE INDEX "tbkuliah_id_dosen" ON "public"."tbkuliah" USING btree ("id_dosen");

CREATE INDEX "tbkuliah_id_kelas" ON "public"."tbkuliah" USING btree ("id_kelas");

CREATE INDEX "tbkuliah_id_matkul" ON "public"."tbkuliah" USING btree ("id_matkul");


DROP VIEW IF EXISTS "lap_kuliah";
CREATE TABLE "lap_kuliah" ("id_kuliah" integer, "nm_matkul" character varying(30), "nm_dosen" character varying(50), "nm_kelas" character varying(10));


DROP TABLE IF EXISTS "tbkuliah_mhs";
CREATE SEQUENCE tbkuliah_mhs_id_kmhs_seq INCREMENT 1 MINVALUE 1 MAXVALUE 9223372036854775807 START 6 CACHE 1;

CREATE TABLE "public"."tbkuliah_mhs" (
    "id_kmhs" integer DEFAULT nextval('tbkuliah_mhs_id_kmhs_seq') NOT NULL,
    "id_mahasiswa" integer NOT NULL,
    "id_kuliah" integer NOT NULL,
    CONSTRAINT "tbkuliah_mhs_id_kmhs" PRIMARY KEY ("id_kmhs"),
    CONSTRAINT "tbkuliah_mhs_id_kuliah_fkey" FOREIGN KEY (id_kuliah) REFERENCES tbkuliah(id_kuliah) ON UPDATE CASCADE ON DELETE CASCADE NOT DEFERRABLE,
    CONSTRAINT "tbkuliah_mhs_id_mahasiswa_fkey" FOREIGN KEY (id_mahasiswa) REFERENCES tbmahasiswa(id_mahasiswa) ON UPDATE CASCADE ON DELETE CASCADE NOT DEFERRABLE
) WITH (oids = false);

CREATE INDEX "tbkuliah_mhs_id_mahasiswa" ON "public"."tbkuliah_mhs" USING btree ("id_mahasiswa");


DROP VIEW IF EXISTS "lap_kuliah_mhs";
CREATE TABLE "lap_kuliah_mhs" ("id_kmhs" integer, "id_kuliah" integer, "id_mahasiswa" integer, "nm_mahasiswa" character varying(100));


DROP TABLE IF EXISTS "json";
CREATE SEQUENCE json_id_seq INCREMENT 1 MINVALUE 1 MAXVALUE 9223372036854775807 START 1 CACHE 1;

CREATE TABLE "public"."json" (
    "id" integer DEFAULT nextval('json_id_seq') NOT NULL,
    "books" json
) WITH (oids = false);


DROP TABLE IF EXISTS "tbujian";
CREATE SEQUENCE tbujian_id_ujian_seq INCREMENT 1 MINVALUE 1 MAXVALUE 9223372036854775807 START 3 CACHE 1;

CREATE TABLE "public"."tbujian" (
    "id_ujian" integer DEFAULT nextval('tbujian_id_ujian_seq') NOT NULL,
    "id_kuliah" integer NOT NULL,
    "id_tsoal" integer NOT NULL,
    "deskripsi" character varying(200),
    "id_jujian" smallint NOT NULL,
    "durasi_ujian" integer NOT NULL,
    CONSTRAINT "tbujian_id_ujian" PRIMARY KEY ("id_ujian"),
    CONSTRAINT "tbujian_id_jenis_fkey" FOREIGN KEY (id_jujian) REFERENCES tbjenis_ujian(id_jujian) ON UPDATE CASCADE ON DELETE CASCADE NOT DEFERRABLE,
    CONSTRAINT "tbujian_id_kuliah_fkey" FOREIGN KEY (id_kuliah) REFERENCES tbkuliah(id_kuliah) ON UPDATE CASCADE ON DELETE CASCADE NOT DEFERRABLE,
    CONSTRAINT "tbujian_id_tipe_fkey" FOREIGN KEY (id_tsoal) REFERENCES tbtipe_soal(id_tsoal) ON UPDATE CASCADE ON DELETE CASCADE NOT DEFERRABLE
) WITH (oids = false);

CREATE INDEX "tbujian_id_kuliah" ON "public"."tbujian" USING btree ("id_kuliah");

CREATE INDEX "tbujian_id_tipe" ON "public"."tbujian" USING btree ("id_tsoal");


DROP TABLE IF EXISTS "tbsoal_ujian";
CREATE SEQUENCE tbsoal_ujian_id_sujian_seq INCREMENT 1 MINVALUE 1 MAXVALUE 9223372036854775807 START 4 CACHE 1;

CREATE TABLE "public"."tbsoal_ujian" (
    "id_sujian" integer DEFAULT nextval('tbsoal_ujian_id_sujian_seq') NOT NULL,
    "id_ujian" integer NOT NULL,
    "id_soal" integer NOT NULL,
    CONSTRAINT "tbsoal_ujian_id_sujian" PRIMARY KEY ("id_sujian")
) WITH (oids = false);

CREATE INDEX "tbsoal_ujian_id_soal" ON "public"."tbsoal_ujian" USING btree ("id_soal");

CREATE INDEX "tbsoal_ujian_id_ujian" ON "public"."tbsoal_ujian" USING btree ("id_ujian");


DROP VIEW IF EXISTS "lap_soal_ujian";
CREATE TABLE "lap_soal_ujian" ("id_sujian" integer, "id_ujian" integer, "id_soal" integer, "isi_soal" text, "jawaban" text, "pilihanGanda" json);


DROP VIEW IF EXISTS "lap_soal";
CREATE TABLE "lap_soal" ("id_soal" integer, "isi_soal" text, "jawaban" text, "pilihanGanda" json, "id_tsoal" smallint, "nm_tipe" character varying(15), "bobot" smallint);


DROP VIEW IF EXISTS "lap_ujian";
CREATE TABLE "lap_ujian" ("id_ujian" integer, "id_kuliah" integer, "nm_matkul" character varying(30), "nm_dosen" character varying(50), "nm_kelas" character varying(10), "id_tsoal" integer, "nm_tipe" character varying(15), "nm_jenis" character varying(10), "jam" double precision, "menit" integer);


DROP TABLE IF EXISTS "lap_mahasiswa";
CREATE TABLE "public"."lap_mahasiswa" (
    "id_mahasiswa" integer,
    "nobp" character(14),
    "nm_mahasiswa" character varying(100),
    "nm_kelas" character varying(10)
) WITH (oids = false);

DROP TABLE IF EXISTS "lap_kuliah";
CREATE TABLE "public"."lap_kuliah" (
    "id_kuliah" integer,
    "nm_matkul" character varying(30),
    "nm_dosen" character varying(50),
    "nm_kelas" character varying(10)
) WITH (oids = false);

DROP TABLE IF EXISTS "lap_kuliah_mhs";
CREATE TABLE "public"."lap_kuliah_mhs" (
    "id_kmhs" integer,
    "id_kuliah" integer,
    "id_mahasiswa" integer,
    "nm_mahasiswa" character varying(100)
) WITH (oids = false);

DROP TABLE IF EXISTS "lap_soal_ujian";
CREATE TABLE "public"."lap_soal_ujian" (
    "id_sujian" integer,
    "id_ujian" integer,
    "id_soal" integer,
    "isi_soal" text,
    "jawaban" text,
    "pilihanGanda" json
) WITH (oids = false);

DROP TABLE IF EXISTS "lap_soal";
CREATE TABLE "public"."lap_soal" (
    "id_soal" integer,
    "isi_soal" text,
    "jawaban" text,
    "pilihanGanda" json,
    "id_tsoal" smallint,
    "nm_tipe" character varying(15),
    "bobot" smallint
) WITH (oids = false);

DROP TABLE IF EXISTS "lap_ujian";
CREATE TABLE "public"."lap_ujian" (
    "id_ujian" integer,
    "id_kuliah" integer,
    "nm_matkul" character varying(30),
    "nm_dosen" character varying(50),
    "nm_kelas" character varying(10),
    "id_tsoal" integer,
    "nm_tipe" character varying(15),
    "nm_jenis" character varying(10),
    "jam" double precision,
    "menit" integer
) WITH (oids = false);

-- 2017-11-07 09:11:12.616871+07
