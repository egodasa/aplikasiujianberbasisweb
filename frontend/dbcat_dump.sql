CREATE TABLE json (
    id integer NOT NULL,
    books pg_catalog.json
);



--
-- Name: json_id_seq; Type: SEQUENCE; Schema: public; Owner: mandan
--

CREATE SEQUENCE json_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


CREATE TABLE tbhasil_ujian (
    id_hasil integer NOT NULL,
    id_ujian integer NOT NULL,
    id_peserta integer NOT NULL,
    nilai integer DEFAULT 0 NOT NULL
);




--
-- Name: tbmahasiswa; Type: TABLE; Schema: public; Owner: mandan
--

CREATE TABLE tbmahasiswa (
    id_mahasiswa integer NOT NULL,
    nobp character(14) NOT NULL,
    nm_mahasiswa character varying(100) NOT NULL,
    id_kelas integer NOT NULL,
    status boolean DEFAULT true NOT NULL
);



--
-- Name: lap_hasil_ujian; Type: VIEW; Schema: public; Owner: mandan
--

CREATE VIEW lap_hasil_ujian AS
 SELECT tbhasil_ujian.id_hasil,
    tbhasil_ujian.id_ujian,
    tbhasil_ujian.id_peserta,
    tbhasil_ujian.nilai,
    tbmahasiswa.nm_mahasiswa,
    tbmahasiswa.nobp
   FROM (tbhasil_ujian
     JOIN tbmahasiswa ON ((tbhasil_ujian.id_peserta = tbmahasiswa.id_mahasiswa)));




--
-- Name: tbjawaban; Type: TABLE; Schema: public; Owner: mandan
--

CREATE TABLE tbjawaban (
    id_jawaban integer NOT NULL,
    id_ujian integer NOT NULL,
    id_soal integer NOT NULL,
    id_peserta integer NOT NULL,
    jawaban text DEFAULT 'Tidak Dijawab'::text
);




--
-- Name: tbsoal; Type: TABLE; Schema: public; Owner: mandan
--

CREATE TABLE tbsoal (
    id_soal integer NOT NULL,
    isi_soal text NOT NULL,
    jawaban text NOT NULL,
    "pilihanGanda" pg_catalog.json,
    id_tsoal smallint DEFAULT '1'::smallint NOT NULL,
    bobot smallint DEFAULT '1'::smallint NOT NULL
);




--
-- Name: lap_jawaban; Type: VIEW; Schema: public; Owner: mandan
--

CREATE VIEW lap_jawaban AS
 SELECT tbjawaban.id_jawaban,
    tbjawaban.id_ujian,
    tbjawaban.id_soal,
    tbjawaban.id_peserta,
    tbsoal.isi_soal,
    tbsoal.jawaban,
    tbjawaban.jawaban AS jawaban_peserta,
    tbsoal.bobot
   FROM (tbjawaban
     JOIN tbsoal ON ((tbjawaban.id_soal = tbsoal.id_soal)));




--
-- Name: tbdosen; Type: TABLE; Schema: public; Owner: mandan
--

CREATE TABLE tbdosen (
    id_dosen integer NOT NULL,
    nidn character varying(10) NOT NULL,
    nm_dosen character varying(100) NOT NULL
);




--
-- Name: tbkelas; Type: TABLE; Schema: public; Owner: mandan
--

CREATE TABLE tbkelas (
    id_kelas integer NOT NULL,
    nm_kelas character varying(10) NOT NULL
);




--
-- Name: tbkuliah; Type: TABLE; Schema: public; Owner: mandan
--

CREATE TABLE tbkuliah (
    id_kuliah integer NOT NULL,
    id_dosen integer NOT NULL,
    id_matkul integer NOT NULL,
    id_kelas integer NOT NULL,
    thn_ajaran integer DEFAULT 20171 NOT NULL
);




--
-- Name: tbmatkul; Type: TABLE; Schema: public; Owner: mandan
--

CREATE TABLE tbmatkul (
    id_matkul integer NOT NULL,
    nm_matkul character varying(30) NOT NULL,
    sks smallint NOT NULL,
    smt smallint DEFAULT 1 NOT NULL
);




--
-- Name: lap_kuliah; Type: VIEW; Schema: public; Owner: mandan
--

CREATE VIEW lap_kuliah AS
 SELECT tbkuliah.id_kuliah,
    tbmatkul.id_matkul,
    tbmatkul.nm_matkul,
    tbdosen.id_dosen,
    tbdosen.nidn,
    tbdosen.nm_dosen,
    tbkelas.nm_kelas
   FROM (((tbkuliah
     JOIN tbmatkul ON ((tbkuliah.id_matkul = tbmatkul.id_matkul)))
     JOIN tbkelas ON ((tbkuliah.id_kelas = tbkelas.id_kelas)))
     JOIN tbdosen ON ((tbkuliah.id_dosen = tbdosen.id_dosen)));




--
-- Name: tbkuliah_mhs; Type: TABLE; Schema: public; Owner: mandan
--

CREATE TABLE tbkuliah_mhs (
    id_kmhs integer NOT NULL,
    id_mahasiswa integer NOT NULL,
    id_kuliah integer NOT NULL
);




--
-- Name: lap_kuliah_mhs; Type: VIEW; Schema: public; Owner: mandan
--

CREATE VIEW lap_kuliah_mhs AS
 SELECT tbkuliah_mhs.id_kmhs,
    tbkuliah_mhs.id_kuliah,
    tbmahasiswa.id_mahasiswa,
    tbmahasiswa.nobp,
    tbmahasiswa.nm_mahasiswa
   FROM ((tbkuliah_mhs
     JOIN tbkuliah ON ((tbkuliah_mhs.id_kuliah = tbkuliah.id_kuliah)))
     JOIN tbmahasiswa ON ((tbkuliah_mhs.id_mahasiswa = tbmahasiswa.id_mahasiswa)));




--
-- Name: lap_mahasiswa; Type: VIEW; Schema: public; Owner: mandan
--

CREATE VIEW lap_mahasiswa AS
 SELECT tbmahasiswa.id_mahasiswa,
    tbmahasiswa.nobp,
    tbmahasiswa.nm_mahasiswa,
    tbkelas.nm_kelas
   FROM (tbmahasiswa
     JOIN tbkelas ON ((tbmahasiswa.id_kelas = tbkelas.id_kelas)));




--
-- Name: tbujian; Type: TABLE; Schema: public; Owner: mandan
--

CREATE TABLE tbujian (
    id_ujian integer NOT NULL,
    id_kuliah integer NOT NULL,
    id_tsoal integer NOT NULL,
    deskripsi character varying(200),
    id_jujian smallint NOT NULL,
    durasi_ujian integer NOT NULL
);




--
-- Name: lap_peserta_ujian; Type: VIEW; Schema: public; Owner: mandan
--

CREATE VIEW lap_peserta_ujian AS
 SELECT tbujian.id_ujian,
    lap_kuliah_mhs.id_mahasiswa,
    lap_kuliah_mhs.nobp,
    lap_kuliah_mhs.nm_mahasiswa
   FROM (tbujian
     JOIN lap_kuliah_mhs ON ((tbujian.id_kuliah = lap_kuliah_mhs.id_kuliah)));




--
-- Name: tbtipe_soal; Type: TABLE; Schema: public; Owner: mandan
--

CREATE TABLE tbtipe_soal (
    id_tsoal integer NOT NULL,
    nm_tipe character varying(15) NOT NULL
);




--
-- Name: lap_soal; Type: VIEW; Schema: public; Owner: mandan
--

CREATE VIEW lap_soal AS
 SELECT tbsoal.id_soal,
    tbsoal.isi_soal,
    tbsoal.jawaban,
    tbsoal."pilihanGanda",
    tbsoal.id_tsoal,
    tbtipe_soal.nm_tipe,
    tbsoal.bobot
   FROM (tbsoal
     JOIN tbtipe_soal ON ((tbsoal.id_tsoal = tbtipe_soal.id_tsoal)));




--
-- Name: tbsoal_ujian; Type: TABLE; Schema: public; Owner: mandan
--

CREATE TABLE tbsoal_ujian (
    id_sujian integer NOT NULL,
    id_ujian integer NOT NULL,
    id_soal integer NOT NULL
);




--
-- Name: lap_soal_ujian; Type: VIEW; Schema: public; Owner: mandan
--

CREATE VIEW lap_soal_ujian AS
 SELECT tbsoal_ujian.id_sujian,
    tbsoal_ujian.id_ujian,
    tbsoal_ujian.id_soal,
    tbsoal.isi_soal,
    tbsoal.jawaban,
    tbsoal."pilihanGanda"
   FROM (tbsoal_ujian
     JOIN tbsoal ON ((tbsoal_ujian.id_soal = tbsoal.id_soal)));




--
-- Name: lap_status_ujian_mhs; Type: VIEW; Schema: public; Owner: mandan
--

CREATE VIEW lap_status_ujian_mhs AS
 SELECT tbmahasiswa.id_mahasiswa,
    tbmahasiswa.nobp,
    tbmahasiswa.nm_mahasiswa,
        CASE
            WHEN (hasil_ujian.nilai IS NOT NULL) THEN true
            ELSE false
        END AS status,
    hasil_ujian.id_tsoal
   FROM (tbmahasiswa
     LEFT JOIN ( SELECT tbhasil_ujian.id_hasil,
            tbhasil_ujian.id_ujian,
            tbhasil_ujian.id_peserta,
            tbhasil_ujian.nilai,
            tbujian.id_tsoal
           FROM (tbhasil_ujian
             JOIN tbujian ON ((tbhasil_ujian.id_ujian = tbujian.id_ujian)))
          WHERE (tbhasil_ujian.id_ujian = 3)) hasil_ujian ON ((tbmahasiswa.id_mahasiswa = hasil_ujian.id_peserta)));




--
-- Name: tbjenis_ujian; Type: TABLE; Schema: public; Owner: mandan
--

CREATE TABLE tbjenis_ujian (
    id_jujian integer NOT NULL,
    nm_jenis character varying(10) NOT NULL
);




--
-- Name: lap_ujian; Type: VIEW; Schema: public; Owner: mandan
--

CREATE VIEW lap_ujian AS
 SELECT tbujian.id_ujian,
    tbujian.id_kuliah,
    tbmatkul.nm_matkul,
    tbdosen.nidn,
    tbdosen.nm_dosen,
    tbkelas.nm_kelas,
    tbujian.id_tsoal,
    tbtipe_soal.nm_tipe,
    tbjenis_ujian.nm_jenis,
    floor(((tbujian.durasi_ujian / 3600000))::double precision) AS jam,
    mod((floor(((tbujian.durasi_ujian / 60000))::double precision))::integer, 60) AS menit
   FROM ((tbujian
     JOIN tbtipe_soal ON ((tbujian.id_tsoal = tbtipe_soal.id_tsoal)))
     JOIN tbjenis_ujian ON ((tbujian.id_jujian = tbjenis_ujian.id_jujian))),
    (((tbkuliah
     JOIN tbdosen ON ((tbkuliah.id_dosen = tbdosen.id_dosen)))
     JOIN tbmatkul ON ((tbkuliah.id_matkul = tbmatkul.id_matkul)))
     JOIN tbkelas ON ((tbkuliah.id_kelas = tbkelas.id_kelas)))
  WHERE (tbujian.id_kuliah = tbkuliah.id_kuliah);




--
-- Name: tbtipe_user; Type: TABLE; Schema: public; Owner: mandan
--

CREATE TABLE tbtipe_user (
    id_tipe integer NOT NULL,
    nm_tipe character varying(15) NOT NULL
);




--
-- Name: tbuser; Type: TABLE; Schema: public; Owner: mandan
--

CREATE TABLE tbuser (
    id_user integer NOT NULL,
    username character varying(15) NOT NULL,
    password text NOT NULL,
    id_tipe integer NOT NULL
);




--
-- Name: lap_user; Type: VIEW; Schema: public; Owner: mandan
--

CREATE VIEW lap_user AS
 SELECT tbuser.id_user,
    tbuser.username,
    tbuser.password,
    tbuser.id_tipe,
    tbtipe_user.nm_tipe
   FROM (tbuser
     JOIN tbtipe_user ON ((tbuser.id_tipe = tbtipe_user.id_tipe)));




--
-- Name: mahasiswa_id_mahasiswa_seq; Type: SEQUENCE; Schema: public; Owner: mandan
--

CREATE SEQUENCE mahasiswa_id_mahasiswa_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;




--
-- Name: mahasiswa_id_mahasiswa_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mandan
--

ALTER SEQUENCE mahasiswa_id_mahasiswa_seq OWNED BY tbsoal.id_soal;


--
-- Name: matkul_id_matkul_seq; Type: SEQUENCE; Schema: public; Owner: mandan
--

CREATE SEQUENCE matkul_id_matkul_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;




--
-- Name: matkul_id_matkul_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mandan
--

ALTER SEQUENCE matkul_id_matkul_seq OWNED BY tbmatkul.id_matkul;


--
-- Name: tbdosen_id_dosen_seq; Type: SEQUENCE; Schema: public; Owner: mandan
--

CREATE SEQUENCE tbdosen_id_dosen_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;




--
-- Name: tbdosen_id_dosen_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mandan
--

ALTER SEQUENCE tbdosen_id_dosen_seq OWNED BY tbdosen.id_dosen;


--
-- Name: tbhasil_ujian_id_hasil_seq; Type: SEQUENCE; Schema: public; Owner: mandan
--

CREATE SEQUENCE tbhasil_ujian_id_hasil_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;




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




--
-- Name: tbjawaban_id_jawaban_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mandan
--

ALTER SEQUENCE tbjawaban_id_jawaban_seq OWNED BY tbjawaban.id_jawaban;


--
-- Name: tbjenis_ujian_id_jujian_seq; Type: SEQUENCE; Schema: public; Owner: mandan
--

CREATE SEQUENCE tbjenis_ujian_id_jujian_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: tbjenis_ujian_id_jujian_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mandan
--

ALTER SEQUENCE tbjenis_ujian_id_jujian_seq OWNED BY tbjenis_ujian.id_jujian;


--
-- Name: tbkelas_id_kelas_seq; Type: SEQUENCE; Schema: public; Owner: mandan
--

CREATE SEQUENCE tbkelas_id_kelas_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: tbkelas_id_kelas_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mandan
--

ALTER SEQUENCE tbkelas_id_kelas_seq OWNED BY tbkelas.id_kelas;


--
-- Name: tbkuliah_id_kuliah_seq; Type: SEQUENCE; Schema: public; Owner: mandan
--

CREATE SEQUENCE tbkuliah_id_kuliah_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: tbkuliah_id_kuliah_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mandan
--

ALTER SEQUENCE tbkuliah_id_kuliah_seq OWNED BY tbkuliah.id_kuliah;


--
-- Name: tbkuliah_mhs_id_kmhs_seq; Type: SEQUENCE; Schema: public; Owner: mandan
--

CREATE SEQUENCE tbkuliah_mhs_id_kmhs_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;




--
-- Name: tbkuliah_mhs_id_kmhs_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mandan
--

ALTER SEQUENCE tbkuliah_mhs_id_kmhs_seq OWNED BY tbkuliah_mhs.id_kmhs;


--
-- Name: tbmahasiswa_id_mahasiswa_seq; Type: SEQUENCE; Schema: public; Owner: mandan
--

CREATE SEQUENCE tbmahasiswa_id_mahasiswa_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;




--
-- Name: tbmahasiswa_id_mahasiswa_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mandan
--

ALTER SEQUENCE tbmahasiswa_id_mahasiswa_seq OWNED BY tbmahasiswa.id_mahasiswa;


--
-- Name: tbsoal_ujian_id_sujian_seq; Type: SEQUENCE; Schema: public; Owner: mandan
--

CREATE SEQUENCE tbsoal_ujian_id_sujian_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;




--
-- Name: tbsoal_ujian_id_sujian_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mandan
--

ALTER SEQUENCE tbsoal_ujian_id_sujian_seq OWNED BY tbsoal_ujian.id_sujian;


--
-- Name: tbtipe_user_id_tipe_seq; Type: SEQUENCE; Schema: public; Owner: mandan
--

CREATE SEQUENCE tbtipe_user_id_tipe_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;




--
-- Name: tbtipe_user_id_tipe_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mandan
--

ALTER SEQUENCE tbtipe_user_id_tipe_seq OWNED BY tbtipe_user.id_tipe;


--
-- Name: tbujian_id_ujian_seq; Type: SEQUENCE; Schema: public; Owner: mandan
--

CREATE SEQUENCE tbujian_id_ujian_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;




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




--
-- Name: tbuser_id_user_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mandan
--

ALTER SEQUENCE tbuser_id_user_seq OWNED BY tbuser.id_user;


--
-- Name: tipe_soal_id_tsoal_seq; Type: SEQUENCE; Schema: public; Owner: mandan
--

CREATE SEQUENCE tipe_soal_id_tsoal_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;




--
-- Name: tipe_soal_id_tsoal_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mandan
--

ALTER SEQUENCE tipe_soal_id_tsoal_seq OWNED BY tbtipe_soal.id_tsoal;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mandan
--

ALTER TABLE ONLY json ALTER COLUMN id SET DEFAULT nextval('json_id_seq'::regclass);


--
-- Name: id_dosen; Type: DEFAULT; Schema: public; Owner: mandan
--

ALTER TABLE ONLY tbdosen ALTER COLUMN id_dosen SET DEFAULT nextval('tbdosen_id_dosen_seq'::regclass);


--
-- Name: id_hasil; Type: DEFAULT; Schema: public; Owner: mandan
--

ALTER TABLE ONLY tbhasil_ujian ALTER COLUMN id_hasil SET DEFAULT nextval('tbhasil_ujian_id_hasil_seq'::regclass);


--
-- Name: id_jawaban; Type: DEFAULT; Schema: public; Owner: mandan
--

ALTER TABLE ONLY tbjawaban ALTER COLUMN id_jawaban SET DEFAULT nextval('tbjawaban_id_jawaban_seq'::regclass);


--
-- Name: id_jujian; Type: DEFAULT; Schema: public; Owner: mandan
--

ALTER TABLE ONLY tbjenis_ujian ALTER COLUMN id_jujian SET DEFAULT nextval('tbjenis_ujian_id_jujian_seq'::regclass);


--
-- Name: id_kelas; Type: DEFAULT; Schema: public; Owner: mandan
--

ALTER TABLE ONLY tbkelas ALTER COLUMN id_kelas SET DEFAULT nextval('tbkelas_id_kelas_seq'::regclass);


--
-- Name: id_kuliah; Type: DEFAULT; Schema: public; Owner: mandan
--

ALTER TABLE ONLY tbkuliah ALTER COLUMN id_kuliah SET DEFAULT nextval('tbkuliah_id_kuliah_seq'::regclass);


--
-- Name: id_kmhs; Type: DEFAULT; Schema: public; Owner: mandan
--

ALTER TABLE ONLY tbkuliah_mhs ALTER COLUMN id_kmhs SET DEFAULT nextval('tbkuliah_mhs_id_kmhs_seq'::regclass);


--
-- Name: id_mahasiswa; Type: DEFAULT; Schema: public; Owner: mandan
--

ALTER TABLE ONLY tbmahasiswa ALTER COLUMN id_mahasiswa SET DEFAULT nextval('tbmahasiswa_id_mahasiswa_seq'::regclass);


--
-- Name: id_matkul; Type: DEFAULT; Schema: public; Owner: mandan
--

ALTER TABLE ONLY tbmatkul ALTER COLUMN id_matkul SET DEFAULT nextval('matkul_id_matkul_seq'::regclass);


--
-- Name: id_soal; Type: DEFAULT; Schema: public; Owner: mandan
--

ALTER TABLE ONLY tbsoal ALTER COLUMN id_soal SET DEFAULT nextval('mahasiswa_id_mahasiswa_seq'::regclass);


--
-- Name: id_sujian; Type: DEFAULT; Schema: public; Owner: mandan
--

ALTER TABLE ONLY tbsoal_ujian ALTER COLUMN id_sujian SET DEFAULT nextval('tbsoal_ujian_id_sujian_seq'::regclass);


--
-- Name: id_tsoal; Type: DEFAULT; Schema: public; Owner: mandan
--

ALTER TABLE ONLY tbtipe_soal ALTER COLUMN id_tsoal SET DEFAULT nextval('tipe_soal_id_tsoal_seq'::regclass);


--
-- Name: id_tipe; Type: DEFAULT; Schema: public; Owner: mandan
--

ALTER TABLE ONLY tbtipe_user ALTER COLUMN id_tipe SET DEFAULT nextval('tbtipe_user_id_tipe_seq'::regclass);


--
-- Name: id_ujian; Type: DEFAULT; Schema: public; Owner: mandan
--

ALTER TABLE ONLY tbujian ALTER COLUMN id_ujian SET DEFAULT nextval('tbujian_id_ujian_seq'::regclass);


--
-- Name: id_user; Type: DEFAULT; Schema: public; Owner: mandan
--

ALTER TABLE ONLY tbuser ALTER COLUMN id_user SET DEFAULT nextval('tbuser_id_user_seq'::regclass);


--
-- Data for Name: json; Type: TABLE DATA; Schema: public; Owner: mandan
--

COPY json (id, books) FROM stdin;
1	[\r\n{"huruf":"A"},\r\n{"huruf":"B"}\r\n]
\.


--
-- Name: json_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mandan
--

SELECT pg_catalog.setval('json_id_seq', 1, true);


--
-- Name: mahasiswa_id_mahasiswa_seq; Type: SEQUENCE SET; Schema: public; Owner: mandan
--

SELECT pg_catalog.setval('mahasiswa_id_mahasiswa_seq', 31, true);


--
-- Name: matkul_id_matkul_seq; Type: SEQUENCE SET; Schema: public; Owner: mandan
--

SELECT pg_catalog.setval('matkul_id_matkul_seq', 5, true);


--
-- Data for Name: tbdosen; Type: TABLE DATA; Schema: public; Owner: mandan
--

COPY tbdosen (id_dosen, nidn, nm_dosen) FROM stdin;
2	23232	dsds
6	1012019001	ANITA ADE RAHMA
7	1009026602	ARFIS
8	1023116001	AZIZUL HAKIM
9	1025125401	BUCHYARDI GOND
10	1028128901	DESFRIANA SARI
11	1013128902	DESI PERMATA SARI
12	1029128101	DESSY HARYANI
13	1027088001	DEVI EDRIANI
14	1021118602	DIAN MISRAWATI
15	1024089001	ELFA FITRIANI
16	1019046601	ELFISWANDI
17	1016098104	ELIZA
18	1020059001	FATMA ARIANI
19	1012028201	FITRI YENI
20	1022018601	HANNA PRATIWI
21	1001059002	HARMELIA
22	1031057501	HASMAYNELIS FITRI
23	1025069101	INDAH VIOZANI
24	1025058801	INDRA FAISAL
25	1015107601	LUSIANA
26	1025027501	MONDRA NELDI
27	1023098902	NITA SOFIA
28	1012018201	PRIMAROSI
29	1007068502	RIKA WAHYUNI
30	1014048602	RIRI PUTRI DIKA
31	1011038501	RONNI ANDRI WIJAYA
32	1030128501	SALMIDESTIAWAN
33	1021078901	SIGIT SANJAYA
34	1027087801	SONI
35	1026128201	TET LINDA YANI
36	1012118901	WELLIA NOVITA
37	1004119001	YAMASITHA
38	1017047602	YOSI YULIA
39	1016078301	YULIA SYAFITRI
40	1024128201	CENNYWATI
41	1023128702	DEFRIZAL SAPUTRA
42	1009038901	HARIS SATRIA
43	1016048403	IRNI RESMI APRIYANTI
44	1015077903	IRPAN SARIPUDIN
45	1025038701	MARIA MARGARETHA EARLENE
46	1019028401	RACHMAWATY
47	1001058204	TEGUH MEIRIZKY GIRDAYANTO
48	1016077202	YULIARMAN MAHMUDDIN
49	1025038501	ANDI B. WIRANATA
50	1009038301	ANDRE ILYAS
51	1017068801	ARIE YUSNELLY
52	1007098201	DARMA SYAHRULLAH EKA JAYA
53	1024086203	DASRIAL
54	1027125401	DASRIL MUNIR
55	1019038102	DICE DASRIL
56	1012078502	DIMAS PERDANA OSKAR
57	1012038303	ELVA SUSANTI
58	1010079101	EMILE SALIM
59	1009128604	ENGLA DESNIM SILVIA
60	1022118504	FITRAH SARI
61	1014018204	HADI IRFANI
62	1022036901	HERYATMAN
63	1027088203	HILDA MARY
64	1025056601	INDRIYENNI
65	1007018004	JON MAIZAR
66	1030098902	M. FADLI
67	1020039001	MARTA WIDIAN SARI
68	303116303	MASRIFAH
69	1006088103	MASRIZAL
70	1006095901	MAWARDI
71	1013029101	MERI MERIA SARI
72	1017078906	MEUTHI AN-NISA NOVIZAR
73	1004079001	MIRSAL
74	1001066001	NALIM
75	1001018305	NARDIMAN
76	1001128601	NILA PRATIWI
77	324123401	R A APULIJAH ABUTOJO
78	1002117201	RAMDANI BAYU PUTRA
79	1017128702	RANGGA WENDRA PRINOYA
80	1008048803	RINI AFRIANI
81	1029038701	RIO ANDHIKA PUTRA
82	1009038404	ROBBY DHARMA
83	1015108903	ROBERTA JULFA
84	1024017001	SASNELWATI
85	1027018901	SILVIA JESIKA
86	1029128503	SRI MONALISA
87	1004107101	SRI MULYATI
88	1005076403	SUHERMIZON
89	1017066402	SYAHNAN SIMATUPANG
90	1013128901	TIFANI RATU FIRDAUS
91	1012039001	TITIK EFNITA
92	1006108801	VICKY BRAHMA KUMBARA
93	1030118604	VIVI NILA SARI
94	1019048803	WINDA AFRIYENIS
95	1019128204	YEKI CANDRA
96	1019087501	YULASMI
97	1013048204	YULI ANGGRAINI
98	1030087001	ZAINAL ABDUL HARIS
99	0011045604	ZERNI MELMUSI
100	1017049101	AULIA FITRUL HADI
101	1011087502	DIYAWATI
102	1015078501	FENDI ANTONI
103	1008018901	HANGGI DWIFA HONESQI
104	1009117001	IDRIZON
105	1017047702	MAIDAWATI
106	1014019002	NOVALIA INDRA
107	1017047701	RIRY YUSKAR
108	1003056801	SILFIA ANDINI
109	1016058902	SULARNO
110	1029116801	SURMAYANTI
111	1009128301	VIVI RESTI DARMISON
112	1003077501	YOSEFRIZAL
113	1028048501	NURFITRI
114	1014039002	AMINDA DEWI SUTIASIH
115	1020078401	ANDRIYAS HARIYANDI
116	1024058901	DEVIT SATRIA
117	1005019001	DEWI DEVITA
118	1017119002	ILHAM TRI MAULANA
119	1025128401	INDRA WIJAYA
120	1023016801	IRNAWATI SIREGAR
121	1031038803	LAILA MARHAYATI
122	1005058504	LILI RISMAINI
123	1003088802	MEGAWATI
124	1012019101	MONICA FRANSISCA
125	1031127801	MUHARIKA DEWI
126	1019028801	NONI FEBRIANA
127	1003038901	POPI RADYULI
128	1014118801	RENNY PERMATA SAPUTRI
129	1008098501	RINI SEFRIANI
130	1003088903	SILVIA PERMATA SARI
131	1009029001	TAUFIK ADE KURNIAWAN
132	1019018402	YOSA NOVIA DEWI
133	1009098901	ZUBAIDAH
134	1024098002	ANDHIKA ANGGAWIRA
135	1026078201	ASIYARFITRIADI
136	1018108501	BAYU PRASETYA YUDHA
137	1003098301	DEVI PURNAMA SARI
138	1017018602	HARRI KURNIAWAN
139	1026067804	HARRY THEOZARD FIKRI
140	1009098503	HERIO RIZKI DEWINDA
141	1006068603	IFANI CANDRA
142	17017305	ISNA ASYRI SYAHRINA
143	1022068801	KRISNOVA NASTASIA
144	1020118203	PURWANTI ENDAH RAHAYU
145	1017018601	RANY FITRIANY
146	1010088203	RINA MARIANA
147	1011059001	SILFI FATAYANI
148	1017089001	SITTI HUTARI MULYANI
149	1011118501	UMMIL KHAIRIYAH
150	1015107101	ZERA MENDOZA
151	1029098901	ALBERT GAZALI
152	1012129101	ANNISAK IZZATY JAMHUR
153	1029108702	ASHABUL FADHLI
154	1020048002	ASRI NAWAS SE MM
155	1002068501	DEBY ERDRIANI
156	1010118402	DENI AMELIA
157	1020057501	DEPI DASMAL
158	1008128701	DEVI SYUKRI AZHARI S.PD.I M.PD
159	1027118601	DHANI PRAMULIA EKA PUTRA
160	1019018202	DIAN FITRINI
161	1020028602	DINUL AKHIYAR
162	1014028503	DODI STAPET
163	1009017602	DODI YANDRI
164	1060785021	DRS.HM.IQBAL.MM
165	1012068203	EDWAR KEMAL
166	1026038501	EKA MARIYANTI
167	1002058401	EKA MELATI M.PD
168	1002058402	EKA MELATI M.PD
169	1015087203	ELLYA GUSWANITA
170	1009048503	ELMI RAHMAWATI PUTRI
171	1017048603	ENDRYL SH MH
172	1009127301	ERDISNA
173	1027088101	ERLINDA
174	1003127702	ERNA SUSANTI SE MM
175	1028098602	EVA RIANTI
176	1021068601	FADLI HERNANDA
177	1011118901	FAJRUL ISLAMI
178	1018058602	FATHURRAHMI
179	1005028102	FEBRIYANNO SURYANA
180	1008088702	FIRNA YENILA
181	1012087401	GUSHELMI
182	1016087201	GUSLENDRA
183	1011108502	HADI SYAHPUTRA
184	1019057502	HAFNI
185	1010039001	HARI MARFALINO
186	1015128601	HARRY AL GHAZALY
187	1016118002	HEMA DESSY HARIANI
188	1020037703	HEMAT JUNEDI
189	1001037101	HENDRIK MARGARET
190	1008108301	HENDY MUCHRIZA
191	1013058604	HESTI PUSPARINI SE M.SI
192	1014099001	HEZY KURNIA
193	1002098302	HIKMAH
194	1021118101	ILHAMDI KURNIAWAN
195	1010068501	IRSYADUL EKA PUTERA
196	1012059001	IRZAL ARIEF WISKY
197	1021038303	ISNADUL HAMDI
198	1028018801	JENDRI MULYADI S.S M.HUM
199	1008077101	JHON VERI
200	1010028701	JIMMY FEBIO
201	1003026702	JUFRIADIF NA AM
202	1029077301	JULIUS SANTONY
203	1012128601	JUMRAWARSI
204	1025128101	KARTIRIA
205	1016058503	KHAIRUL ZAMAN
206	1019068501	LAKRY MALTAF PUTRA
207	1020119201	LARISSA NAVIA RANI
208	1003098302	LENI SYASMIRA
209	1022069201	LIGA MAYOLA
210	1021128701	LINORA RAHAYU
211	1014058901	MAHA RANI
212	1003058302	MELINA IRMAYENI SH M.KN
213	1021117701	MONDHA IRFANDI
214	1011076801	MUHAMMAD MAHZUM
215	1002058901	MUHAMMAD TEGUH ILHAM
216	1026059101	MUTIANA PRATIWI
217	1008106404	NUSYIRWIN
218	1005108604	OKTA ANDRICA PUTRA
219	1006068701	ONDRA EKA PUTRA
220	1011058003	PRIMA SANITA SYAIFUL
221	1003048501	RAFLIS
222	1007068001	RAFNIS
223	1019125102	RIFDA NAJMI FUAD
224	1019128501	RINA SUSANTI
225	1005047601	RINI SOVIA
226	1015048302	RIZA YONITA S.S MM
227	1003068801	ROKI ADITAMA
228	1022108302	RUDI SYAFRI
229	1023046101	SABARUDIN
230	1028128501	SAHARI
231	1026108202	SATRIA RONALDY
232	1021018402	SHALLY AMNA
233	1001088204	SITTI RIZKI MULYANI
234	1016038602	SOFIKA ENGGARI
235	1015067501	SRI RAHMAWATI
236	1024048503	SRI RAMADHAN
237	1025076401	SUHELMI HELIA
238	1023108601	SYAFRI ARLIS
239	1027067903	SYAFRI JODI
240	1016068402	SYAFRIKA DENI RIZKI
241	1006057201	SYAMSI
242	1013048502	SYELFIA DEWIMARNI S.PD M.PD
243	1021037202	SYUHADI
244	1010068304	USMAN
245	1006017601	VIVI IRAWATI
246	1010028505	VIVI PUSPITA SARI
247	1008058902	WIFRA SAFITRI
248	1024048502	YANTI YUSMAN
249	1010088704	YENG PRIMAWATI
250	1002117401	YOSE RIZAL
251	1015057301	YUHANDRI
252	1003078402	YULIA RETNO SARI
253	1005117101	YUSTA NOVERISON
254	1009096401	ZEFRI YENNI
255	1017069001	AGGY PRAMANA GUSMAN
256	1028088702	AGUS SURYADI
257	1020057603	ASMAINI
258	1018048301	BILLY HENDRIK
259	1009087402	DEDY WAHYUDI
260	1003088601	DODI GUSWANDI
261	1026108501	EKO AMRI JAYA
262	1017127401	EMIL NAF`AN
263	1011098501	FIRDAUS
264	1010058703	HALIFIA HENDRI
265	1028018301	HANDY RACHMAT TRIYADI
266	1023037504	HARIS SURYAMEN
267	1017089002	HARKAMSYAH ANDRIANOF
268	1020099101	HASRI AWAL
269	1018078601	ISMI PUTRI
270	1012108401	MARDHIAH MASRIL
271	1003078601	MARDISON
272	1017098206	MARTIN WAHYUNUS
273	1018017501	MUHARDI. Z
274	1023098901	NESA LITA
275	1031059001	RAHMAT HIDAYAT
276	1026099001	REFI SENATA
277	1004038101	RETNO DEVITA
278	1016067902	RIA ANGGRAINI
279	1004077904	RISKA ROBIANTO
280	1010047701	RITA
281	1007099001	ROMI HARDIANTO
282	1016038601	RURI HARTIKA ZAIN
283	1004069101	SILKY SAFIRA
284	1011019001	YOGI WIYANDRA
285	1013049001	YONKY PERNANDO
286	1012085301	ZULBATRI
287	1012098102	ZULFAHMI
288	1026097501	ERWIN RAMADIAN
289	1027018501	HENNY YULIUS
290	1007048304	IRSAN
291	1003049001	MOHAMMAD FADHLI
292	1011018301	MUFRIDA MERI Z
293	1029058703	WAHYU FITRIANDA MUFTI
294	1021098101	ABULWAFA MUHAMMAD
295	1010097701	ADI PRANOTO
296	1011098802	ANESIA NILA KINANTI
297	1028058402	BENNY WAHYUDI
298	1011064901	CHARLES DARWIN
299	1021088601	DEVAL GUSRION
300	1021129101	DEVIA KARTIKA
301	1015048703	DEWI EKA PUTRI
302	1026129001	DHIO SAPUTRA
303	1010128402	DIAN CHRISTINA
304	1008028803	EKA LIA FEBRIANTI
305	1014088502	EKA PRAJA WIYATA MANDALA
306	1015028801	FEBRI HADI
307	1014036901	GUNADI WIDI NUR CAHYO
308	1022038901	IHSAN VERDIAN
309	1009047901	ILMAWATI
310	1014039301	LIDYA RIZKI ANANDA
311	1012029101	MASRIADI
312	1028088201	MISHBAH ULHUSNA
313	1022098403	MUHAMMAD AFDHAL
314	1012059101	MUHAMMAD IKHLAS
315	1018119001	MUHAMMAD REZA PUTRA
316	1007078901	MUSLI YANTO
317	1007118403	MUSTAPA
318	1031038901	NUGRAHA RAHMANSYAH
319	1028018001	PINTA MEDINA
320	1021018802	PURNAMA SARI
321	1023119001	RAJA AYU MAHESSYA
322	1012128701	RANDY PERMANA
323	1029098402	REVA MUHARENI
324	1031088901	REVI GUSRIVA
325	1007069201	RICKI ARDIANSYAH
326	1013098901	RIMA LIANA GEMA
327	1012118403	RIZKI NURDIN
328	1017059201	ROMI WIJAYA
329	1007087002	SARJON DEFIT
330	1026099002	SAYENDRA SAFARIA
331	1021128801	SHARY ARMONITHA LUSINIA
332	1023018901	SRI DIANA PUTRI
333	0005076607	SUMIJAN
334	1001059001	TERI ADE PUTRA
335	1004118102	TITIN KOMLA DEWI
336	1008108202	USMAN
337	1007088801	VICKY ARIANDI
338	1003098202	WENTY ZAHRATI
339	1004129101	YESRI ELVA
340	1016089101	ZAKIRMAN
341	1017047902	AFRILDA SARI
342	1028018201	CUT DONA KORDELIA
343	1011027001	FEBRIAN
344	1024048504	NADRA ARSYAD
345	1014028804	REZZA FALEN
346	1018048401	RIKI ADRIADI
347	0006047306	WENDI BOY
348	1018118401	WIDIAWATI PURBA
349	1024127202	ZULDES JONI ST
\.


--
-- Name: tbdosen_id_dosen_seq; Type: SEQUENCE SET; Schema: public; Owner: mandan
--

SELECT pg_catalog.setval('tbdosen_id_dosen_seq', 349, true);


--
-- Data for Name: tbhasil_ujian; Type: TABLE DATA; Schema: public; Owner: mandan
--

COPY tbhasil_ujian (id_hasil, id_ujian, id_peserta, nilai) FROM stdin;
1	3	1	50
3	4	2	5
\.


--
-- Name: tbhasil_ujian_id_hasil_seq; Type: SEQUENCE SET; Schema: public; Owner: mandan
--

SELECT pg_catalog.setval('tbhasil_ujian_id_hasil_seq', 3, true);


--
-- Data for Name: tbjawaban; Type: TABLE DATA; Schema: public; Owner: mandan
--

COPY tbjawaban (id_jawaban, id_ujian, id_soal, id_peserta, jawaban) FROM stdin;
16	4	31	2	anumu
\.


--
-- Name: tbjawaban_id_jawaban_seq; Type: SEQUENCE SET; Schema: public; Owner: mandan
--

SELECT pg_catalog.setval('tbjawaban_id_jawaban_seq', 16, true);


--
-- Data for Name: tbjenis_ujian; Type: TABLE DATA; Schema: public; Owner: mandan
--

COPY tbjenis_ujian (id_jujian, nm_jenis) FROM stdin;
1	UAS
2	UTS
3	Lain-lain
\.


--
-- Name: tbjenis_ujian_id_jujian_seq; Type: SEQUENCE SET; Schema: public; Owner: mandan
--

SELECT pg_catalog.setval('tbjenis_ujian_id_jujian_seq', 4, true);


--
-- Data for Name: tbkelas; Type: TABLE DATA; Schema: public; Owner: mandan
--

COPY tbkelas (id_kelas, nm_kelas) FROM stdin;
1	SI-10
3	SI-8
4	SI-1
5	SI-2
6	SI-3
\.


--
-- Name: tbkelas_id_kelas_seq; Type: SEQUENCE SET; Schema: public; Owner: mandan
--

SELECT pg_catalog.setval('tbkelas_id_kelas_seq', 6, true);


--
-- Data for Name: tbkuliah; Type: TABLE DATA; Schema: public; Owner: mandan
--

COPY tbkuliah (id_kuliah, id_dosen, id_matkul, id_kelas, thn_ajaran) FROM stdin;
3	2	3	3	20171
8	333	4	3	20171
\.


--
-- Name: tbkuliah_id_kuliah_seq; Type: SEQUENCE SET; Schema: public; Owner: mandan
--

SELECT pg_catalog.setval('tbkuliah_id_kuliah_seq', 16, true);


--
-- Data for Name: tbkuliah_mhs; Type: TABLE DATA; Schema: public; Owner: mandan
--

COPY tbkuliah_mhs (id_kmhs, id_mahasiswa, id_kuliah) FROM stdin;
6	1	3
7	2	8
8	3	8
10	2	3
11	3	3
\.


--
-- Name: tbkuliah_mhs_id_kmhs_seq; Type: SEQUENCE SET; Schema: public; Owner: mandan
--

SELECT pg_catalog.setval('tbkuliah_mhs_id_kmhs_seq', 12, true);


--
-- Data for Name: tbmahasiswa; Type: TABLE DATA; Schema: public; Owner: mandan
--

COPY tbmahasiswa (id_mahasiswa, nobp, nm_mahasiswa, id_kelas, status) FROM stdin;
1	14101152610565	Ego Dafma Dasa	1	t
2	14101152610561	Kudil	3	t
3	14101152610990	kudil 2	1	t
\.


--
-- Name: tbmahasiswa_id_mahasiswa_seq; Type: SEQUENCE SET; Schema: public; Owner: mandan
--

SELECT pg_catalog.setval('tbmahasiswa_id_mahasiswa_seq', 3, true);


--
-- Data for Name: tbmatkul; Type: TABLE DATA; Schema: public; Owner: mandan
--

COPY tbmatkul (id_matkul, nm_matkul, sks, smt) FROM stdin;
1	Komputer Masyarakat	2	1
3	Keamanan Komputer	3	1
4	Pengelolaan Sistem Informasi	3	1
5	Pendidikan Agama	2	1
\.


--
-- Data for Name: tbsoal; Type: TABLE DATA; Schema: public; Owner: mandan
--

COPY tbsoal (id_soal, isi_soal, jawaban, "pilihanGanda", id_tsoal, bobot) FROM stdin;
2	Ayam adalah?	Ayam adalah hewan berkaki 2	\N	2	1
7	Bara kaki gajah?	ampek da	\N	2	1
10	Bara kaki anjiang?	B	\N	2	10
11	pantek kau	fak yu	\N	2	20
1	Berapakah kaki kucing?	A	[{"huruf":"A","isi_pilihan":"4"},{"huruf":"B","isi_pilihan":"3"},{"huruf":"C","isi_pilihan":"2"}]	1	1
12	mkmkkm	qwqwqwq	\N	2	20
16	cxccs	B	[{"huruf":"A","isi_pilihan":"xsx"},{"huruf":"B","isi_pilihan":" xx "}]	1	0
17	dsxs	A	[{"huruf":"A","isi_pilihan":"cdc"},{"huruf":"B","isi_pilihan":"cdc"},{"huruf":"C","isi_pilihan":"cdc"}]	1	1
18	Komas adalah?	Anu	\N	2	20
21	Kepanjangan dari WWW adalah?	A	[{"huruf":"A","isi_pilihan":"World Wide Web"},{"huruf":"B","isi_pilihan":"World Wide Website"}]	1	1
23	Anu adalah?	anu	\N	2	20
24	Ayam adalah	adaym	\N	2	15
22	Kepanjangan dari PC adalah?	A	[{"huruf":"A","isi_pilihan":"Personal Computer"},{"huruf":"B","isi_pilihan":"Personal Candidate"},{"huruf":"C","isi_pilihan":"Personal Canciang"}]	1	1
25	mandul	gundul	\N	2	20
26	mandul	gundul	\N	2	20
27	dafuk	gundul	\N	2	20
28	gundulmu	gigi	\N	2	20
29	anumu	gundulmu	\N	2	20
30	momo	mumu	\N	2	21
31	Sistem adalah?	Sekumpulan elemen yang bekerja sama untuk mencapai sebuah tujuan	\N	2	15
\.


--
-- Data for Name: tbsoal_ujian; Type: TABLE DATA; Schema: public; Owner: mandan
--

COPY tbsoal_ujian (id_sujian, id_ujian, id_soal) FROM stdin;
6	3	21
7	3	22
13	2	28
15	2	30
16	4	31
\.


--
-- Name: tbsoal_ujian_id_sujian_seq; Type: SEQUENCE SET; Schema: public; Owner: mandan
--

SELECT pg_catalog.setval('tbsoal_ujian_id_sujian_seq', 16, true);


--
-- Data for Name: tbtipe_soal; Type: TABLE DATA; Schema: public; Owner: mandan
--

COPY tbtipe_soal (id_tsoal, nm_tipe) FROM stdin;
1	Pilihan Ganda
2	Essai
\.


--
-- Data for Name: tbtipe_user; Type: TABLE DATA; Schema: public; Owner: mandan
--

COPY tbtipe_user (id_tipe, nm_tipe) FROM stdin;
1	Admin
2	Dosen
\.


--
-- Name: tbtipe_user_id_tipe_seq; Type: SEQUENCE SET; Schema: public; Owner: mandan
--

SELECT pg_catalog.setval('tbtipe_user_id_tipe_seq', 2, true);


--
-- Data for Name: tbujian; Type: TABLE DATA; Schema: public; Owner: mandan
--

COPY tbujian (id_ujian, id_kuliah, id_tsoal, deskripsi, id_jujian, durasi_ujian) FROM stdin;
3	3	1	ANuu	2	3600000
4	8	2	Test	1	3600000
\.


--
-- Name: tbujian_id_ujian_seq; Type: SEQUENCE SET; Schema: public; Owner: mandan
--

SELECT pg_catalog.setval('tbujian_id_ujian_seq', 4, true);


--
-- Data for Name: tbuser; Type: TABLE DATA; Schema: public; Owner: mandan
--

COPY tbuser (id_user, username, password, id_tipe) FROM stdin;
1	admin	21232f297a57a5a743894a0e4a801fc3	1
2	mandan	c65c85285ded60d163267e183b0c054b	1
359	1019046601	b7b734250f742dab8a1589f725ef7b3a	2
360	1016098104	2812044b39bfa6f2d40f34dd1fef3edf	2
361	1020059001	bbcb7aa41ecf36508f1fa33a70988ee0	2
362	1012028201	3dd9bd5a2d54b9d26dca7626e3b1b668	2
363	1022018601	9403384727ef1f29d85c778e8e1b169c	2
364	1001059002	bb4bef0c4486890299cd250a65f9900e	2
365	1031057501	6a815de054b84d3ef7ed54585d25ec33	2
366	1025069101	49e9ab2fb06ddc23e0b06e777d0c0b41	2
367	1025058801	d373ef8938da648821aba2f26e571037	2
368	1015107601	385afe8b50053133008e14d10e64ed6e	2
369	1025027501	a03c311486416b6f3cf1bfdcb5752d14	2
370	1023098902	7f1a2676d3baf3e392caa0921f782477	2
371	1012018201	e0282ec4bf2922af46c7243709f78082	2
372	1007068502	79d78b789a4f67d4d29e67d11213aa68	2
373	1014048602	9ad3a6a97a4db91ee893b299384a02c0	2
374	1011038501	03ae389acda027545f3dbabaf759935d	2
375	1030128501	e198db3fb6ba917dce2107f1ec6b962a	2
376	1021078901	8c0ae9dc37e6860778bfcf65f2e1a247	2
377	1027087801	05352aef7448107e3737dbbdb6c94222	2
378	1026128201	e5e620280edfdc57b3ded51b9fc12e01	2
379	1012118901	7838d6a240e01afc0200f127dc2e21bc	2
380	1004119001	53fb52d6874923557e2901e87ae35525	2
381	1017047602	83fe76ca06bf2fd41d521fd39ca30566	2
382	1016078301	b309849cb415f46f5d7785310c2dd349	2
383	1024128201	aa63e50b66649e45a76be0e56c7b2e8c	2
384	1023128702	45a486fb5a50df42aaf32981d8d62f6e	2
385	1009038901	25150e9acd9efaf3d9ab6aac93aabd07	2
386	1016048403	5b14d9b7f86de17b2ca6aa85ec0f730e	2
387	1015077903	49431020cc52cc85fdfe33fbfe344bd1	2
388	1025038701	cfa4dd7e3b5e33cabf8ed519b26d61a6	2
389	1019028401	7ba2f52d59c903cdd0363419ae22a917	2
390	1001058204	c3f784ec6e7ffabe84bf23e38ddaf02b	2
391	1016077202	550216e63807a4c43df296d7e65c08bf	2
392	1025038501	32d7221efe9123495492828a6defafd0	2
393	1009038301	a6a7fd704953c6c86bc853c7c049e237	2
394	1017068801	ae0db61d667bdd0b492776007ae191c8	2
395	1007098201	a2f2b3b76307c1d1b6dfba4ac592c81a	2
396	1024086203	b3fce63e2623ff4e899ac08dd88d03a0	2
397	1027125401	d1785f2eb5eeb945c70ab0ff0027e9e6	2
398	1019038102	37955a600a9095dd615d5abfdeb616a2	2
399	1012078502	dcecb344563634b0300b2c1b519a9b93	2
400	1012038303	eef9fef38bc28eebfd44e3533d2235b3	2
401	1010079101	cb13feb0c64a968395a08726210984ed	2
402	1009128604	1f433ed70dadcb4a0517d806d3c48407	2
403	1022118504	8bec9211223aa3ca3f230ca5f4cec511	2
404	1014018204	1d77bf23a64a53664449b3cfc8e732b4	2
405	1022036901	395f7030a6a60ab2695e4a06eb05432d	2
406	1027088203	a71f519c52d036fac6d2ad39c4f84e06	2
407	1025056601	ca32ad74a3229b8f792d668c2372442f	2
408	1007018004	c7fbc4c13012a4775472cc37e81a9ec8	2
409	1030098902	b8ff8c2f9a77bb39ea961f0e2bf2ac2f	2
410	1020039001	6bf479e196f23b7b0a6d441191e8b599	2
411	303116303	e3d0aa02ff17e79662f68d9e1bee2ee8	2
412	1006088103	e9e9d81891a6f3668f51d8ae3c94e906	2
413	1006095901	654132ebfe237acace32b341a442ea85	2
414	1013029101	f877350e060547976d5d7feb5833a40f	2
415	1017078906	3dfddbfceff5d04fc71ec26925923e83	2
416	1004079001	818c178f60b7bacc1e271b411e719975	2
417	1001066001	cd9d2bcfa8c667121a40ff5d354dfb9e	2
418	1001018305	b75e100dd0d2c368c069c3aa153a6fe9	2
419	1001128601	75e8860b5277f6fc85823baef026ed36	2
420	324123401	21543f684d15dfa388c55a6c388f4757	2
421	1002117201	a56fbba84972534a3ef84befa4896351	2
422	1017128702	76267113daa448faf96ee1584af526d2	2
423	1008048803	60867a0ee02d68c7bd24825c4defd9dc	2
424	1029038701	e5d3d1dd0abd158c23cf05ae53db0dc1	2
425	1009038404	391e9d1267cc89e74b33e772d6a46b68	2
426	1015108903	aa5e32d9035514d094843eb2516caf65	2
427	1024017001	c4834de60ac8bbcfb30edbe2167222f9	2
428	1027018901	60728dbd9699ff9e8099f55d3b85dc9e	2
429	1029128503	31914eb8854dfef0421bf3302cb54ba3	2
430	1004107101	aa59b904afc428ae442a975bfa218f08	2
431	1005076403	4a9aa85b54ce93d949f1e0dd035e685e	2
432	1017066402	d5a127898092dc0b4e6130923bace951	2
433	1013128901	c553355f76f581ff7cf327b8c824048a	2
434	1012039001	0e76467994eb0c0c186543ecdaf440f6	2
435	1006108801	5d9cf5ba0f1cd4687da5bfc10fc7fdd4	2
436	1030118604	82e6d5c3bb616d5c8fd7951894fbd481	2
437	1019048803	a9ebd49580749f9a0f58825b4ed28498	2
438	1019128204	dea37a46a63834184af1bdda7109c78b	2
439	1019087501	c60831852d631d41b528a99ea05967e1	2
440	1013048204	352c6aed7a51a9f610be757c278f93c8	2
441	1030087001	dd4508d06e164911a77be15ba38b0a2e	2
442	0011045604	b7150f1876caabc1fda47de6c82b436a	2
443	1017049101	b495a7dab14690b6751a3531f4813d65	2
444	1011087502	9a878e7d933604dfd9ea7c72f45ed312	2
445	1015078501	a3ad6abcb2e01d367302487d87b87946	2
446	1008018901	3c6e8340893ff23472367b4e2ea71197	2
447	1009117001	f9c1c5e3d7fea4f8b0ec1cac69234086	2
448	1017047702	32ebe498f7ae149f808437815afffccf	2
449	1014019002	0b7e75bac580e3bdf1d6bc26f415cbe5	2
450	1017047701	e23ff070850c8a6182c8d02ec752e172	2
451	1003056801	5abc26b04d6693b85a755dce7c39a34b	2
452	1016058902	28e74fec2a55bc15d26feff11f0bfa76	2
453	1029116801	060890186b7eda40874dd4096ac06fce	2
454	1009128301	9ce8175d40b82127cfe93c71c8292b5b	2
455	1003077501	94b1b86f8fe751cab1af8c0e909f5003	2
456	1028048501	2cfb49e47bcc2cc9d56cee2ff24e6f6f	2
457	1014039002	8aeae3ee54943bb53b6f2f72e3b2d070	2
458	1020078401	0d0a29ae2ac7cff1de9dd4327db8b51d	2
459	1024058901	867bb4206d5b4c72d2205ae3300e481a	2
460	1005019001	c889da02c80e3f15f70025d879a3fec7	2
461	1017119002	f80a050cf1279624062426a6a1113e91	2
462	1025128401	8258ec8db937d9bf65959df9694bbace	2
463	1023016801	dcf14592c37d322aac9ccd9bd27f5b74	2
464	1031038803	84509ba4378610175421c1a2263ed908	2
465	1005058504	f8478eb13e6a09d191b72988ccf6d92b	2
466	1003088802	ee845fb4d297d941720c10a1f7a20cb9	2
467	1012019101	fc6f1450af02f8e695fcb1cde3a1786e	2
468	1031127801	89252d4472ec6d6cd92d2d714bf23927	2
469	1019028801	680b667ad2e89648773db5fc4cefb2a7	2
470	1003038901	4294d77dbb428e77c6a7c1df89f6d52c	2
471	1014118801	b606484bdee33f65fc206aee873e7748	2
472	1008098501	8a92b95d1501d5c4ae26bb109a953554	2
473	1003088903	cfb54487b6b64de7ecdb183e211174e6	2
474	1009029001	6c36f50da93bb009139ce690292ba1c0	2
475	1019018402	2e3a27c7a1fefa89cc3ef1ca6f8ac90f	2
476	1009098901	cf3ef93d17532dd791d59aebdb9c6aa3	2
477	1024098002	9c1e1e4d9b8bf133bf19246162f6960c	2
478	1026078201	afcb5380fca83c5747a4b7072738f665	2
479	1018108501	3067fad77d88b85535a9ddf83d266bc7	2
480	1003098301	649c216a4cb34e24c8e4536067dba635	2
481	1017018602	a1e82cef0e6b237872da71ff84b8f08c	2
482	1026067804	7e97e42800c28e2183e50ec66bfa59bf	2
483	1009098503	e162924e7a812328e0868952e0ec7812	2
484	1006068603	57ba246210cfe28e783c2191174e5aba	2
485	17017305	1492f6541ff8a0e5d1b7fa736c36022f	2
486	1022068801	929f8d337ac3b6ee302bbb7e78cc198f	2
487	1020118203	bcb8aa4b84c3fdae1834333d534dc6e8	2
488	1017018601	833b1903fa46529729e51c43f0641ef4	2
489	1010088203	e206a0dd753908443cc434d192bec49f	2
490	1011059001	fc34233a47434828c0766644519d5f14	2
491	1017089001	5de2c22d0f009ebd238a13d94a12bd0f	2
492	1011118501	620354f945469e4fa3372e52cac96f9f	2
493	1015107101	00655f31d17252de89d493ccc134014d	2
494	1029098901	47f3c6f84f93ce864db46e1cb28e9048	2
495	1012129101	9a4e57c4df174690053557463d4bc100	2
496	1029108702	1b14305c33478f04cd5e11fd30fb5873	2
497	1020048002	4baa61ff027a474f2a0fce8739e3ab78	2
498	1002068501	03f75a635d09f008be7a6b421228526b	2
499	1010118402	d3680a39f84132bdb992148a34b99b8e	2
500	1020057501	e6bba6f2bf6a4a0e887e5b21257fc3dc	2
501	1008128701	138f54303393b0c64e7535c6e30ba27f	2
502	1027118601	51d732a2632c0b335acf5b92c5639977	2
503	1019018202	32dfbf15de0ad6fd1a4dcd2e0a6d75b7	2
504	1020028602	14f437fa35a0f8835d540e7736a91c1b	2
505	1014028503	bda187e9467d70705ad7fc0c2d77d189	2
506	1009017602	67fc1feec18a549bc39c61989fd679d7	2
507	1060785021	5d73327edc1670abeb384899d0d2ca9b	2
508	1012068203	a36f49324d0e8ab56475c5313d2722b5	2
509	1026038501	4804d571589c0d7d4e43332dc35f0bc5	2
510	1002058401	8230e0a9ff93cc8a0ad60b60bd7e8f97	2
511	1002058402	fdd9edcb33856969afc5016662ea7981	2
512	1015087203	314269df841032cf139bf69a931e4899	2
513	1009048503	694209f9e2c9609802ff7b59a798a233	2
514	1017048603	4028e0d8d04ce4258ef3d96734f6484b	2
515	1009127301	004fdfed8b2f55a5ca003a6700411ac0	2
516	1027088101	f40087de51c34b9ffa4fc571a68eca2b	2
517	1003127702	74627db9137d4a1260a5b3901205be9c	2
518	1028098602	9b5dd3afbda3a248bfd39760a6a15ece	2
519	1021068601	8f08d788b574b96f69b333d5d2f86c61	2
520	1011118901	92ba61af7c6cd7bd74b0e4b1777c6ffb	2
521	1018058602	eff2ab3ac21ba9c399ac6429e334b309	2
522	1005028102	6210cb7716ea90552be31df36fffdbde	2
523	1008088702	0e1996ccc08eb7d3879a06230788ccb6	2
524	1012087401	5503c342c802ae7260364365a49b8fc6	2
525	1016087201	e0f022e45bde7beff942211c94ce90bc	2
526	1011108502	590911d0d4a07e0879bd0181dc779dd9	2
527	1019057502	4691a5de0323c0b2852e7b0e784f338f	2
528	1010039001	2cc8585919b5918b1bfa7bb69767755c	2
529	1015128601	418aa346900a65549c36c6ef03f50638	2
530	1016118002	d476dceec3342115e0b113420d5d5ec6	2
531	1020037703	d389f8065e6da98569f8f08ca213350c	2
532	1001037101	d2f69975d53d093e75ee54f2146e3b40	2
533	1008108301	dce292745f259ded53f8c8718283814d	2
534	1013058604	b97d3caa27894de1f8e5c0b23a2bd614	2
535	1014099001	0ad3812ac5a98f0327ebd3222381651a	2
536	1002098302	280d223b218768adad57cb26b67666eb	2
537	1021118101	4a0b03396975b9714c5fcfd735292b25	2
538	1010068501	dac1e1a5f27a0f3a60894fc6a161d35f	2
539	1012059001	1652fa570c88e47b039b90c4d992f904	2
540	1021038303	1a5587f6f504a80ccce7e8d6e7fd2f1b	2
541	1028018801	f3189c0a1ffead9e20b7607dfdb360e9	2
542	1008077101	97137bf9ef6f6834d3f696d1200e892f	2
543	1010028701	bc1a477111e35e750c19fa1fdc5cdcc5	2
544	1003026702	661f55f5232625b1ed42cf6f9837a795	2
545	1029077301	09aa2b00919ba470cff6bbaf6268bcf8	2
546	1012128601	e068d3646670a9bfe3ae55d15f29ccf5	2
547	1025128101	468a95b7a4f07d37a3a8d2f7d6bf8b8d	2
548	1016058503	5c9d6c8683d7e992670f5cb4ddd75d11	2
549	1019068501	0e5f4d411fabfd9a93233e6228a292d6	2
550	1020119201	66869673bbf9f49a803918e52f9344c2	2
551	1003098302	11bd4dacdeada766d52b2d8f5ec445a0	2
552	1022069201	74a69cda5746ae5132421d8abcd37665	2
553	1021128701	ff652944756450fa36318413589d8e91	2
554	1014058901	5eeaaef57c76711fce481db2111f4048	2
555	1003058302	21886c7355f5d6003976565cf93b18ee	2
556	1021117701	d8ed3390b3c4ebe247da1ff280527180	2
557	1011076801	0534e8063838456239a19de780cc7e4f	2
558	1002058901	c1d6d025a9bf21e93e9ef50709d5defa	2
348	23232	dec6b16e0f76873a895788f9f6206aa0	2
349	1012019001	db6653d17bc6d38ec16390d7368ee1df	2
350	1009026602	41ef49094fe0cd268aec84f100dcb963	2
351	1023116001	543fa11cff502800d9cf8ef3a550e199	2
352	1025125401	1a35a5d2bafd6b907a43a78788e74003	2
353	1028128901	c4e95b4da82ad63735dc8398b34e0b8e	2
354	1013128902	8d452f6928b45c750494a3ca3f729bd1	2
355	1029128101	5c09a6f1b3ff4d516f1f1239fad46e9c	2
356	1027088001	ba759f455514b2e2b7c59a98e599f676	2
357	1021118602	4f9cd0f4ad10179bb8928a3107d79114	2
358	1024089001	e13d389c6543438eea77db7d320eebdb	2
559	1026059101	84b2b67474f771a2ccf957c9a0ad2a9c	2
560	1008106404	d593d98c67b55559adfd8d664a139b19	2
561	1005108604	5de1375657555b87287e61029cbcba38	2
562	1006068701	58dab111e9a5c9274b1495223583fe8a	2
563	1011058003	1beee3dd215e8c927e8884affc56b703	2
564	1003048501	80cb6448ffefccd281392e869dcf9f0d	2
565	1007068001	c7da92a0a249589398a9f19459e9b3ca	2
566	1019125102	de410426faf5e9dd52f10e9c0302cefd	2
567	1019128501	d9417bbce59a58cf88e7a50e716289f7	2
568	1005047601	994c61d8299fd52a3ca1dd9f9e1b9894	2
569	1015048302	843e3d6a9bd3c79adcb7a3b1f5c7c648	2
570	1003068801	5904810f7af1610d4858ce07a4f7115d	2
571	1022108302	13692cd10a3ad6cc23e04eb8feae2e30	2
572	1023046101	e698cde4413ba9ec3598bcfd5205337d	2
573	1028128501	376fe5cd6fc9e597878a9a6052eee80f	2
574	1026108202	7d0997b54968e4ad9ba86e858fea03cb	2
575	1021018402	a1b97fce986bbc5f589de1f16e0a0610	2
576	1001088204	55f03e193dce6fc8ccb11762a7395c9b	2
577	1016038602	50480bab3a1d37adaef66c8fb4924194	2
578	1015067501	f02f35088baee4ba480be42b218ba771	2
579	1024048503	bfb0deb7a4ad120758ca92c4e793dbe8	2
580	1025076401	4c42d7cb423a0d3f5904b4ea03a0c89d	2
581	1023108601	f412d00a20f3b3fdefa65bd277e12be8	2
582	1027067903	9d50402371867e470379854eec2497a6	2
583	1016068402	b060f1d283b508222857dbfce586f416	2
584	1006057201	9d3a28da4448076ce52c38951effb153	2
585	1013048502	a686b74b0bbbcd360792932d497a26ef	2
586	1021037202	483c2db3dc1d60ee40d305268aca357d	2
587	1010068304	37d32583b02757da9f22d986a8175a3e	2
588	1006017601	13c9cce123c61d3f15877b1f2bfea2fe	2
589	1010028505	5672de8cb831cdb7e909b4246f222bdb	2
590	1008058902	d3bc7f40bf74edd484521583e0caa7bd	2
591	1024048502	69729cd2ea43c3dae8e893be5cc333d7	2
592	1010088704	4809076fbdbf18a4465d0ba571a436e3	2
593	1002117401	2eebc66d5b7e5726d45c5cba283ce267	2
594	1015057301	1143576c889e73636c02253fc3fb1fef	2
595	1003078402	5aeedf80aca54d652a1ec0c3418b75fd	2
596	1005117101	924683a87280d0397b799c4c389183ad	2
597	1009096401	2a4193a0e8e5c61387ef42dbc785caa9	2
598	1017069001	2af2887fd5cb324fd6cb4d61aa25d844	2
599	1028088702	0ff9e48eb017cee8ac80bb4ba7976cb7	2
600	1020057603	a3a7e2ca29ff257a1f4330674a10395e	2
601	1018048301	d438c4a0ca9eb51c51320a984451185b	2
602	1009087402	6a164fe31725657a6b07ac126d22540f	2
603	1003088601	23ce910f56cc7587e0c45d2af4028bee	2
604	1026108501	54f0476a949560af91075773737acd01	2
605	1017127401	a2ecc113f73f57fb80f9c6e9f5e338a4	2
606	1011098501	84d2dd7dfee8479f3f159d5d01970572	2
607	1010058703	00410c010fa6fd6c91d089d92e63b441	2
608	1028018301	bf14b3905d503d7ffc33d6fc27e5cf6d	2
609	1023037504	c64bc88a7c074d024d2d980b5aa7224d	2
610	1017089002	7487fc894f5725624733cebc7ec7789a	2
611	1020099101	a41148e86744dd7fa831ea3e6b98e934	2
612	1018078601	10771bea600e26b4039bdb897bb54177	2
613	1012108401	b4374edd5400c35739931c1e77a7fec8	2
614	1003078601	e621635f6f8dd4e07f01d57d9d3eb802	2
615	1017098206	332f67e472d8ef9af97d65b7f75d96f1	2
616	1018017501	19f951d02f44329c086279a33c0a45ea	2
617	1023098901	049bd9480828633f838973e3cc0cfbd9	2
618	1031059001	4ab1e48dc7992f0586a16611dbd9589a	2
619	1026099001	63ff6104e7d5340fc488f63524e47cf4	2
620	1004038101	dd877f4d6c95a155743e17767e134cad	2
621	1016067902	75e0dfc20918450fc4645e421d1154ff	2
622	1004077904	f1721311f34ec1c8a4f4df19cd47bada	2
623	1010047701	ffacef19254a92e0189d67ee66f380d6	2
624	1007099001	a854f57635a684060191bd5764307583	2
625	1016038601	ec3c83acf8dc8bad8225e1126e59deaf	2
626	1004069101	f7e2ad5600381feba6bdcbd08eb9ef42	2
627	1011019001	c2158f2cb95abb684712fd335698f57e	2
628	1013049001	d51c9904a975f3d7091caa60ce4f05ce	2
629	1012085301	5b13456cdc4a47382a50f175385c7426	2
630	1012098102	b98c68b29feedcb66411a0a925b0686a	2
631	1026097501	1d995ed455656e05863f4c11e257ff01	2
632	1027018501	ad2bd18163b3fc9d0509c1f9870349e8	2
633	1007048304	c43b4a6b156322c63dcf6c1bb3e116d4	2
634	1003049001	0a50920aa1fc90e18abb03b3d0a4652d	2
635	1011018301	28adc4a28013adcd312cc5e50c790c27	2
636	1029058703	be0f1cfdeaf6ddea9e81aefb0c9617f2	2
637	1021098101	8b65be2c4cabb3fdbfd700a37f635d87	2
638	1010097701	9facbeb85435c8887a531dffd557106b	2
639	1011098802	9871c74ade16d76f46ad170a86495654	2
640	1028058402	f4d80f79a6591906a491a64e93727450	2
641	1011064901	a1c77ff398e51fe10e098242187fcbde	2
642	1021088601	a10c516b8e0d59769562509431695129	2
643	1021129101	683b703045431e27f7b8685aaefdf2b4	2
644	1015048703	f18c4459290adf3e1bf362a4773a1772	2
645	1026129001	d3e1f4a9eb07806118bfae2d55156cc9	2
646	1010128402	afab50cbc0011c16c6aad60718bd2594	2
647	1008028803	b10e39fd2bec74c184b0ce2c280a1dba	2
648	1014088502	c6d17ad42af11431ce744c8aebff0b23	2
649	1015028801	3c1df319090badb1c535b798b5fb17c8	2
650	1014036901	c4056fb1a2b968a9b061a651384528df	2
651	1022038901	510f522ab51bf75c0bc6201debce7d65	2
652	1009047901	eff13f2385713c472d163aa9992bf29e	2
653	1014039301	5d0591862764eabac24b1df361b83b20	2
654	1012029101	9dd7bd8ef4effd8d37fccf2e8a38ac00	2
655	1028088201	aa298a29f0505cf8e3a1b4f4380accd6	2
656	1022098403	542426bf8a4200f0bf34c01d4d63181e	2
657	1012059101	81d5a8c805dbd0ba4fde970677d3b66a	2
658	1018119001	53ebd7fe4e28af5c16c9402f1d0f9d9f	2
659	1007078901	2879d29e153538d32cddc50126fa8651	2
660	1007118403	6797c3f45282a4a790402028c6eab1f2	2
661	1031038901	f326b47c65eb3c3b8607f27ebe6856f0	2
662	1028018001	446fd677ec31cd0e927e8d3c2952f385	2
663	1021018802	8f487a4d7894157cf8eec915a8e8f385	2
664	1023119001	e3f4f702adce7934786c209a139389f4	2
665	1012128701	bab325127a8d03eda64ab1ad407959bd	2
666	1029098402	319413dc533a68c4b8e8bffa9e019e52	2
667	1031088901	090a72aa7ce6dea2c7c0503c294e838e	2
668	1007069201	3062fd59fcaa2a2419719c748aa2f0b4	2
669	1013098901	5073d620b0c94eb5905fe4ffd686b760	2
670	1012118403	fcb3247be0ac18afdde99f851b0313db	2
671	1017059201	5aa1f96e6780e421d609f451b229b404	2
672	1007087002	df07e9a198a728d52346457e67de9a85	2
673	1026099002	ce03997786da1d90816ca5e7f924bb5c	2
674	1021128801	87c30a3561640b3434b99b39889bbc14	2
675	1023018901	fa8fa93668b5eb23b1fa75d0b57457f0	2
676	0005076607	3eedfc7a0dba6a74faa594f93c952d6b	2
677	1001059001	c921c88532ded9f26f485337679a829d	2
678	1004118102	58825c75176809ea749d98165dc8fdd8	2
679	1008108202	822852718286dca99e9d648daad6890e	2
680	1007088801	67e7eb27059120296cf8f4fe6672b886	2
681	1003098202	3fe62502727d1584eecaf3f2b531db55	2
682	1004129101	07684e1fe1eac0e7b97da1e2d7c65840	2
683	1016089101	9888c0c08b49fcf704fffe42906b07f1	2
684	1017047902	7ce32f0192f125e8e52f6ce67c399d07	2
685	1028018201	509f04d7c7ba2b23d2697d8591e89cd7	2
686	1011027001	63165c8763306d451a365f7d6310e426	2
687	1024048504	b79e3db89189ddf42fb9dd1290932e53	2
688	1014028804	14e04704351e19a80f6c944af2755742	2
689	1018048401	1777ffa08840d4021e018fbb67ba9739	2
690	0006047306	9bec1cf143b3cb4293d549b43e794a2a	2
691	1018118401	272600c8c36015d82677e4723f525b32	2
692	1024127202	2eb10d9fe37a73151f6c67807d704ed2	2
\.


--
-- Name: tbuser_id_user_seq; Type: SEQUENCE SET; Schema: public; Owner: mandan
--

SELECT pg_catalog.setval('tbuser_id_user_seq', 692, true);


--
-- Name: tipe_soal_id_tsoal_seq; Type: SEQUENCE SET; Schema: public; Owner: mandan
--

SELECT pg_catalog.setval('tipe_soal_id_tsoal_seq', 3, true);


--
-- Name: mahasiswa_pkey; Type: CONSTRAINT; Schema: public; Owner: mandan
--

ALTER TABLE ONLY tbsoal
    ADD CONSTRAINT mahasiswa_pkey PRIMARY KEY (id_soal);


--
-- Name: matkul_pkey; Type: CONSTRAINT; Schema: public; Owner: mandan
--

ALTER TABLE ONLY tbmatkul
    ADD CONSTRAINT matkul_pkey PRIMARY KEY (id_matkul);


--
-- Name: tbdosen_nidn_key; Type: CONSTRAINT; Schema: public; Owner: mandan
--

ALTER TABLE ONLY tbdosen
    ADD CONSTRAINT tbdosen_nidn_key UNIQUE (nidn);


--
-- Name: tbdosen_pkey; Type: CONSTRAINT; Schema: public; Owner: mandan
--

ALTER TABLE ONLY tbdosen
    ADD CONSTRAINT tbdosen_pkey PRIMARY KEY (id_dosen);


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
-- Name: tbjenis_ujian_pkey; Type: CONSTRAINT; Schema: public; Owner: mandan
--

ALTER TABLE ONLY tbjenis_ujian
    ADD CONSTRAINT tbjenis_ujian_pkey PRIMARY KEY (id_jujian);


--
-- Name: tbkelas_pkey; Type: CONSTRAINT; Schema: public; Owner: mandan
--

ALTER TABLE ONLY tbkelas
    ADD CONSTRAINT tbkelas_pkey PRIMARY KEY (id_kelas);


--
-- Name: tbkuliah_id_kuliah; Type: CONSTRAINT; Schema: public; Owner: mandan
--

ALTER TABLE ONLY tbkuliah
    ADD CONSTRAINT tbkuliah_id_kuliah PRIMARY KEY (id_kuliah);


--
-- Name: tbkuliah_mhs_id_kmhs; Type: CONSTRAINT; Schema: public; Owner: mandan
--

ALTER TABLE ONLY tbkuliah_mhs
    ADD CONSTRAINT tbkuliah_mhs_id_kmhs PRIMARY KEY (id_kmhs);


--
-- Name: tbmahasiswa_nobp; Type: CONSTRAINT; Schema: public; Owner: mandan
--

ALTER TABLE ONLY tbmahasiswa
    ADD CONSTRAINT tbmahasiswa_nobp UNIQUE (nobp);


--
-- Name: tbmahasiswa_pkey; Type: CONSTRAINT; Schema: public; Owner: mandan
--

ALTER TABLE ONLY tbmahasiswa
    ADD CONSTRAINT tbmahasiswa_pkey PRIMARY KEY (id_mahasiswa);


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
-- Name: tipe_soal_pkey; Type: CONSTRAINT; Schema: public; Owner: mandan
--

ALTER TABLE ONLY tbtipe_soal
    ADD CONSTRAINT tipe_soal_pkey PRIMARY KEY (id_tsoal);


--
-- Name: tbhasil_ujian_id_peserta; Type: INDEX; Schema: public; Owner: mandan
--

CREATE INDEX tbhasil_ujian_id_peserta ON tbhasil_ujian USING btree (id_peserta);


--
-- Name: tbhasil_ujian_id_ujian; Type: INDEX; Schema: public; Owner: mandan
--

CREATE INDEX tbhasil_ujian_id_ujian ON tbhasil_ujian USING btree (id_ujian);


--
-- Name: tbjawaban_id_peserta; Type: INDEX; Schema: public; Owner: mandan
--

CREATE INDEX tbjawaban_id_peserta ON tbjawaban USING btree (id_peserta);


--
-- Name: tbjawaban_id_soal; Type: INDEX; Schema: public; Owner: mandan
--

CREATE INDEX tbjawaban_id_soal ON tbjawaban USING btree (id_soal);


--
-- Name: tbjawaban_id_ujian; Type: INDEX; Schema: public; Owner: mandan
--

CREATE INDEX tbjawaban_id_ujian ON tbjawaban USING btree (id_ujian);


--
-- Name: tbkuliah_id_dosen; Type: INDEX; Schema: public; Owner: mandan
--

CREATE INDEX tbkuliah_id_dosen ON tbkuliah USING btree (id_dosen);


--
-- Name: tbkuliah_id_kelas; Type: INDEX; Schema: public; Owner: mandan
--

CREATE INDEX tbkuliah_id_kelas ON tbkuliah USING btree (id_kelas);


--
-- Name: tbkuliah_id_matkul; Type: INDEX; Schema: public; Owner: mandan
--

CREATE INDEX tbkuliah_id_matkul ON tbkuliah USING btree (id_matkul);


--
-- Name: tbkuliah_mhs_id_mahasiswa; Type: INDEX; Schema: public; Owner: mandan
--

CREATE INDEX tbkuliah_mhs_id_mahasiswa ON tbkuliah_mhs USING btree (id_mahasiswa);


--
-- Name: tbmahasiswa_id_kelas; Type: INDEX; Schema: public; Owner: mandan
--

CREATE INDEX tbmahasiswa_id_kelas ON tbmahasiswa USING btree (id_kelas);


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
-- Name: tbujian_id_tipe; Type: INDEX; Schema: public; Owner: mandan
--

CREATE INDEX tbujian_id_tipe ON tbujian USING btree (id_tsoal);


--
-- Name: tbhasil_ujian_id_ujian_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mandan
--

ALTER TABLE ONLY tbhasil_ujian
    ADD CONSTRAINT tbhasil_ujian_id_ujian_fkey FOREIGN KEY (id_ujian) REFERENCES tbujian(id_ujian) ON UPDATE CASCADE;


--
-- Name: tbjawaban_id_peserta_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mandan
--

ALTER TABLE ONLY tbjawaban
    ADD CONSTRAINT tbjawaban_id_peserta_fkey FOREIGN KEY (id_peserta) REFERENCES tbmahasiswa(id_mahasiswa) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: tbjawaban_id_soal_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mandan
--

ALTER TABLE ONLY tbjawaban
    ADD CONSTRAINT tbjawaban_id_soal_fkey FOREIGN KEY (id_soal) REFERENCES tbsoal(id_soal) ON UPDATE CASCADE;


--
-- Name: tbjawaban_id_ujian_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mandan
--

ALTER TABLE ONLY tbjawaban
    ADD CONSTRAINT tbjawaban_id_ujian_fkey FOREIGN KEY (id_ujian) REFERENCES tbujian(id_ujian) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: tbkuliah_id_dosen_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mandan
--

ALTER TABLE ONLY tbkuliah
    ADD CONSTRAINT tbkuliah_id_dosen_fkey FOREIGN KEY (id_dosen) REFERENCES tbdosen(id_dosen) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: tbkuliah_id_kelas_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mandan
--

ALTER TABLE ONLY tbkuliah
    ADD CONSTRAINT tbkuliah_id_kelas_fkey FOREIGN KEY (id_kelas) REFERENCES tbkelas(id_kelas) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: tbkuliah_id_matkul_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mandan
--

ALTER TABLE ONLY tbkuliah
    ADD CONSTRAINT tbkuliah_id_matkul_fkey FOREIGN KEY (id_matkul) REFERENCES tbmatkul(id_matkul) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: tbkuliah_mhs_id_kuliah_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mandan
--

ALTER TABLE ONLY tbkuliah_mhs
    ADD CONSTRAINT tbkuliah_mhs_id_kuliah_fkey FOREIGN KEY (id_kuliah) REFERENCES tbkuliah(id_kuliah) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: tbkuliah_mhs_id_mahasiswa_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mandan
--

ALTER TABLE ONLY tbkuliah_mhs
    ADD CONSTRAINT tbkuliah_mhs_id_mahasiswa_fkey FOREIGN KEY (id_mahasiswa) REFERENCES tbmahasiswa(id_mahasiswa) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: tbmahasiswa_id_kelas_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mandan
--

ALTER TABLE ONLY tbmahasiswa
    ADD CONSTRAINT tbmahasiswa_id_kelas_fkey FOREIGN KEY (id_kelas) REFERENCES tbkelas(id_kelas) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: tbsoal_id_tsoal_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mandan
--

ALTER TABLE ONLY tbsoal
    ADD CONSTRAINT tbsoal_id_tsoal_fkey FOREIGN KEY (id_tsoal) REFERENCES tbtipe_soal(id_tsoal) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: tbujian_id_jenis_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mandan
--

ALTER TABLE ONLY tbujian
    ADD CONSTRAINT tbujian_id_jenis_fkey FOREIGN KEY (id_jujian) REFERENCES tbjenis_ujian(id_jujian) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: tbujian_id_kuliah_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mandan
--

ALTER TABLE ONLY tbujian
    ADD CONSTRAINT tbujian_id_kuliah_fkey FOREIGN KEY (id_kuliah) REFERENCES tbkuliah(id_kuliah) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: tbujian_id_tipe_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mandan
--

ALTER TABLE ONLY tbujian
    ADD CONSTRAINT tbujian_id_tipe_fkey FOREIGN KEY (id_tsoal) REFERENCES tbtipe_soal(id_tsoal) ON UPDATE CASCADE ON DELETE CASCADE;


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

