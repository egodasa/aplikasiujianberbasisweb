<template>
<div>
<sec-header></sec-header>
    <sec-sidebar :listMenu="menu"></sec-sidebar>
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
import { adminConf } from './admin.js'
import { Bus } from '../../../bus.js';
export default {
  name: 'halamanAdmin',
  components : {
      secHeader, secFooter, secContent, secSidebar
  },
  mixins : [adminConf],
  data () {
      return {
         menu : []
      }
  },
  created () {
      this.menu = this.adminMenu
  }
}
</script>

</style>
