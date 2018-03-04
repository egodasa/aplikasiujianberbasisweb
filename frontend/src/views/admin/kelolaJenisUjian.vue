<template>
    
<div class="w3-container">
    <h2>Daftar Jenis Ujian</h2>
    <gen-form :pk="tableContent[0].name" :url="url" :input="listForm"></gen-form>
    <gen-table :pk="tableContent[0].name" :url="url" :tableContent="tableContent"></gen-table>
</div>

</template>

<script>
import genTable from '../../components/GenTable.vue'
import genForm from '../../components/formGenerator.vue'
import admin from './halamanAdmin.vue'
export default {
  name: 'kelolaJenisUjian',
  components : {
      genTable, genForm, admin
  },
  data () {
      return {
          url : 'jenis_ujian',
            listForm : [
                {
					caption: "Nama Jenis Ujian",
					name:"nm_jujian",
					jenis:"textField",
					tipe:"text",
					value:null
					}
			],
            tableContent : [
                {name:"id_jujian",show: false,caption:null},
                {name:"nm_jujian",show: true,caption:"Nama Jenis Ujian"}
            ]
        }
  }
}
</script>

<style scoped>

</style>
