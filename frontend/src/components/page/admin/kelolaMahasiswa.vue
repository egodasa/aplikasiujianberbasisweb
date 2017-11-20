<template>
    <admin>
<div class="w3-container">
    <h2>Daftar Mahasiswa</h2>
    <gen-form :pk="tableContent.content[0]" :url="url" :input="listForm"></gen-form>
    <gen-table :pk="tableContent.content[0]" :url="url" :tableContent="tableContent"></gen-table>
</div>
</admin>
</template>

<script>
import genTable from '../../template/GenTable.vue'
import genForm from '../../template/formGenerator.vue'
import axios from 'axios'
import admin from './halamanAdmin.vue'

export default {
  name: 'kelolaMahasiswa',
  components : {
      genTable, genForm, admin
  },
  data () {
      return {
          url : 'mahasiswa',
            listForm : [
                {
					caption: "Nama Mahasiswa",
					name:"nm_mahasiswa",
					jenis:"textField",
					tipe:"text",
					value:null,
                    error : null
					},
                {
					caption: "NOBP",
					name:"nobp",
					jenis:"textField",
					tipe:"text",
                    min:14,
                    max:14,
					value:null,
                    error : null
					}
                    
			],
            tableContent : {
                header : ['Nama','NOBP'],
                content : ['id_mahasiswa','nm_mahasiswa','nobp']
            }
        }
  },
  created () {
      this.getDataKelas()
  },
  methods : {
        getDataKelas () {
            axios.get('api/kelas')
                .then(res=>{
                    this.listForm[2].option = res.data.data
                    })
                .catch((err)=>{
                    console.log(err)
                    })
        }
  }
}
</script>

<style scoped>

</style>
