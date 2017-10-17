// The following line loads the standalone build of Vue instead of the runtime-only build,
// so you don't have to do: import Vue from 'vue/dist/vue'
// This is done with the browser options. For the config, see package.json
import Vue from 'vue'
import VueSession from 'vue-session'
import VueRouter from 'vue-router'
import App from './App.vue'
import routes from './routes.js';

Vue.use(VueRouter);
Vue.use(VueSession)
// We create the router instance here.
const router = new VueRouter({
  routes: routes
});
new Vue({ // eslint-disable-line no-new
  el: '#app',
  router,
  render: (h) => h(App)
})
