import kelolaUjian from './components/kelolaUjian.vue';
import kelolaSoal from './components/kelolaSoal.vue';
import kelolaPeserta from './components/kelolaPeserta.vue';
import kelolaPesertaUjian from './components/kelolaPesertaUjian.vue';
import kelolaSoalUjian from './components/kelolaSoalUjian.vue';
import kelolaKelas from './components/kelolaKelas.vue';
import home from './components/Home.vue';
import loginPeserta from './components/loginPeserta.vue';
import petunjukUjian from './components/petunjukUjian.vue';
import pelaksanaanUjian from './components/pelaksanaanUjian.vue';
import hasilUjian from './components/hasilUjian.vue';

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
    path: '/admin/peserta',
    name : 'kelolaPeserta',
    component: kelolaPeserta
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
