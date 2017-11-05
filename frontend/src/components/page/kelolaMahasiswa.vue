<template>
    <div>
    <div class="w3-container w3-blue-gray w3-round">
        <h2>Daftar Mahasiswa</h2>
    </div>
    <gen-form :pk="tableContent.content[0]" :url="url" :input="listForm"></gen-form>
    <gen-table :pk="tableContent.content[0]" :url="url" :tableContent="tableContent"></gen-table>
    </div>
</template>

<script>
import genTable from '../GenTable.vue'
import genForm from '../formGenerator.vue'
import axios from 'axios'

export default {
  name: 'kelolaMahasiswa',
  components : {
      genTable, genForm
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
					},
                {
					caption: "Kelas Asal",
					name:"id_kelas",
					jenis:"selectOption",
					tipe:"text",
					value:null,
                    valueSelect : "id_kelas",
                    captionSelect : "nm_kelas",
                    option:[{}],
                    error : null
					},
                    
			],
            tableContent : {
                header : ['Nama','NOBP','Kelas Asal'],
                content : ['id_mahasiswa','nm_mahasiswa','nobp','nm_kelas']
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
