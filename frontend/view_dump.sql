create view lap_matkul_dosen as SELECT tbmatkul_dosen.id_mdosen,
    tbmatkul_dosen.kd_matkul,
    tbmatkul.nm_matkul,
    tbmatkul_dosen.nidn,
    tbdosen.nm_dosen
   FROM ((tbmatkul_dosen
     JOIN tbdosen ON (((tbmatkul_dosen.nidn)::text = (tbdosen.nidn)::text)))
     JOIN tbmatkul ON (((tbmatkul_dosen.kd_matkul)::text = (tbmatkul.kd_matkul)::text)));
     
create view lap_kuliah as SELECT a.id_kuliah,
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
     
create view lap_user as SELECT tbuser.id_user,
    tbuser.username,
    tbuser.password,
    tbuser.id_juser,
    tbjenis_user.nm_juser
   FROM (tbuser
     JOIN tbjenis_user ON ((tbuser.id_juser = tbjenis_user.id_juser)));

create view lap_ujian as SELECT a.id_ujian,
    a.hari,
    a.id_jujian,
    a.id_jsoal,
    a.mulai,
    a.selesai,
    b.id_kuliah,
    b.id_mdosen,
    b.kd_matkul,
    b.nm_matkul,
    b.nidn,
    b.nm_dosen,
    b.durasi,
    b.id_kelas,
    b.nm_kelas,
    b.tahun_akademik
   FROM (tbujian a
     JOIN lap_kuliah b ON ((a.id_kuliah = b.id_kuliah)));

create view lap_kuliah_mahasiswa as SELECT a.id_kuliah,
    a.nobp,
    c.nm_mahasiswa,
    a.status,
    b.nm_matkul,
    b.kd_matkul
   FROM ((tbkuliah_mahasiswa a
     JOIN lap_kuliah b ON ((a.id_kuliah = b.id_kuliah)))
     JOIN tbmahasiswa c ON (((a.nobp)::text = (c.nobp)::text)));
     
create view lap_peserta_ujian as SELECT a.id_ujian,
    a.id_kuliah,
    b.nobp,
    b.status
   FROM (tbujian a
     JOIN lap_kuliah_mahasiswa b ON ((a.id_kuliah = b.id_kuliah)));
