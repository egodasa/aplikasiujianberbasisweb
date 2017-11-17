<template>
<div>
<sec-header></sec-header>
    <sec-sidebar :listMenu="menu"></sec-sidebar>
    <sec-content>
            <slot></slot>
    <sec-footer>
        <p class="w3-left">Template and CSS by <a href="https://www.w3schools.com/w3css/default.asp" target="_blank">w3.css</a></p>
        <p></p>
    </sec-footer>
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
  created () {
      this.menu = this.dosenMenu
  }
}
</script>

</style>
