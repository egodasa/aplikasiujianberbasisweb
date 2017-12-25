<template>
<div>
<sec-header></sec-header>
    <sec-sidebar :listMenu="menu">
        <template slot="sidebarAtas">
            <div class="w3-bar-block">
            <span class="w3-bar-item w3-button w3-padding"><i class="fa fa-user fa-fw"></i> {{$lcs.get('infoLogin').username}}</span>
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
  beforeRouteEnter: (to, from, next)=>{
      next(vm => {
        if(vm.$lcs.get('infoLogin')){
            if(new Date().getTime() > vm.$lcs.get('infoLogin').expireLogin){
                vm.$lcs.remove('infoLogin')
                vm.$router.push({path:'/'})
            }
            else{
                if(vm.$lcs.get('infoLogin').id_juser == 1) vm.$router.push({path:'/admin'})
                else if(vm.$lcs.get('infoLogin').id_juser == 3) vm.$router.push({path:'/'})
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
