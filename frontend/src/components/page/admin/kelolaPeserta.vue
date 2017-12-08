<template>
    
    <div>
    <div class="w3-container w3-blue-gray w3-round">
        <h2>Daftar Mahasiswa</h2>
    </div>
    <gen-form :pk="tableContent.content[0]" :url="url" :input="listForm"></gen-form>
    <gen-table :url="url" :table-content="tableContent"></gen-table>
    </div>

</template>

<script>
import genTable from '../../template/GenTable.vue'
import genForm from '../../template/formGenerator.vue'
import axios from 'axios'
import admin from './halamanAdmin.vue'

export default {
  name: 'kelolaPeserta',
  components : {
      genTable, genForm, admin
  },
  data () {
      return {
          url : 'peserta',
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
					},
                {
					caption: "Kelas Asal",
					name:"id_kelas",
					jenis:"selectOption",
					tipe:"text",
					value:null,
                    valueSelect : "id",
                    captionSelect : "nm_kelas",
                    option:[{}],
                    error : null
					},
                    
			],
            tableContent : {
                header : ['Nama','NOBP','Kelas Asal'],
                content : ['id','nm_mahasiswa','nobp','nm_kelas']
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
