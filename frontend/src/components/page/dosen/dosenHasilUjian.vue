<template>
    <dosen>
<div class="w3-container">
    <h2>Laporan Hasil Ujian</h2>
    <gen-table :pk="tableContent.content[0]" :url="url" :tableContent="tableContent" tableType="lain" :aksi.boolean="false" :formButton.Boolean="false"></gen-table>
</div>
</dosen>
</template>

<script>
import genTable from '../../template/GenTable.vue'
import dosen from './halamanDosen.vue'
export default {
  name: 'dosenHasilUjian',
  components : {
      genTable, dosen
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
