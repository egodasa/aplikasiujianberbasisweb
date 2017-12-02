import kelolaUjianDetail from './components/page/admin/kelolaUjianDetail.vue';
import kelolaUjian from './components/page/admin/kelolaUjian.vue';

import kelolaSoal from './components/page/admin/kelolaSoal.vue';
import kelolaMahasiswa from './components/page/admin/kelolaMahasiswa.vue';
import kelolaPesertaUjian from './components/page/admin/kelolaPesertaUjian.vue';
import kelolaSoalUjian from './components/page/admin/kelolaSoalUjian.vue';
import kelolaKelas from './components/page/admin/kelolaKelas.vue';
import kelolaMatkul from './components/page/admin/kelolaMatkul.vue';
import kelolaMatkulDosen from './components/page/admin/kelolaMatkulDosen.vue';
import kelolaTipeSoal from './components/page/admin/kelolaTipeSoal.vue';
import kelolaJenisUjian from './components/page/admin/kelolaJenisUjian.vue';
import kelolaDosen from './components/page/admin/kelolaDosen.vue';
import kelolaDosenMatkul from './components/page/admin/kelolaDosenMatkul.vue';
import kelolaKuliah from './components/page/admin/kelolaKuliah.vue';
import kelolaKuliahMahasiswa from './components/page/admin/kelolaKuliahMahasiswa.vue';
import hasilUjian from './components/page/admin/hasilUjian.vue';
import jawabanUjian from './components/page/admin/jawabanUjian.vue';
import cekJawaban from './components/page/admin/cekJawaban.vue';
import loginPengguna from './components/page/loginPengguna.vue';
import dashboardAdmin from './components/page/admin/dashboardAdmin.vue';
import dashboardDosen from './components/page/dosen/dashboardDosen.vue';

import DkelolaUjian from './components/page/dosen/kelolaUjian.vue';
import DkelolaUjianDetail from './components/page/dosen/kelolaUjianDetail.vue';

import home from './components/Home.vue';
import loginPeserta from './components/page/peserta/loginPeserta.vue';
import petunjukUjian from './components/page/peserta/petunjukUjian.vue';
import pelaksanaanUjian from './components/page/peserta/pelaksanaanUjian.vue';

export default [
  // Redirects to /route-one as the default route.
  {
    path: '/',
    component : loginPengguna
  },
  {
    path: '/admin',
    component : dashboardAdmin
  },
  {
    path: '/dosen',
    component : dashboardDosen
  },
  {
    path: '/login',
    component : loginPengguna
  },
  {
    path: '/admin/ujian',
    component: kelolaUjian
  },
  {
    path: '/admin/ujian/:idUjian/mahasiswa',
    name : 'kelolaPesertaUjian',
    component: kelolaPesertaUjian
  },
  {
    path: '/admin/ujian/:idUjian',
    name : 'kelolaUjianDetail',
    component: kelolaUjianDetail
  },
  {
    path: '/admin/ujian/:idUjian/soal',
    name : 'kelolaSoalUjian',
    component: kelolaSoalUjian
  },
  {
    path: '/admin/ujian/:idUjian/hasil',
    name : 'hasilUjian',
    component: hasilUjian
  },
  {
    path: '/admin/ujian/:idUjian/jawaban/:idPeserta',
    name : 'cekJawaban',
    component: cekJawaban
  },
  {
    path: '/admin/ujian/:idUjian/jawaban',
    name : 'jawabanUjian',
    component: jawabanUjian
  },
  {
    path: '/admin/mahasiswa',
    name : 'kelolaMahasiswa',
    component: kelolaMahasiswa
  },
  {
    path: '/admin/soal',
    name: 'kelolaSoal',
    component: kelolaSoal
  },
  {
    path: '/admin/kelas',
    name: 'kelolaKelas',
    component: kelolaKelas
  },
  {
    path: '/admin/matkul',
    name: 'kelolaMatkul',
    component: kelolaMatkul
  },
  {
    path: '/admin/jenis-ujian',
    name: 'kelolaJenisUjian',
    component: kelolaJenisUjian
  },
  {
    path: '/admin/tipe-soal',
    name: 'kelolaTipeSoal',
    component: kelolaTipeSoal
  },
  {
    path: '/admin/dosen',
    name: 'kelolaDosen',
    component: kelolaDosen
  },
  {
    path: '/ujian/login',
    name: 'loginPeserta',
    component: loginPeserta
  },
  {
    path: '/ujian/petunjuk',
    name: 'petunjukUjian',
    component: petunjukUjian
  },
  {
    path: '/ujian/soal',
    name: 'pelaksanaanUjian',
    component: pelaksanaanUjian
  },
  {
    path: '/dosen/ujian',
    name : 'DkelolaUjian',
    component: DkelolaUjian
  },
  {
    path: '/dosen/ujian/:idUjian',
    name : 'DkelolaUjianDetail',
    component: DkelolaUjianDetail
  }
];
