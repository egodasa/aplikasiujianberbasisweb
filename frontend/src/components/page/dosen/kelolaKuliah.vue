<template>
<div class="w3-container">
    <h2>Daftar Kuliah</h2>
    <i>* Status kuliah akan aktif jika terdapat minimal 1 mahasiswa pada kuliah tersebut.</i>
    <div class="w3-border"></div>
    <br/>
    <gen-form :pk="tableContent[0].name" :url="url" :input="listForm">
    </gen-form>
    <gen-table :pk="tableContent[0].name" :url="url" :table-content="tableContent" tableType="hapus">
    <template slot="customAction" slot-scope="ca">
        <span class="hint--top" aria-label="Peserta Kuliah">
            <router-link :to="{name:'kelolaPesertaKuliah',params:{idKuliah:ca.pkData[tableContent[0].name]}}" class="w3-button w3-hover-white w3-white"><i class="fa fa-users "></i></router-link>
        </span>
    </template>
    <template slot="customSearch">
        <label style="font-size:17px;">Tahun Akademik </label>
        <input type="number" style="width:100px;height:30px;" class="w3-button w3-small w3-border w3-white" v-model="tahun_akademik" :placeholder="tahun_akademik"/> 
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
          tahun_akademik : new Date().getFullYear().toString(),
          url : 'dosen/'+this.$cks.getCookies('infoLogin').username+'/kuliah',
            tableContent : [
                {name: 'id_kuliah',show: false,caption: null},
                {name: 'nm_matkul',show: true,caption: "Mata Kuliah"},
                {name: 'ket_nm_kelas',show: true,caption: "Kelas"},
                {name: 'nm_status_kuliah',show: true,caption: "Status"}
            ],
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
            bus.$emit('toggleFormData')
        },
        getDataSelect (url,index){
            this.$ajx.get(url)
                .then(res=>{
                    this.listForm[index].options = res.data.data
                    })
                .catch((err)=>{
                    
                    })
        }
  }
}
</script>

<style slot-scoped>

</style>
