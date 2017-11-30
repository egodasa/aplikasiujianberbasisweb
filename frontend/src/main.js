// The following line loads the standalone build of Vue instead of the runtime-only build,
// so you don't have to do: import Vue from 'vue/dist/vue'
// This is done with the browser options. For the config, see package.json
import Vue from 'vue'
import VueSession from 'vue-session'
import VueRouter from 'vue-router'
import App from './App.vue'
import routes from './routes.js'
import VeeValidate, { Validator } from 'vee-validate';
import bahasa from '../node_modules/vee-validate/dist/locale/id.js'
import vSelect from 'vue-select'
import wysiwyg from "vue-wysiwyg";
Vue.use(wysiwyg, {});
import Notifications from 'vue-notification'

Vue.use(Notifications)
Vue.component('v-select', vSelect)
VeeValidate.Validator.addLocale(bahasa)
Vue.use(VueRouter);
Vue.use(VueSession);
Vue.use(VeeValidate, {locale: 'id',delay:"1000"});
// We create the router instance here.
const router = new VueRouter({
  routes: routes
});
new Vue({ // eslint-disable-line no-new
  el: '#app',
  router,
  render: (h) => h(App)
})
