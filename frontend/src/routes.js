//Halaman Admin
import dashboardAdmin from './components/page/admin/dashboardAdmin.vue';
import halamanAdmin from './components/page/admin/halamanAdmin.vue';
import kelolaUser from './components/page/admin/kelolaUser.vue';
import kelolaMahasiswa from './components/page/admin/kelolaMahasiswa.vue';
import kelolaKelas from './components/page/admin/kelolaKelas.vue';
import kelolaMatkul from './components/page/admin/kelolaMatkul.vue';
import kelolaTipeSoal from './components/page/admin/kelolaTipeSoal.vue';
import kelolaJenisUjian from './components/page/admin/kelolaJenisUjian.vue';
import kelolaDosen from './components/page/admin/kelolaDosen.vue';

//Halaman Dosen
import halamanDosen from './components/page/dosen/halamanDosen.vue';
import dashboardDosen from './components/page/dosen/dashboardDosen.vue';
import kelolaUjian from './components/page/dosen/kelolaUjian.vue';
import kelolaUjianDetail from './components/page/dosen/kelolaUjianDetail.vue';
import cekJawaban from './components/page/dosen/cekJawaban.vue';
import kelolaKuliah from './components/page/dosen/kelolaKuliah.vue';
import kelolaPesertaKuliah from './components/page/dosen/kelolaPesertaKuliah.vue';

//Halaman mahasiswa
import loginPeserta from './components/page/peserta/loginPeserta.vue';
import petunjukUjian from './components/page/peserta/petunjukUjian.vue';
import pelaksanaanUjian from './components/page/peserta/pelaksanaanUjian.vue';

//Halaman Publik
import loginPengguna from './components/page/loginPengguna.vue';

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
            path: 'mahasiswa',
            name : 'kelolaMahasiswa',
            component: kelolaMahasiswa
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
        name : 'beranda',
        component: dashboardDosen
      },
      {
        path: 'ujian',
        name : 'kelolaUjian',
        component: kelolaUjian
      },
      {
        path: 'ujian/:idUjian/detail',
        name : 'kelolaUjianDetail',
        component: kelolaUjianDetail
      },
      {
        path: 'kuliah',
        name : "kelolaKuliah",
        component: kelolaKuliah
      },
      {
        path: 'kuliah/:idKuliah/peserta',
        name : 'kelolaPesertaKuliah',
        component: kelolaPesertaKuliah
      },
      {
        path: 'ujian/:idUjian/jawaban/:idPeserta',
        name : 'cekJawaban',
        component: cekJawaban
      }
    ]
  }
];
