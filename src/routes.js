import kelolaUjian from './components/kelolaUjian.vue';
import kelolaPeserta from './components/kelolaPeserta.vue';
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
    path: '/peserta',
    component: kelolaPeserta
  }
];
