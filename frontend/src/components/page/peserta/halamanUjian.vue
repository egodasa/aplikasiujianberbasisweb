<template>
<div>
<sec-header></sec-header>
    <sec-sidebar></sec-sidebar>
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
import { Bus } from '../../../bus.js';
export default {
  name: 'halamanUjian',
  components : {
      secHeader, secFooter, secContent, secSidebar
  },
  data () {
      return {
         
      }
  }
}
</script>

</style>
