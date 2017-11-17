<template>
<admin>
<div class="w3-container">
    <h2>Aplikasi CAT</h2>
    Changelog :<br/>
    <b>v2.5.0</b><br/>
    - Mengganti module mysql pada Backend dengan query builder KnexJS<br/>
    - Mengganti AngularJS dengan VueJS pada Frontend dan masih berlanjut.
    - Desain baru
    <br/>
    <b>v1.0.0</b><br/>
    - Aplikasi berjalan dengan baik menggunakan Frontend AngularJS. Namun diketahui tidak support pada beberapa browser<br/>
    <ul>
        <li>Fitur manajemen Ujian, Soal ujian dan peserta ujian</li>
        <li>Fitur manajemen Soal</li>
        <li>Fitur manajemen Peserta</li>
    </ul>
</div>
</admin>
</template>

<script>
import admin from './halamanAdmin.vue'

export default {
  name: 'dashboardAdmin',
  components : {
      admin
  },
  data () {
    return {
      
    }
  }
}
</script>

<style scoped>

</style>
