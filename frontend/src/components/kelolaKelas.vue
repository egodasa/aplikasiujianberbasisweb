<template>
    <div>
    <div class="w3-container w3-blue-gray w3-round">
        <h2>Daftar Kelas</h2>
    </div>
    <gen-form :url="url" :input="listForm"></gen-form>
    <gen-table :url="url" :header="tableHeader"></gen-table>
    </div>
</template>

<script>
import genTable from './GenTable.vue'
import genForm from './formGenerator.vue'

export default {
  name: 'kelolaKelas',
  components : {
      genTable, genForm
  },
  data () {
      return {
          url : 'kelas',
            listForm : [
                {
					caption: "Nama Kelas",
					name:"nm_kelas",
					jenis:"textField",
					tipe:"text",
					value:null
					}
			],
            tableHeader : ['Nama Kelas']
        }
  }
}
</script>

<style scoped>

</style>
