import kelolaUjianDetail from './components/page/admin/kelolaUjianDetail.vue';
import kelolaUjian from './components/page/admin/kelolaUjian.vue';
import kelolaUser from './components/page/admin/kelolaUser.vue';

import kelolaSoal from './components/page/admin/kelolaSoal.vue';
import kelolaMahasiswa from './components/page/admin/kelolaMahasiswa.vue';
import kelolaPesertaUjian from './components/page/admin/kelolaPesertaUjian.vue';
import kelolaSoalUjian from './components/page/admin/kelolaSoalUjian.vue';
import kelolaKelas from './components/page/admin/kelolaKelas.vue';
import kelolaMatkul from './components/page/admin/kelolaMatkul.vue';
import kelolaTipeSoal from './components/page/admin/kelolaTipeSoal.vue';
import kelolaJenisUjian from './components/page/admin/kelolaJenisUjian.vue';
import kelolaDosen from './components/page/admin/kelolaDosen.vue';

import kelolaKuliah from './components/page/admin/kelolaKuliah.vue';
import kelolaKuliahDetail from './components/page/admin/kelolaKuliahDetail.vue';

import DkelolaKuliah from './components/page/dosen/kelolaKuliah.vue';
import DkelolaKuliahDetail from './components/page/dosen/kelolaKuliahDetail.vue';

import hasilUjian from './components/page/admin/hasilUjian.vue';
import cekJawaban from './components/page/admin/cekJawaban.vue';
import DcekJawaban from './components/page/dosen/cekJawaban.vue';
import loginPengguna from './components/page/loginPengguna.vue';
import dashboardAdmin from './components/page/admin/dashboardAdmin.vue';
import dashboardDosen from './components/page/dosen/dashboardDosen.vue';
import halamanDosen from './components/page/dosen/halamanDosen.vue';
import halamanAdmin from './components/page/admin/halamanAdmin.vue';

import DkelolaUjian from './components/page/dosen/kelolaUjian.vue';
import DkelolaUjianDetail from './components/page/dosen/kelolaUjianDetail.vue';

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
    component : halamanAdmin,
    children : [
          {
            path: '',
            component: dashboardAdmin
          },
          {
            path: 'kuliah',
            component: kelolaKuliah
          },
          {
            path: 'kuliah/:idKuliah',
            name : 'kelolaKuliahDetail',
            component: kelolaKuliahDetail
          },
          {
            path: 'ujian',
            component: kelolaUjian
          },
          {
            path: 'ujian/:idUjian/mahasiswa',
            name : 'kelolaPesertaUjian',
            component: kelolaPesertaUjian
          },
          {
            path: 'ujian/:idUjian',
            name : 'kelolaUjianDetail',
            component: kelolaUjianDetail
          },
          {
            path: 'ujian/:idUjian/soal',
            name : 'kelolaSoalUjian',
            component: kelolaSoalUjian
          },
          {
            path: 'ujian/:idUjian/hasil',
            name : 'hasilUjian',
            component: hasilUjian
          },
          {
            path: 'ujian/:idUjian/jawaban/:idPeserta',
            name : 'cekJawaban',
            component: cekJawaban
          },
          {
            path: 'mahasiswa',
            name : 'kelolaMahasiswa',
            component: kelolaMahasiswa
          },
          {
            path: 'soal',
            name: 'kelolaSoal',
            component: kelolaSoal
          },
          {
            path: 'kelas',
            name: 'kelolaKelas',
            component: kelolaKelas
          },
          {
            path: 'matkul',
            name: 'kelolaMatkul',
            component: kelolaMatkul
          },
          {
            path: 'jenis-ujian',
            name: 'kelolaJenisUjian',
            component: kelolaJenisUjian
          },
          {
            path: 'tipe-soal',
            name: 'kelolaTipeSoal',
            component: kelolaTipeSoal
          },
          {
            path: 'dosen',
            name: 'kelolaDosen',
            component: kelolaDosen
          },
          {
            path: 'user',
            name: 'kelolaUser',
            component: kelolaUser
          }
    ]
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
    path: '/dosen/:nidn',
    component : halamanDosen,
    children : [
      {
        path: '',
        name : 'Dberanda',
        component: dashboardDosen
      },
      {
        path: 'ujian',
        name : 'DkelolaUjian',
        component: DkelolaUjian
      },
      {
        path: 'ujian/:idUjian',
        name : 'DkelolaUjianDetail',
        component: DkelolaUjianDetail
      },
      {
        path: 'kuliah',
        name : "DkelolaKuliah",
        component: DkelolaKuliah
      },
      {
        path: 'kuliah/:idKuliah',
        name : 'DkelolaKuliahDetail',
        component: DkelolaKuliahDetail
      },
      {
        path: 'ujian/:idUjian/jawaban/:idPeserta',
        name : 'DcekJawaban',
        component: DcekJawaban
      },
    ]
  }
];
