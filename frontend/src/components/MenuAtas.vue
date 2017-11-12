<template>
<header class="w3-col s12 w3-blue-grey w3-border-bottom w3-border-blue" style="height:auto;">
    <router-link v-for="m in listMenu" class="w3-button w3-blue-grey w3-hover-blue w3-mobile" :to="m.path">{{m.name}}</router-link>
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
          path : '/admin/mahasiswa',
          name : 'Mahasiswa'
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
          path : '/admin/matkul',
          name : 'Matkul'
      },
      {
          path : '/admin/tipe-soal',
          name : 'Tipe Soal'
      },
      {
          path : '/admin/jenis-ujian',
          name : 'Jenis Ujian'
      },
      {
          path : '/admin/dosen',
          name : 'Dosen'
      },
      {
          path : '/admin/kuliah',
          name : 'Kuliah'
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
