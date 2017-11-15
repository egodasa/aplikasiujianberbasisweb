<template>
<div class="w3-container">
    <h2>Daftar Tipe Soal</h2>
    <gen-form :pk="tableContent.content[0]" :url="url" :input="listForm"></gen-form>
    <gen-table :pk="tableContent.content[0]" :url="url" :tableContent="tableContent"></gen-table>
</div>
</template>

<script>
import genTable from '../GenTable.vue'
import genForm from '../formGenerator.vue'

export default {
  name: 'kelolaTipeSoal',
  components : {
      genTable, genForm
  },
  data () {
      return {
          url : 'tipe_soal',
            listForm : [
                {
					caption: "Nama Tipe Soal",
					name:"nm_tipe",
					jenis:"textField",
					tipe:"text",
					value:null
					}
			],
            tableContent : {
                header :  ['Nama Tipe Soal'],
                content : ['id_tsoal','nm_tipe']
            }
        }
  }
}
</script>

<style scoped>

</style>
