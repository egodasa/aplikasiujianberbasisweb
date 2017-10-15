import kelolaUjian from './components/kelolaUjian.vue';
import kelolaSoal from './components/kelolaSoal.vue';
import kelolaPeserta from './components/kelolaPeserta.vue';
import kelolaPesertaUjian from './components/kelolaPesertaUjian.vue';
import kelolaSoalUjian from './components/kelolaSoalUjian.vue';
import home from './components/Home.vue';

export default [
  // Redirects to /route-one as the default route.
  {
    path: '/',
    component : home
  },
  {
    path: '/ujian',
    component: kelolaUjian
  },
  {
    path: '/ujian/:idUjian/peserta',
    name : 'kelolaPesertaUjian',
    component: kelolaPesertaUjian
  },
  {
    path: '/ujian/:idUjian/soal',
    name : 'kelolaSoalUjian',
    component: kelolaSoalUjian
  },
  {
    path: '/peserta',
    component: kelolaPeserta
  },
  {
    path: '/soal',
    component: kelolaSoal
  }
];
