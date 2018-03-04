import Vue from 'vue'
import Router from 'vue-router'
import Home from './views/Home.vue'
import About from './views/About.vue'

//Halaman Admin
import dashboardAdmin from './views/admin/dashboardAdmin.vue';
import halamanAdmin from './views/admin/halamanAdmin.vue';
import kelolaUser from './views/admin/kelolaUser.vue';
import kelolaMahasiswa from './views/admin/kelolaMahasiswa.vue';
import kelolaKelas from './views/admin/kelolaKelas.vue';
import kelolaMatkul from './views/admin/kelolaMatkul.vue';
import kelolaTipeSoal from './views/admin/kelolaTipeSoal.vue';
import kelolaJenisUjian from './views/admin/kelolaJenisUjian.vue';
import kelolaDosen from './views/admin/kelolaDosen.vue';

//Halaman Dosen
import halamanDosen from './views/dosen/halamanDosen.vue';
import dashboardDosen from './views/dosen/dashboardDosen.vue';
import kelolaUjian from './views/dosen/kelolaUjian.vue';
import kelolaUjianDetail from './views/dosen/kelolaUjianDetail.vue';
import cekJawaban from './views/dosen/cekJawaban.vue';
import kelolaKuliah from './views/dosen/kelolaKuliah.vue';
import kelolaPesertaKuliah from './views/dosen/kelolaPesertaKuliah.vue';

//Halaman mahasiswa
import loginPeserta from './views/peserta/loginPeserta.vue';
import petunjukUjian from './views/peserta/petunjukUjian.vue';
import pelaksanaanUjian from './views/peserta/pelaksanaanUjian.vue';

//Halaman Publik
import loginPengguna from './views/loginPengguna.vue';


Vue.use(Router)

export default new Router({
  routes: [
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
  ]
})
