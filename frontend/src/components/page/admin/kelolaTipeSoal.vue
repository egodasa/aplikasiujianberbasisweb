<template>
    <admin>
<div class="w3-container">
    <h2>Daftar Tipe Soal</h2>
    <gen-form :pk="tableContent.content[0]" :url="url" :input="listForm"></gen-form>
    <gen-table :pk="tableContent.content[0]" :url="url" :tableContent="tableContent"></gen-table>
</div>
</admin>
</template>

<script>
import genTable from '../../template/GenTable.vue'
import genForm from '../../template/formGenerator.vue'
import admin from './halamanAdmin.vue'

export default {
  name: 'kelolaTipeSoal',
  components : {
      genTable, genForm, admin
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
