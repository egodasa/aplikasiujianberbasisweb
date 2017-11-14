<template>
<admin judul="Daftar Kelas">
    <gen-form :pk="tableContent.content[0]" :url="url" :input="listForm"></gen-form>
    <gen-table :pk="tableContent.content[0]" :url="url" :tableContent="tableContent"></gen-table>
</admin>
</template>

<script>
import genTable from '../GenTable.vue'
import genForm from '../formGenerator.vue'
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
            tableContent : {
                header :  ['Nama Kelas'],
                content : ['id_kelas','nm_kelas']
            }
        }
  }
}
</script>

<style scoped>

</style>
