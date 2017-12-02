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
  beforeMounted () {
      if(this.$session.has('user')){
          if(this.$session.get('user').id_juser != 2) this.$router.push({path:'/dosen'})
      }else{
        this.$router.push({path:'/'})
      }
  },
  beforeCreated (){
      
  },
  created () {
      this.menu = this.dosenMenu
  }
}
</script>

</style>
