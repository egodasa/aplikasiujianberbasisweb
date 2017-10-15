<template>
    <div>
    <div class="w3-container w3-blue-gray w3-round">
        <h2>Daftar Peserta Ujian</h2>
    </div>
    <gen-table :url="url" :header="tableHeader"></gen-table>
    </div>
</template>

<script>
import genTable from './GenTable.vue'
import genFormList from './formListGenerator.vue'

export default {
  name: 'kelolaPeserta',
  components : {
      genTable, genFormList
  },
  data () {
      return {
          url : 'ujian/'+this.$route.params.idUjian+'/peserta',
          tableHeader : ['Nama Peserta','Status']
        }
  }
}
</script>

<style scoped>

</style>
