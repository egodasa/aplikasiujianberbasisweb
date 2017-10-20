<template>
    <div>
    <div class="w3-container w3-blue-gray w3-round">
        <h2>Laporan Hasil Ujian</h2>
    </div>
    <gen-table :url="url" :header="tableHeader" :aksi.Boolean="false"></gen-table>
    </div>
</template>

<script>
import genTable from './GenTable.vue'
export default {
  name: 'hasilUjian',
  components : {
      genTable
  },
  data () {
      return {
          url : 'ujian/'+this.$route.params.idUjian+'/hasil',
          tableHeader : ['Nama Peserta','Benar','Salah','Nilai']
        }
  }
}
</script>

<style scoped>

</style>
