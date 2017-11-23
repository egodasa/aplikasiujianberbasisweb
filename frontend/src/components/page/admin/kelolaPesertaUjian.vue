<template>
    <admin>
<div class="w3-container">
    <h2>Daftar Peserta Ujian</h2>
    <gen-table :pk="tableContent.content[0]" :formButton.Boolean="false" :url="url" :tableContent="tableContent" tableType="lain" :aksi.boolean="false"></gen-table>
</div>
</admin>
</template>

<script>
import genTable from '../../template/GenTable.vue'
import admin from './halamanAdmin.vue'
export default {
  name: 'kelolaPesertaUjian',
  components : {
      genTable, admin
  },
  data () {
      return {
          url : 'ujian/'+this.$route.params.idUjian+'/mahasiswa',
            tableContent : {
                header :  ['NOBP','Nama Mahasiswa'],
                content : ['id_ujian','nobp','nm_mahasiswa']
            }
        }
  }
}
</script>

<style scoped>

</style>
