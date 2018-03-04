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
import secHeader from '../../components/header.vue'
import secFooter from '../../components/footer.vue'
import secContent from '../../components/content.vue'
import secSidebar from '../../components/sidebar.vue'
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
