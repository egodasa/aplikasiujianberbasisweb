<template>
    
<div class="w3-container">
    <h2>Daftar Mata Kuliah</h2>
    <gen-form :pk="tableContent.content[0]" :url="url" :input="listForm"></gen-form>
    <gen-table pk="id_matkul" :url="url" :tableContent="tableContent">
    </gen-table>
</div>

</template>

<script>
import genTable from '../../template/GenTable.vue'
import genForm from '../../template/formGenerator.vue'
import admin from './halamanAdmin.vue'

export default {
  name: 'kelolaMatkul',
  components : {
      genTable, genForm, admin
  },
  data () {
      return {
          url : 'matkul',
            listForm : [
                {
					caption: "Kode Matkul",
					name:"kd_matkul",
					jenis:"textField",
					tipe:"text",
					value:null
					},
                {
					caption: "Nama Matkul",
					name:"nm_matkul",
					jenis:"textField",
					tipe:"text",
					value:null
					},
                {
					caption: "SKS",
					name:"sks",
					jenis:"textField",
					tipe:"number",
					value:null
					},
                {
					caption: "Semester",
					name:"smt",
					jenis:"textField",
					tipe:"number",
					value:null
					}
			],
            tableContent : {
                header :  ['Kode Matkul','Nama Matkul','Semester','SKS'],
                content : ['id_matkul','kd_matkul','nm_matkul','smt','sks']
            }
        }
  }
}
</script>

<style scoped>

</style>
