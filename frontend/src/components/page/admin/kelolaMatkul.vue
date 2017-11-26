<template>
    <admin>
<div class="w3-container">
    <h2>Daftar Mata Kuliah</h2>
    <gen-form :pk="tableContent.content[0]" :url="url" :input="listForm"></gen-form>
    <gen-table pk="id_matkul" :url="url" :tableContent="tableContent">
        <template slot="customAction" scope="ca">
            <span class="hint--top" aria-label="Dosen Pengampu">
                <router-link :to="{name:'kelolaMatkulDosen',params:{kdMatkul:ca.pkData.kd_matkul}}" class="w3-button w3-hover-white w3-white"><i class="fa fa-list-alt "></i></router-link>
            </span>
        </template>
    </gen-table>
</div>
</admin>
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
                content : ['kd_matkul','nm_matkul','smt','sks']
            }
        }
  }
}
</script>

<style scoped>

</style>
