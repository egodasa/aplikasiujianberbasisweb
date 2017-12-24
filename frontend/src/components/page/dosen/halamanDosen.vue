<template>
<div>
<sec-header></sec-header>
    <sec-sidebar :listMenu="menu" :welcomeMessage="$session.get('user').username"></sec-sidebar>
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
import { dosenConf } from './dosen.js'

export default {
  name: 'halamanDosen',
  components : {
      secHeader, secFooter, secContent, secSidebar
  },
  mixins : [dosenConf],
  data () {
      return {
         menu : []
      }
  },
  beforeRouteEnter (to, from, next) {
      next(vm => {
            console.log('nsdfskd')
            if(vm.$session.has('user')){
                if(vm.$session.get('user').id_juser == 1) vm.$router.push({path:'/admin'})
                else{
                    if(vm.$session.get('user').username != vm.$route.params.nidn) vm.$router.push({path:'/dosen/'+vm.$session.get('user').username})
                    }
            }else vm.$router.push({path:'/'})
        })
  },
  beforeCreated () {
      
  },
  created () {
      this.menu = this.dosenMenu
  }
}
</script>

</style>
