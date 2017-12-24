<template>
<div>
<sec-header></sec-header>
    <sec-sidebar :listMenu="menu">
    </sec-sidebar>
    <sec-content>
            <slot>
            <router-view></router-view>
            </slot>
    </sec-content>
</div>
</template>

<script>
import secHeader from '../../template/header.vue'
import secFooter from '../../template/footer.vue'
import secContent from '../../template/content.vue'
import secSidebar from '../../template/sidebar.vue'
import { adminConf } from './admin.js'


export default {
  name: 'halamanAdmin',
  components : {
      secHeader, secFooter, secContent, secSidebar
  },
  beforeRouteEnter (to, from, next) {
      next(vm => {
            if(vm.$lcs.get('user')){
                if(vm.$lcs.get('user').id_juser == 2) vm.$router.push({path:'/dosen'})
            }else vm.$router.push({path:'/'})
        })
  },
  mixins : [adminConf],
  data () {
      return {
         menu : [],
         hariSekarang : null
      }
  },
  created () {
      this.menu = this.adminMenu
      
  },
  beforeCreated () {
  }
}
</script>

</style>
