<template>
    <admin>
<div class="w3-container">
    <h2>Daftar Nama Kelas</h2>
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
