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
          path : '/admin/ujian',
          name : 'Ujian'
      },
      {
          path : '/admin/peserta',
          name : 'Peserta'
      },
      {
          path : '/admin/soal',
          name : 'Bank Soal'
      },
      {
          path : '/admin/kelas',
          name : 'Kelas'
      },
      {
          path : '/ujian/login',
          name : 'Login Peserta Ujian'
      },
      {
          path : '/ujian/petunjuk',
          name : 'Petunjuk Ujian'
      },
      {
          path : '/ujian/soal',
          name : 'LJK Ujian'
      }
      ]
    }
  }
}
</script>

<style scoped>

</style>
