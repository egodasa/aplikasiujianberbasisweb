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

import dosenKelolaUjian from './components/page/dosen/dosenKelolaUjian.vue';
import dosenKelolaKuliah from './components/page/dosen/dosenKelolaKuliah.vue';
import dosenKelolaKuliahMahasiswa from './components/page/dosen/dosenKelolaKuliahMahasiswa.vue';
import dosenHasilUjian from './components/page/dosen/dosenHasilUjian.vue';
import dosenKelolaSoalUjian from './components/page/dosen/dosenKelolaSoalUjian.vue';
import dosenCekJawaban from './components/page/dosen/dosenCekJawaban.vue';
import dosenJawabanUjian from './components/page/dosen/dosenJawabanUjian.vue';

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
    path: '/admin/matkul/:kdMatkul/dosen',
    name: 'kelolaMatkulDosen',
    component: kelolaMatkulDosen
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
    path: '/admin/dosen/:nidn/matkul',
    name: 'kelolaDosenMatkul',
    component: kelolaDosenMatkul
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
    name: 'dosenKelolaUjian',
    component: dosenKelolaUjian
  },
  {
    path: '/dosen/kuliah',
    name: 'dosenKelolaKuliah',
    component: dosenKelolaKuliah
  },
  {
    path: '/dosen/kuliah/:idKuliah',
    name: 'dosenKelolaKuliahMahasiswa',
    component: dosenKelolaKuliahMahasiswa
  },
  {
    path: '/dosen/ujian/:idUjian/hasil',
    name : 'dosenHasilUjian',
    component: dosenHasilUjian
  },
  {
    path: '/dosen/ujian/:idUjian/soal',
    name : 'dosenKelolaSoalUjian',
    component: dosenKelolaSoalUjian
  },
  {
    path: '/dosen/ujian/:idUjian/jawaban/:idPeserta',
    name : 'dosenCekJawaban',
    component: dosenCekJawaban
  },
  {
    path: '/dosen/ujian/:idUjian/jawaban',
    name : 'dosenJawabanUjian',
    component: dosenJawabanUjian
  }
];
