<template>
<div>
<sec-header></sec-header>
    <sec-sidebar :listMenu="menu">
        <template slot="sidebarAtas">
            <div class="w3-bar-block">
            <span class="w3-bar-item w3-button w3-padding"><i class="fa fa-user fa-fw"></i> {{$cks.getCookies('infoLogin').username}}</span>
            </div>
        </template>
    </sec-sidebar>
    <sec-content>
            <slot>
            <router-view></router-view>
            </slot>
    </sec-content>
</div>
</template>

<script>
import secHeader from '../../components/header.vue'
import secFooter from '../../components/footer.vue'
import secContent from '../../components/content.vue'
import secSidebar from '../../components/sidebar.vue'
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
  beforeRouteEnter: (to, from, next)=>{
      next(vm => {
        if(vm.$cks.isCookies('infoLogin')){
            if(new Date().getTime() > vm.$cks.getCookies('infoLogin').expireLogin){
                vm.$lcs.remove('infoLogin')
                vm.$router.push({path:'/'})
            }
            else{
                if(vm.$cks.getCookies('infoLogin').id_juser == 1) vm.$router.push({path:'/admin'})
                else if(vm.$cks.getCookies('infoLogin').id_juser == 3) vm.$router.push({path:'/'})
            }
        }else vm.$router.push({path:'/'})
      })
    },
  created () {
      this.menu = this.dosenMenu
  }
}
</script>

</style>
