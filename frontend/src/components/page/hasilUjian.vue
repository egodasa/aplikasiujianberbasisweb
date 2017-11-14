<template>
<admin judul="Laporan Hasil Ujian">
    <gen-table :pk="tableContent.content[0]" :url="url" :tableContent="tableContent" tableType="lain" :aksi.boolean="false"></gen-table>
</admin>
</template>

<script>
import genTable from '../GenTable.vue'
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
