<template>
    <div>
    <div class="w3-container w3-blue-gray w3-round">
        <h2>Daftar Matkul</h2>
    </div>
    <gen-form :pk="tableContent.content[0]" :url="url" :input="listForm"></gen-form>
    <gen-table pk="id_matkul" :url="url" :tableContent="tableContent">
        <template slot="customAction" scope="ca">
            <router-link :to="{name:'kelolaMatkulDosen',params:{idMatkul:ca.pkData}}" class="w3-btn w3-small w3-blue"><i class="fa fa-edit w3-small"></i> <b>Dosen Pengampu</b></router-link>
        </template>
    </gen-table>
    </div>
</template>

<script>
import genTable from '../GenTable.vue'
import genForm from '../formGenerator.vue'

export default {
  name: 'kelolaMatkul',
  components : {
      genTable, genForm
  },
  data () {
      return {
          url : 'matkul',
            listForm : [
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
					}
			],
            tableContent : {
                header :  ['Nama Matkul','SKS'],
                content : ['id_matkul','nm_matkul','sks']
            }
        }
  }
}
</script>

<style scoped>

</style>
