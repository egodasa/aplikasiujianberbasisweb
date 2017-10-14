<template>
    <div>
    <div class="w3-container w3-blue-gray w3-round">
        <h2>Daftar Peserta Keseluruhan</h2>
    </div>
    <gen-form :url="url" :input="listForm"></gen-form>
    <gen-table :url="url" :header="tableHeader"></gen-table>
    </div>
</template>

<script>
import genTable from './GenTable.vue'
import genForm from './formGenerator.vue'

export default {
  name: 'kelolaPeserta',
  components : {
      genTable, genForm
  },
  data () {
      return {
          url : 'peserta',
            listForm : [
                {
					caption: "Nama Peserta",
					name:"nm_peserta",
					jenis:"textField",
					tipe:"text",
					value:null
					}
			],
            tableHeader : ['Nama Peserta']
        }
  }
}
</script>

<style scoped>

</style>
