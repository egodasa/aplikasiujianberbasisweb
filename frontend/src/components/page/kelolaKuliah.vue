<template>
    <div>
    <div class="w3-container w3-blue-gray w3-round">
        <h2>Daftar Mahasiswa</h2>
    </div>
    <gen-form :pk="tableContent.content[0]" :url="url" :input="listForm"></gen-form>
    <gen-table :pk="tableContent.content[0]" :url="url" :table-content="tableContent">
        <template slot="customAction" scope="ca">
            <router-link :to="{name:'kelolaKuliahMahasiswa',params:{idKuliah:ca.pkData}}" class="w3-btn w3-small w3-blue"><i class="fa fa-edit w3-small"></i> <b>Daftar Mahasiswa</b></router-link>
        </template>
    </gen-table>
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
          url : 'kuliah',
            listForm : [
                {
					caption: "Pilih Mata Kuliah",
					name:"id_matkul",
					jenis:"selectOption",
					tipe:"text",
					value:null,
                    valueSelect : "id_matkul",
                    captionSelect : "nm_matkul",
                    option:[{}],
                    error : null
					},
                {
					caption: "Pilih Dosen",
					name:"id_dosen",
					jenis:"selectOption",
					tipe:"text",
					value:null,
                    valueSelect : "id_dosen",
                    captionSelect : "nm_dosen",
                    option:[{}],
                    error : null
					},
                {
					caption: "Pilih Kelas",
					name:"id_kelas",
					jenis:"selectOption",
					tipe:"text",
					value:null,
                    valueSelect : "id_kelas",
                    captionSelect : "nm_kelas",
                    option:[{}],
                    error : null
					}
                    
			],
            tableContent : {
                header : ['Mata Kuliah','Dosen','Kelas'],
                content : ['id_kuliah','nm_matkul','nm_dosen','nm_kelas']
            }
        }
  },
  created () {
      this.getDataKelas()
      this.getDataMatkul()
      this.getDataDosen()
  },
  methods : {
        getDataMatkul () {
            axios.get('api/matkul')
                .then(res=>{
                    this.listForm[0].option = res.data.data
                    })
                .catch((err)=>{
                    console.log(err)
                    })
        },
        getDataDosen () {
            axios.get('api/dosen')
                .then(res=>{
                    this.listForm[1].option = res.data.data
                    })
                .catch((err)=>{
                    console.log(err)
                    })
        },
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
