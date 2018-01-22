<template>
    
<div class="w3-container">
    <h2>Daftar Dosen</h2>
    <gen-form :pk="tableContent[0].name" :url="url" :input="listForm"></gen-form>
    <gen-table :pk="tableContent[0].name" :url="url" :tableContent="tableContent">
    </gen-table>
</div>

</template>

<script>
import genTable from '../../template/GenTable.vue'
import genForm from '../../template/formGenerator.vue'
import admin from './halamanAdmin.vue'

export default {
  name: 'kelolaDosen',
  components : {
      genTable, genForm, admin
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
            tableContent : [
                {name:"id_dosen",show:false ,caption:null},
                {name:"nidn",show: true,caption:"NIDN"},
                {name:"nm_dosen",show: true,caption:"Nama Dosen"}
            ]
        }
  }
}
</script>

<style scoped>

</style>
