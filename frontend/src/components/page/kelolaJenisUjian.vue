<template>
<admin judul="Daftar Jenis Ujian">
    <gen-form :pk="tableContent.content[0]" :url="url" :input="listForm"></gen-form>
    <gen-table :pk="tableContent.content[0]" :url="url" :tableContent="tableContent"></gen-table>
</admin>
</template>

<script>
import genTable from '../GenTable.vue'
import genForm from '../formGenerator.vue'
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
					name:"nm_jenis",
					jenis:"textField",
					tipe:"text",
					value:null
					}
			],
            tableContent : {
                header :  ['Nama Jenis Ujian'],
                content : ['id_jujian','nm_jenis']
            }
        }
  }
}
</script>

<style scoped>

</style>
