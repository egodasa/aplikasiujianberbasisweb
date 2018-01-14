import pesan from '../template/pesan.vue';

const pesan_plugin = {
  install(Vue, options) {
    Vue.component(pesan.name, pesan)
  }
};

export default pesan_plugin;
