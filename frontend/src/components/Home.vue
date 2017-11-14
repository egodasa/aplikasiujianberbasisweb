<template>
<div>
    <sec-header></sec-header>
    <div class="w3-container w3-blue-gray">
        <h2>Aplikasi Ujian Berbasis Web</h2>
    </div>
    <div class="w3-container">
    Changelog :<br/>
    <b>v2.0.0</b><br/>
    - Mengganti module mysql pada Backend dengan query builder KnexJS<br/>
    - Mengganti AngularJS dengan VueJS pada Frontend dan masih berlanjut.
    <br/>
    <b>v1.0.0</b><br/>
    - Aplikasi berjalan dengan baik menggunakan Frontend AngularJS. Namun diketahui tidak support pada beberapa browser<br/>
    <ul>
        <li>Fitur manajemen Ujian, Soal ujian dan peserta ujian</li>
        <li>Fitur manajemen Soal</li>
        <li>Fitur manajemen Peserta</li>
    </ul>
    </div>
</div>
</template>

<script>
import secHeader from './header.vue'

export default {
  name: 'home',
  components : {
      secHeader
      },
  data () {
    return {
      
    }
  }
}
</script>

<style scoped>

</style>
