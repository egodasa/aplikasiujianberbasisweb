import Vue from 'vue'
import VueSession from 'vue-session'
import VueRouter from 'vue-router'
import App from './App.vue'
import router from './router'

import vSelect from 'vue-select'
import wysiwyg from "vue-wysiwyg";
import Notifications from 'vue-notification'
import store from 'store'
import axios from 'axios'
import lodash from 'lodash'
import { Bus } from './bus.js'
import vuecookies from 'vue-cookies'
import VueQuillEditor from 'vue-quill-editor'
import fp2 from 'fingerprintjs2'
import jwt_decode from 'jwt-decode'

Vue.use(VueQuillEditor)
Vue.use(wysiwyg, {
    hideModules: { "bold":false,
"headings":true,
"hyperlink":true,
"image":true,
"italic":false,
"list_ordered":false,
"list_unordered":false,
"removeFormat":false,
"table":false
}
})
Vue.use(Notifications)
Vue.component('v-select', vSelect)
Vue.use(VueRouter);
Vue.use(VueSession);
const cks = {
    setCookies (x,y,z = null){
        z == null ? vuecookies.set(x,y) : vuecookies.set(x,y,z)
    },
    getCookies (x){
        return jwt_decode(vuecookies.get(x)).data
    },
    clearCookies (x){
        vuecookies.remove(x)
    },
    isCookies (x){
        return vuecookies.isKey(x)
    }
}
const localStorage = {
    setLcs (x,y){
        store.set(x,y)
    },
    getLcs (x){
        return store.get(x)
    },
    clearLcs (){
        store.clearAll()
    },
    removeLcs (x){
        store.remove(x)
    }
}
//Vue.prototype.$pdfMake = pdfMake
Vue.prototype.$cekLogin = null
Vue.prototype.$lcs = localStorage
Vue.prototype.$cks = cks
Vue.prototype.$fp2 = new fp2({
        excludeUserAgent : true,
        excludeLanguage : true,
        excludeColorDepth : true,
        excludeScreenResolution : true,
        excludeAvailableScreenResolution : true,
        excludeSessionStorage  : true,
        excludePlatform : true
        })
axios.defaults.baseURL = 'http://127.0.0.1:49300'
axios.interceptors.request.use((config)=>{
    if(vuecookies.isKey('infoLogin')){
        config.headers.common['Authorization'] = 'Bearer '+ vuecookies.get('infoLogin')
    }
    return config;
  }, (error)=>{
    // Do something with request error
    return Promise.reject(error);
  });
window.bus = Bus
window._ = lodash
Vue.prototype.$ajx = axios

Vue.config.productionTip = false

new Vue({
  router,
  render: h => h(App)
}).$mount('#app')
