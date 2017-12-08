<template>
    
<div class="w3-container">
    <h2>Daftar Dosen Pengampu</h2>
    <gen-form :pk="tableContent.content[0]" :url="url" :input="listForm" contentType="lain">
        <h2>Tambah Data</h2>
        <label>Pilih Dosen</label>
        <span class="w3-container">
        <v-select v-model="dosen" multiple :options="listDosen" label="nm_dosen"></v-select>
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
import _ from 'lodash'
import { Bus } from '../../../bus.js';
import axios from 'axios'

export default {
  name: 'kelolaMatkulDosen',
  components : {
      genTable, genForm, admin
  },
  data () {
      return {
          url : 'matkul/'+this.$route.params.kdMatkul+'/dosen',
          tableContent : {
            header :  ['NIDN','Nama Dosen'],
            content : ['id_mdosen','nidn','nm_dosen']
            },
            dosen : null,
            listDosen : []
            }
    },
    created () {
        this.getListDosen()
    },
    methods : {
        submitData (){
            var tmp = []
            _.forEach(this.dosen, (v,k)=>{
                tmp.push({id_mdosen:v.nidn+""+this.$route.params.kdMatkul ,nidn:v.nidn,kd_matkul:this.$route.params.kdMatkul})
                })
            axios.post('api/'+this.url,tmp)
            .then(res=>{
                Bus.$emit('toggleFormData')
                Bus.$emit('newData')
                this.matkul = null
                })
            .catch(err=>{
                console.log(err)
                })
            
        },
        getListDosen () {
            axios.get('api/dosen')
            .then(res=>{
                this.listDosen = res.data.data
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
