import kelolaUjian from './components/page/kelolaUjian.vue';
import kelolaSoal from './components/page/kelolaSoal.vue';
import kelolaMahasiswa from './components/page/kelolaMahasiswa.vue';
import kelolaPesertaUjian from './components/page/kelolaPesertaUjian.vue';
import kelolaSoalUjian from './components/page/kelolaSoalUjian.vue';
import kelolaKelas from './components/page/kelolaKelas.vue';
import kelolaMatkul from './components/page/kelolaMatkul.vue';
import kelolaTipeSoal from './components/page/kelolaTipeSoal.vue';
import kelolaJenisUjian from './components/page/kelolaJenisUjian.vue';
import kelolaDosen from './components/page/kelolaDosen.vue';
import kelolaKuliah from './components/page/kelolaKuliah.vue';
import kelolaKuliahMahasiswa from './components/page/kelolaKuliahMahasiswa.vue';
import hasilUjian from './components/page/hasilUjian.vue';
import jawabanUjian from './components/page/jawabanUjian.vue';


import home from './components/Home.vue';
import loginPeserta from './components/loginPeserta.vue';
import petunjukUjian from './components/petunjukUjian.vue';
import pelaksanaanUjian from './components/pelaksanaanUjian.vue';

export default [
  // Redirects to /route-one as the default route.
  {
    path: '/',
    component : home
  },
  {
    path: '/admin/ujian',
    component: kelolaUjian
  },
  {
    path: '/admin/ujian/:idUjian/peserta',
    name : 'kelolaPesertaUjian',
    component: kelolaPesertaUjian
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
    path: '/admin/kuliah',
    name: 'kelolaKuliah',
    component: kelolaKuliah
  },
  {
    path: '/admin/kuliah/:idKuliah',
    name: 'kelolaKuliahMahasiswa',
    component: kelolaKuliahMahasiswa
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
  }
];
