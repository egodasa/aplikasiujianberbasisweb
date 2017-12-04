<template>
<div>
<sec-header></sec-header>
    <sec-sidebar :listMenu="menu" :welcomeMessage="$session.get('user').username"></sec-sidebar>
    <sec-content>
            <slot></slot>
    </sec-content>
</div>
</template>

<script>
import secHeader from '../../template/header.vue'
import secFooter from '../../template/footer.vue'
import secContent from '../../template/content.vue'
import secSidebar from '../../template/sidebar.vue'
import { dosenConf } from './dosen.js'
import { Bus } from '../../../bus.js';
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
            console.log(from)
            console.log(to)
            if(vm.$session.has('user')){
                console.log('gundul')
                if(vm.$session.get('user').id_juser == 1) vm.$router.push({path:'/admin'})
            }else vm.$router.push({path:'/'})
        })
  },
  beforeCreated (){
      
  },
  created () {
      this.menu = this.dosenMenu
  }
}
</script>

</style>
