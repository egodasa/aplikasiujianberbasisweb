<template>
    <admin>
<div class="w3-container">
    <h2>Daftar Kuliah</h2>
    <gen-form :pk="tableContent.content[0]" :url="url" :input="listForm"></gen-form>
    <gen-table :pk="tableContent.content[0]" :url="url" :table-content="tableContent">
        <template slot="customAction" scope="ca">
            <span class="hint--top" aria-label="Daftar Mahasiswa">
                <router-link :to="{name:'kelolaKuliahMahasiswa',params:{idKuliah:ca.pkData[tableContent.content[0]]}}" class="w3-button w3-hover-white w3-small w3-white"><i class="fa fa-users w3-small"></i></router-link>
            </span>
        </template>
    </gen-table>
</div>
</admin>
</template>

<script>
import genTable from '../../template/GenTable.vue'
import genForm from '../../template/formGenerator.vue'
import axios from 'axios'
import _ from 'lodash'
import admin from './halamanAdmin.vue'

export default {
  name: 'kelolaMahasiswa',
  components : {
      genTable, genForm, admin
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
                    placeholder : "Cari atau Pilih Dosen  ...",
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
                    var hasil = res.data.data
                    /*var hasil_tmp = []
                    _.forEach(hasil,(v,k)=>{
                      hasil_tmp.push({label : v.nm_dosen,value : v.id_dosen})  
                        })
                    this.listForm[1].option = hasil_tmp*/
                    this.listForm[1].option = hasil
                    console.log(this.listForm[1].option)
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
