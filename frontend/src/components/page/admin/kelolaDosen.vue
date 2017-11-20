<template>
    <admin>
<div class="w3-container">
    <h2>Daftar Dosen</h2>
    <gen-form :pk="tableContent.content[0]" :url="url" :input="listForm"></gen-form>
    <gen-table :pk="tableContent.content[0]" :url="url" :tableContent="tableContent">
        <template slot="customAction" scope="ca">
            <span class="hint--top" aria-label="Matkul Diampu">
                <router-link :to="{name:'kelolaDosenMatkul',params:{nidn:ca.pkData.nidn}}" class="w3-button w3-hover-white w3-white"><i class="fa fa-list-alt "></i></router-link>
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
                content : ['id','nidn','nm_dosen']
            }
        }
  }
}
</script>

<style scoped>

</style>
