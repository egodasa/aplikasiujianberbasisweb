<template>
<div>
    <sec-header></sec-header>
    <sec-sidebar :listMenu="adminMenu"></sec-sidebar>
    <sec-content>
        <div class="w3-container">
            <h2>{{judul}}</h2>
            <slot></slot>
        </div>
    <sec-footer>
        <p class="w3-left">Universitas Putra Indonesia YPTK Padang <br/>Powered by <a href="https://www.w3schools.com/w3css/default.asp" target="_blank">w3.css</a></p>
        <p></p>
    </sec-footer>
    </sec-content>
</div>
</template>

<script>
import secHeader from '../header.vue'
import secFooter from '../footer.vue'
import secContent from '../content.vue'
import secSidebar from '../sidebar.vue'
import { adminData } from '../mixins/mixins.js'
export default {
  name: 'halamanAdmin',
  components : {
      secHeader, secFooter, secContent, secSidebar
  },
  mixins : [adminData],
  props : {
      judul : {
          type : String,
          required : false,
          default : "Halaman"
      }
  } 
}
</script>

<style scoped>

</style>
