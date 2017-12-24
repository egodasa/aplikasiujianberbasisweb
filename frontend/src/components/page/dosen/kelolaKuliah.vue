<template>
<div class="w3-container">
    <h2>Daftar Kuliah</h2>
    <gen-form :pk="tableContent.content[0]" :url="url" :input="listForm"></gen-form>
    <gen-table :pk="tableContent.content[0]" :url="url" :table-content="tableContent" tableType="hapus">
    <template slot="customAction" slot-scope="ca">
        <span class="hint--top" aria-label="Kelola Kuliah">
            <router-link :to="{name:'DkelolaKuliahDetail',params:{idKuliah:ca.pkData[tableContent.content[0]]}}" class="w3-button w3-hover-white w3-white"><i class="fa fa-cog "></i></router-link>
        </span>
    </template>
    </gen-table>
</div>

</template>

<script>
import genTable from '../../template/GenTable.vue'
import genForm from '../../template/formGenerator.vue'
import dosen from './halamanDosen.vue'
import selectize from 'vue2-selectize'

export default {
  name: 'kelolaKuliah',
  components : {
      genTable, genForm, dosen, selectize
  },
  data () {
      return {
          url : 'dosen/'+this.$session.get('user').username+'/kuliah',
            tableContent : {
                header : ['Mata Kuliah','Kelas','Tahun Akademik','Status'],
                content : ['id_kuliah','nm_matkul','ket_nm_kelas','tahun_akademik','nm_status_kuliah']
            },
            listForm : [
                {
                    caption : "Pilih Mata Kuliah",
                    name : "kd_matkul",
                    jenis : "selectize",
                    labelField : 'nm_matkul',
                    valueField : 'kd_matkul',
                    options : [],
                    searchField : ['kd_matkul','nm_matkul']
                },
                {
                    caption : "Tambahkan kelas",
                    name : "kelas",
                    jenis : "selectize",
                    labelField : 'nm_kelas',
                    valueField : 'id_kelas',
                    options : [],
                    searchField : ['nm_kelas'],
                    maxItems : null
                },
                {
                    caption : "Tahun Akademik",
                    name : "tahun_akademik",
                    jenis : "textField",
                    type : "text"
                }
            ]
        }
  },
  created () {
        this.getDataSelect('api/matkul',0)
        this.getDataSelect('api/kelas',1)
  },
  methods : {
        toggleFormData() {
            Bus.$emit('toggleFormData')
        },
        getDataSelect (url,index){
            this.$ajx.get(url)
                .then(res=>{
                    this.listForm[index].options = res.data.data
                    })
                .catch((err)=>{
                    console.log(err)
                    })
        }
  }
}
</script>

<style slot-scoped>

</style>
