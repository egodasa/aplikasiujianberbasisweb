<template>
<div>
<sec-header></sec-header>
    <sec-sidebar :listMenu="menu"></sec-sidebar>
    <sec-content>
            <router-view></router-view>
    <sec-footer>
        <p class="w3-left">Universitas Putra Indonesia YPTK Padang <br/>Powered by <a href="https://www.w3schools.com/w3css/default.asp" target="_blank">w3.css</a></p>
        <p></p>
    </sec-footer>
    </sec-content>
</div>
</template>

<script>
import admin from './components/page/halamanAdmin.vue'
import secHeader from './components/header.vue'
import secFooter from './components/footer.vue'
import secContent from './components/content.vue'
import secSidebar from './components/sidebar.vue'
import { userConf } from './components/mixins/mixins.js'
import { Bus } from './bus.js';
export default {
  name: 'app',
  components : {
      admin, secHeader, secFooter, secContent, secSidebar
  },
  mixins : [userConf],
  data () {
      return {
         menu : []
      }
  },
  created () {
      Bus.$on('setMenu',x=>{
          this.setMenu(x)
          })
      if(this.$session.has('user')){
        var ses = this.$session.get('user')
        if(ses.id_tipe == 1) this.menu = this.adminMenu
        else this.menu = this.dosenMenu
      }
      else this.menu = this.userMenu
  },
  methods : {
      setMenu (x) {
          if(x == 1) this.menu = this.adminMenu
          else if(x == 2) this.menu = this.dosenMenu
          else this.menu = this.userMenu
      }
  } 
}
</script>

</style>
