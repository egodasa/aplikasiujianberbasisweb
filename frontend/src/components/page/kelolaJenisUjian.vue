<template>
    <div>
    <div class="w3-container w3-blue-gray w3-round">
        <h2>Daftar Tipe Soal</h2>
    </div>
    <gen-form :pk="tableContent.content[0]" :url="url" :input="listForm"></gen-form>
    <gen-table :pk="tableContent.content[0]" :url="url" :tableContent="tableContent"></gen-table>
    </div>
</template>

<script>
import genTable from '../GenTable.vue'
import genForm from '../formGenerator.vue'

export default {
  name: 'kelolaJenisUjian',
  components : {
      genTable, genForm
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
