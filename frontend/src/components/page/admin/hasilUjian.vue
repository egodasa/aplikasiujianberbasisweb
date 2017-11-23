<template>
    <admin>
<div class="w3-container">
    <h2>Laporan Hasil Ujian</h2>
    <gen-table :pk="tableContent.content[0]" :formButton.Boolean="false" :url="url" :tableContent="tableContent" tableType="lain" :aksi.boolean="false"></gen-table>
</div>
</admin>
</template>

<script>
import genTable from '../../template/GenTable.vue'
import admin from './halamanAdmin.vue'
export default {
  name: 'hasilUjian',
  components : {
      genTable, admin
  },
  data () {
      return {
          url : 'ujian/'+this.$route.params.idUjian+'/hasil',
            tableContent : {
                header :  ['NOBP','Nama Mahasiswa','Nilai'],
                content : ['id_hasil','nobp','nm_mahasiswa','nilai']
            }
        }
  }
}
</script>

<style scoped>

</style>
