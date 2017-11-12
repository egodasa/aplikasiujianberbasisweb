<template>
<div class="w3-row">
    <menu-atas></menu-atas>
    <div class="w3-main w3-pale-blue w3-col s12">
        <div class="w3-card-8 w3-margin w3-light-gray w3-round-large">
        <!--
        <div class="w3-container w3-blue-gray w3-round">
            <h2>Aplikasi Ujian Berbasis Web</h2>
        </div>
        -->
            <router-view></router-view>
        </div>
    </div> 
    <footer class="w3-col s12 w3-black w3-cell-row w3-container" style="bottom:0px;">
        <h5 class="w3-cell-bottom">Aplikasi Ujian Berbasis Web, Created by Ego Dafma Dasa</h5>
    </footer>
</div>
</template>

<script>
import menuAtas from './components/MenuAtas.vue'

export default {
  name: 'app',
  components: {
    menuAtas
  },
  data () {
      return {
          
      }
  }
}
</script>
<style src="../assets/stylesheets/w3.css">
</style>
