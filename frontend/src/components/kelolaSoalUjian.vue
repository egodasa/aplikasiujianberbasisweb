<template>
    <div>
    <div class="w3-container w3-blue-gray w3-round">
        <h2>Daftar Soal Ujian</h2>
    </div>
    <gen-table :url="url" :header="tableHeader"></gen-table>
    </div>
</template>

<script>
import genTable from './GenTable.vue'
import genFormList from './formListGenerator.vue'

export default {
  name: 'kelolaSoalUjian',
  components : {
      genTable, genFormList
  },
  data () {
      return {
          url : 'ujian/'+this.$route.params.idUjian+'/soal',
          tableHeader : ['Isi soal']
        }
  }
}
</script>

<style scoped>

</style>
