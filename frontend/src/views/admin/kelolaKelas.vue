<template>
    
<div class="w3-container">
    <h2>Daftar Nama Kelas</h2>
    <gen-form :pk="tableContent[0].name" :url="url" :input="listForm"></gen-form>
    <gen-table :pk="tableContent[0].name" :url="url" :tableContent="tableContent"></gen-table>
</div>

</template>

<script>
import genTable from '../../components/GenTable.vue'
import genForm from '../../components/formGenerator.vue'
import admin from './halamanAdmin.vue'
export default {
  name: 'kelolaKelas',
  components : {
      genTable, genForm, admin
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
            tableContent : [
                {name:'id_kelas',show:false,caption:"ID Kelas"},
                {name:'nm_kelas',show:true,caption:"Nama Kelas"}
            ]
        }
  }
}
</script>

<style scoped>

</style>
