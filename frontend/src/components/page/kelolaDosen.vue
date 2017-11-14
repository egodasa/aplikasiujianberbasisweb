<template>
<admin judul="Daftar Dosen">
    <gen-form :pk="tableContent.content[0]" :url="url" :input="listForm"></gen-form>
    <gen-table :pk="tableContent.content[0]" :url="url" :tableContent="tableContent"></gen-table>
</admin>
</template>

<script>
import genTable from '../GenTable.vue'
import genForm from '../formGenerator.vue'
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
