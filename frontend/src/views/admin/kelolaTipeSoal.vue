<template>
    
<div class="w3-container">
    <h2>Daftar Tipe Soal</h2>
    <gen-form :pk="tableContent[0].name" :url="url" :input="listForm"></gen-form>
    <gen-table :pk="tableContent[0].name" :url="url" :tableContent="tableContent"></gen-table>
</div>

</template>

<script>
import genTable from '../../components/GenTable.vue'
import genForm from '../../components/formGenerator.vue'
import admin from './halamanAdmin.vue'

export default {
  name: 'kelolaTipeSoal',
  components : {
      genTable, genForm, admin
  },
  data () {
      return {
          url : 'jenis_soal',
            listForm : [
                {
					caption: "Nama Tipe Soal",
					name:"nm_jsoal",
					jenis:"textField",
					tipe:"text",
					value:null
					}
			],
            tableContent : [
                {name:"id_jsoal",show:false,caption:null},
                {name:"nm_jsoal",show:true,caption:"Nama Tipe Soal"}
            ]
        }
  }
}
</script>

<style scoped>

</style>
