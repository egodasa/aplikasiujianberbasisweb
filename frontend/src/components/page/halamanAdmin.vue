<template>
<div>
    <sec-header></sec-header>
    <sec-sidebar :listMenu="adminMenu"></sec-sidebar>
    <sec-content>
            <slot></slot>
    <sec-footer>
        <p class="w3-left">Universitas Putra Indonesia YPTK Padang <br/>Powered by <a href="https://www.w3schools.com/w3css/default.asp" target="_blank">w3.css</a></p>
        <p></p>
    </sec-footer>
    </sec-content>
</div>
</template>

<script>
import secHeader from '../template/header.vue'
import secFooter from '../template/footer.vue'
import secContent from '../template/content.vue'
import secSidebar from '../template/sidebar.vue'
import { adminData } from '../mixins/mixins.js'
export default {
  name: 'halamanAdmin',
  components : {
      secHeader, secFooter, secContent, secSidebar
  },
  mixins : [adminData]
}
</script>

<style scoped>

</style>
