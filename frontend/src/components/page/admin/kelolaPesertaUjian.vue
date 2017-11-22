<template>
    <admin>
<div class="w3-container">
    <h2>Daftar Mahasiswa</h2>
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
</admin>
</template>

<script>
import genTable from '../../template/GenTable.vue'
import genForm from '../../template/formGenerator.vue'
import admin from './halamanAdmin.vue'
import _ from 'lodash'
import { Bus } from '../../../bus.js';
import axios from 'axios'

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
            axios.post('api/'+this.url,tmp)
            .then(res=>{
                Bus.$emit('toggleFormData')
                Bus.$emit('newData')
                this.mahasiswa = null
                })
            .catch(err=>{
                console.log(err)
                })
            
        },
        getListMahasiswa () {
            axios.get('api/mahasiswa')
            .then(res=>{
                this.listMahasiswa = res.data.data
                })
            .catch(err=>{
                })
        },
        toggleFormData() {
            Bus.$emit('toggleFormData')
        }
    }
}
</script>

<style scoped>

</style>
