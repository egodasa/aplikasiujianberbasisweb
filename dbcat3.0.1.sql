--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.9
-- Dumped by pg_dump version 9.5.9

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: peserta_ujian; Type: TABLE; Schema: public; Owner: mandan
--

CREATE TABLE peserta_ujian (
    id_ujian character varying(40),
    nobp character varying(15),
    nm_mahasiswa character varying(100),
    id_kelas integer,
    nm_kelas character varying(10),
    nilai integer,
    status_ujian_peserta integer,
    nm_status_ujian_peserta text
);


ALTER TABLE peserta_ujian OWNER TO mandan;

--
-- Name: gethasilujian(character varying); Type: FUNCTION; Schema: public; Owner: mandan
--

CREATE FUNCTION gethasilujian(v_id_ujian character varying) RETURNS SETOF peserta_ujian
    LANGUAGE plpgsql
    AS $$
BEGIN
 RETURN QUERY select a.id_ujian,a.nobp,
a.nm_mahasiswa,
cast(a.id_kelas as integer),
a.nm_kelas,
cast((case when (b.nilai IS NULL) then 0 ELSE b.nilai END) as integer) as nilai,
cast((case when (b.nilai IS NULL) then
(CASE WHEN c.jawaban IS NULL THEN 3 ELSE 4 END)
ELSE 5 END) as integer) as status_ujian_peserta,

case when (b.nilai IS NULL) then
(CASE WHEN c.jawaban IS NULL THEN 'Belum Ujian' ELSE 'Periksa Jawaban' END)
ELSE 'Sudah Ujian' END as nm_status_ujian_peserta
 from lap_peserta_ujian a  
left join (select * from tbhasil_ujian aa where aa.id_ujian=v_id_ujian) b on a.nobp=b.nobp 
left join (select aaa.id_ujian,aaa.nobp,aaa.jawaban from tbjawaban aaa where aaa.id_ujian = v_id_ujian) c on a.nobp=c.nobp
where a.id_ujian=v_id_ujian order by a.nm_kelas desc,a.nm_mahasiswa asc;
END; $$;


ALTER FUNCTION public.gethasilujian(v_id_ujian character varying) OWNER TO mandan;

--
-- Name: updatestatuskuliah(); Type: FUNCTION; Schema: public; Owner: mandan
--

CREATE FUNCTION updatestatuskuliah() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin
update tbkuliah set status_kuliah=1 where id_kuliah = new.id_kuliah;
return new;
end;
$$;


ALTER FUNCTION public.updatestatuskuliah() OWNER TO mandan;

--
-- Name: updatestatusujian(); Type: FUNCTION; Schema: public; Owner: mandan
--

CREATE FUNCTION updatestatusujian() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
update tbujian set status_ujian=1 where id_ujian=new.id_ujian;
RETURN new;
END;
$$;


ALTER FUNCTION public.updatestatusujian() OWNER TO mandan;

--
-- Name: tbjawaban_id_jawaban_seq; Type: SEQUENCE; Schema: public; Owner: mandan
--

CREATE SEQUENCE tbjawaban_id_jawaban_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE tbjawaban_id_jawaban_seq OWNER TO mandan;

--
-- Name: tbjawaban; Type: TABLE; Schema: public; Owner: mandan
--

CREATE TABLE tbjawaban (
    id_jawaban integer DEFAULT nextval('tbjawaban_id_jawaban_seq'::regclass) NOT NULL,
    id_ujian character varying(60) NOT NULL,
    nobp character varying(15) NOT NULL,
    jawaban text NOT NULL,
    id_soal integer NOT NULL
);


ALTER TABLE tbjawaban OWNER TO mandan;

--
-- Name: tbsoal_id_soal_seq; Type: SEQUENCE; Schema: public; Owner: mandan
--

CREATE SEQUENCE tbsoal_id_soal_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE tbsoal_id_soal_seq OWNER TO mandan;

--
-- Name: tbsoal; Type: TABLE; Schema: public; Owner: mandan
--

CREATE TABLE tbsoal (
    id_soal integer DEFAULT nextval('tbsoal_id_soal_seq'::regclass) NOT NULL,
    isi_soal text NOT NULL,
    "pilihanGanda" json,
    id_jsoal smallint NOT NULL,
    bobot smallint DEFAULT 1 NOT NULL,
    jawaban text NOT NULL
);


ALTER TABLE tbsoal OWNER TO mandan;

--
-- Name: lap_jawaban; Type: VIEW; Schema: public; Owner: mandan
--

CREATE VIEW lap_jawaban AS
 SELECT tbjawaban.id_jawaban,
    tbjawaban.nobp,
    tbjawaban.id_ujian,
    tbjawaban.id_soal,
    tbsoal.isi_soal,
    tbsoal.jawaban,
    tbjawaban.jawaban AS jawaban_peserta,
    tbsoal.bobot
   FROM (tbjawaban
     JOIN tbsoal ON ((tbjawaban.id_soal = tbsoal.id_soal)));


ALTER TABLE lap_jawaban OWNER TO mandan;

--
-- Name: tbnama_kelas_id_kelas_seq; Type: SEQUENCE; Schema: public; Owner: mandan
--

CREATE SEQUENCE tbnama_kelas_id_kelas_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE tbnama_kelas_id_kelas_seq OWNER TO mandan;

--
-- Name: tbkelas; Type: TABLE; Schema: public; Owner: mandan
--

CREATE TABLE tbkelas (
    id_kelas integer DEFAULT nextval('tbnama_kelas_id_kelas_seq'::regclass) NOT NULL,
    nm_kelas character varying(10) NOT NULL
);


ALTER TABLE tbkelas OWNER TO mandan;

--
-- Name: tbkelas_ujian_id_kujian_seq; Type: SEQUENCE; Schema: public; Owner: mandan
--

CREATE SEQUENCE tbkelas_ujian_id_kujian_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE tbkelas_ujian_id_kujian_seq OWNER TO mandan;

--
-- Name: tbkelas_kuliah; Type: TABLE; Schema: public; Owner: mandan
--

CREATE TABLE tbkelas_kuliah (
    id_kkuliah integer DEFAULT nextval('tbkelas_ujian_id_kujian_seq'::regclass) NOT NULL,
    id_kuliah character varying(60) NOT NULL,
    id_kelas integer NOT NULL
);


ALTER TABLE tbkelas_kuliah OWNER TO mandan;

--
-- Name: lap_kelas_kuliah; Type: VIEW; Schema: public; Owner: mandan
--

CREATE VIEW lap_kelas_kuliah AS
 SELECT a.id_kkuliah,
    a.id_kelas,
    a.id_kuliah,
    b.nm_kelas
   FROM (tbkelas_kuliah a
     JOIN tbkelas b ON ((a.id_kelas = b.id_kelas)));


ALTER TABLE lap_kelas_kuliah OWNER TO mandan;

--
-- Name: tbdosen_id_dosen_seq; Type: SEQUENCE; Schema: public; Owner: mandan
--

CREATE SEQUENCE tbdosen_id_dosen_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE tbdosen_id_dosen_seq OWNER TO mandan;

--
-- Name: tbdosen; Type: TABLE; Schema: public; Owner: mandan
--

CREATE TABLE tbdosen (
    id_dosen integer DEFAULT nextval('tbdosen_id_dosen_seq'::regclass) NOT NULL,
    nm_dosen character varying(100) NOT NULL,
    nidn character varying(15) NOT NULL,
    status_dosen smallint DEFAULT 1 NOT NULL
);


ALTER TABLE tbdosen OWNER TO mandan;

--
-- Name: tbkuliah; Type: TABLE; Schema: public; Owner: mandan
--

CREATE TABLE tbkuliah (
    id_kuliah character varying(40) NOT NULL,
    nidn character varying(11) NOT NULL,
    kd_matkul character varying(15) NOT NULL,
    tahun_akademik character varying(5) NOT NULL,
    status_kuliah smallint DEFAULT '0'::smallint NOT NULL
);


ALTER TABLE tbkuliah OWNER TO mandan;

--
-- Name: tbmatkul_id_matkul_seq1; Type: SEQUENCE; Schema: public; Owner: mandan
--

CREATE SEQUENCE tbmatkul_id_matkul_seq1
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE tbmatkul_id_matkul_seq1 OWNER TO mandan;

--
-- Name: tbmatkul; Type: TABLE; Schema: public; Owner: mandan
--

CREATE TABLE tbmatkul (
    id_matkul integer DEFAULT nextval('tbmatkul_id_matkul_seq1'::regclass) NOT NULL,
    kd_matkul character varying(15) NOT NULL,
    nm_matkul character varying(100) NOT NULL,
    sks smallint NOT NULL,
    smt smallint NOT NULL,
    status_matkul smallint DEFAULT 1 NOT NULL
);


ALTER TABLE tbmatkul OWNER TO mandan;

--
-- Name: tbstatus_status_seq; Type: SEQUENCE; Schema: public; Owner: mandan
--

CREATE SEQUENCE tbstatus_status_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE tbstatus_status_seq OWNER TO mandan;

--
-- Name: tbstatus; Type: TABLE; Schema: public; Owner: mandan
--

CREATE TABLE tbstatus (
    status integer DEFAULT nextval('tbstatus_status_seq'::regclass) NOT NULL,
    nm_status character varying(20) NOT NULL
);


ALTER TABLE tbstatus OWNER TO mandan;

--
-- Name: lap_kuliah; Type: VIEW; Schema: public; Owner: mandan
--

CREATE VIEW lap_kuliah AS
 SELECT a.id_kuliah,
    a.kd_matkul,
    b.nm_matkul,
    a.nidn,
    c.nm_dosen,
    ( SELECT array_to_json(array_agg(d_1.id_kelas)) AS kelas
           FROM (tbkelas_kuliah d_1
             JOIN tbkelas e ON ((e.id_kelas = d_1.id_kelas)))
          WHERE ((d_1.id_kuliah)::text = (a.id_kuliah)::text)) AS id_kelas,
    ( SELECT array_to_json(array_agg(e.nm_kelas)) AS kelas
           FROM (tbkelas_kuliah d_1
             JOIN tbkelas e ON ((d_1.id_kelas = e.id_kelas)))
          WHERE ((d_1.id_kuliah)::text = (a.id_kuliah)::text)) AS nm_kelas,
    a.tahun_akademik,
    a.status_kuliah,
    d.nm_status AS nm_status_kuliah
   FROM (((tbkuliah a
     JOIN tbmatkul b ON (((a.kd_matkul)::text = (b.kd_matkul)::text)))
     JOIN tbdosen c ON (((a.nidn)::text = (c.nidn)::text)))
     JOIN tbstatus d ON ((a.status_kuliah = d.status)));


ALTER TABLE lap_kuliah OWNER TO mandan;

--
-- Name: tbmahasiswa_id_mahasiswa_seq; Type: SEQUENCE; Schema: public; Owner: mandan
--

CREATE SEQUENCE tbmahasiswa_id_mahasiswa_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE tbmahasiswa_id_mahasiswa_seq OWNER TO mandan;

--
-- Name: tbmahasiswa; Type: TABLE; Schema: public; Owner: mandan
--

CREATE TABLE tbmahasiswa (
    id_mahasiswa integer DEFAULT nextval('tbmahasiswa_id_mahasiswa_seq'::regclass) NOT NULL,
    nm_mahasiswa character varying(100) NOT NULL,
    nobp character varying(15) NOT NULL,
    status_mahasiswa smallint DEFAULT 1 NOT NULL
);


ALTER TABLE tbmahasiswa OWNER TO mandan;

--
-- Name: tbpeserta_kuliah; Type: TABLE; Schema: public; Owner: mandan
--

CREATE TABLE tbpeserta_kuliah (
    id_peserta character varying(60) NOT NULL,
    nobp character varying(15) NOT NULL,
    id_kuliah character varying(40) NOT NULL,
    status_peserta smallint DEFAULT 1 NOT NULL,
    status_kelas_peserta smallint DEFAULT '3'::smallint NOT NULL,
    id_kelas integer DEFAULT 0 NOT NULL
);


ALTER TABLE tbpeserta_kuliah OWNER TO mandan;

--
-- Name: lap_peserta_kuliah; Type: VIEW; Schema: public; Owner: mandan
--

CREATE VIEW lap_peserta_kuliah AS
 SELECT a.id_peserta,
    b.id_kuliah,
    b.kd_matkul,
    b.nm_matkul,
    b.nidn,
    b.nm_dosen,
    b.tahun_akademik,
    a.nobp,
    c.nm_mahasiswa,
    a.status_peserta,
    d.nm_status AS nm_status_peserta,
    a.status_kelas_peserta,
    e.nm_status AS nm_status_kelas_peserta,
    a.id_kelas,
    f.nm_kelas
   FROM (((((tbpeserta_kuliah a
     LEFT JOIN lap_kuliah b ON (((a.id_kuliah)::text = (b.id_kuliah)::text)))
     JOIN tbmahasiswa c ON (((a.nobp)::text = (c.nobp)::text)))
     JOIN tbstatus d ON ((a.status_peserta = d.status)))
     JOIN tbstatus e ON ((a.status_kelas_peserta = e.status)))
     JOIN tbkelas f ON ((a.id_kelas = f.id_kelas)));


ALTER TABLE lap_peserta_kuliah OWNER TO mandan;

--
-- Name: tbjenis_soal_id_jsoal_seq; Type: SEQUENCE; Schema: public; Owner: mandan
--

CREATE SEQUENCE tbjenis_soal_id_jsoal_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE tbjenis_soal_id_jsoal_seq OWNER TO mandan;

--
-- Name: tbjenis_soal; Type: TABLE; Schema: public; Owner: mandan
--

CREATE TABLE tbjenis_soal (
    id_jsoal integer DEFAULT nextval('tbjenis_soal_id_jsoal_seq'::regclass) NOT NULL,
    nm_jsoal character varying(20) NOT NULL
);


ALTER TABLE tbjenis_soal OWNER TO mandan;

--
-- Name: tbjenis_ujian_id_jujian_seq; Type: SEQUENCE; Schema: public; Owner: mandan
--

CREATE SEQUENCE tbjenis_ujian_id_jujian_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE tbjenis_ujian_id_jujian_seq OWNER TO mandan;

--
-- Name: tbjenis_ujian; Type: TABLE; Schema: public; Owner: mandan
--

CREATE TABLE tbjenis_ujian (
    id_jujian integer DEFAULT nextval('tbjenis_ujian_id_jujian_seq'::regclass) NOT NULL,
    nm_jujian character varying(10) NOT NULL
);


ALTER TABLE tbjenis_ujian OWNER TO mandan;

--
-- Name: tbujian; Type: TABLE; Schema: public; Owner: mandan
--

CREATE TABLE tbujian (
    id_ujian character varying(40) NOT NULL,
    hari date NOT NULL,
    mulai time without time zone NOT NULL,
    selesai time without time zone NOT NULL,
    deskripsi character varying(100) NOT NULL,
    status_ujian smallint DEFAULT 0 NOT NULL,
    id_jujian smallint NOT NULL,
    id_jsoal smallint NOT NULL,
    id_kuliah character varying(40) NOT NULL
);


ALTER TABLE tbujian OWNER TO mandan;

--
-- Name: lap_ujian; Type: VIEW; Schema: public; Owner: mandan
--

CREATE VIEW lap_ujian AS
 SELECT a.id_ujian,
    a.hari,
    a.mulai,
    a.selesai,
    a.deskripsi,
    a.status_ujian,
    c.nm_status AS nm_status_ujian,
    a.id_jsoal,
    d.nm_jsoal,
    a.id_jujian,
    e.nm_jujian,
    b.id_kuliah,
    b.kd_matkul,
    b.nm_matkul,
    b.nidn,
    b.nm_dosen,
    b.id_kelas,
    b.nm_kelas,
    b.tahun_akademik
   FROM ((((tbujian a
     JOIN lap_kuliah b ON (((a.id_kuliah)::text = (b.id_kuliah)::text)))
     JOIN tbstatus c ON ((a.status_ujian = c.status)))
     JOIN tbjenis_soal d ON ((a.id_jsoal = d.id_jsoal)))
     JOIN tbjenis_ujian e ON ((a.id_jujian = e.id_jujian)));


ALTER TABLE lap_ujian OWNER TO mandan;

--
-- Name: lap_peserta_ujian; Type: VIEW; Schema: public; Owner: mandan
--

CREATE VIEW lap_peserta_ujian AS
 SELECT a.id_ujian,
    a.hari,
    a.mulai,
    a.selesai,
    a.deskripsi,
    a.status_ujian,
    a.nm_status_ujian,
    a.id_jsoal,
    a.nm_jsoal,
    a.id_jujian,
    a.nm_jujian,
    a.kd_matkul,
    a.nm_matkul,
    a.nidn,
    a.nm_dosen,
    b.id_kuliah,
    b.nobp,
    b.nm_mahasiswa,
    b.id_kelas,
    b.nm_kelas,
    concat(a.nm_matkul, '-', a.nm_jujian) AS nm_ujian
   FROM (lap_ujian a
     JOIN ( SELECT aa.id_kuliah,
            aa.nobp,
            bb.nm_mahasiswa,
            aa.id_kelas,
            cc.nm_kelas
           FROM ((tbpeserta_kuliah aa
             JOIN tbmahasiswa bb ON (((aa.nobp)::text = (bb.nobp)::text)))
             JOIN tbkelas cc ON ((aa.id_kelas = cc.id_kelas)))) b ON (((a.id_kuliah)::text = (b.id_kuliah)::text)))
  WHERE (a.status_ujian = 1);


ALTER TABLE lap_peserta_ujian OWNER TO mandan;

--
-- Name: lap_soal; Type: VIEW; Schema: public; Owner: mandan
--

CREATE VIEW lap_soal AS
 SELECT tbsoal.id_soal,
    tbsoal.isi_soal,
    tbsoal."pilihanGanda",
    tbsoal.id_jsoal,
    tbsoal.bobot,
    tbsoal.jawaban,
    tbjenis_soal.nm_jsoal
   FROM (tbsoal
     JOIN tbjenis_soal ON ((tbsoal.id_jsoal = tbjenis_soal.id_jsoal)));


ALTER TABLE lap_soal OWNER TO mandan;

--
-- Name: tbsoal_ujian_id_sujian_seq1; Type: SEQUENCE; Schema: public; Owner: mandan
--

CREATE SEQUENCE tbsoal_ujian_id_sujian_seq1
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE tbsoal_ujian_id_sujian_seq1 OWNER TO mandan;

--
-- Name: tbsoal_ujian; Type: TABLE; Schema: public; Owner: mandan
--

CREATE TABLE tbsoal_ujian (
    id_sujian integer DEFAULT nextval('tbsoal_ujian_id_sujian_seq1'::regclass) NOT NULL,
    id_ujian character varying(40) NOT NULL,
    id_soal integer NOT NULL
);


ALTER TABLE tbsoal_ujian OWNER TO mandan;

--
-- Name: lap_soal_ujian; Type: VIEW; Schema: public; Owner: mandan
--

CREATE VIEW lap_soal_ujian AS
 SELECT tbsoal_ujian.id_ujian,
    tbsoal.id_soal,
    tbsoal.isi_soal,
    tbsoal."pilihanGanda",
    tbsoal.id_jsoal,
    tbsoal.bobot,
    tbsoal.jawaban
   FROM (tbsoal_ujian
     JOIN tbsoal ON ((tbsoal_ujian.id_soal = tbsoal.id_soal)));


ALTER TABLE lap_soal_ujian OWNER TO mandan;

--
-- Name: tbjenis_user_id_juser_seq; Type: SEQUENCE; Schema: public; Owner: mandan
--

CREATE SEQUENCE tbjenis_user_id_juser_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE tbjenis_user_id_juser_seq OWNER TO mandan;

--
-- Name: tbjenis_user; Type: TABLE; Schema: public; Owner: mandan
--

CREATE TABLE tbjenis_user (
    id_juser integer DEFAULT nextval('tbjenis_user_id_juser_seq'::regclass) NOT NULL,
    nm_juser character varying(20) NOT NULL
);


ALTER TABLE tbjenis_user OWNER TO mandan;

--
-- Name: tbuser_id_user_seq; Type: SEQUENCE; Schema: public; Owner: mandan
--

CREATE SEQUENCE tbuser_id_user_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE tbuser_id_user_seq OWNER TO mandan;

--
-- Name: tbuser; Type: TABLE; Schema: public; Owner: mandan
--

CREATE TABLE tbuser (
    id_user integer DEFAULT nextval('tbuser_id_user_seq'::regclass) NOT NULL,
    username character varying(30) NOT NULL,
    password text NOT NULL,
    id_juser smallint NOT NULL,
    status_user smallint DEFAULT 1 NOT NULL
);


ALTER TABLE tbuser OWNER TO mandan;

--
-- Name: lap_user; Type: VIEW; Schema: public; Owner: mandan
--

CREATE VIEW lap_user AS
 SELECT tbuser.id_user,
    tbuser.username,
    tbuser.password,
    tbuser.id_juser,
    tbjenis_user.nm_juser
   FROM (tbuser
     JOIN tbjenis_user ON ((tbuser.id_juser = tbjenis_user.id_juser)));


ALTER TABLE lap_user OWNER TO mandan;

--
-- Name: tbhasil_ujian_id_hasil_seq; Type: SEQUENCE; Schema: public; Owner: mandan
--

CREATE SEQUENCE tbhasil_ujian_id_hasil_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE tbhasil_ujian_id_hasil_seq OWNER TO mandan;

--
-- Name: tbhasil_ujian; Type: TABLE; Schema: public; Owner: mandan
--

CREATE TABLE tbhasil_ujian (
    id_hasil integer DEFAULT nextval('tbhasil_ujian_id_hasil_seq'::regclass) NOT NULL,
    id_ujian character varying(40) NOT NULL,
    nobp character varying(15) NOT NULL,
    nilai smallint NOT NULL
);


ALTER TABLE tbhasil_ujian OWNER TO mandan;

--
-- Name: tbpengaturan; Type: TABLE; Schema: public; Owner: mandan
--

CREATE TABLE tbpengaturan (
    pengaturan json
);


ALTER TABLE tbpengaturan OWNER TO mandan;

--
-- Data for Name: peserta_ujian; Type: TABLE DATA; Schema: public; Owner: mandan
--

COPY peserta_ujian (id_ujian, nobp, nm_mahasiswa, id_kelas, nm_kelas, nilai, status_ujian_peserta, nm_status_ujian_peserta) FROM stdin;
\.


--
-- Data for Name: tbdosen; Type: TABLE DATA; Schema: public; Owner: mandan
--

COPY tbdosen (id_dosen, nm_dosen, nidn, status_dosen) FROM stdin;
1	ANITA ADE RAHMA	1012019001	1
2	ARFIS	1009026602	1
3	AZIZUL HAKIM	1023116001	1
4	BUCHYARDI GOND	1025125401	1
5	DESFRIANA SARI	1028128901	1
6	DESI PERMATA SARI	1013128902	1
7	DESSY HARYANI	1029128101	1
8	DEVI EDRIANI	1027088001	1
9	DIAN MISRAWATI	1021118602	1
10	ELFA FITRIANI	1024089001	1
11	ELFISWANDI	1019046601	1
12	ELIZA	1016098104	1
13	FATMA ARIANI	1020059001	1
14	FITRI YENI	1012028201	1
15	HANNA PRATIWI	1022018601	1
16	HARMELIA	1001059002	1
17	HASMAYNELIS FITRI	1031057501	1
18	INDAH VIOZANI	1025069101	1
19	INDRA FAISAL	1025058801	1
20	LUSIANA	1015107601	1
21	MONDRA NELDI	1025027501	1
22	NITA SOFIA	1023098902	1
23	PRIMAROSI	1012018201	1
24	RIKA WAHYUNI	1007068502	1
25	RIRI PUTRI DIKA	1014048602	1
26	RONNI ANDRI WIJAYA	1011038501	1
27	SALMIDESTIAWAN	1030128501	1
28	SIGIT SANJAYA	1021078901	1
29	SONI	1027087801	1
30	TET LINDA YANI	1026128201	1
31	WELLIA NOVITA	1012118901	1
32	YAMASITHA	1004119001	1
33	YOSI YULIA	1017047602	1
34	YULIA SYAFITRI	1016078301	1
35	CENNYWATI	1024128201	1
36	DEFRIZAL SAPUTRA	1023128702	1
37	HARIS SATRIA	1009038901	1
38	IRNI RESMI APRIYANTI	1016048403	1
39	IRPAN SARIPUDIN	1015077903	1
40	MARIA MARGARETHA EARLENE	1025038701	1
41	RACHMAWATY	1019028401	1
42	TEGUH MEIRIZKY GIRDAYANTO	1001058204	1
43	YULIARMAN MAHMUDDIN	1016077202	1
44	ANDI B. WIRANATA	1025038501	1
45	ANDRE ILYAS	1009038301	1
46	ARIE YUSNELLY	1017068801	1
47	DARMA SYAHRULLAH EKA JAYA	1007098201	1
48	DASRIAL	1024086203	1
49	DASRIL MUNIR	1027125401	1
50	DICE DASRIL	1019038102	1
51	DIMAS PERDANA OSKAR	1012078502	1
52	ELVA SUSANTI	1012038303	1
53	EMILE SALIM	1010079101	1
54	ENGLA DESNIM SILVIA	1009128604	1
55	FITRAH SARI	1022118504	1
56	HADI IRFANI	1014018204	1
57	HERYATMAN	1022036901	1
58	HILDA MARY	1027088203	1
59	INDRIYENNI	1025056601	1
60	JON MAIZAR	1007018004	1
61	M. FADLI	1030098902	1
62	MARTA WIDIAN SARI	1020039001	1
63	MASRIFAH	303116303	1
64	MASRIZAL	1006088103	1
65	MAWARDI	1006095901	1
66	MERI MERIA SARI	1013029101	1
67	MEUTHI AN-NISA NOVIZAR	1017078906	1
68	MIRSAL	1004079001	1
69	NALIM	1001066001	1
70	NARDIMAN	1001018305	1
71	NILA PRATIWI	1001128601	1
72	R A APULIJAH ABUTOJO	324123401	1
73	RAMDANI BAYU PUTRA	1002117201	1
74	RANGGA WENDRA PRINOYA	1017128702	1
75	RINI AFRIANI	1008048803	1
76	RIO ANDHIKA PUTRA	1029038701	1
77	ROBBY DHARMA	1009038404	1
78	ROBERTA JULFA	1015108903	1
79	SASNELWATI	1024017001	1
80	SILVIA JESIKA	1027018901	1
81	SRI MONALISA	1029128503	1
82	SRI MULYATI	1004107101	1
83	SUHERMIZON	1005076403	1
84	SYAHNAN SIMATUPANG	1017066402	1
85	TIFANI RATU FIRDAUS	1013128901	1
86	TITIK EFNITA	1012039001	1
87	VICKY BRAHMA KUMBARA	1006108801	1
88	VIVI NILA SARI	1030118604	1
89	WINDA AFRIYENIS	1019048803	1
90	YEKI CANDRA	1019128204	1
91	YULASMI	1019087501	1
92	YULI ANGGRAINI	1013048204	1
93	ZAINAL ABDUL HARIS	1030087001	1
94	ZERNI MELMUSI	0011045604	1
95	AULIA FITRUL HADI	1017049101	1
96	DIYAWATI	1011087502	1
97	FENDI ANTONI	1015078501	1
98	HANGGI DWIFA HONESQI	1008018901	1
99	IDRIZON	1009117001	1
100	MAIDAWATI	1017047702	1
101	NOVALIA INDRA	1014019002	1
102	RIRY YUSKAR	1017047701	1
103	SILFIA ANDINI	1003056801	1
104	SULARNO	1016058902	1
105	SURMAYANTI	1029116801	1
106	VIVI RESTI DARMISON	1009128301	1
107	YOSEFRIZAL	1003077501	1
108	NURFITRI	1028048501	1
109	AMINDA DEWI SUTIASIH	1014039002	1
110	ANDRIYAS HARIYANDI	1020078401	1
111	DEVIT SATRIA	1024058901	1
112	DEWI DEVITA	1005019001	1
113	ILHAM TRI MAULANA	1017119002	1
114	INDRA WIJAYA	1025128401	1
115	IRNAWATI SIREGAR	1023016801	1
116	LAILA MARHAYATI	1031038803	1
117	LILI RISMAINI	1005058504	1
118	MEGAWATI	1003088802	1
119	MONICA FRANSISCA	1012019101	1
120	MUHARIKA DEWI	1031127801	1
121	NONI FEBRIANA	1019028801	1
122	POPI RADYULI	1003038901	1
123	RENNY PERMATA SAPUTRI	1014118801	1
124	RINI SEFRIANI	1008098501	1
125	SILVIA PERMATA SARI	1003088903	1
126	TAUFIK ADE KURNIAWAN	1009029001	1
127	YOSA NOVIA DEWI	1019018402	1
128	ZUBAIDAH	1009098901	1
129	ANDHIKA ANGGAWIRA	1024098002	1
130	ASIYARFITRIADI	1026078201	1
131	BAYU PRASETYA YUDHA	1018108501	1
132	DEVI PURNAMA SARI	1003098301	1
133	HARRI KURNIAWAN	1017018602	1
134	HARRY THEOZARD FIKRI	1026067804	1
135	HERIO RIZKI DEWINDA	1009098503	1
136	IFANI CANDRA	1006068603	1
137	ISNA ASYRI SYAHRINA	17017305	1
138	KRISNOVA NASTASIA	1022068801	1
139	PURWANTI ENDAH RAHAYU	1020118203	1
140	RANY FITRIANY	1017018601	1
141	RINA MARIANA	1010088203	1
142	SILFI FATAYANI	1011059001	1
143	SITTI HUTARI MULYANI	1017089001	1
144	UMMIL KHAIRIYAH	1011118501	1
145	ZERA MENDOZA	1015107101	1
146	ALBERT GAZALI	1029098901	1
147	ANNISAK IZZATY JAMHUR	1012129101	1
148	ASHABUL FADHLI	1029108702	1
149	ASRI NAWAS SE MM	1020048002	1
150	DEBY ERDRIANI	1002068501	1
151	DENI AMELIA	1010118402	1
152	DEPI DASMAL	1020057501	1
153	DEVI SYUKRI AZHARI S.PD.I M.PD	1008128701	1
154	DHANI PRAMULIA EKA PUTRA	1027118601	1
155	DIAN FITRINI	1019018202	1
156	DINUL AKHIYAR	1020028602	1
157	DODI STAPET	1014028503	1
158	DODI YANDRI	1009017602	1
159	DRS.HM.IQBAL.MM	1060785021	1
160	EDWAR KEMAL	1012068203	1
161	EKA MARIYANTI	1026038501	1
162	EKA MELATI M.PD	1002058401	1
163	EKA MELATI M.PD	1002058402	1
164	ELLYA GUSWANITA	1015087203	1
165	ELMI RAHMAWATI PUTRI	1009048503	1
166	ENDRYL SH MH	1017048603	1
167	ERDISNA	1009127301	1
168	ERLINDA	1027088101	1
169	ERNA SUSANTI SE MM	1003127702	1
170	EVA RIANTI	1028098602	1
171	FADLI HERNANDA	1021068601	1
172	FAJRUL ISLAMI	1011118901	1
173	FATHURRAHMI	1018058602	1
174	FEBRIYANNO SURYANA	1005028102	1
175	FIRNA YENILA	1008088702	1
176	GUSHELMI	1012087401	1
177	GUSLENDRA	1016087201	1
178	HADI SYAHPUTRA	1011108502	1
179	HAFNI	1019057502	1
180	HARI MARFALINO	1010039001	1
181	HARRY AL GHAZALY	1015128601	1
182	HEMA DESSY HARIANI	1016118002	1
183	HEMAT JUNEDI	1020037703	1
184	HENDRIK MARGARET	1001037101	1
185	HENDY MUCHRIZA	1008108301	1
186	HESTI PUSPARINI SE M.SI	1013058604	1
187	HEZY KURNIA	1014099001	1
188	HIKMAH	1002098302	1
189	ILHAMDI KURNIAWAN	1021118101	1
190	IRSYADUL EKA PUTERA	1010068501	1
191	IRZAL ARIEF WISKY	1012059001	1
192	ISNADUL HAMDI	1021038303	1
193	JENDRI MULYADI S.S M.HUM	1028018801	1
194	JHON VERI	1008077101	1
195	JIMMY FEBIO	1010028701	1
196	JUFRIADIF NA AM	1003026702	1
197	JULIUS SANTONY	1029077301	1
198	JUMRAWARSI	1012128601	1
199	KARTIRIA	1025128101	1
200	KHAIRUL ZAMAN	1016058503	1
201	LAKRY MALTAF PUTRA	1019068501	1
202	LARISSA NAVIA RANI	1020119201	1
203	LENI SYASMIRA	1003098302	1
204	LIGA MAYOLA	1022069201	1
205	LINORA RAHAYU	1021128701	1
206	MAHA RANI	1014058901	1
207	MELINA IRMAYENI SH M.KN	1003058302	1
208	MONDHA IRFANDI	1021117701	1
209	MUHAMMAD MAHZUM	1011076801	1
210	MUHAMMAD TEGUH ILHAM	1002058901	1
211	MUTIANA PRATIWI	1026059101	1
212	NUSYIRWIN	1008106404	1
213	OKTA ANDRICA PUTRA	1005108604	1
214	ONDRA EKA PUTRA	1006068701	1
215	PRIMA SANITA SYAIFUL	1011058003	1
216	RAFLIS	1003048501	1
217	RAFNIS	1007068001	1
218	RIFDA NAJMI FUAD	1019125102	1
219	RINA SUSANTI	1019128501	1
220	RINI SOVIA	1005047601	1
221	RIZA YONITA S.S MM	1015048302	1
222	ROKI ADITAMA	1003068801	1
223	RUDI SYAFRI	1022108302	1
224	SABARUDIN	1023046101	1
225	SAHARI	1028128501	1
226	SATRIA RONALDY	1026108202	1
227	SHALLY AMNA	1021018402	1
228	SITTI RIZKI MULYANI	1001088204	1
229	SOFIKA ENGGARI	1016038602	1
230	SRI RAHMAWATI	1015067501	1
231	SRI RAMADHAN	1024048503	1
232	SUHELMI HELIA	1025076401	1
233	SYAFRI ARLIS	1023108601	1
234	SYAFRI JODI	1027067903	1
235	SYAFRIKA DENI RIZKI	1016068402	1
236	SYAMSI	1006057201	1
237	SYELFIA DEWIMARNI S.PD M.PD	1013048502	1
238	SYUHADI	1021037202	1
239	USMAN	1010068304	1
240	VIVI IRAWATI	1006017601	1
241	VIVI PUSPITA SARI	1010028505	1
242	WIFRA SAFITRI	1008058902	1
243	YANTI YUSMAN	1024048502	1
244	YENG PRIMAWATI	1010088704	1
245	YOSE RIZAL	1002117401	1
246	YUHANDRI	1015057301	1
247	YULIA RETNO SARI	1003078402	1
248	YUSTA NOVERISON	1005117101	1
249	ZEFRI YENNI	1009096401	1
250	AGGY PRAMANA GUSMAN	1017069001	1
251	AGUS SURYADI	1028088702	1
252	ASMAINI	1020057603	1
253	BILLY HENDRIK	1018048301	1
254	DEDY WAHYUDI	1009087402	1
255	DODI GUSWANDI	1003088601	1
256	EKO AMRI JAYA	1026108501	1
257	EMIL NAF`AN	1017127401	1
258	FIRDAUS	1011098501	1
259	HALIFIA HENDRI	1010058703	1
260	HANDY RACHMAT TRIYADI	1028018301	1
261	HARIS SURYAMEN	1023037504	1
262	HARKAMSYAH ANDRIANOF	1017089002	1
263	HASRI AWAL	1020099101	1
264	ISMI PUTRI	1018078601	1
265	MARDHIAH MASRIL	1012108401	1
266	MARDISON	1003078601	1
267	MARTIN WAHYUNUS	1017098206	1
268	MUHARDI. Z	1018017501	1
269	NESA LITA	1023098901	1
270	RAHMAT HIDAYAT	1031059001	1
271	REFI SENATA	1026099001	1
272	RETNO DEVITA	1004038101	1
273	RIA ANGGRAINI	1016067902	1
274	RISKA ROBIANTO	1004077904	1
275	RITA	1010047701	1
276	ROMI HARDIANTO	1007099001	1
277	RURI HARTIKA ZAIN	1016038601	1
278	SILKY SAFIRA	1004069101	1
279	YOGI WIYANDRA	1011019001	1
280	YONKY PERNANDO	1013049001	1
281	ZULBATRI	1012085301	1
282	ZULFAHMI	1012098102	1
283	ERWIN RAMADIAN	1026097501	1
284	HENNY YULIUS	1027018501	1
285	IRSAN	1007048304	1
286	MOHAMMAD FADHLI	1003049001	1
287	MUFRIDA MERI Z	1011018301	1
288	WAHYU FITRIANDA MUFTI	1029058703	1
289	ABULWAFA MUHAMMAD	1021098101	1
290	ADI PRANOTO	1010097701	1
291	ANESIA NILA KINANTI	1011098802	1
292	BENNY WAHYUDI	1028058402	1
293	CHARLES DARWIN	1011064901	1
294	DEVAL GUSRION	1021088601	1
295	DEVIA KARTIKA	1021129101	1
296	DEWI EKA PUTRI	1015048703	1
297	DHIO SAPUTRA	1026129001	1
298	DIAN CHRISTINA	1010128402	1
299	EKA LIA FEBRIANTI	1008028803	1
300	EKA PRAJA WIYATA MANDALA	1014088502	1
301	FEBRI HADI	1015028801	1
302	GUNADI WIDI NUR CAHYO	1014036901	1
303	IHSAN VERDIAN	1022038901	1
304	ILMAWATI	1009047901	1
305	LIDYA RIZKI ANANDA	1014039301	1
306	MASRIADI	1012029101	1
307	MISHBAH ULHUSNA	1028088201	1
308	MUHAMMAD AFDHAL	1022098403	1
309	MUHAMMAD IKHLAS	1012059101	1
310	MUHAMMAD REZA PUTRA	1018119001	1
311	MUSLI YANTO	1007078901	1
312	MUSTAPA	1007118403	1
313	NUGRAHA RAHMANSYAH	1031038901	1
314	PINTA MEDINA	1028018001	1
315	PURNAMA SARI	1021018802	1
316	RAJA AYU MAHESSYA	1023119001	1
317	RANDY PERMANA	1012128701	1
318	REVA MUHARENI	1029098402	1
319	REVI GUSRIVA	1031088901	1
320	RICKI ARDIANSYAH	1007069201	1
321	RIMA LIANA GEMA	1013098901	1
322	RIZKI NURDIN	1012118403	1
323	ROMI WIJAYA	1017059201	1
324	SARJON DEFIT	1007087002	1
325	SAYENDRA SAFARIA	1026099002	1
326	SHARY ARMONITHA LUSINIA	1021128801	1
327	SRI DIANA PUTRI	1023018901	1
328	SUMIJAN	0005076607	1
329	TERI ADE PUTRA	1001059001	1
330	TITIN KOMLA DEWI	1004118102	1
331	USMAN	1008108202	1
332	VICKY ARIANDI	1007088801	1
333	WENTY ZAHRATI	1003098202	1
334	YESRI ELVA	1004129101	1
335	ZAKIRMAN	1016089101	1
336	AFRILDA SARI	1017047902	1
337	CUT DONA KORDELIA	1028018201	1
338	FEBRIAN	1011027001	1
339	NADRA ARSYAD	1024048504	1
340	REZZA FALEN	1014028804	1
341	RIKI ADRIADI	1018048401	1
342	WENDI BOY	0006047306	1
343	WIDIAWATI PURBA	1018118401	1
344	ZULDES JONI ST	1024127202	1
346	dafuk	123456	1
347	graphql	000000	1
\.


--
-- Name: tbdosen_id_dosen_seq; Type: SEQUENCE SET; Schema: public; Owner: mandan
--

SELECT pg_catalog.setval('tbdosen_id_dosen_seq', 1, false);


--
-- Data for Name: tbhasil_ujian; Type: TABLE DATA; Schema: public; Owner: mandan
--

COPY tbhasil_ujian (id_hasil, id_ujian, nobp, nilai) FROM stdin;
\.


--
-- Name: tbhasil_ujian_id_hasil_seq; Type: SEQUENCE SET; Schema: public; Owner: mandan
--

SELECT pg_catalog.setval('tbhasil_ujian_id_hasil_seq', 3, true);


--
-- Data for Name: tbjawaban; Type: TABLE DATA; Schema: public; Owner: mandan
--

COPY tbjawaban (id_jawaban, id_ujian, nobp, jawaban, id_soal) FROM stdin;
\.


--
-- Name: tbjawaban_id_jawaban_seq; Type: SEQUENCE SET; Schema: public; Owner: mandan
--

SELECT pg_catalog.setval('tbjawaban_id_jawaban_seq', 6, true);


--
-- Data for Name: tbjenis_soal; Type: TABLE DATA; Schema: public; Owner: mandan
--

COPY tbjenis_soal (id_jsoal, nm_jsoal) FROM stdin;
1	Pilihan Ganda
2	Essai
\.


--
-- Name: tbjenis_soal_id_jsoal_seq; Type: SEQUENCE SET; Schema: public; Owner: mandan
--

SELECT pg_catalog.setval('tbjenis_soal_id_jsoal_seq', 1, false);


--
-- Data for Name: tbjenis_ujian; Type: TABLE DATA; Schema: public; Owner: mandan
--

COPY tbjenis_ujian (id_jujian, nm_jujian) FROM stdin;
1	UTS
2	UAS
3	Lain
\.


--
-- Name: tbjenis_ujian_id_jujian_seq; Type: SEQUENCE SET; Schema: public; Owner: mandan
--

SELECT pg_catalog.setval('tbjenis_ujian_id_jujian_seq', 1, false);


--
-- Data for Name: tbjenis_user; Type: TABLE DATA; Schema: public; Owner: mandan
--

COPY tbjenis_user (id_juser, nm_juser) FROM stdin;
1	Admin
2	Dosen
3	Mahasiswa
\.


--
-- Name: tbjenis_user_id_juser_seq; Type: SEQUENCE SET; Schema: public; Owner: mandan
--

SELECT pg_catalog.setval('tbjenis_user_id_juser_seq', 1, false);


--
-- Data for Name: tbkelas; Type: TABLE DATA; Schema: public; Owner: mandan
--

COPY tbkelas (id_kelas, nm_kelas) FROM stdin;
1	SI-1
2	SI-2
3	SI-3
4	SI-4
5	SI-5
6	SI-6
7	SI-7
8	SI-8
9	SI-9
10	SI-10
11	SI-11
\.


--
-- Data for Name: tbkelas_kuliah; Type: TABLE DATA; Schema: public; Owner: mandan
--

COPY tbkelas_kuliah (id_kkuliah, id_kuliah, id_kelas) FROM stdin;
1	KKKI12106-1026108501-20171	10
2	KKKI12106-1026108501-20171	9
6	KKKI22106-1026108501-20171	1
7	KKKI22106-1026108501-20171	2
8	KKKI22106-1026108501-20171	3
3	KPKI12102-1029108702-20171	6
\.


--
-- Name: tbkelas_ujian_id_kujian_seq; Type: SEQUENCE SET; Schema: public; Owner: mandan
--

SELECT pg_catalog.setval('tbkelas_ujian_id_kujian_seq', 6, true);


--
-- Data for Name: tbkuliah; Type: TABLE DATA; Schema: public; Owner: mandan
--

COPY tbkuliah (id_kuliah, nidn, kd_matkul, tahun_akademik, status_kuliah) FROM stdin;
\.


--
-- Data for Name: tbmahasiswa; Type: TABLE DATA; Schema: public; Owner: mandan
--

COPY tbmahasiswa (id_mahasiswa, nm_mahasiswa, nobp, status_mahasiswa) FROM stdin;
1	Ego Dafma Dasa	14101152610565	1
2	Aidil	14101152610544	1
3	Irvan Rultio	14101152610550	1
4	Davidsyah Permana Putra	14101152610545	1
5	Yogi Anggara	14101152610590	1
6	Afdhal Trianda	14101152610555	1
7	Muhammad Fadli	14101152610579	1
8	M.Nurico Pratama S	14101152610551	1
9	Khaliq Alfikrizal	14101152610574	1
10	Riyan Mahruf Syaputra	14101152610583	1
11	Gilang Kovalen	13101152610342	1
12	Cici Syuryantika	14101152610561	1
13	Debby Puspitasari	14101152610562	1
14	Novrizal Adri	14101152610032	1
15	Try Lestari	14101152610733	1
16	Masrifadil Firmansyah	14101152610457	1
\.


--
-- Name: tbmahasiswa_id_mahasiswa_seq; Type: SEQUENCE SET; Schema: public; Owner: mandan
--

SELECT pg_catalog.setval('tbmahasiswa_id_mahasiswa_seq', 1, false);


--
-- Data for Name: tbmatkul; Type: TABLE DATA; Schema: public; Owner: mandan
--

COPY tbmatkul (id_matkul, kd_matkul, nm_matkul, sks, smt, status_matkul) FROM stdin;
1	KKKI12106	Pengantar Teknologi Info.	2	1	1
2	KKKI12116	Paket Pemrograman I ()	2	1	1
3	KKKI13105	Pengantar Manajemen	3	1	1
4	KKKI13111	Kalkulus	3	1	1
5	KPKI12101	Pendidikan Pancasila	2	1	1
6	KPKI12102	Pendidikan Agama	2	1	1
7	KPKI12105	Bahasa Inggris I	2	1	1
8	KBKI23117	Paket Pemrograman II ()	3	2	1
9	KKKI22106	Pengetahuan Bisnis (E-Businees)	2	2	1
10	KKKI22108	Teori Organisasi Umum	2	2	1
11	KKKI23102	Alg. & Struktur Data II (Pas)	3	2	1
12	KKKI23104	Statistika	3	2	1
13	KKKI23109	Sistem Basis Data	3	2	1
14	KKKI23110	Konsep Sis. Informasi	3	2	1
15	KPKI22107	Bahasa Inggris II	2	2	1
16	KBKI32110	Sistem Info. Manajemen	2	3	1
17	KBKI32114	Arsitektur Komputer	2	3	1
18	KBKI32115	Metode Peng Dan Akses	2	3	1
19	KBKI33109	Perancangan Basis Data	3	3	1
20	KKKI33101	Matematika Diskrit	3	3	1
21	KKKI33103	Aljabar Linier	3	3	1
22	KKKI33114	Bhs Pemrograman I (C)	3	3	1
23	KBKI42122	Teknik Riset Operasional (3)	2	4	1
24	KBKI43106	Ans. Dan Perancangan SI  1	3	4	1
25	KBKI43112	Bhs Pemrograman II (C++)	3	4	1
26	KBKI43113	Model Dan Simulasi	3	4	1
27	KKKI42113	Sistem Operasi	2	4	1
28	KKKI43116	Dasar Akuntansi (2)	3	4	1
29	KPKI42103	Pend. Kewarganegaraan	2	4	1
30	KBKI52118	Sistem Inventory  (1)	2	5	1
31	KBKI53108	Analisa Dan Perancangan SI	2	5	1
32	KBKI53112	Bhs Pemrograman III ( JAVA)	3	5	1
33	KKKI52112	Teknik Kompilasi	2	5	1
34	KPKI52103	Sistem Informasi Akuntansi	2	5	1
35	KPKI52104	Analisis Proses Bisnis	2	5	1
36	KPKI52108	Komputer & Masyarakat (2)	2	5	1
37	PKBI52001	Mnj. Proyek Perangkat Lunak	2	5	1
38	PKBI52002	Aplikasi Basis Data Server	2	5	1
39	KBKI62121	Metodologi Penelitian	2	6	1
40	KBKI63101	Jaringan Komputer	3	6	1
41	KBKI63104	Testing &amp; Implementasi Sist.	3	6	1
42	KBKI63107	Sist. Penunjang Keputusan	3	6	1
43	KPKI62101	Perbankan	2	6	1
44	KPKI62104	Bahasa Indonesia	2	6	1
45	KPKI62108	Pendidikan Karakter	2	6	1
46	PKKI62003	Aplikasi Grafika Komputer	2	6	1
47	BBKI72123	Etika Profesi	2	7	1
48	KKKI72103	Mnj. Sains (Jaringan Saraf)	2	7	1
49	KKKI72120	Praktek Kerja Lapangan  (2)	2	7	1
50	KKKI73110	Pengelolaan Sis. Info.	3	7	1
51	BBKI82112	Kecakapan Antar Personal	2	7	1
52	KBKI82127	Kapita Selekta	2	7	1
53	KBKI83119	Bhs.Pemrograman Lanjutan (VB Lanjutan)	3	7	1
54	KPKI82106	Kewirausahaan	2	7	1
55	KKKI13102	Algo. Struktur DataI (Pas)	3	1	1
\.


--
-- Name: tbmatkul_id_matkul_seq1; Type: SEQUENCE SET; Schema: public; Owner: mandan
--

SELECT pg_catalog.setval('tbmatkul_id_matkul_seq1', 1, false);


--
-- Name: tbnama_kelas_id_kelas_seq; Type: SEQUENCE SET; Schema: public; Owner: mandan
--

SELECT pg_catalog.setval('tbnama_kelas_id_kelas_seq', 1, false);


--
-- Data for Name: tbpengaturan; Type: TABLE DATA; Schema: public; Owner: mandan
--

COPY tbpengaturan (pengaturan) FROM stdin;
\.


--
-- Data for Name: tbpeserta_kuliah; Type: TABLE DATA; Schema: public; Owner: mandan
--

COPY tbpeserta_kuliah (id_peserta, nobp, id_kuliah, status_peserta, status_kelas_peserta, id_kelas) FROM stdin;
14101152610565-KKKI12106-1026108501-20171	14101152610565	KKKI12106-1026108501-20171	1	3	10
14101152610544-KKKI12106-1026108501-20171	14101152610544	KKKI12106-1026108501-20171	1	3	9
14101152610555-KKKI22106-1026108501-20171	14101152610555	KKKI22106-1026108501-20171	1	3	1
14101152610544-KKKI22106-1026108501-20171	14101152610544	KKKI22106-1026108501-20171	1	3	1
14101152610561-KKKI22106-1026108501-20171	14101152610561	KKKI22106-1026108501-20171	1	3	1
14101152610545-KKKI22106-1026108501-20171	14101152610545	KKKI22106-1026108501-20171	1	3	2
14101152610562-KKKI22106-1026108501-20171	14101152610562	KKKI22106-1026108501-20171	1	3	2
14101152610565-KKKI22106-1026108501-20171	14101152610565	KKKI22106-1026108501-20171	1	3	2
14101152610574-KKKI22106-1026108501-20171	14101152610574	KKKI22106-1026108501-20171	1	3	3
13101152610342-KKKI22106-1026108501-20171	13101152610342	KKKI22106-1026108501-20171	1	3	3
14101152610550-KKKI22106-1026108501-20171	14101152610550	KKKI22106-1026108501-20171	1	3	3
14101152610555-KPKI12102-1029108702-20171	14101152610555	KPKI12102-1029108702-20171	1	3	6
14101152610544-KPKI12102-1029108702-20171	14101152610544	KPKI12102-1029108702-20171	1	3	6
\.


--
-- Data for Name: tbsoal; Type: TABLE DATA; Schema: public; Owner: mandan
--

COPY tbsoal (id_soal, isi_soal, "pilihanGanda", id_jsoal, bobot, jawaban) FROM stdin;
2	javascript adalah	\N	2	20	bahasa pemrograman
3	E dalam bisnis adaa=lah	[{"huruf":"A","isi_pilihan":"elektronik"},{"huruf":"B","isi_pilihan":"gundul"},{"huruf":"C","isi_pilihan":"au ah gelap"}]	1	1	A
1	Gundul adalah	\N	2	12	eh
4	xzx	\N	2	12	zx
5	sdsx	\N	2	12	sax
6	sdsx	\N	2	12	sax
7	sdsx	\N	2	12	sax
8	sdsx	\N	2	12	sax
9	cxzzz	[{"huruf":"A","isi_pilihan":"scz"},{"huruf":"B","isi_pilihan":"xs"},{"huruf":"C","isi_pilihan":"zsx"}]	1	1	A
10	dasdsa	\N	2	12	swsa
11	Bisnis adalah?	[{"huruf":"A","isi_pilihan":"manggaleh"},{"huruf":"B","isi_pilihan":"ntah"}]	1	1	A
12	sads	\N	2	12	xasx
13	ccdc	\N	2	12	zxczz
14	zxcz	\N	2	12	zxczxc
15	zcasz	\N	2	12	cdxcdx
16	zscszcz	\N	2	12	zdddccd
17	zxccxzd	\N	2	12	dzczxvdv
18	zcxxccx	\N	2	12	xcxxzc
19	zxc	\N	2	12	xzc
20	xzX	\N	2	12	zsxz
21	Gundulmu	\N	2	20	gundulku
\.


--
-- Name: tbsoal_id_soal_seq; Type: SEQUENCE SET; Schema: public; Owner: mandan
--

SELECT pg_catalog.setval('tbsoal_id_soal_seq', 21, true);


--
-- Data for Name: tbsoal_ujian; Type: TABLE DATA; Schema: public; Owner: mandan
--

COPY tbsoal_ujian (id_sujian, id_ujian, id_soal) FROM stdin;
\.


--
-- Name: tbsoal_ujian_id_sujian_seq1; Type: SEQUENCE SET; Schema: public; Owner: mandan
--

SELECT pg_catalog.setval('tbsoal_ujian_id_sujian_seq1', 21, true);


--
-- Data for Name: tbstatus; Type: TABLE DATA; Schema: public; Owner: mandan
--

COPY tbstatus (status, nm_status) FROM stdin;
0	Tidak Aktif
1	Aktif
2	Ditunda
3	Belum Ujian
4	Periksa Jawaban
5	Sudah Ujian
\.


--
-- Name: tbstatus_status_seq; Type: SEQUENCE SET; Schema: public; Owner: mandan
--

SELECT pg_catalog.setval('tbstatus_status_seq', 1, false);


--
-- Data for Name: tbujian; Type: TABLE DATA; Schema: public; Owner: mandan
--

COPY tbujian (id_ujian, hari, mulai, selesai, deskripsi, status_ujian, id_jujian, id_jsoal, id_kuliah) FROM stdin;
\.


--
-- Data for Name: tbuser; Type: TABLE DATA; Schema: public; Owner: mandan
--

COPY tbuser (id_user, username, password, id_juser, status_user) FROM stdin;
1	1012019001	db6653d17bc6d38ec16390d7368ee1df	2	1
2	1009026602	41ef49094fe0cd268aec84f100dcb963	2	1
4	1025125401	1a35a5d2bafd6b907a43a78788e74003	2	1
5	1028128901	c4e95b4da82ad63735dc8398b34e0b8e	2	1
6	1013128902	8d452f6928b45c750494a3ca3f729bd1	2	1
7	1029128101	5c09a6f1b3ff4d516f1f1239fad46e9c	2	1
8	1027088001	ba759f455514b2e2b7c59a98e599f676	2	1
9	1021118602	4f9cd0f4ad10179bb8928a3107d79114	2	1
10	1024089001	e13d389c6543438eea77db7d320eebdb	2	1
11	1019046601	b7b734250f742dab8a1589f725ef7b3a	2	1
12	1016098104	2812044b39bfa6f2d40f34dd1fef3edf	2	1
13	1020059001	bbcb7aa41ecf36508f1fa33a70988ee0	2	1
14	1012028201	3dd9bd5a2d54b9d26dca7626e3b1b668	2	1
15	1022018601	9403384727ef1f29d85c778e8e1b169c	2	1
16	1001059002	bb4bef0c4486890299cd250a65f9900e	2	1
17	1031057501	6a815de054b84d3ef7ed54585d25ec33	2	1
18	1025069101	49e9ab2fb06ddc23e0b06e777d0c0b41	2	1
19	1025058801	d373ef8938da648821aba2f26e571037	2	1
20	1015107601	385afe8b50053133008e14d10e64ed6e	2	1
21	1025027501	a03c311486416b6f3cf1bfdcb5752d14	2	1
22	1023098902	7f1a2676d3baf3e392caa0921f782477	2	1
23	1012018201	e0282ec4bf2922af46c7243709f78082	2	1
24	1007068502	79d78b789a4f67d4d29e67d11213aa68	2	1
25	1014048602	9ad3a6a97a4db91ee893b299384a02c0	2	1
26	1011038501	03ae389acda027545f3dbabaf759935d	2	1
27	1030128501	e198db3fb6ba917dce2107f1ec6b962a	2	1
28	1021078901	8c0ae9dc37e6860778bfcf65f2e1a247	2	1
29	1027087801	05352aef7448107e3737dbbdb6c94222	2	1
30	1026128201	e5e620280edfdc57b3ded51b9fc12e01	2	1
31	1012118901	7838d6a240e01afc0200f127dc2e21bc	2	1
32	1004119001	53fb52d6874923557e2901e87ae35525	2	1
33	1017047602	83fe76ca06bf2fd41d521fd39ca30566	2	1
34	1016078301	b309849cb415f46f5d7785310c2dd349	2	1
35	1024128201	aa63e50b66649e45a76be0e56c7b2e8c	2	1
36	1023128702	45a486fb5a50df42aaf32981d8d62f6e	2	1
37	1009038901	25150e9acd9efaf3d9ab6aac93aabd07	2	1
38	1016048403	5b14d9b7f86de17b2ca6aa85ec0f730e	2	1
39	1015077903	49431020cc52cc85fdfe33fbfe344bd1	2	1
40	1025038701	cfa4dd7e3b5e33cabf8ed519b26d61a6	2	1
41	1019028401	7ba2f52d59c903cdd0363419ae22a917	2	1
42	1001058204	c3f784ec6e7ffabe84bf23e38ddaf02b	2	1
43	1016077202	550216e63807a4c43df296d7e65c08bf	2	1
44	1025038501	32d7221efe9123495492828a6defafd0	2	1
45	1009038301	a6a7fd704953c6c86bc853c7c049e237	2	1
46	1017068801	ae0db61d667bdd0b492776007ae191c8	2	1
47	1007098201	a2f2b3b76307c1d1b6dfba4ac592c81a	2	1
48	1024086203	b3fce63e2623ff4e899ac08dd88d03a0	2	1
49	1027125401	d1785f2eb5eeb945c70ab0ff0027e9e6	2	1
50	1019038102	37955a600a9095dd615d5abfdeb616a2	2	1
51	1012078502	dcecb344563634b0300b2c1b519a9b93	2	1
52	1012038303	eef9fef38bc28eebfd44e3533d2235b3	2	1
53	1010079101	cb13feb0c64a968395a08726210984ed	2	1
54	1009128604	1f433ed70dadcb4a0517d806d3c48407	2	1
55	1022118504	8bec9211223aa3ca3f230ca5f4cec511	2	1
56	1014018204	1d77bf23a64a53664449b3cfc8e732b4	2	1
57	1022036901	395f7030a6a60ab2695e4a06eb05432d	2	1
58	1027088203	a71f519c52d036fac6d2ad39c4f84e06	2	1
59	1025056601	ca32ad74a3229b8f792d668c2372442f	2	1
60	1007018004	c7fbc4c13012a4775472cc37e81a9ec8	2	1
61	1030098902	b8ff8c2f9a77bb39ea961f0e2bf2ac2f	2	1
62	1020039001	6bf479e196f23b7b0a6d441191e8b599	2	1
63	303116303	e3d0aa02ff17e79662f68d9e1bee2ee8	2	1
64	1006088103	e9e9d81891a6f3668f51d8ae3c94e906	2	1
65	1006095901	654132ebfe237acace32b341a442ea85	2	1
66	1013029101	f877350e060547976d5d7feb5833a40f	2	1
67	1017078906	3dfddbfceff5d04fc71ec26925923e83	2	1
68	1004079001	818c178f60b7bacc1e271b411e719975	2	1
69	1001066001	cd9d2bcfa8c667121a40ff5d354dfb9e	2	1
70	1001018305	b75e100dd0d2c368c069c3aa153a6fe9	2	1
71	1001128601	75e8860b5277f6fc85823baef026ed36	2	1
72	324123401	21543f684d15dfa388c55a6c388f4757	2	1
73	1002117201	a56fbba84972534a3ef84befa4896351	2	1
74	1017128702	76267113daa448faf96ee1584af526d2	2	1
75	1008048803	60867a0ee02d68c7bd24825c4defd9dc	2	1
76	1029038701	e5d3d1dd0abd158c23cf05ae53db0dc1	2	1
77	1009038404	391e9d1267cc89e74b33e772d6a46b68	2	1
78	1015108903	aa5e32d9035514d094843eb2516caf65	2	1
79	1024017001	c4834de60ac8bbcfb30edbe2167222f9	2	1
80	1027018901	60728dbd9699ff9e8099f55d3b85dc9e	2	1
81	1029128503	31914eb8854dfef0421bf3302cb54ba3	2	1
82	1004107101	aa59b904afc428ae442a975bfa218f08	2	1
83	1005076403	4a9aa85b54ce93d949f1e0dd035e685e	2	1
84	1017066402	d5a127898092dc0b4e6130923bace951	2	1
85	1013128901	c553355f76f581ff7cf327b8c824048a	2	1
86	1012039001	0e76467994eb0c0c186543ecdaf440f6	2	1
87	1006108801	5d9cf5ba0f1cd4687da5bfc10fc7fdd4	2	1
88	1030118604	82e6d5c3bb616d5c8fd7951894fbd481	2	1
89	1019048803	a9ebd49580749f9a0f58825b4ed28498	2	1
90	1019128204	dea37a46a63834184af1bdda7109c78b	2	1
91	1019087501	c60831852d631d41b528a99ea05967e1	2	1
92	1013048204	352c6aed7a51a9f610be757c278f93c8	2	1
93	1030087001	dd4508d06e164911a77be15ba38b0a2e	2	1
94	0011045604	b7150f1876caabc1fda47de6c82b436a	2	1
95	1017049101	b495a7dab14690b6751a3531f4813d65	2	1
96	1011087502	9a878e7d933604dfd9ea7c72f45ed312	2	1
97	1015078501	a3ad6abcb2e01d367302487d87b87946	2	1
98	1008018901	3c6e8340893ff23472367b4e2ea71197	2	1
99	1009117001	f9c1c5e3d7fea4f8b0ec1cac69234086	2	1
100	1017047702	32ebe498f7ae149f808437815afffccf	2	1
101	1014019002	0b7e75bac580e3bdf1d6bc26f415cbe5	2	1
102	1017047701	e23ff070850c8a6182c8d02ec752e172	2	1
103	1003056801	5abc26b04d6693b85a755dce7c39a34b	2	1
104	1016058902	28e74fec2a55bc15d26feff11f0bfa76	2	1
105	1029116801	060890186b7eda40874dd4096ac06fce	2	1
106	1009128301	9ce8175d40b82127cfe93c71c8292b5b	2	1
107	1003077501	94b1b86f8fe751cab1af8c0e909f5003	2	1
108	1028048501	2cfb49e47bcc2cc9d56cee2ff24e6f6f	2	1
109	1014039002	8aeae3ee54943bb53b6f2f72e3b2d070	2	1
110	1020078401	0d0a29ae2ac7cff1de9dd4327db8b51d	2	1
111	1024058901	867bb4206d5b4c72d2205ae3300e481a	2	1
112	1005019001	c889da02c80e3f15f70025d879a3fec7	2	1
113	1017119002	f80a050cf1279624062426a6a1113e91	2	1
114	1025128401	8258ec8db937d9bf65959df9694bbace	2	1
115	1023016801	dcf14592c37d322aac9ccd9bd27f5b74	2	1
116	1031038803	84509ba4378610175421c1a2263ed908	2	1
117	1005058504	f8478eb13e6a09d191b72988ccf6d92b	2	1
118	1003088802	ee845fb4d297d941720c10a1f7a20cb9	2	1
119	1012019101	fc6f1450af02f8e695fcb1cde3a1786e	2	1
120	1031127801	89252d4472ec6d6cd92d2d714bf23927	2	1
121	1019028801	680b667ad2e89648773db5fc4cefb2a7	2	1
122	1003038901	4294d77dbb428e77c6a7c1df89f6d52c	2	1
123	1014118801	b606484bdee33f65fc206aee873e7748	2	1
124	1008098501	8a92b95d1501d5c4ae26bb109a953554	2	1
125	1003088903	cfb54487b6b64de7ecdb183e211174e6	2	1
126	1009029001	6c36f50da93bb009139ce690292ba1c0	2	1
127	1019018402	2e3a27c7a1fefa89cc3ef1ca6f8ac90f	2	1
128	1009098901	cf3ef93d17532dd791d59aebdb9c6aa3	2	1
129	1024098002	9c1e1e4d9b8bf133bf19246162f6960c	2	1
130	1026078201	afcb5380fca83c5747a4b7072738f665	2	1
131	1018108501	3067fad77d88b85535a9ddf83d266bc7	2	1
132	1003098301	649c216a4cb34e24c8e4536067dba635	2	1
133	1017018602	a1e82cef0e6b237872da71ff84b8f08c	2	1
134	1026067804	7e97e42800c28e2183e50ec66bfa59bf	2	1
135	1009098503	e162924e7a812328e0868952e0ec7812	2	1
136	1006068603	57ba246210cfe28e783c2191174e5aba	2	1
137	17017305	1492f6541ff8a0e5d1b7fa736c36022f	2	1
138	1022068801	929f8d337ac3b6ee302bbb7e78cc198f	2	1
139	1020118203	bcb8aa4b84c3fdae1834333d534dc6e8	2	1
140	1017018601	833b1903fa46529729e51c43f0641ef4	2	1
141	1010088203	e206a0dd753908443cc434d192bec49f	2	1
142	1011059001	fc34233a47434828c0766644519d5f14	2	1
143	1017089001	5de2c22d0f009ebd238a13d94a12bd0f	2	1
144	1011118501	620354f945469e4fa3372e52cac96f9f	2	1
145	1015107101	00655f31d17252de89d493ccc134014d	2	1
146	1029098901	47f3c6f84f93ce864db46e1cb28e9048	2	1
147	1012129101	9a4e57c4df174690053557463d4bc100	2	1
148	1029108702	1b14305c33478f04cd5e11fd30fb5873	2	1
149	1020048002	4baa61ff027a474f2a0fce8739e3ab78	2	1
150	1002068501	03f75a635d09f008be7a6b421228526b	2	1
151	1010118402	d3680a39f84132bdb992148a34b99b8e	2	1
152	1020057501	e6bba6f2bf6a4a0e887e5b21257fc3dc	2	1
153	1008128701	138f54303393b0c64e7535c6e30ba27f	2	1
154	1027118601	51d732a2632c0b335acf5b92c5639977	2	1
155	1019018202	32dfbf15de0ad6fd1a4dcd2e0a6d75b7	2	1
156	1020028602	14f437fa35a0f8835d540e7736a91c1b	2	1
157	1014028503	bda187e9467d70705ad7fc0c2d77d189	2	1
158	1009017602	67fc1feec18a549bc39c61989fd679d7	2	1
159	1060785021	5d73327edc1670abeb384899d0d2ca9b	2	1
160	1012068203	a36f49324d0e8ab56475c5313d2722b5	2	1
161	1026038501	4804d571589c0d7d4e43332dc35f0bc5	2	1
162	1002058401	8230e0a9ff93cc8a0ad60b60bd7e8f97	2	1
163	1002058402	fdd9edcb33856969afc5016662ea7981	2	1
164	1015087203	314269df841032cf139bf69a931e4899	2	1
165	1009048503	694209f9e2c9609802ff7b59a798a233	2	1
166	1017048603	4028e0d8d04ce4258ef3d96734f6484b	2	1
167	1009127301	004fdfed8b2f55a5ca003a6700411ac0	2	1
168	1027088101	f40087de51c34b9ffa4fc571a68eca2b	2	1
169	1003127702	74627db9137d4a1260a5b3901205be9c	2	1
170	1028098602	9b5dd3afbda3a248bfd39760a6a15ece	2	1
171	1021068601	8f08d788b574b96f69b333d5d2f86c61	2	1
172	1011118901	92ba61af7c6cd7bd74b0e4b1777c6ffb	2	1
173	1018058602	eff2ab3ac21ba9c399ac6429e334b309	2	1
174	1005028102	6210cb7716ea90552be31df36fffdbde	2	1
175	1008088702	0e1996ccc08eb7d3879a06230788ccb6	2	1
176	1012087401	5503c342c802ae7260364365a49b8fc6	2	1
177	1016087201	e0f022e45bde7beff942211c94ce90bc	2	1
178	1011108502	590911d0d4a07e0879bd0181dc779dd9	2	1
179	1019057502	4691a5de0323c0b2852e7b0e784f338f	2	1
180	1010039001	2cc8585919b5918b1bfa7bb69767755c	2	1
181	1015128601	418aa346900a65549c36c6ef03f50638	2	1
182	1016118002	d476dceec3342115e0b113420d5d5ec6	2	1
183	1020037703	d389f8065e6da98569f8f08ca213350c	2	1
184	1001037101	d2f69975d53d093e75ee54f2146e3b40	2	1
185	1008108301	dce292745f259ded53f8c8718283814d	2	1
186	1013058604	b97d3caa27894de1f8e5c0b23a2bd614	2	1
187	1014099001	0ad3812ac5a98f0327ebd3222381651a	2	1
188	1002098302	280d223b218768adad57cb26b67666eb	2	1
189	1021118101	4a0b03396975b9714c5fcfd735292b25	2	1
190	1010068501	dac1e1a5f27a0f3a60894fc6a161d35f	2	1
191	1012059001	1652fa570c88e47b039b90c4d992f904	2	1
192	1021038303	1a5587f6f504a80ccce7e8d6e7fd2f1b	2	1
193	1028018801	f3189c0a1ffead9e20b7607dfdb360e9	2	1
194	1008077101	97137bf9ef6f6834d3f696d1200e892f	2	1
195	1010028701	bc1a477111e35e750c19fa1fdc5cdcc5	2	1
196	1003026702	661f55f5232625b1ed42cf6f9837a795	2	1
197	1029077301	09aa2b00919ba470cff6bbaf6268bcf8	2	1
198	1012128601	e068d3646670a9bfe3ae55d15f29ccf5	2	1
199	1025128101	468a95b7a4f07d37a3a8d2f7d6bf8b8d	2	1
200	1016058503	5c9d6c8683d7e992670f5cb4ddd75d11	2	1
201	1019068501	0e5f4d411fabfd9a93233e6228a292d6	2	1
202	1020119201	66869673bbf9f49a803918e52f9344c2	2	1
203	1003098302	11bd4dacdeada766d52b2d8f5ec445a0	2	1
204	1022069201	74a69cda5746ae5132421d8abcd37665	2	1
205	1021128701	ff652944756450fa36318413589d8e91	2	1
206	1014058901	5eeaaef57c76711fce481db2111f4048	2	1
207	1003058302	21886c7355f5d6003976565cf93b18ee	2	1
208	1021117701	d8ed3390b3c4ebe247da1ff280527180	2	1
209	1011076801	0534e8063838456239a19de780cc7e4f	2	1
210	1002058901	c1d6d025a9bf21e93e9ef50709d5defa	2	1
211	1026059101	84b2b67474f771a2ccf957c9a0ad2a9c	2	1
212	1008106404	d593d98c67b55559adfd8d664a139b19	2	1
213	1005108604	5de1375657555b87287e61029cbcba38	2	1
214	1006068701	58dab111e9a5c9274b1495223583fe8a	2	1
215	1011058003	1beee3dd215e8c927e8884affc56b703	2	1
216	1003048501	80cb6448ffefccd281392e869dcf9f0d	2	1
217	1007068001	c7da92a0a249589398a9f19459e9b3ca	2	1
218	1019125102	de410426faf5e9dd52f10e9c0302cefd	2	1
219	1019128501	d9417bbce59a58cf88e7a50e716289f7	2	1
220	1005047601	994c61d8299fd52a3ca1dd9f9e1b9894	2	1
221	1015048302	843e3d6a9bd3c79adcb7a3b1f5c7c648	2	1
222	1003068801	5904810f7af1610d4858ce07a4f7115d	2	1
223	1022108302	13692cd10a3ad6cc23e04eb8feae2e30	2	1
224	1023046101	e698cde4413ba9ec3598bcfd5205337d	2	1
225	1028128501	376fe5cd6fc9e597878a9a6052eee80f	2	1
226	1026108202	7d0997b54968e4ad9ba86e858fea03cb	2	1
227	1021018402	a1b97fce986bbc5f589de1f16e0a0610	2	1
228	1001088204	55f03e193dce6fc8ccb11762a7395c9b	2	1
229	1016038602	50480bab3a1d37adaef66c8fb4924194	2	1
230	1015067501	f02f35088baee4ba480be42b218ba771	2	1
231	1024048503	bfb0deb7a4ad120758ca92c4e793dbe8	2	1
232	1025076401	4c42d7cb423a0d3f5904b4ea03a0c89d	2	1
233	1023108601	f412d00a20f3b3fdefa65bd277e12be8	2	1
234	1027067903	9d50402371867e470379854eec2497a6	2	1
235	1016068402	b060f1d283b508222857dbfce586f416	2	1
236	1006057201	9d3a28da4448076ce52c38951effb153	2	1
237	1013048502	a686b74b0bbbcd360792932d497a26ef	2	1
238	1021037202	483c2db3dc1d60ee40d305268aca357d	2	1
239	1010068304	37d32583b02757da9f22d986a8175a3e	2	1
240	1006017601	13c9cce123c61d3f15877b1f2bfea2fe	2	1
241	1010028505	5672de8cb831cdb7e909b4246f222bdb	2	1
242	1008058902	d3bc7f40bf74edd484521583e0caa7bd	2	1
243	1024048502	69729cd2ea43c3dae8e893be5cc333d7	2	1
244	1010088704	4809076fbdbf18a4465d0ba571a436e3	2	1
245	1002117401	2eebc66d5b7e5726d45c5cba283ce267	2	1
246	1015057301	1143576c889e73636c02253fc3fb1fef	2	1
247	1003078402	5aeedf80aca54d652a1ec0c3418b75fd	2	1
248	1005117101	924683a87280d0397b799c4c389183ad	2	1
249	1009096401	2a4193a0e8e5c61387ef42dbc785caa9	2	1
250	1017069001	2af2887fd5cb324fd6cb4d61aa25d844	2	1
251	1028088702	0ff9e48eb017cee8ac80bb4ba7976cb7	2	1
252	1020057603	a3a7e2ca29ff257a1f4330674a10395e	2	1
253	1018048301	d438c4a0ca9eb51c51320a984451185b	2	1
254	1009087402	6a164fe31725657a6b07ac126d22540f	2	1
255	1003088601	23ce910f56cc7587e0c45d2af4028bee	2	1
256	1026108501	54f0476a949560af91075773737acd01	2	1
257	1017127401	a2ecc113f73f57fb80f9c6e9f5e338a4	2	1
258	1011098501	84d2dd7dfee8479f3f159d5d01970572	2	1
259	1010058703	00410c010fa6fd6c91d089d92e63b441	2	1
260	1028018301	bf14b3905d503d7ffc33d6fc27e5cf6d	2	1
261	1023037504	c64bc88a7c074d024d2d980b5aa7224d	2	1
262	1017089002	7487fc894f5725624733cebc7ec7789a	2	1
263	1020099101	a41148e86744dd7fa831ea3e6b98e934	2	1
264	1018078601	10771bea600e26b4039bdb897bb54177	2	1
265	1012108401	b4374edd5400c35739931c1e77a7fec8	2	1
266	1003078601	e621635f6f8dd4e07f01d57d9d3eb802	2	1
267	1017098206	332f67e472d8ef9af97d65b7f75d96f1	2	1
268	1018017501	19f951d02f44329c086279a33c0a45ea	2	1
269	1023098901	049bd9480828633f838973e3cc0cfbd9	2	1
270	1031059001	4ab1e48dc7992f0586a16611dbd9589a	2	1
271	1026099001	63ff6104e7d5340fc488f63524e47cf4	2	1
272	1004038101	dd877f4d6c95a155743e17767e134cad	2	1
273	1016067902	75e0dfc20918450fc4645e421d1154ff	2	1
274	1004077904	f1721311f34ec1c8a4f4df19cd47bada	2	1
275	1010047701	ffacef19254a92e0189d67ee66f380d6	2	1
276	1007099001	a854f57635a684060191bd5764307583	2	1
277	1016038601	ec3c83acf8dc8bad8225e1126e59deaf	2	1
278	1004069101	f7e2ad5600381feba6bdcbd08eb9ef42	2	1
279	1011019001	c2158f2cb95abb684712fd335698f57e	2	1
280	1013049001	d51c9904a975f3d7091caa60ce4f05ce	2	1
281	1012085301	5b13456cdc4a47382a50f175385c7426	2	1
282	1012098102	b98c68b29feedcb66411a0a925b0686a	2	1
283	1026097501	1d995ed455656e05863f4c11e257ff01	2	1
284	1027018501	ad2bd18163b3fc9d0509c1f9870349e8	2	1
285	1007048304	c43b4a6b156322c63dcf6c1bb3e116d4	2	1
286	1003049001	0a50920aa1fc90e18abb03b3d0a4652d	2	1
287	1011018301	28adc4a28013adcd312cc5e50c790c27	2	1
288	1029058703	be0f1cfdeaf6ddea9e81aefb0c9617f2	2	1
289	1021098101	8b65be2c4cabb3fdbfd700a37f635d87	2	1
290	1010097701	9facbeb85435c8887a531dffd557106b	2	1
291	1011098802	9871c74ade16d76f46ad170a86495654	2	1
292	1028058402	f4d80f79a6591906a491a64e93727450	2	1
293	1011064901	a1c77ff398e51fe10e098242187fcbde	2	1
294	1021088601	a10c516b8e0d59769562509431695129	2	1
295	1021129101	683b703045431e27f7b8685aaefdf2b4	2	1
296	1015048703	f18c4459290adf3e1bf362a4773a1772	2	1
297	1026129001	d3e1f4a9eb07806118bfae2d55156cc9	2	1
298	1010128402	afab50cbc0011c16c6aad60718bd2594	2	1
299	1008028803	b10e39fd2bec74c184b0ce2c280a1dba	2	1
300	1014088502	c6d17ad42af11431ce744c8aebff0b23	2	1
301	1015028801	3c1df319090badb1c535b798b5fb17c8	2	1
302	1014036901	c4056fb1a2b968a9b061a651384528df	2	1
303	1022038901	510f522ab51bf75c0bc6201debce7d65	2	1
304	1009047901	eff13f2385713c472d163aa9992bf29e	2	1
305	1014039301	5d0591862764eabac24b1df361b83b20	2	1
306	1012029101	9dd7bd8ef4effd8d37fccf2e8a38ac00	2	1
307	1028088201	aa298a29f0505cf8e3a1b4f4380accd6	2	1
308	1022098403	542426bf8a4200f0bf34c01d4d63181e	2	1
309	1012059101	81d5a8c805dbd0ba4fde970677d3b66a	2	1
310	1018119001	53ebd7fe4e28af5c16c9402f1d0f9d9f	2	1
311	1007078901	2879d29e153538d32cddc50126fa8651	2	1
312	1007118403	6797c3f45282a4a790402028c6eab1f2	2	1
313	1031038901	f326b47c65eb3c3b8607f27ebe6856f0	2	1
314	1028018001	446fd677ec31cd0e927e8d3c2952f385	2	1
315	1021018802	8f487a4d7894157cf8eec915a8e8f385	2	1
316	1023119001	e3f4f702adce7934786c209a139389f4	2	1
317	1012128701	bab325127a8d03eda64ab1ad407959bd	2	1
318	1029098402	319413dc533a68c4b8e8bffa9e019e52	2	1
319	1031088901	090a72aa7ce6dea2c7c0503c294e838e	2	1
320	1007069201	3062fd59fcaa2a2419719c748aa2f0b4	2	1
321	1013098901	5073d620b0c94eb5905fe4ffd686b760	2	1
322	1012118403	fcb3247be0ac18afdde99f851b0313db	2	1
323	1017059201	5aa1f96e6780e421d609f451b229b404	2	1
324	1007087002	df07e9a198a728d52346457e67de9a85	2	1
325	1026099002	ce03997786da1d90816ca5e7f924bb5c	2	1
326	1021128801	87c30a3561640b3434b99b39889bbc14	2	1
327	1023018901	fa8fa93668b5eb23b1fa75d0b57457f0	2	1
328	0005076607	3eedfc7a0dba6a74faa594f93c952d6b	2	1
329	1001059001	c921c88532ded9f26f485337679a829d	2	1
330	1004118102	58825c75176809ea749d98165dc8fdd8	2	1
331	1008108202	822852718286dca99e9d648daad6890e	2	1
332	1007088801	67e7eb27059120296cf8f4fe6672b886	2	1
333	1003098202	3fe62502727d1584eecaf3f2b531db55	2	1
334	1004129101	07684e1fe1eac0e7b97da1e2d7c65840	2	1
335	1016089101	9888c0c08b49fcf704fffe42906b07f1	2	1
336	1017047902	7ce32f0192f125e8e52f6ce67c399d07	2	1
337	1028018201	509f04d7c7ba2b23d2697d8591e89cd7	2	1
338	1011027001	63165c8763306d451a365f7d6310e426	2	1
339	1024048504	b79e3db89189ddf42fb9dd1290932e53	2	1
340	1014028804	14e04704351e19a80f6c944af2755742	2	1
341	1018048401	1777ffa08840d4021e018fbb67ba9739	2	1
342	0006047306	9bec1cf143b3cb4293d549b43e794a2a	2	1
343	1018118401	272600c8c36015d82677e4723f525b32	2	1
344	1024127202	2eb10d9fe37a73151f6c67807d704ed2	2	1
345	14101152610565	b8395747c31aa0193e7e77927657e475	3	1
346	14101152610544	5950281a3621ea1c6c4c0f65833269b1	3	1
347	14101152610550	6cb5b33ada74131864000ba9613a07f9	3	1
348	14101152610545	d54b2fc4585b90728ab84583d5c1a39f	3	1
349	14101152610590	a83a194d10279ec3f04200762ebbcc7d	3	1
350	14101152610555	6e64633165732096f3b954ab36812bda	3	1
351	14101152610579	8126e4037e2ec701a56dcfe28ad16cdc	3	1
352	14101152610551	b5de808cb4f4e09a6ef86be48409be89	3	1
353	14101152610574	3e0ba80fef7f7667285a3d319dd24388	3	1
354	14101152610583	f874c5313e4850445e94c6a1a745997f	3	1
355	13101152610342	95b3e070b9d82dc1ae1c833b8d4866a3	3	1
356	14101152610561	892aabf259c972d076840a84fb2e2b69	3	1
357	14101152610562	63318714d66582e0b006a1a947d4c7d2	3	1
358	14101152610032	31c1d16e140d495fe35b203428eb9d58	3	1
359	14101152610733	250eb727438e3f472dd12323abc1eb65	3	1
360	14101152610457	39ed25e64fb16dc99b8defcc926dd315	3	1
362	admin	21232f297a57a5a743894a0e4a801fc3	1	1
\.


--
-- Name: tbuser_id_user_seq; Type: SEQUENCE SET; Schema: public; Owner: mandan
--

SELECT pg_catalog.setval('tbuser_id_user_seq', 4, true);


--
-- Name: tbdosen_id_dosen; Type: CONSTRAINT; Schema: public; Owner: mandan
--

ALTER TABLE ONLY tbdosen
    ADD CONSTRAINT tbdosen_id_dosen PRIMARY KEY (id_dosen);


--
-- Name: tbdosen_nidn; Type: CONSTRAINT; Schema: public; Owner: mandan
--

ALTER TABLE ONLY tbdosen
    ADD CONSTRAINT tbdosen_nidn UNIQUE (nidn);


--
-- Name: tbhasil_ujian_id_hasil; Type: CONSTRAINT; Schema: public; Owner: mandan
--

ALTER TABLE ONLY tbhasil_ujian
    ADD CONSTRAINT tbhasil_ujian_id_hasil PRIMARY KEY (id_hasil);


--
-- Name: tbjawaban_id_jawaban; Type: CONSTRAINT; Schema: public; Owner: mandan
--

ALTER TABLE ONLY tbjawaban
    ADD CONSTRAINT tbjawaban_id_jawaban PRIMARY KEY (id_jawaban);


--
-- Name: tbjenis_soal_id_jsoal; Type: CONSTRAINT; Schema: public; Owner: mandan
--

ALTER TABLE ONLY tbjenis_soal
    ADD CONSTRAINT tbjenis_soal_id_jsoal PRIMARY KEY (id_jsoal);


--
-- Name: tbjenis_ujian_id_jujian; Type: CONSTRAINT; Schema: public; Owner: mandan
--

ALTER TABLE ONLY tbjenis_ujian
    ADD CONSTRAINT tbjenis_ujian_id_jujian PRIMARY KEY (id_jujian);


--
-- Name: tbjenis_user_id_juser; Type: CONSTRAINT; Schema: public; Owner: mandan
--

ALTER TABLE ONLY tbjenis_user
    ADD CONSTRAINT tbjenis_user_id_juser PRIMARY KEY (id_juser);


--
-- Name: tbkelas_id_kelas; Type: CONSTRAINT; Schema: public; Owner: mandan
--

ALTER TABLE ONLY tbkelas
    ADD CONSTRAINT tbkelas_id_kelas PRIMARY KEY (id_kelas);


--
-- Name: tbkelas_kuliah_id_kkuliah; Type: CONSTRAINT; Schema: public; Owner: mandan
--

ALTER TABLE ONLY tbkelas_kuliah
    ADD CONSTRAINT tbkelas_kuliah_id_kkuliah PRIMARY KEY (id_kkuliah);


--
-- Name: tbkuliah_id_kuliah; Type: CONSTRAINT; Schema: public; Owner: mandan
--

ALTER TABLE ONLY tbkuliah
    ADD CONSTRAINT tbkuliah_id_kuliah PRIMARY KEY (id_kuliah);


--
-- Name: tbmahasiswa_id_mahasiswa; Type: CONSTRAINT; Schema: public; Owner: mandan
--

ALTER TABLE ONLY tbmahasiswa
    ADD CONSTRAINT tbmahasiswa_id_mahasiswa PRIMARY KEY (id_mahasiswa);


--
-- Name: tbmahasiswa_nobp; Type: CONSTRAINT; Schema: public; Owner: mandan
--

ALTER TABLE ONLY tbmahasiswa
    ADD CONSTRAINT tbmahasiswa_nobp UNIQUE (nobp);


--
-- Name: tbmatkul_id_matkul; Type: CONSTRAINT; Schema: public; Owner: mandan
--

ALTER TABLE ONLY tbmatkul
    ADD CONSTRAINT tbmatkul_id_matkul PRIMARY KEY (id_matkul);


--
-- Name: tbpeserta_kuliah_id_peserta; Type: CONSTRAINT; Schema: public; Owner: mandan
--

ALTER TABLE ONLY tbpeserta_kuliah
    ADD CONSTRAINT tbpeserta_kuliah_id_peserta PRIMARY KEY (id_peserta);


--
-- Name: tbsoal_id_soal; Type: CONSTRAINT; Schema: public; Owner: mandan
--

ALTER TABLE ONLY tbsoal
    ADD CONSTRAINT tbsoal_id_soal PRIMARY KEY (id_soal);


--
-- Name: tbsoal_ujian_id_sujian; Type: CONSTRAINT; Schema: public; Owner: mandan
--

ALTER TABLE ONLY tbsoal_ujian
    ADD CONSTRAINT tbsoal_ujian_id_sujian PRIMARY KEY (id_sujian);


--
-- Name: tbstatus_status; Type: CONSTRAINT; Schema: public; Owner: mandan
--

ALTER TABLE ONLY tbstatus
    ADD CONSTRAINT tbstatus_status PRIMARY KEY (status);


--
-- Name: tbujian_id_ujian; Type: CONSTRAINT; Schema: public; Owner: mandan
--

ALTER TABLE ONLY tbujian
    ADD CONSTRAINT tbujian_id_ujian PRIMARY KEY (id_ujian);


--
-- Name: tbuser_id_user; Type: CONSTRAINT; Schema: public; Owner: mandan
--

ALTER TABLE ONLY tbuser
    ADD CONSTRAINT tbuser_id_user PRIMARY KEY (id_user);


--
-- Name: tbuser_username; Type: CONSTRAINT; Schema: public; Owner: mandan
--

ALTER TABLE ONLY tbuser
    ADD CONSTRAINT tbuser_username UNIQUE (username);


--
-- Name: tbhasil_ujian_id_ujian; Type: INDEX; Schema: public; Owner: mandan
--

CREATE INDEX tbhasil_ujian_id_ujian ON tbhasil_ujian USING btree (id_ujian);


--
-- Name: tbhasil_ujian_nobp; Type: INDEX; Schema: public; Owner: mandan
--

CREATE INDEX tbhasil_ujian_nobp ON tbhasil_ujian USING btree (nobp);


--
-- Name: tbjawaban_id_soal; Type: INDEX; Schema: public; Owner: mandan
--

CREATE INDEX tbjawaban_id_soal ON tbjawaban USING btree (id_soal);


--
-- Name: tbjawaban_id_ujian; Type: INDEX; Schema: public; Owner: mandan
--

CREATE INDEX tbjawaban_id_ujian ON tbjawaban USING btree (id_ujian);


--
-- Name: tbjawaban_nobp; Type: INDEX; Schema: public; Owner: mandan
--

CREATE INDEX tbjawaban_nobp ON tbjawaban USING btree (nobp);


--
-- Name: tbkuliah_kd_matkul; Type: INDEX; Schema: public; Owner: mandan
--

CREATE INDEX tbkuliah_kd_matkul ON tbkuliah USING btree (kd_matkul);


--
-- Name: tbkuliah_nidn; Type: INDEX; Schema: public; Owner: mandan
--

CREATE INDEX tbkuliah_nidn ON tbkuliah USING btree (nidn);


--
-- Name: tbsoal_ujian_id_soal; Type: INDEX; Schema: public; Owner: mandan
--

CREATE INDEX tbsoal_ujian_id_soal ON tbsoal_ujian USING btree (id_soal);


--
-- Name: tbsoal_ujian_id_ujian; Type: INDEX; Schema: public; Owner: mandan
--

CREATE INDEX tbsoal_ujian_id_ujian ON tbsoal_ujian USING btree (id_ujian);


--
-- Name: tbujian_id_kuliah; Type: INDEX; Schema: public; Owner: mandan
--

CREATE INDEX tbujian_id_kuliah ON tbujian USING btree (id_kuliah);


--
-- Name: updateStatusKuliah; Type: TRIGGER; Schema: public; Owner: mandan
--

CREATE TRIGGER "updateStatusKuliah" AFTER INSERT ON tbpeserta_kuliah FOR EACH ROW EXECUTE PROCEDURE updatestatuskuliah();


--
-- Name: updateStatusUjian; Type: TRIGGER; Schema: public; Owner: mandan
--

CREATE TRIGGER "updateStatusUjian" AFTER INSERT ON tbsoal_ujian FOR EACH ROW EXECUTE PROCEDURE updatestatusujian();


--
-- Name: tbhasil_ujian_id_ujian_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mandan
--

ALTER TABLE ONLY tbhasil_ujian
    ADD CONSTRAINT tbhasil_ujian_id_ujian_fkey FOREIGN KEY (id_ujian) REFERENCES tbujian(id_ujian) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: tbjawaban_id_ujian_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mandan
--

ALTER TABLE ONLY tbjawaban
    ADD CONSTRAINT tbjawaban_id_ujian_fkey FOREIGN KEY (id_ujian) REFERENCES tbujian(id_ujian) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: tbsoal_ujian_id_soal_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mandan
--

ALTER TABLE ONLY tbsoal_ujian
    ADD CONSTRAINT tbsoal_ujian_id_soal_fkey FOREIGN KEY (id_soal) REFERENCES tbsoal(id_soal) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: tbsoal_ujian_id_ujian_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mandan
--

ALTER TABLE ONLY tbsoal_ujian
    ADD CONSTRAINT tbsoal_ujian_id_ujian_fkey FOREIGN KEY (id_ujian) REFERENCES tbujian(id_ujian) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: tbujian_id_kuliah_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mandan
--

ALTER TABLE ONLY tbujian
    ADD CONSTRAINT tbujian_id_kuliah_fkey FOREIGN KEY (id_kuliah) REFERENCES tbkuliah(id_kuliah) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

