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
-- Name: tbhasil_ujian; Type: TABLE; Schema: public; Owner: mandan
--

CREATE TABLE tbhasil_ujian (
    id_hasil integer NOT NULL,
    id_ujian integer NOT NULL,
    nobp character varying(14) NOT NULL,
    nilai smallint NOT NULL
);


ALTER TABLE tbhasil_ujian OWNER TO mandan;

--
-- Name: tbmahasiswa; Type: TABLE; Schema: public; Owner: mandan
--

CREATE TABLE tbmahasiswa (
    nobp character varying(15) NOT NULL,
    nm_mahasiswa character varying(100) NOT NULL,
    status boolean DEFAULT true NOT NULL,
    id_mahasiswa integer NOT NULL
);


ALTER TABLE tbmahasiswa OWNER TO mandan;

--
-- Name: lap_hasil_ujian; Type: VIEW; Schema: public; Owner: mandan
--

CREATE VIEW lap_hasil_ujian AS
 SELECT tbhasil_ujian.id_hasil,
    tbhasil_ujian.id_ujian,
    tbhasil_ujian.nobp,
    tbmahasiswa.nm_mahasiswa,
    tbhasil_ujian.nilai
   FROM (tbhasil_ujian
     JOIN tbmahasiswa ON (((tbhasil_ujian.nobp)::text = (tbmahasiswa.nobp)::text)));


ALTER TABLE lap_hasil_ujian OWNER TO mandan;

--
-- Name: tbjawaban; Type: TABLE; Schema: public; Owner: mandan
--

CREATE TABLE tbjawaban (
    id_jawaban integer NOT NULL,
    id_ujian integer NOT NULL,
    nobp character varying(15) NOT NULL,
    jawaban text NOT NULL,
    id_soal integer NOT NULL
);


ALTER TABLE tbjawaban OWNER TO mandan;

--
-- Name: tbsoal; Type: TABLE; Schema: public; Owner: mandan
--

CREATE TABLE tbsoal (
    id_soal integer NOT NULL,
    isi_soal text NOT NULL,
    "pilihanGanda" json,
    id_jsoal smallint NOT NULL,
    bobot smallint DEFAULT '1'::smallint NOT NULL,
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
-- Name: tbdosen; Type: TABLE; Schema: public; Owner: mandan
--

CREATE TABLE tbdosen (
    nidn character varying(11) NOT NULL,
    nm_dosen character varying(100) NOT NULL,
    status boolean DEFAULT true NOT NULL,
    id_dosen integer NOT NULL
);


ALTER TABLE tbdosen OWNER TO mandan;

--
-- Name: tbmatkul; Type: TABLE; Schema: public; Owner: mandan
--

CREATE TABLE tbmatkul (
    kd_matkul character varying(15) NOT NULL,
    nm_matkul character varying(100) NOT NULL,
    sks smallint NOT NULL,
    smt smallint NOT NULL,
    id_matkul integer NOT NULL
);


ALTER TABLE tbmatkul OWNER TO mandan;

--
-- Name: tbmatkul_dosen; Type: TABLE; Schema: public; Owner: mandan
--

CREATE TABLE tbmatkul_dosen (
    id_mdosen character varying(32) NOT NULL,
    kd_matkul character varying(15) NOT NULL,
    nidn character varying(11) NOT NULL
);


ALTER TABLE tbmatkul_dosen OWNER TO mandan;

--
-- Name: lap_matkul_dosen; Type: VIEW; Schema: public; Owner: mandan
--

CREATE VIEW lap_matkul_dosen AS
 SELECT tbmatkul_dosen.id_mdosen,
    tbmatkul_dosen.kd_matkul,
    tbmatkul.nm_matkul,
    tbmatkul_dosen.nidn,
    tbdosen.nm_dosen
   FROM ((tbmatkul_dosen
     JOIN tbdosen ON (((tbmatkul_dosen.nidn)::text = (tbdosen.nidn)::text)))
     JOIN tbmatkul ON (((tbmatkul_dosen.kd_matkul)::text = (tbmatkul.kd_matkul)::text)));


ALTER TABLE lap_matkul_dosen OWNER TO mandan;

--
-- Name: tbkuliah; Type: TABLE; Schema: public; Owner: mandan
--

CREATE TABLE tbkuliah (
    id_kuliah integer NOT NULL,
    id_mdosen character varying(32) NOT NULL,
    id_kelas integer NOT NULL,
    tahun_akademik integer NOT NULL
);


ALTER TABLE tbkuliah OWNER TO mandan;

--
-- Name: tbnama_kelas; Type: TABLE; Schema: public; Owner: mandan
--

CREATE TABLE tbnama_kelas (
    id_kelas integer NOT NULL,
    nm_kelas character varying(10) NOT NULL
);


ALTER TABLE tbnama_kelas OWNER TO mandan;

--
-- Name: lap_kuliah; Type: VIEW; Schema: public; Owner: mandan
--

CREATE VIEW lap_kuliah AS
 SELECT a.id_kuliah,
    a.id_mdosen,
    b.kd_matkul,
    b.nm_matkul,
    b.nidn,
    b.nm_dosen,
    c.id_kelas,
    c.nm_kelas,
    a.tahun_akademik
   FROM ((tbkuliah a
     JOIN lap_matkul_dosen b ON (((a.id_mdosen)::text = (b.id_mdosen)::text)))
     JOIN tbnama_kelas c ON ((a.id_kelas = c.id_kelas)));


ALTER TABLE lap_kuliah OWNER TO mandan;

--
-- Name: tbpeserta_ujian; Type: TABLE; Schema: public; Owner: mandan
--

CREATE TABLE tbpeserta_ujian (
    id_peserta integer NOT NULL,
    id_ujian integer NOT NULL,
    nobp character varying(15) NOT NULL,
    status boolean DEFAULT true NOT NULL
);


ALTER TABLE tbpeserta_ujian OWNER TO mandan;

--
-- Name: lap_peserta_ujian; Type: VIEW; Schema: public; Owner: mandan
--  

CREATE TABLE tbujian (
    id_ujian integer NOT NULL,
    id_kuliah integer NOT NULL,
    hari date DEFAULT '2017-11-22'::date NOT NULL,
    id_jujian integer NOT NULL,
    id_jsoal integer NOT NULL,
    mulai time without time zone DEFAULT '16:00:00'::time without time zone NOT NULL,
    selesai time without time zone DEFAULT '17:30:00'::time without time zone NOT NULL,
    deskripsi character varying(100),
    status boolean
);


CREATE TABLE tbjenis_soal (
    id_jsoal integer NOT NULL,
    nm_jsoal character varying(20) NOT NULL
);


ALTER TABLE tbjenis_soal OWNER TO mandan;

--
-- Name: tbjenis_ujian; Type: TABLE; Schema: public; Owner: mandan
--

CREATE TABLE tbjenis_ujian (
    id_jujian integer NOT NULL,
    nm_jujian character varying(10) NOT NULL
);


ALTER TABLE tbjenis_ujian OWNER TO mandan;


CREATE TABLE tbsoal_ujian (
    id_sujian integer NOT NULL,
    id_ujian integer NOT NULL,
    id_soal integer NOT NULL
);


ALTER TABLE tbsoal_ujian OWNER TO mandan;

CREATE TABLE tbjenis_user (
    id_juser integer NOT NULL,
    nm_juser character varying(20) NOT NULL
);


ALTER TABLE tbjenis_user OWNER TO mandan;

--
-- Name: tbuser; Type: TABLE; Schema: public; Owner: mandan
--

CREATE TABLE tbuser (
    id_user integer NOT NULL,
    username character varying(30) NOT NULL,
    password text NOT NULL,
    id_juser smallint NOT NULL
);


ALTER TABLE tbuser OWNER TO mandan;

ALTER TABLE tbujian OWNER TO mandan;
CREATE VIEW lap_ujian AS
 SELECT a.id_ujian,
    a.hari,
    a.id_jujian,
    c.nm_jujian,
    a.id_jsoal,
    d.nm_jsoal,
    a.mulai,
    a.selesai,
    b.id_kuliah,
    b.id_mdosen,
    b.kd_matkul,
    b.nm_matkul,
    b.nidn,
    b.nm_dosen,
    b.id_kelas,
    b.nm_kelas,
    b.tahun_akademik
   FROM (((tbujian a
     JOIN lap_kuliah b ON ((a.id_kuliah = b.id_kuliah)))
     JOIN tbjenis_ujian c ON ((a.id_jujian = c.id_jujian)))
     JOIN tbjenis_soal d ON ((a.id_jsoal = d.id_jsoal)));


ALTER TABLE lap_ujian OWNER TO mandan;

CREATE VIEW lap_peserta_ujian AS
 SELECT a.id_ujian,
    a.nobp,
    c.nm_mahasiswa,
    a.status,
    b.hari,
    b.id_jujian,
    b.id_jsoal,
    b.mulai,
    b.selesai,
    b.id_kuliah,
    b.id_mdosen,
    b.kd_matkul,
    b.nm_matkul,
    b.nidn,
    b.nm_dosen,
    b.id_kelas,
    b.nm_kelas,
    b.tahun_akademik,
    a.id_peserta
   FROM ((tbpeserta_ujian a
     JOIN lap_ujian b ON ((a.id_ujian = b.id_ujian)))
     JOIN tbmahasiswa c ON (((a.nobp)::text = (c.nobp)::text)));


ALTER TABLE lap_peserta_ujian OWNER TO mandan;

--
-- Name: tbjenis_soal; Type: TABLE; Schema: public; Owner: mandan
--

--
-- Name: tbujian; Type: TABLE; Schema: public; Owner: mandan
--



--
-- Name: lap_ujian; Type: VIEW; Schema: public; Owner: mandan
-

--
-- Name: lap_peserta_ujian; Type: VIEW; Schema: public; Owner: mandan
--


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
-- Name: tbsoal_ujian; Type: TABLE; Schema: public; Owner: mandan
--


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
-- Name: tbjenis_user; Type: TABLE; Schema: public; Owner: mandan
--

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
-- Name: tbdosen_id_seq; Type: SEQUENCE; Schema: public; Owner: mandan
--

CREATE SEQUENCE tbdosen_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE tbdosen_id_seq OWNER TO mandan;

--
-- Name: tbdosen_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mandan
--

ALTER SEQUENCE tbdosen_id_seq OWNED BY tbdosen.id_dosen;


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
-- Name: tbhasil_ujian_id_hasil_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mandan
--

ALTER SEQUENCE tbhasil_ujian_id_hasil_seq OWNED BY tbhasil_ujian.id_hasil;


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
-- Name: tbjawaban_id_jawaban_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mandan
--

ALTER SEQUENCE tbjawaban_id_jawaban_seq OWNED BY tbjawaban.id_jawaban;


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
-- Name: tbjenis_soal_id_jsoal_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mandan
--

ALTER SEQUENCE tbjenis_soal_id_jsoal_seq OWNED BY tbjenis_soal.id_jsoal;


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
-- Name: tbjenis_ujian_id_jujian_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mandan
--

ALTER SEQUENCE tbjenis_ujian_id_jujian_seq OWNED BY tbjenis_ujian.id_jujian;


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
-- Name: tbjenis_user_id_juser_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mandan
--

ALTER SEQUENCE tbjenis_user_id_juser_seq OWNED BY tbjenis_user.id_juser;


--
-- Name: tbkuliah_id_kuliah_seq; Type: SEQUENCE; Schema: public; Owner: mandan
--

CREATE SEQUENCE tbkuliah_id_kuliah_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE tbkuliah_id_kuliah_seq OWNER TO mandan;

--
-- Name: tbkuliah_id_kuliah_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mandan
--

ALTER SEQUENCE tbkuliah_id_kuliah_seq OWNED BY tbkuliah.id_kuliah;


--
-- Name: tbpeserta_ujian_id_peserta_seq; Type: SEQUENCE; Schema: public; Owner: mandan
--

CREATE SEQUENCE tbpeserta_ujian_id_peserta_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE tbpeserta_ujian_id_peserta_seq OWNER TO mandan;

--
-- Name: tbpeserta_ujian_id_peserta_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mandan
--

ALTER SEQUENCE tbpeserta_ujian_id_peserta_seq OWNED BY tbpeserta_ujian.id_peserta;


--
-- Name: tbmahasiswa_id_seq; Type: SEQUENCE; Schema: public; Owner: mandan
--

CREATE SEQUENCE tbmahasiswa_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE tbmahasiswa_id_seq OWNER TO mandan;

--
-- Name: tbmahasiswa_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mandan
--

ALTER SEQUENCE tbmahasiswa_id_seq OWNED BY tbmahasiswa.id_mahasiswa;


--
-- Name: tbmatkul_id_matkul_seq; Type: SEQUENCE; Schema: public; Owner: mandan
--

CREATE SEQUENCE tbmatkul_id_matkul_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE tbmatkul_id_matkul_seq OWNER TO mandan;

--
-- Name: tbmatkul_id_matkul_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mandan
--

ALTER SEQUENCE tbmatkul_id_matkul_seq OWNED BY tbmatkul.id_matkul;


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
-- Name: tbnama_kelas_id_kelas_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mandan
--

ALTER SEQUENCE tbnama_kelas_id_kelas_seq OWNED BY tbnama_kelas.id_kelas;


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
-- Name: tbsoal_id_soal_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mandan
--

ALTER SEQUENCE tbsoal_id_soal_seq OWNED BY tbsoal.id_soal;


--
-- Name: tbsoal_ujian_id_sujian_seq; Type: SEQUENCE; Schema: public; Owner: mandan
--

CREATE SEQUENCE tbsoal_ujian_id_sujian_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE tbsoal_ujian_id_sujian_seq OWNER TO mandan;

--
-- Name: tbsoal_ujian_id_sujian_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mandan
--

ALTER SEQUENCE tbsoal_ujian_id_sujian_seq OWNED BY tbsoal_ujian.id_sujian;


--
-- Name: tbujian_id_ujian_seq; Type: SEQUENCE; Schema: public; Owner: mandan
--

CREATE SEQUENCE tbujian_id_ujian_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE tbujian_id_ujian_seq OWNER TO mandan;

--
-- Name: tbujian_id_ujian_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mandan
--

ALTER SEQUENCE tbujian_id_ujian_seq OWNED BY tbujian.id_ujian;


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
-- Name: tbuser_id_user_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mandan
--

ALTER SEQUENCE tbuser_id_user_seq OWNED BY tbuser.id_user;


--
-- Name: id_dosen; Type: DEFAULT; Schema: public; Owner: mandan
--

ALTER TABLE ONLY tbdosen ALTER COLUMN id_dosen SET DEFAULT nextval('tbdosen_id_seq'::regclass);


--
-- Name: id_hasil; Type: DEFAULT; Schema: public; Owner: mandan
--

ALTER TABLE ONLY tbhasil_ujian ALTER COLUMN id_hasil SET DEFAULT nextval('tbhasil_ujian_id_hasil_seq'::regclass);


--
-- Name: id_jawaban; Type: DEFAULT; Schema: public; Owner: mandan
--

ALTER TABLE ONLY tbjawaban ALTER COLUMN id_jawaban SET DEFAULT nextval('tbjawaban_id_jawaban_seq'::regclass);


--
-- Name: id_jsoal; Type: DEFAULT; Schema: public; Owner: mandan
--

ALTER TABLE ONLY tbjenis_soal ALTER COLUMN id_jsoal SET DEFAULT nextval('tbjenis_soal_id_jsoal_seq'::regclass);


--
-- Name: id_jujian; Type: DEFAULT; Schema: public; Owner: mandan
--

ALTER TABLE ONLY tbjenis_ujian ALTER COLUMN id_jujian SET DEFAULT nextval('tbjenis_ujian_id_jujian_seq'::regclass);


--
-- Name: id_juser; Type: DEFAULT; Schema: public; Owner: mandan
--

ALTER TABLE ONLY tbjenis_user ALTER COLUMN id_juser SET DEFAULT nextval('tbjenis_user_id_juser_seq'::regclass);


--
-- Name: id_kuliah; Type: DEFAULT; Schema: public; Owner: mandan
--

ALTER TABLE ONLY tbkuliah ALTER COLUMN id_kuliah SET DEFAULT nextval('tbkuliah_id_kuliah_seq'::regclass);


--
-- Name: id_peserta; Type: DEFAULT; Schema: public; Owner: mandan
--

ALTER TABLE ONLY tbpeserta_ujian ALTER COLUMN id_peserta SET DEFAULT nextval('tbpeserta_ujian_id_peserta_seq'::regclass);


--
-- Name: id_mahasiswa; Type: DEFAULT; Schema: public; Owner: mandan
--

ALTER TABLE ONLY tbmahasiswa ALTER COLUMN id_mahasiswa SET DEFAULT nextval('tbmahasiswa_id_seq'::regclass);


--
-- Name: id_matkul; Type: DEFAULT; Schema: public; Owner: mandan
--

ALTER TABLE ONLY tbmatkul ALTER COLUMN id_matkul SET DEFAULT nextval('tbmatkul_id_matkul_seq'::regclass);


--
-- Name: id_kelas; Type: DEFAULT; Schema: public; Owner: mandan
--

ALTER TABLE ONLY tbnama_kelas ALTER COLUMN id_kelas SET DEFAULT nextval('tbnama_kelas_id_kelas_seq'::regclass);


--
-- Name: id_soal; Type: DEFAULT; Schema: public; Owner: mandan
--

ALTER TABLE ONLY tbsoal ALTER COLUMN id_soal SET DEFAULT nextval('tbsoal_id_soal_seq'::regclass);


--
-- Name: id_sujian; Type: DEFAULT; Schema: public; Owner: mandan
--

ALTER TABLE ONLY tbsoal_ujian ALTER COLUMN id_sujian SET DEFAULT nextval('tbsoal_ujian_id_sujian_seq'::regclass);


--
-- Name: id_ujian; Type: DEFAULT; Schema: public; Owner: mandan
--

ALTER TABLE ONLY tbujian ALTER COLUMN id_ujian SET DEFAULT nextval('tbujian_id_ujian_seq'::regclass);


--
-- Name: id_user; Type: DEFAULT; Schema: public; Owner: mandan
--

ALTER TABLE ONLY tbuser ALTER COLUMN id_user SET DEFAULT nextval('tbuser_id_user_seq'::regclass);


--
-- Data for Name: tbdosen; Type: TABLE DATA; Schema: public; Owner: mandan
--

COPY tbdosen (nidn, nm_dosen, status, id_dosen) FROM stdin;
1012019001	ANITA ADE RAHMA	t	1
1009026602	ARFIS	t	2
1023116001	AZIZUL HAKIM	t	3
1025125401	BUCHYARDI GOND	t	4
1028128901	DESFRIANA SARI	t	5
1013128902	DESI PERMATA SARI	t	6
1029128101	DESSY HARYANI	t	7
1027088001	DEVI EDRIANI	t	8
1021118602	DIAN MISRAWATI	t	9
1024089001	ELFA FITRIANI	t	10
1019046601	ELFISWANDI	t	11
1016098104	ELIZA	t	12
1020059001	FATMA ARIANI	t	13
1012028201	FITRI YENI	t	14
1022018601	HANNA PRATIWI	t	15
1001059002	HARMELIA	t	16
1031057501	HASMAYNELIS FITRI	t	17
1025069101	INDAH VIOZANI	t	18
1025058801	INDRA FAISAL	t	19
1015107601	LUSIANA	t	20
1025027501	MONDRA NELDI	t	21
1023098902	NITA SOFIA	t	22
1012018201	PRIMAROSI	t	23
1007068502	RIKA WAHYUNI	t	24
1014048602	RIRI PUTRI DIKA	t	25
1011038501	RONNI ANDRI WIJAYA	t	26
1030128501	SALMIDESTIAWAN	t	27
1021078901	SIGIT SANJAYA	t	28
1027087801	SONI	t	29
1026128201	TET LINDA YANI	t	30
1012118901	WELLIA NOVITA	t	31
1004119001	YAMASITHA	t	32
1017047602	YOSI YULIA	t	33
1016078301	YULIA SYAFITRI	t	34
1024128201	CENNYWATI	t	35
1023128702	DEFRIZAL SAPUTRA	t	36
1009038901	HARIS SATRIA	t	37
1016048403	IRNI RESMI APRIYANTI	t	38
1015077903	IRPAN SARIPUDIN	t	39
1025038701	MARIA MARGARETHA EARLENE	t	40
1019028401	RACHMAWATY	t	41
1001058204	TEGUH MEIRIZKY GIRDAYANTO	t	42
1016077202	YULIARMAN MAHMUDDIN	t	43
1025038501	ANDI B. WIRANATA	t	44
1009038301	ANDRE ILYAS	t	45
1017068801	ARIE YUSNELLY	t	46
1007098201	DARMA SYAHRULLAH EKA JAYA	t	47
1024086203	DASRIAL	t	48
1027125401	DASRIL MUNIR	t	49
1019038102	DICE DASRIL	t	50
1012078502	DIMAS PERDANA OSKAR	t	51
1012038303	ELVA SUSANTI	t	52
1010079101	EMILE SALIM	t	53
1009128604	ENGLA DESNIM SILVIA	t	54
1022118504	FITRAH SARI	t	55
1014018204	HADI IRFANI	t	56
1022036901	HERYATMAN	t	57
1027088203	HILDA MARY	t	58
1025056601	INDRIYENNI	t	59
1007018004	JON MAIZAR	t	60
1030098902	M. FADLI	t	61
1020039001	MARTA WIDIAN SARI	t	62
303116303	MASRIFAH	t	63
1006088103	MASRIZAL	t	64
1006095901	MAWARDI	t	65
1013029101	MERI MERIA SARI	t	66
1017078906	MEUTHI AN-NISA NOVIZAR	t	67
1004079001	MIRSAL	t	68
1001066001	NALIM	t	69
1001018305	NARDIMAN	t	70
1001128601	NILA PRATIWI	t	71
324123401	R A APULIJAH ABUTOJO	t	72
1002117201	RAMDANI BAYU PUTRA	t	73
1017128702	RANGGA WENDRA PRINOYA	t	74
1008048803	RINI AFRIANI	t	75
1029038701	RIO ANDHIKA PUTRA	t	76
1009038404	ROBBY DHARMA	t	77
1015108903	ROBERTA JULFA	t	78
1024017001	SASNELWATI	t	79
1027018901	SILVIA JESIKA	t	80
1029128503	SRI MONALISA	t	81
1004107101	SRI MULYATI	t	82
1005076403	SUHERMIZON	t	83
1017066402	SYAHNAN SIMATUPANG	t	84
1013128901	TIFANI RATU FIRDAUS	t	85
1012039001	TITIK EFNITA	t	86
1006108801	VICKY BRAHMA KUMBARA	t	87
1030118604	VIVI NILA SARI	t	88
1019048803	WINDA AFRIYENIS	t	89
1019128204	YEKI CANDRA	t	90
1019087501	YULASMI	t	91
1013048204	YULI ANGGRAINI	t	92
1030087001	ZAINAL ABDUL HARIS	t	93
0011045604	ZERNI MELMUSI	t	94
1017049101	AULIA FITRUL HADI	t	95
1011087502	DIYAWATI	t	96
1015078501	FENDI ANTONI	t	97
1008018901	HANGGI DWIFA HONESQI	t	98
1009117001	IDRIZON	t	99
1017047702	MAIDAWATI	t	100
1014019002	NOVALIA INDRA	t	101
1017047701	RIRY YUSKAR	t	102
1003056801	SILFIA ANDINI	t	103
1016058902	SULARNO	t	104
1029116801	SURMAYANTI	t	105
1009128301	VIVI RESTI DARMISON	t	106
1003077501	YOSEFRIZAL	t	107
1028048501	NURFITRI	t	108
1014039002	AMINDA DEWI SUTIASIH	t	109
1020078401	ANDRIYAS HARIYANDI	t	110
1024058901	DEVIT SATRIA	t	111
1005019001	DEWI DEVITA	t	112
1017119002	ILHAM TRI MAULANA	t	113
1025128401	INDRA WIJAYA	t	114
1023016801	IRNAWATI SIREGAR	t	115
1031038803	LAILA MARHAYATI	t	116
1005058504	LILI RISMAINI	t	117
1003088802	MEGAWATI	t	118
1012019101	MONICA FRANSISCA	t	119
1031127801	MUHARIKA DEWI	t	120
1019028801	NONI FEBRIANA	t	121
1003038901	POPI RADYULI	t	122
1014118801	RENNY PERMATA SAPUTRI	t	123
1008098501	RINI SEFRIANI	t	124
1003088903	SILVIA PERMATA SARI	t	125
1009029001	TAUFIK ADE KURNIAWAN	t	126
1019018402	YOSA NOVIA DEWI	t	127
1009098901	ZUBAIDAH	t	128
1024098002	ANDHIKA ANGGAWIRA	t	129
1026078201	ASIYARFITRIADI	t	130
1018108501	BAYU PRASETYA YUDHA	t	131
1003098301	DEVI PURNAMA SARI	t	132
1017018602	HARRI KURNIAWAN	t	133
1026067804	HARRY THEOZARD FIKRI	t	134
1009098503	HERIO RIZKI DEWINDA	t	135
1006068603	IFANI CANDRA	t	136
17017305	ISNA ASYRI SYAHRINA	t	137
1022068801	KRISNOVA NASTASIA	t	138
1020118203	PURWANTI ENDAH RAHAYU	t	139
1017018601	RANY FITRIANY	t	140
1010088203	RINA MARIANA	t	141
1011059001	SILFI FATAYANI	t	142
1017089001	SITTI HUTARI MULYANI	t	143
1011118501	UMMIL KHAIRIYAH	t	144
1015107101	ZERA MENDOZA	t	145
1029098901	ALBERT GAZALI	t	146
1012129101	ANNISAK IZZATY JAMHUR	t	147
1029108702	ASHABUL FADHLI	t	148
1020048002	ASRI NAWAS SE MM	t	149
1002068501	DEBY ERDRIANI	t	150
1010118402	DENI AMELIA	t	151
1020057501	DEPI DASMAL	t	152
1008128701	DEVI SYUKRI AZHARI S.PD.I M.PD	t	153
1027118601	DHANI PRAMULIA EKA PUTRA	t	154
1019018202	DIAN FITRINI	t	155
1020028602	DINUL AKHIYAR	t	156
1014028503	DODI STAPET	t	157
1009017602	DODI YANDRI	t	158
1060785021	DRS.HM.IQBAL.MM	t	159
1012068203	EDWAR KEMAL	t	160
1026038501	EKA MARIYANTI	t	161
1002058401	EKA MELATI M.PD	t	162
1002058402	EKA MELATI M.PD	t	163
1015087203	ELLYA GUSWANITA	t	164
1009048503	ELMI RAHMAWATI PUTRI	t	165
1017048603	ENDRYL SH MH	t	166
1009127301	ERDISNA	t	167
1027088101	ERLINDA	t	168
1003127702	ERNA SUSANTI SE MM	t	169
1028098602	EVA RIANTI	t	170
1021068601	FADLI HERNANDA	t	171
1011118901	FAJRUL ISLAMI	t	172
1018058602	FATHURRAHMI	t	173
1005028102	FEBRIYANNO SURYANA	t	174
1008088702	FIRNA YENILA	t	175
1012087401	GUSHELMI	t	176
1016087201	GUSLENDRA	t	177
1011108502	HADI SYAHPUTRA	t	178
1019057502	HAFNI	t	179
1010039001	HARI MARFALINO	t	180
1015128601	HARRY AL GHAZALY	t	181
1016118002	HEMA DESSY HARIANI	t	182
1020037703	HEMAT JUNEDI	t	183
1001037101	HENDRIK MARGARET	t	184
1008108301	HENDY MUCHRIZA	t	185
1013058604	HESTI PUSPARINI SE M.SI	t	186
1014099001	HEZY KURNIA	t	187
1002098302	HIKMAH	t	188
1021118101	ILHAMDI KURNIAWAN	t	189
1010068501	IRSYADUL EKA PUTERA	t	190
1012059001	IRZAL ARIEF WISKY	t	191
1021038303	ISNADUL HAMDI	t	192
1028018801	JENDRI MULYADI S.S M.HUM	t	193
1008077101	JHON VERI	t	194
1010028701	JIMMY FEBIO	t	195
1003026702	JUFRIADIF NA AM	t	196
1029077301	JULIUS SANTONY	t	197
1012128601	JUMRAWARSI	t	198
1025128101	KARTIRIA	t	199
1016058503	KHAIRUL ZAMAN	t	200
1019068501	LAKRY MALTAF PUTRA	t	201
1020119201	LARISSA NAVIA RANI	t	202
1003098302	LENI SYASMIRA	t	203
1022069201	LIGA MAYOLA	t	204
1021128701	LINORA RAHAYU	t	205
1014058901	MAHA RANI	t	206
1003058302	MELINA IRMAYENI SH M.KN	t	207
1021117701	MONDHA IRFANDI	t	208
1011076801	MUHAMMAD MAHZUM	t	209
1002058901	MUHAMMAD TEGUH ILHAM	t	210
1026059101	MUTIANA PRATIWI	t	211
1008106404	NUSYIRWIN	t	212
1005108604	OKTA ANDRICA PUTRA	t	213
1006068701	ONDRA EKA PUTRA	t	214
1011058003	PRIMA SANITA SYAIFUL	t	215
1003048501	RAFLIS	t	216
1007068001	RAFNIS	t	217
1019125102	RIFDA NAJMI FUAD	t	218
1019128501	RINA SUSANTI	t	219
1005047601	RINI SOVIA	t	220
1015048302	RIZA YONITA S.S MM	t	221
1003068801	ROKI ADITAMA	t	222
1022108302	RUDI SYAFRI	t	223
1023046101	SABARUDIN	t	224
1028128501	SAHARI	t	225
1026108202	SATRIA RONALDY	t	226
1021018402	SHALLY AMNA	t	227
1001088204	SITTI RIZKI MULYANI	t	228
1016038602	SOFIKA ENGGARI	t	229
1015067501	SRI RAHMAWATI	t	230
1024048503	SRI RAMADHAN	t	231
1025076401	SUHELMI HELIA	t	232
1023108601	SYAFRI ARLIS	t	233
1027067903	SYAFRI JODI	t	234
1016068402	SYAFRIKA DENI RIZKI	t	235
1006057201	SYAMSI	t	236
1013048502	SYELFIA DEWIMARNI S.PD M.PD	t	237
1021037202	SYUHADI	t	238
1010068304	USMAN	t	239
1006017601	VIVI IRAWATI	t	240
1010028505	VIVI PUSPITA SARI	t	241
1008058902	WIFRA SAFITRI	t	242
1024048502	YANTI YUSMAN	t	243
1010088704	YENG PRIMAWATI	t	244
1002117401	YOSE RIZAL	t	245
1015057301	YUHANDRI	t	246
1003078402	YULIA RETNO SARI	t	247
1005117101	YUSTA NOVERISON	t	248
1009096401	ZEFRI YENNI	t	249
1017069001	AGGY PRAMANA GUSMAN	t	250
1028088702	AGUS SURYADI	t	251
1020057603	ASMAINI	t	252
1018048301	BILLY HENDRIK	t	253
1009087402	DEDY WAHYUDI	t	254
1003088601	DODI GUSWANDI	t	255
1026108501	EKO AMRI JAYA	t	256
1017127401	EMIL NAF`AN	t	257
1011098501	FIRDAUS	t	258
1010058703	HALIFIA HENDRI	t	259
1028018301	HANDY RACHMAT TRIYADI	t	260
1023037504	HARIS SURYAMEN	t	261
1017089002	HARKAMSYAH ANDRIANOF	t	262
1020099101	HASRI AWAL	t	263
1018078601	ISMI PUTRI	t	264
1012108401	MARDHIAH MASRIL	t	265
1003078601	MARDISON	t	266
1017098206	MARTIN WAHYUNUS	t	267
1018017501	MUHARDI. Z	t	268
1023098901	NESA LITA	t	269
1031059001	RAHMAT HIDAYAT	t	270
1026099001	REFI SENATA	t	271
1004038101	RETNO DEVITA	t	272
1016067902	RIA ANGGRAINI	t	273
1004077904	RISKA ROBIANTO	t	274
1010047701	RITA	t	275
1007099001	ROMI HARDIANTO	t	276
1016038601	RURI HARTIKA ZAIN	t	277
1004069101	SILKY SAFIRA	t	278
1011019001	YOGI WIYANDRA	t	279
1013049001	YONKY PERNANDO	t	280
1012085301	ZULBATRI	t	281
1012098102	ZULFAHMI	t	282
1026097501	ERWIN RAMADIAN	t	283
1027018501	HENNY YULIUS	t	284
1007048304	IRSAN	t	285
1003049001	MOHAMMAD FADHLI	t	286
1011018301	MUFRIDA MERI Z	t	287
1029058703	WAHYU FITRIANDA MUFTI	t	288
1021098101	ABULWAFA MUHAMMAD	t	289
1010097701	ADI PRANOTO	t	290
1011098802	ANESIA NILA KINANTI	t	291
1028058402	BENNY WAHYUDI	t	292
1011064901	CHARLES DARWIN	t	293
1021088601	DEVAL GUSRION	t	294
1021129101	DEVIA KARTIKA	t	295
1015048703	DEWI EKA PUTRI	t	296
1026129001	DHIO SAPUTRA	t	297
1010128402	DIAN CHRISTINA	t	298
1008028803	EKA LIA FEBRIANTI	t	299
1014088502	EKA PRAJA WIYATA MANDALA	t	300
1015028801	FEBRI HADI	t	301
1014036901	GUNADI WIDI NUR CAHYO	t	302
1022038901	IHSAN VERDIAN	t	303
1009047901	ILMAWATI	t	304
1014039301	LIDYA RIZKI ANANDA	t	305
1012029101	MASRIADI	t	306
1028088201	MISHBAH ULHUSNA	t	307
1022098403	MUHAMMAD AFDHAL	t	308
1012059101	MUHAMMAD IKHLAS	t	309
1018119001	MUHAMMAD REZA PUTRA	t	310
1007078901	MUSLI YANTO	t	311
1007118403	MUSTAPA	t	312
1031038901	NUGRAHA RAHMANSYAH	t	313
1028018001	PINTA MEDINA	t	314
1021018802	PURNAMA SARI	t	315
1023119001	RAJA AYU MAHESSYA	t	316
1012128701	RANDY PERMANA	t	317
1029098402	REVA MUHARENI	t	318
1031088901	REVI GUSRIVA	t	319
1007069201	RICKI ARDIANSYAH	t	320
1013098901	RIMA LIANA GEMA	t	321
1012118403	RIZKI NURDIN	t	322
1017059201	ROMI WIJAYA	t	323
1007087002	SARJON DEFIT	t	324
1026099002	SAYENDRA SAFARIA	t	325
1021128801	SHARY ARMONITHA LUSINIA	t	326
1023018901	SRI DIANA PUTRI	t	327
0005076607	SUMIJAN	t	328
1001059001	TERI ADE PUTRA	t	329
1004118102	TITIN KOMLA DEWI	t	330
1008108202	USMAN	t	331
1007088801	VICKY ARIANDI	t	332
1003098202	WENTY ZAHRATI	t	333
1004129101	YESRI ELVA	t	334
1016089101	ZAKIRMAN	t	335
1017047902	AFRILDA SARI	t	336
1028018201	CUT DONA KORDELIA	t	337
1011027001	FEBRIAN	t	338
1024048504	NADRA ARSYAD	t	339
1014028804	REZZA FALEN	t	340
1018048401	RIKI ADRIADI	t	341
0006047306	WENDI BOY	t	342
1018118401	WIDIAWATI PURBA	t	343
1024127202	ZULDES JONI ST	t	344
123456	dafuk	t	346
000000	graphql	t	347
\.


--
-- Name: tbdosen_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mandan
--

SELECT pg_catalog.setval('tbdosen_id_seq', 348, true);


--
-- Data for Name: tbhasil_ujian; Type: TABLE DATA; Schema: public; Owner: mandan
--

COPY tbhasil_ujian (id_hasil, id_ujian, nobp, nilai) FROM stdin;
1	4	14101152610565	33
2	4	14101152610550	100
3	4	14101152610544	66
4	6	14101152610565	34
5	6	14101152610544	49
6	5	13101152610342	47
\.


--
-- Name: tbhasil_ujian_id_hasil_seq; Type: SEQUENCE SET; Schema: public; Owner: mandan
--

SELECT pg_catalog.setval('tbhasil_ujian_id_hasil_seq', 6, true);


--
-- Data for Name: tbjawaban; Type: TABLE DATA; Schema: public; Owner: mandan
--

COPY tbjawaban (id_jawaban, id_ujian, nobp, jawaban, id_soal) FROM stdin;
1	6	14101152610565	jawaban 1	6
2	6	14101152610565	jawaban 2	7
3	6	14101152610565	jawaban 3	8
4	6	14101152610544	dsdasdas	6
5	6	14101152610544	sadsax	7
6	6	14101152610544	asxsx	8
7	5	13101152610342	ideologi negara	3
8	5	13101152610342	jawaban 2	4
9	5	13101152610342	jawaban 3	5
10	5	14101152610561	msmdmadksmkd	3
11	5	14101152610561	msmxmzmlxlml	4
12	5	14101152610561	kkdskcdckcl;	5
13	5	14101152610561	<ol><li>sadssasd</li><li>asdasds</li><li>asdsadsad</li></ol>	13
\.


--
-- Name: tbjawaban_id_jawaban_seq; Type: SEQUENCE SET; Schema: public; Owner: mandan
--

SELECT pg_catalog.setval('tbjawaban_id_jawaban_seq', 14, true);


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

SELECT pg_catalog.setval('tbjenis_soal_id_jsoal_seq', 2, true);


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

SELECT pg_catalog.setval('tbjenis_ujian_id_jujian_seq', 4, true);


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

SELECT pg_catalog.setval('tbjenis_user_id_juser_seq', 3, true);


--
-- Data for Name: tbkuliah; Type: TABLE DATA; Schema: public; Owner: mandan
--

COPY tbkuliah (id_kuliah, id_mdosen, id_kelas, tahun_akademik) FROM stdin;
5	1026108501KKKI12106	1	20141
6	1007118403KPKI12101	1	20141
7	1010058703KBKI42122	1	20161
8	1024089001KKKI13111	1	20151
\.


--
-- Name: tbkuliah_id_kuliah_seq; Type: SEQUENCE SET; Schema: public; Owner: mandan
--

SELECT pg_catalog.setval('tbkuliah_id_kuliah_seq', 8, true);


--
-- Data for Name: tbpeserta_ujian; Type: TABLE DATA; Schema: public; Owner: mandan
--

COPY tbpeserta_ujian (id_peserta, id_kuliah, nobp, status) FROM stdin;
1	1	14101152610565	t
2	1	14101152610544	t
3	1	14101152610550	t
4	1	14101152610545	t
5	1	14101152610590	t
6	2	14101152610555	t
7	2	14101152610579	t
8	2	14101152610551	t
9	2	14101152610574	t
10	2	14101152610583	t
11	5	14101152610565	t
12	5	14101152610544	t
13	5	14101152610550	t
15	6	14101152610457	t
16	6	14101152610562	t
17	6	14101152610561	t
18	6	13101152610342	t
19	7	14101152610565	t
20	7	14101152610544	t
21	7	14101152610550	t
22	7	14101152610545	t
23	7	14101152610590	t
24	7	14101152610574	t
25	8	14101152610544	t
26	8	14101152610565	t
27	8	14101152610550	t
28	8	14101152610545	t
29	8	14101152610590	t
\.


--
-- Name: tbpeserta_ujian_id_peserta_seq; Type: SEQUENCE SET; Schema: public; Owner: mandan
--

SELECT pg_catalog.setval('tbpeserta_ujian_id_peserta_seq', 29, true);


--
-- Data for Name: tbmahasiswa; Type: TABLE DATA; Schema: public; Owner: mandan
--

COPY tbmahasiswa (nobp, nm_mahasiswa, status, id_mahasiswa) FROM stdin;
14101152610565	Ego Dafma Dasa	t	1
14101152610544	Aidil	t	2
14101152610550	Irvan Rultio	t	3
14101152610545	Davidsyah Permana Putra	t	4
14101152610590	Yogi Anggara	t	5
14101152610555	Afdhal Trianda	t	6
14101152610579	Muhammad Fadli	t	7
14101152610551	M.Nurico Pratama S	t	8
14101152610574	Khaliq Alfikrizal	t	9
14101152610583	Riyan Mahruf Syaputra	t	10
13101152610342	Gilang Kovalen	t	11
14101152610561	Cici Syuryantika	t	12
14101152610562	Debby Puspitasari	t	13
14101152610032	Novrizal Adri	t	14
14101152610733	Try Lestari	t	15
14101152610457	Masrifadil Firmansyah	t	16
\.


--
-- Name: tbmahasiswa_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mandan
--

SELECT pg_catalog.setval('tbmahasiswa_id_seq', 17, true);


--
-- Data for Name: tbmatkul; Type: TABLE DATA; Schema: public; Owner: mandan
--

COPY tbmatkul (kd_matkul, nm_matkul, sks, smt, id_matkul) FROM stdin;
KKKI12106	Pengantar Teknologi Info.	2	1	1
KKKI12116	Paket Pemrograman I ()	2	1	2
KKKI13105	Pengantar Manajemen	3	1	3
KKKI13111	Kalkulus	3	1	4
KPKI12101	Pendidikan Pancasila	2	1	5
KPKI12102	Pendidikan Agama	2	1	6
KPKI12105	Bahasa Inggris I	2	1	7
KBKI23117	Paket Pemrograman II ()	3	2	8
KKKI22106	Pengetahuan Bisnis (E-Businees)	2	2	9
KKKI22108	Teori Organisasi Umum	2	2	10
KKKI23102	Alg. & Struktur Data II (Pas)	3	2	11
KKKI23104	Statistika	3	2	12
KKKI23109	Sistem Basis Data	3	2	13
KKKI23110	Konsep Sis. Informasi	3	2	14
KPKI22107	Bahasa Inggris II	2	2	15
KBKI32110	Sistem Info. Manajemen	2	3	16
KBKI32114	Arsitektur Komputer	2	3	17
KBKI32115	Metode Peng Dan Akses	2	3	18
KBKI33109	Perancangan Basis Data	3	3	19
KKKI33101	Matematika Diskrit	3	3	20
KKKI33103	Aljabar Linier	3	3	21
KKKI33114	Bhs Pemrograman I (C)	3	3	22
KBKI42122	Teknik Riset Operasional (3)	2	4	23
KBKI43106	Ans. Dan Perancangan SI  1	3	4	24
KBKI43112	Bhs Pemrograman II (C++)	3	4	25
KBKI43113	Model Dan Simulasi	3	4	26
KKKI42113	Sistem Operasi	2	4	27
KKKI43116	Dasar Akuntansi (2)	3	4	28
KPKI42103	Pend. Kewarganegaraan	2	4	29
KBKI52118	Sistem Inventory  (1)	2	5	30
KBKI53108	Analisa Dan Perancangan SI	2	5	31
KBKI53112	Bhs Pemrograman III ( JAVA)	3	5	32
KKKI52112	Teknik Kompilasi	2	5	33
KPKI52103	Sistem Informasi Akuntansi	2	5	34
KPKI52104	Analisis Proses Bisnis	2	5	35
KPKI52108	Komputer & Masyarakat (2)	2	5	36
PKBI52001	Mnj. Proyek Perangkat Lunak	2	5	37
PKBI52002	Aplikasi Basis Data Server	2	5	38
KBKI62121	Metodologi Penelitian	2	6	39
KBKI63101	Jaringan Komputer	3	6	40
KBKI63104	Testing &amp; Implementasi Sist.	3	6	41
KBKI63107	Sist. Penunjang Keputusan	3	6	42
KPKI62101	Perbankan	2	6	43
KPKI62104	Bahasa Indonesia	2	6	44
KPKI62108	Pendidikan Karakter	2	6	45
PKKI62003	Aplikasi Grafika Komputer	2	6	46
BBKI72123	Etika Profesi	2	7	47
KKKI72103	Mnj. Sains (Jaringan Saraf)	2	7	48
KKKI72120	Praktek Kerja Lapangan  (2)	2	7	49
KKKI73110	Pengelolaan Sis. Info.	3	7	50
BBKI82112	Kecakapan Antar Personal	2	7	51
KBKI82127	Kapita Selekta	2	7	52
KBKI83119	Bhs.Pemrograman Lanjutan (VB Lanjutan)	3	7	53
KPKI82106	Kewirausahaan	2	7	54
KKKI13102	Algo. Struktur DataI (Pas)	3	1	55
\.


--
-- Data for Name: tbmatkul_dosen; Type: TABLE DATA; Schema: public; Owner: mandan
--

COPY tbmatkul_dosen (id_mdosen, kd_matkul, nidn) FROM stdin;
1007118403KPKI12101	KPKI12101	1007118403
1012085301KKKI13105	KKKI13105	1012085301
1024089001KKKI13105	KKKI13105	1024089001
1024089001KKKI13111	KKKI13111	1024089001
1026108501KKKI12106	KKKI12106	1026108501
1003026702KKKI13102	KKKI13102	1003026702
1003026702KKKI23102	KKKI23102	1003026702
1029108702KPKI12102	KPKI12102	1029108702
1029108702BBKI82112	BBKI82112	1029108702
1026129001KKKI12116	KKKI12116	1026129001
1008088702KKKI22106	KKKI22106	1008088702
1010118402KKKI22108	KKKI22108	1010118402
1012128601KKKI23104	KKKI23104	1012128601
1015067501KKKI23109	KKKI23109	1015067501
1026108501KKKI23110	KKKI23110	1026108501
1009096401KBKI42122	KBKI42122	1009096401
1010058703KBKI42122	KBKI42122	1010058703
\.


--
-- Name: tbmatkul_id_matkul_seq; Type: SEQUENCE SET; Schema: public; Owner: mandan
--

SELECT pg_catalog.setval('tbmatkul_id_matkul_seq', 55, true);


--
-- Data for Name: tbnama_kelas; Type: TABLE DATA; Schema: public; Owner: mandan
--

COPY tbnama_kelas (id_kelas, nm_kelas) FROM stdin;
1	SI-10
\.


--
-- Name: tbnama_kelas_id_kelas_seq; Type: SEQUENCE SET; Schema: public; Owner: mandan
--

SELECT pg_catalog.setval('tbnama_kelas_id_kelas_seq', 2, true);


--
-- Data for Name: tbsoal; Type: TABLE DATA; Schema: public; Owner: mandan
--

COPY tbsoal (id_soal, isi_soal, "pilihanGanda", id_jsoal, bobot, jawaban) FROM stdin;
1	Javascript berjalan pada"	[{"huruf":"A","isi_pilihan":"Browser"},{"huruf":"B","isi_pilihan":"Server"},{"huruf":"C","isi_pilihan":"Semua benar"}]	1	1	C
3	Pancasila adalah?	\N	2	20	Ideologi dan lambang negara
4	Soal 2	\N	2	30	Jawaban 2
5	Soal 3	\N	2	30	Jawaban 3
6	Soal 1	\N	2	20	Jawaban 1
7	Soal 2	\N	2	20	jawaban 2
8	Soal 3	\N	2	20	jawaban 3
9	PC?	[{"huruf":"A","isi_pilihan":"Personal Compuoter"},{"huruf":"B","isi_pilihan":"Personal Computer"}]	1	1	B
10	WWW	[{"huruf":"A","isi_pilihan":"Wordl Wide Web"},{"huruf":"B","isi_pilihan":"World Wide Web"}]	1	1	B
11	Bilangan biner terdiri atas?	[{"huruf":"A","isi_pilihan":"1 dan 2"},{"huruf":"B","isi_pilihan":"0 dan 1"}]	1	1	B
12	CPU kependekan dari?	[{"huruf":"A","isi_pilihan":"Core Processing Unit"},{"huruf":"B","isi_pilihan":"Computer Processing Unit"}]	1	1	A
13	<b>taba<i> miring</i></b><div><ol><li><b><i>dsdsaax</i></b></li><li><b><i>dsasxas</i></b></li></ol></div>	\N	2	1	<ol><li>xasxsaxsa</li><li>xaxxx</li></ol>
14	dsadsadsffe	[{"huruf":"A","isi_pilihan":"scz"},{"huruf":"B","isi_pilihan":"cxx"}]	1	1	B
15	gundul adalah	\N	2	20	botak
\.


--
-- Name: tbsoal_id_soal_seq; Type: SEQUENCE SET; Schema: public; Owner: mandan
--

SELECT pg_catalog.setval('tbsoal_id_soal_seq', 15, true);


--
-- Data for Name: tbsoal_ujian; Type: TABLE DATA; Schema: public; Owner: mandan
--

COPY tbsoal_ujian (id_sujian, id_ujian, id_soal) FROM stdin;
1	4	1
2	5	3
3	5	4
4	5	5
5	6	6
6	6	7
7	6	8
8	4	9
9	4	10
10	4	11
11	4	12
12	5	13
13	4	14
14	5	15
\.


--
-- Name: tbsoal_ujian_id_sujian_seq; Type: SEQUENCE SET; Schema: public; Owner: mandan
--

SELECT pg_catalog.setval('tbsoal_ujian_id_sujian_seq', 14, true);


--
-- Data for Name: tbujian; Type: TABLE DATA; Schema: public; Owner: mandan
--

COPY tbujian (id_ujian, id_kuliah, hari, id_jujian, id_jsoal, mulai, selesai, deskripsi, status) FROM stdin;
4	5	2017-11-21	1	1	08:00:00	10:00:00	Ujian	\N
5	6	2017-11-21	1	2	08:00:00	10:00:00	Ujian	\N
6	7	2017-11-21	1	2	08:00:00	10:00:00	Ujian	\N
7	8	2017-11-22	1	2	08:00:00	10:00:00	Ujian	\N
\.


--
-- Name: tbujian_id_ujian_seq; Type: SEQUENCE SET; Schema: public; Owner: mandan
--

SELECT pg_catalog.setval('tbujian_id_ujian_seq', 7, true);


--
-- Data for Name: tbuser; Type: TABLE DATA; Schema: public; Owner: mandan
--

COPY tbuser (id_user, username, password, id_juser) FROM stdin;
1	1012019001	db6653d17bc6d38ec16390d7368ee1df	2
2	1009026602	41ef49094fe0cd268aec84f100dcb963	2
3	1023116001	543fa11cff502800d9cf8ef3a550e199	2
4	1025125401	1a35a5d2bafd6b907a43a78788e74003	2
5	1028128901	c4e95b4da82ad63735dc8398b34e0b8e	2
6	1013128902	8d452f6928b45c750494a3ca3f729bd1	2
7	1029128101	5c09a6f1b3ff4d516f1f1239fad46e9c	2
8	1027088001	ba759f455514b2e2b7c59a98e599f676	2
9	1021118602	4f9cd0f4ad10179bb8928a3107d79114	2
10	1024089001	e13d389c6543438eea77db7d320eebdb	2
11	1019046601	b7b734250f742dab8a1589f725ef7b3a	2
12	1016098104	2812044b39bfa6f2d40f34dd1fef3edf	2
13	1020059001	bbcb7aa41ecf36508f1fa33a70988ee0	2
14	1012028201	3dd9bd5a2d54b9d26dca7626e3b1b668	2
15	1022018601	9403384727ef1f29d85c778e8e1b169c	2
16	1001059002	bb4bef0c4486890299cd250a65f9900e	2
17	1031057501	6a815de054b84d3ef7ed54585d25ec33	2
18	1025069101	49e9ab2fb06ddc23e0b06e777d0c0b41	2
19	1025058801	d373ef8938da648821aba2f26e571037	2
20	1015107601	385afe8b50053133008e14d10e64ed6e	2
21	1025027501	a03c311486416b6f3cf1bfdcb5752d14	2
22	1023098902	7f1a2676d3baf3e392caa0921f782477	2
23	1012018201	e0282ec4bf2922af46c7243709f78082	2
24	1007068502	79d78b789a4f67d4d29e67d11213aa68	2
25	1014048602	9ad3a6a97a4db91ee893b299384a02c0	2
26	1011038501	03ae389acda027545f3dbabaf759935d	2
27	1030128501	e198db3fb6ba917dce2107f1ec6b962a	2
28	1021078901	8c0ae9dc37e6860778bfcf65f2e1a247	2
29	1027087801	05352aef7448107e3737dbbdb6c94222	2
30	1026128201	e5e620280edfdc57b3ded51b9fc12e01	2
31	1012118901	7838d6a240e01afc0200f127dc2e21bc	2
32	1004119001	53fb52d6874923557e2901e87ae35525	2
33	1017047602	83fe76ca06bf2fd41d521fd39ca30566	2
34	1016078301	b309849cb415f46f5d7785310c2dd349	2
35	1024128201	aa63e50b66649e45a76be0e56c7b2e8c	2
36	1023128702	45a486fb5a50df42aaf32981d8d62f6e	2
37	1009038901	25150e9acd9efaf3d9ab6aac93aabd07	2
38	1016048403	5b14d9b7f86de17b2ca6aa85ec0f730e	2
39	1015077903	49431020cc52cc85fdfe33fbfe344bd1	2
40	1025038701	cfa4dd7e3b5e33cabf8ed519b26d61a6	2
41	1019028401	7ba2f52d59c903cdd0363419ae22a917	2
42	1001058204	c3f784ec6e7ffabe84bf23e38ddaf02b	2
43	1016077202	550216e63807a4c43df296d7e65c08bf	2
44	1025038501	32d7221efe9123495492828a6defafd0	2
45	1009038301	a6a7fd704953c6c86bc853c7c049e237	2
46	1017068801	ae0db61d667bdd0b492776007ae191c8	2
47	1007098201	a2f2b3b76307c1d1b6dfba4ac592c81a	2
48	1024086203	b3fce63e2623ff4e899ac08dd88d03a0	2
49	1027125401	d1785f2eb5eeb945c70ab0ff0027e9e6	2
50	1019038102	37955a600a9095dd615d5abfdeb616a2	2
51	1012078502	dcecb344563634b0300b2c1b519a9b93	2
52	1012038303	eef9fef38bc28eebfd44e3533d2235b3	2
53	1010079101	cb13feb0c64a968395a08726210984ed	2
54	1009128604	1f433ed70dadcb4a0517d806d3c48407	2
55	1022118504	8bec9211223aa3ca3f230ca5f4cec511	2
56	1014018204	1d77bf23a64a53664449b3cfc8e732b4	2
57	1022036901	395f7030a6a60ab2695e4a06eb05432d	2
58	1027088203	a71f519c52d036fac6d2ad39c4f84e06	2
59	1025056601	ca32ad74a3229b8f792d668c2372442f	2
60	1007018004	c7fbc4c13012a4775472cc37e81a9ec8	2
61	1030098902	b8ff8c2f9a77bb39ea961f0e2bf2ac2f	2
62	1020039001	6bf479e196f23b7b0a6d441191e8b599	2
63	303116303	e3d0aa02ff17e79662f68d9e1bee2ee8	2
64	1006088103	e9e9d81891a6f3668f51d8ae3c94e906	2
65	1006095901	654132ebfe237acace32b341a442ea85	2
66	1013029101	f877350e060547976d5d7feb5833a40f	2
67	1017078906	3dfddbfceff5d04fc71ec26925923e83	2
68	1004079001	818c178f60b7bacc1e271b411e719975	2
69	1001066001	cd9d2bcfa8c667121a40ff5d354dfb9e	2
70	1001018305	b75e100dd0d2c368c069c3aa153a6fe9	2
71	1001128601	75e8860b5277f6fc85823baef026ed36	2
72	324123401	21543f684d15dfa388c55a6c388f4757	2
73	1002117201	a56fbba84972534a3ef84befa4896351	2
74	1017128702	76267113daa448faf96ee1584af526d2	2
75	1008048803	60867a0ee02d68c7bd24825c4defd9dc	2
76	1029038701	e5d3d1dd0abd158c23cf05ae53db0dc1	2
77	1009038404	391e9d1267cc89e74b33e772d6a46b68	2
78	1015108903	aa5e32d9035514d094843eb2516caf65	2
79	1024017001	c4834de60ac8bbcfb30edbe2167222f9	2
80	1027018901	60728dbd9699ff9e8099f55d3b85dc9e	2
81	1029128503	31914eb8854dfef0421bf3302cb54ba3	2
82	1004107101	aa59b904afc428ae442a975bfa218f08	2
83	1005076403	4a9aa85b54ce93d949f1e0dd035e685e	2
84	1017066402	d5a127898092dc0b4e6130923bace951	2
85	1013128901	c553355f76f581ff7cf327b8c824048a	2
86	1012039001	0e76467994eb0c0c186543ecdaf440f6	2
87	1006108801	5d9cf5ba0f1cd4687da5bfc10fc7fdd4	2
88	1030118604	82e6d5c3bb616d5c8fd7951894fbd481	2
89	1019048803	a9ebd49580749f9a0f58825b4ed28498	2
90	1019128204	dea37a46a63834184af1bdda7109c78b	2
91	1019087501	c60831852d631d41b528a99ea05967e1	2
92	1013048204	352c6aed7a51a9f610be757c278f93c8	2
93	1030087001	dd4508d06e164911a77be15ba38b0a2e	2
94	0011045604	b7150f1876caabc1fda47de6c82b436a	2
95	1017049101	b495a7dab14690b6751a3531f4813d65	2
96	1011087502	9a878e7d933604dfd9ea7c72f45ed312	2
97	1015078501	a3ad6abcb2e01d367302487d87b87946	2
98	1008018901	3c6e8340893ff23472367b4e2ea71197	2
99	1009117001	f9c1c5e3d7fea4f8b0ec1cac69234086	2
100	1017047702	32ebe498f7ae149f808437815afffccf	2
101	1014019002	0b7e75bac580e3bdf1d6bc26f415cbe5	2
102	1017047701	e23ff070850c8a6182c8d02ec752e172	2
103	1003056801	5abc26b04d6693b85a755dce7c39a34b	2
104	1016058902	28e74fec2a55bc15d26feff11f0bfa76	2
105	1029116801	060890186b7eda40874dd4096ac06fce	2
106	1009128301	9ce8175d40b82127cfe93c71c8292b5b	2
107	1003077501	94b1b86f8fe751cab1af8c0e909f5003	2
108	1028048501	2cfb49e47bcc2cc9d56cee2ff24e6f6f	2
109	1014039002	8aeae3ee54943bb53b6f2f72e3b2d070	2
110	1020078401	0d0a29ae2ac7cff1de9dd4327db8b51d	2
111	1024058901	867bb4206d5b4c72d2205ae3300e481a	2
112	1005019001	c889da02c80e3f15f70025d879a3fec7	2
113	1017119002	f80a050cf1279624062426a6a1113e91	2
114	1025128401	8258ec8db937d9bf65959df9694bbace	2
115	1023016801	dcf14592c37d322aac9ccd9bd27f5b74	2
116	1031038803	84509ba4378610175421c1a2263ed908	2
117	1005058504	f8478eb13e6a09d191b72988ccf6d92b	2
118	1003088802	ee845fb4d297d941720c10a1f7a20cb9	2
119	1012019101	fc6f1450af02f8e695fcb1cde3a1786e	2
120	1031127801	89252d4472ec6d6cd92d2d714bf23927	2
121	1019028801	680b667ad2e89648773db5fc4cefb2a7	2
122	1003038901	4294d77dbb428e77c6a7c1df89f6d52c	2
123	1014118801	b606484bdee33f65fc206aee873e7748	2
124	1008098501	8a92b95d1501d5c4ae26bb109a953554	2
125	1003088903	cfb54487b6b64de7ecdb183e211174e6	2
126	1009029001	6c36f50da93bb009139ce690292ba1c0	2
127	1019018402	2e3a27c7a1fefa89cc3ef1ca6f8ac90f	2
128	1009098901	cf3ef93d17532dd791d59aebdb9c6aa3	2
129	1024098002	9c1e1e4d9b8bf133bf19246162f6960c	2
130	1026078201	afcb5380fca83c5747a4b7072738f665	2
131	1018108501	3067fad77d88b85535a9ddf83d266bc7	2
132	1003098301	649c216a4cb34e24c8e4536067dba635	2
133	1017018602	a1e82cef0e6b237872da71ff84b8f08c	2
134	1026067804	7e97e42800c28e2183e50ec66bfa59bf	2
135	1009098503	e162924e7a812328e0868952e0ec7812	2
136	1006068603	57ba246210cfe28e783c2191174e5aba	2
137	17017305	1492f6541ff8a0e5d1b7fa736c36022f	2
138	1022068801	929f8d337ac3b6ee302bbb7e78cc198f	2
139	1020118203	bcb8aa4b84c3fdae1834333d534dc6e8	2
140	1017018601	833b1903fa46529729e51c43f0641ef4	2
141	1010088203	e206a0dd753908443cc434d192bec49f	2
142	1011059001	fc34233a47434828c0766644519d5f14	2
143	1017089001	5de2c22d0f009ebd238a13d94a12bd0f	2
144	1011118501	620354f945469e4fa3372e52cac96f9f	2
145	1015107101	00655f31d17252de89d493ccc134014d	2
146	1029098901	47f3c6f84f93ce864db46e1cb28e9048	2
147	1012129101	9a4e57c4df174690053557463d4bc100	2
148	1029108702	1b14305c33478f04cd5e11fd30fb5873	2
149	1020048002	4baa61ff027a474f2a0fce8739e3ab78	2
150	1002068501	03f75a635d09f008be7a6b421228526b	2
151	1010118402	d3680a39f84132bdb992148a34b99b8e	2
152	1020057501	e6bba6f2bf6a4a0e887e5b21257fc3dc	2
153	1008128701	138f54303393b0c64e7535c6e30ba27f	2
154	1027118601	51d732a2632c0b335acf5b92c5639977	2
155	1019018202	32dfbf15de0ad6fd1a4dcd2e0a6d75b7	2
156	1020028602	14f437fa35a0f8835d540e7736a91c1b	2
157	1014028503	bda187e9467d70705ad7fc0c2d77d189	2
158	1009017602	67fc1feec18a549bc39c61989fd679d7	2
159	1060785021	5d73327edc1670abeb384899d0d2ca9b	2
160	1012068203	a36f49324d0e8ab56475c5313d2722b5	2
161	1026038501	4804d571589c0d7d4e43332dc35f0bc5	2
162	1002058401	8230e0a9ff93cc8a0ad60b60bd7e8f97	2
163	1002058402	fdd9edcb33856969afc5016662ea7981	2
164	1015087203	314269df841032cf139bf69a931e4899	2
165	1009048503	694209f9e2c9609802ff7b59a798a233	2
166	1017048603	4028e0d8d04ce4258ef3d96734f6484b	2
167	1009127301	004fdfed8b2f55a5ca003a6700411ac0	2
168	1027088101	f40087de51c34b9ffa4fc571a68eca2b	2
169	1003127702	74627db9137d4a1260a5b3901205be9c	2
170	1028098602	9b5dd3afbda3a248bfd39760a6a15ece	2
171	1021068601	8f08d788b574b96f69b333d5d2f86c61	2
172	1011118901	92ba61af7c6cd7bd74b0e4b1777c6ffb	2
173	1018058602	eff2ab3ac21ba9c399ac6429e334b309	2
174	1005028102	6210cb7716ea90552be31df36fffdbde	2
175	1008088702	0e1996ccc08eb7d3879a06230788ccb6	2
176	1012087401	5503c342c802ae7260364365a49b8fc6	2
177	1016087201	e0f022e45bde7beff942211c94ce90bc	2
178	1011108502	590911d0d4a07e0879bd0181dc779dd9	2
179	1019057502	4691a5de0323c0b2852e7b0e784f338f	2
180	1010039001	2cc8585919b5918b1bfa7bb69767755c	2
181	1015128601	418aa346900a65549c36c6ef03f50638	2
182	1016118002	d476dceec3342115e0b113420d5d5ec6	2
183	1020037703	d389f8065e6da98569f8f08ca213350c	2
184	1001037101	d2f69975d53d093e75ee54f2146e3b40	2
185	1008108301	dce292745f259ded53f8c8718283814d	2
186	1013058604	b97d3caa27894de1f8e5c0b23a2bd614	2
187	1014099001	0ad3812ac5a98f0327ebd3222381651a	2
188	1002098302	280d223b218768adad57cb26b67666eb	2
189	1021118101	4a0b03396975b9714c5fcfd735292b25	2
190	1010068501	dac1e1a5f27a0f3a60894fc6a161d35f	2
191	1012059001	1652fa570c88e47b039b90c4d992f904	2
192	1021038303	1a5587f6f504a80ccce7e8d6e7fd2f1b	2
193	1028018801	f3189c0a1ffead9e20b7607dfdb360e9	2
194	1008077101	97137bf9ef6f6834d3f696d1200e892f	2
195	1010028701	bc1a477111e35e750c19fa1fdc5cdcc5	2
196	1003026702	661f55f5232625b1ed42cf6f9837a795	2
197	1029077301	09aa2b00919ba470cff6bbaf6268bcf8	2
198	1012128601	e068d3646670a9bfe3ae55d15f29ccf5	2
199	1025128101	468a95b7a4f07d37a3a8d2f7d6bf8b8d	2
200	1016058503	5c9d6c8683d7e992670f5cb4ddd75d11	2
201	1019068501	0e5f4d411fabfd9a93233e6228a292d6	2
202	1020119201	66869673bbf9f49a803918e52f9344c2	2
203	1003098302	11bd4dacdeada766d52b2d8f5ec445a0	2
204	1022069201	74a69cda5746ae5132421d8abcd37665	2
205	1021128701	ff652944756450fa36318413589d8e91	2
206	1014058901	5eeaaef57c76711fce481db2111f4048	2
207	1003058302	21886c7355f5d6003976565cf93b18ee	2
208	1021117701	d8ed3390b3c4ebe247da1ff280527180	2
209	1011076801	0534e8063838456239a19de780cc7e4f	2
210	1002058901	c1d6d025a9bf21e93e9ef50709d5defa	2
211	1026059101	84b2b67474f771a2ccf957c9a0ad2a9c	2
212	1008106404	d593d98c67b55559adfd8d664a139b19	2
213	1005108604	5de1375657555b87287e61029cbcba38	2
214	1006068701	58dab111e9a5c9274b1495223583fe8a	2
215	1011058003	1beee3dd215e8c927e8884affc56b703	2
216	1003048501	80cb6448ffefccd281392e869dcf9f0d	2
217	1007068001	c7da92a0a249589398a9f19459e9b3ca	2
218	1019125102	de410426faf5e9dd52f10e9c0302cefd	2
219	1019128501	d9417bbce59a58cf88e7a50e716289f7	2
220	1005047601	994c61d8299fd52a3ca1dd9f9e1b9894	2
221	1015048302	843e3d6a9bd3c79adcb7a3b1f5c7c648	2
222	1003068801	5904810f7af1610d4858ce07a4f7115d	2
223	1022108302	13692cd10a3ad6cc23e04eb8feae2e30	2
224	1023046101	e698cde4413ba9ec3598bcfd5205337d	2
225	1028128501	376fe5cd6fc9e597878a9a6052eee80f	2
226	1026108202	7d0997b54968e4ad9ba86e858fea03cb	2
227	1021018402	a1b97fce986bbc5f589de1f16e0a0610	2
228	1001088204	55f03e193dce6fc8ccb11762a7395c9b	2
229	1016038602	50480bab3a1d37adaef66c8fb4924194	2
230	1015067501	f02f35088baee4ba480be42b218ba771	2
231	1024048503	bfb0deb7a4ad120758ca92c4e793dbe8	2
232	1025076401	4c42d7cb423a0d3f5904b4ea03a0c89d	2
233	1023108601	f412d00a20f3b3fdefa65bd277e12be8	2
234	1027067903	9d50402371867e470379854eec2497a6	2
235	1016068402	b060f1d283b508222857dbfce586f416	2
236	1006057201	9d3a28da4448076ce52c38951effb153	2
237	1013048502	a686b74b0bbbcd360792932d497a26ef	2
238	1021037202	483c2db3dc1d60ee40d305268aca357d	2
239	1010068304	37d32583b02757da9f22d986a8175a3e	2
240	1006017601	13c9cce123c61d3f15877b1f2bfea2fe	2
241	1010028505	5672de8cb831cdb7e909b4246f222bdb	2
242	1008058902	d3bc7f40bf74edd484521583e0caa7bd	2
243	1024048502	69729cd2ea43c3dae8e893be5cc333d7	2
244	1010088704	4809076fbdbf18a4465d0ba571a436e3	2
245	1002117401	2eebc66d5b7e5726d45c5cba283ce267	2
246	1015057301	1143576c889e73636c02253fc3fb1fef	2
247	1003078402	5aeedf80aca54d652a1ec0c3418b75fd	2
248	1005117101	924683a87280d0397b799c4c389183ad	2
249	1009096401	2a4193a0e8e5c61387ef42dbc785caa9	2
250	1017069001	2af2887fd5cb324fd6cb4d61aa25d844	2
251	1028088702	0ff9e48eb017cee8ac80bb4ba7976cb7	2
252	1020057603	a3a7e2ca29ff257a1f4330674a10395e	2
253	1018048301	d438c4a0ca9eb51c51320a984451185b	2
254	1009087402	6a164fe31725657a6b07ac126d22540f	2
255	1003088601	23ce910f56cc7587e0c45d2af4028bee	2
256	1026108501	54f0476a949560af91075773737acd01	2
257	1017127401	a2ecc113f73f57fb80f9c6e9f5e338a4	2
258	1011098501	84d2dd7dfee8479f3f159d5d01970572	2
259	1010058703	00410c010fa6fd6c91d089d92e63b441	2
260	1028018301	bf14b3905d503d7ffc33d6fc27e5cf6d	2
261	1023037504	c64bc88a7c074d024d2d980b5aa7224d	2
262	1017089002	7487fc894f5725624733cebc7ec7789a	2
263	1020099101	a41148e86744dd7fa831ea3e6b98e934	2
264	1018078601	10771bea600e26b4039bdb897bb54177	2
265	1012108401	b4374edd5400c35739931c1e77a7fec8	2
266	1003078601	e621635f6f8dd4e07f01d57d9d3eb802	2
267	1017098206	332f67e472d8ef9af97d65b7f75d96f1	2
268	1018017501	19f951d02f44329c086279a33c0a45ea	2
269	1023098901	049bd9480828633f838973e3cc0cfbd9	2
270	1031059001	4ab1e48dc7992f0586a16611dbd9589a	2
271	1026099001	63ff6104e7d5340fc488f63524e47cf4	2
272	1004038101	dd877f4d6c95a155743e17767e134cad	2
273	1016067902	75e0dfc20918450fc4645e421d1154ff	2
274	1004077904	f1721311f34ec1c8a4f4df19cd47bada	2
275	1010047701	ffacef19254a92e0189d67ee66f380d6	2
276	1007099001	a854f57635a684060191bd5764307583	2
277	1016038601	ec3c83acf8dc8bad8225e1126e59deaf	2
278	1004069101	f7e2ad5600381feba6bdcbd08eb9ef42	2
279	1011019001	c2158f2cb95abb684712fd335698f57e	2
280	1013049001	d51c9904a975f3d7091caa60ce4f05ce	2
281	1012085301	5b13456cdc4a47382a50f175385c7426	2
282	1012098102	b98c68b29feedcb66411a0a925b0686a	2
283	1026097501	1d995ed455656e05863f4c11e257ff01	2
284	1027018501	ad2bd18163b3fc9d0509c1f9870349e8	2
285	1007048304	c43b4a6b156322c63dcf6c1bb3e116d4	2
286	1003049001	0a50920aa1fc90e18abb03b3d0a4652d	2
287	1011018301	28adc4a28013adcd312cc5e50c790c27	2
288	1029058703	be0f1cfdeaf6ddea9e81aefb0c9617f2	2
289	1021098101	8b65be2c4cabb3fdbfd700a37f635d87	2
290	1010097701	9facbeb85435c8887a531dffd557106b	2
291	1011098802	9871c74ade16d76f46ad170a86495654	2
292	1028058402	f4d80f79a6591906a491a64e93727450	2
293	1011064901	a1c77ff398e51fe10e098242187fcbde	2
294	1021088601	a10c516b8e0d59769562509431695129	2
295	1021129101	683b703045431e27f7b8685aaefdf2b4	2
296	1015048703	f18c4459290adf3e1bf362a4773a1772	2
297	1026129001	d3e1f4a9eb07806118bfae2d55156cc9	2
298	1010128402	afab50cbc0011c16c6aad60718bd2594	2
299	1008028803	b10e39fd2bec74c184b0ce2c280a1dba	2
300	1014088502	c6d17ad42af11431ce744c8aebff0b23	2
301	1015028801	3c1df319090badb1c535b798b5fb17c8	2
302	1014036901	c4056fb1a2b968a9b061a651384528df	2
303	1022038901	510f522ab51bf75c0bc6201debce7d65	2
304	1009047901	eff13f2385713c472d163aa9992bf29e	2
305	1014039301	5d0591862764eabac24b1df361b83b20	2
306	1012029101	9dd7bd8ef4effd8d37fccf2e8a38ac00	2
307	1028088201	aa298a29f0505cf8e3a1b4f4380accd6	2
308	1022098403	542426bf8a4200f0bf34c01d4d63181e	2
309	1012059101	81d5a8c805dbd0ba4fde970677d3b66a	2
310	1018119001	53ebd7fe4e28af5c16c9402f1d0f9d9f	2
311	1007078901	2879d29e153538d32cddc50126fa8651	2
312	1007118403	6797c3f45282a4a790402028c6eab1f2	2
313	1031038901	f326b47c65eb3c3b8607f27ebe6856f0	2
314	1028018001	446fd677ec31cd0e927e8d3c2952f385	2
315	1021018802	8f487a4d7894157cf8eec915a8e8f385	2
316	1023119001	e3f4f702adce7934786c209a139389f4	2
317	1012128701	bab325127a8d03eda64ab1ad407959bd	2
318	1029098402	319413dc533a68c4b8e8bffa9e019e52	2
319	1031088901	090a72aa7ce6dea2c7c0503c294e838e	2
320	1007069201	3062fd59fcaa2a2419719c748aa2f0b4	2
321	1013098901	5073d620b0c94eb5905fe4ffd686b760	2
322	1012118403	fcb3247be0ac18afdde99f851b0313db	2
323	1017059201	5aa1f96e6780e421d609f451b229b404	2
324	1007087002	df07e9a198a728d52346457e67de9a85	2
325	1026099002	ce03997786da1d90816ca5e7f924bb5c	2
326	1021128801	87c30a3561640b3434b99b39889bbc14	2
327	1023018901	fa8fa93668b5eb23b1fa75d0b57457f0	2
328	0005076607	3eedfc7a0dba6a74faa594f93c952d6b	2
329	1001059001	c921c88532ded9f26f485337679a829d	2
330	1004118102	58825c75176809ea749d98165dc8fdd8	2
331	1008108202	822852718286dca99e9d648daad6890e	2
332	1007088801	67e7eb27059120296cf8f4fe6672b886	2
333	1003098202	3fe62502727d1584eecaf3f2b531db55	2
334	1004129101	07684e1fe1eac0e7b97da1e2d7c65840	2
335	1016089101	9888c0c08b49fcf704fffe42906b07f1	2
336	1017047902	7ce32f0192f125e8e52f6ce67c399d07	2
337	1028018201	509f04d7c7ba2b23d2697d8591e89cd7	2
338	1011027001	63165c8763306d451a365f7d6310e426	2
339	1024048504	b79e3db89189ddf42fb9dd1290932e53	2
340	1014028804	14e04704351e19a80f6c944af2755742	2
341	1018048401	1777ffa08840d4021e018fbb67ba9739	2
342	0006047306	9bec1cf143b3cb4293d549b43e794a2a	2
343	1018118401	272600c8c36015d82677e4723f525b32	2
344	1024127202	2eb10d9fe37a73151f6c67807d704ed2	2
345	14101152610565	b8395747c31aa0193e7e77927657e475	3
346	14101152610544	5950281a3621ea1c6c4c0f65833269b1	3
347	14101152610550	6cb5b33ada74131864000ba9613a07f9	3
348	14101152610545	d54b2fc4585b90728ab84583d5c1a39f	3
349	14101152610590	a83a194d10279ec3f04200762ebbcc7d	3
350	14101152610555	6e64633165732096f3b954ab36812bda	3
351	14101152610579	8126e4037e2ec701a56dcfe28ad16cdc	3
352	14101152610551	b5de808cb4f4e09a6ef86be48409be89	3
353	14101152610574	3e0ba80fef7f7667285a3d319dd24388	3
354	14101152610583	f874c5313e4850445e94c6a1a745997f	3
355	13101152610342	95b3e070b9d82dc1ae1c833b8d4866a3	3
356	14101152610561	892aabf259c972d076840a84fb2e2b69	3
357	14101152610562	63318714d66582e0b006a1a947d4c7d2	3
358	14101152610032	31c1d16e140d495fe35b203428eb9d58	3
359	14101152610733	250eb727438e3f472dd12323abc1eb65	3
360	14101152610457	39ed25e64fb16dc99b8defcc926dd315	3
362	admin	21232f297a57a5a743894a0e4a801fc3	1
\.


--
-- Name: tbuser_id_user_seq; Type: SEQUENCE SET; Schema: public; Owner: mandan
--

SELECT pg_catalog.setval('tbuser_id_user_seq', 362, true);


--
-- Name: tbbmatkul_kd_matkul; Type: CONSTRAINT; Schema: public; Owner: mandan
--

ALTER TABLE ONLY tbmatkul
    ADD CONSTRAINT tbbmatkul_kd_matkul UNIQUE (kd_matkul);


--
-- Name: tbdosen_id; Type: CONSTRAINT; Schema: public; Owner: mandan
--

ALTER TABLE ONLY tbdosen
    ADD CONSTRAINT tbdosen_id PRIMARY KEY (id_dosen);


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
-- Name: tbkuliah_id_kuliah; Type: CONSTRAINT; Schema: public; Owner: mandan
--

ALTER TABLE ONLY tbkuliah
    ADD CONSTRAINT tbkuliah_id_kuliah PRIMARY KEY (id_kuliah);


--
-- Name: tbpeserta_ujian_id_peserta; Type: CONSTRAINT; Schema: public; Owner: mandan
--

ALTER TABLE ONLY tbpeserta_ujian
    ADD CONSTRAINT tbpeserta_ujian_id_peserta PRIMARY KEY (id_peserta);


--
-- Name: tbmahasiswa_id; Type: CONSTRAINT; Schema: public; Owner: mandan
--

ALTER TABLE ONLY tbmahasiswa
    ADD CONSTRAINT tbmahasiswa_id PRIMARY KEY (id_mahasiswa);


--
-- Name: tbmahasiswa_nobp; Type: CONSTRAINT; Schema: public; Owner: mandan
--

ALTER TABLE ONLY tbmahasiswa
    ADD CONSTRAINT tbmahasiswa_nobp UNIQUE (nobp);


--
-- Name: tbmatkul_dosen_id_mdosen; Type: CONSTRAINT; Schema: public; Owner: mandan
--

ALTER TABLE ONLY tbmatkul_dosen
    ADD CONSTRAINT tbmatkul_dosen_id_mdosen PRIMARY KEY (id_mdosen);


--
-- Name: tbmatkul_id_matkul; Type: CONSTRAINT; Schema: public; Owner: mandan
--

ALTER TABLE ONLY tbmatkul
    ADD CONSTRAINT tbmatkul_id_matkul PRIMARY KEY (id_matkul);


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
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

