<template>
    <div>
    <div class="w3-container w3-blue-gray w3-round">
        <h2>Bank Soal</h2>
    </div>
    <gen-form :url="url" :input="listForm"></gen-form>
    <gen-table :url="url" :header="tableHeader"></gen-table>
    </div>
</template>

<script>
import genTable from './GenTable.vue'
import genForm from './formGenerator.vue'

export default {
  name: 'kelolaSoal',
  components : {
      genTable, genForm
  },
  data () {
      return {
          url : 'soal',
            listForm : [
                {
					caption: "Isi Soal",
					name:"isi_soal",
					jenis:"textField",
					tipe:"text",
					value:null
					}
			],
            tableHeader : ['Isi Soal','Jawaban']
        }
  }
}
</script>

<style scoped>

</style>
