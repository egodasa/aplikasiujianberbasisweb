<template>
    <div>
    <div class="w3-container w3-blue-gray w3-round">
        <h2>Daftar Dosen</h2>
    </div>
    <gen-form :pk="tableContent.content[0]" :url="url" :input="listForm"></gen-form>
    <gen-table :pk="tableContent.content[0]" :url="url" :tableContent="tableContent"></gen-table>
    </div>
</template>

<script>
import genTable from '../GenTable.vue'
import genForm from '../formGenerator.vue'

export default {
  name: 'kelolaDosen',
  components : {
      genTable, genForm
  },
  data () {
      return {
          url : 'dosen',
            listForm : [
                {
					caption: "NIDN",
					name:"nidn",
					jenis:"textField",
					tipe:"text",
					value:null
					},
                {
					caption: "Nama Dosen",
					name:"nm_dosen",
					jenis:"textField",
					tipe:"text",
					value:null
					}
			],
            tableContent : {
                header :  ['NIDN','Nama Dosen'],
                content : ['id_dosen','nidn','nm_dosen']
            }
        }
  }
}
</script>

<style scoped>

</style>
