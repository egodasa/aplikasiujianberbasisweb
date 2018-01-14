<template>
    
<div class="w3-container">
    <h2>Daftar Mahasiswa</h2>
    <div class="w3-border"></div>
    <gen-form :pk="tableContent.content[0]" :url="url" :input="listForm" contentType="lain">
        <h2>Tambah Data</h2>
        <label>Pilih Mahasiswa</label>
        <span class="w3-container">
        <v-select v-model="mahasiswa" multiple :options="listMahasiswa" label="nm_mahasiswa"></v-select>
        </span>
        <span class="w3-container">
        <button class="w3-button w3-blue " @click="submitData()">Tambahkan</button>
        <button class="w3-button w3-red" @click="toggleFormData()">Batal</button>
        </span>
    </gen-form>
    <gen-table :pk="tableContent.content[0]" :url="url" tableType="hapus" :tableContent="tableContent">
    </gen-table>
</div>

</template>

<script>
import genTable from '../../template/GenTable.vue'
import genForm from '../../template/formGenerator.vue'
import admin from './halamanAdmin.vue'

export default {
  name: 'kelolaKuliahMahasiswa',
  components : {
      genTable, admin, genForm
  },
  data () {
      return {
          url : 'kuliah/'+this.$route.params.idKuliah+'/mahasiswa',
          tableContent : {
                header :  ['Nama Mahasiswa'],
                content : ['id_kmhs','nm_mahasiswa']
            },
            mahasiswa : null,
            listMahasiswa : []
        }
  },
  created () {
      this.getListMahasiswa()
  },
  methods : {
    submitData (){
            var tmp = []
            _.forEach(this.mahasiswa, (v,k)=>{
                tmp.push({id_kuliah:this.$route.params.idKuliah,nobp:v.nobp})
                })
            this.$ajx.post('api/'+this.url,tmp)
            .then(res=>{
                bus.$emit('toggleFormData')
                bus.$emit('newData')
                this.mahasiswa = null
                })
            .catch(err=>{
                
                })
            
        },
        getListMahasiswa () {
            this.$ajx.get('api/mahasiswa')
            .then(res=>{
                this.listMahasiswa = res.data.data
                })
            .catch(err=>{
                })
        },
        toggleFormData() {
            bus.$emit('toggleFormData')
        }
    }
}
</script>

<style scoped>

</style>
