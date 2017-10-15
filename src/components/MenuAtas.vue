<template>
<header class="w3-col s12 w3-black" style="height:auto;">
    <router-link v-for="m in listMenu" class="w3-button w3-blue-gray w3-hover-green w3-mobile" :to="m.path">{{m.name}}</router-link>
</header>
</template>

<script>
export default {
  name: 'menuAtas',
  data () {
    return {
      listMenu : [
      {
          path : '/',
          name : 'Beranda'
      },
      {
          path : '/ujian',
          name : 'Ujian'
      },
      {
          path : '/peserta',
          name : 'Peserta'
      },
      {
          path : '/soal',
          name : 'Bank Soal'
      }
      ]
    }
  }
}
</script>

<style scoped>

</style>
