<template>
    <div class="w3-container">
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
    <gen-table :pk="tableContent.content[0]" :url="url" :tableContent="tableContent" tableType="lain">
        <template slot="customAction" scope="ca">
            <template v-if="ca.pkData.status_ujian_peserta == 3">
                <button class="w3-button w3-small w3-red" disabled="true">Tidak Ada</button>
            </template>
            <template v-else-if="ca.pkData.status_ujian_peserta == 4">
                <router-link tag="button" :to="{name:'cekJawaban',params:{idUjian:$route.params.idUjian,idPeserta:ca.pkData.nobp}}" class="w3-btn w3-small w3-blue">
                    <i class="fa fa-edit w3-small"></i> <b>Periksa Jawaban</b>
                </router-link>
            </template>
            <template v-else-if="ca.pkData.status_ujian_peserta == 5">
                <button class="w3-button w3-small w3-blue" disabled="true">Tidak Ada</button>
            </template>
        </template>
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
  name: 'kelolaPesertaUjian',
  components : {
      genTable, genForm
  },
  data () {
      return {
          url : 'ujian/'+this.$route.params.idUjian+'/mahasiswa',
            tableContent : {
                header :  ['NOBP','Nama','Status Peserta','Status Ujian'],
                content : ['id_mahasiswa','nobp','nm_mahasiswa','nm_status_peserta','nm_status_upeserta']
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
                tmp.push({id_peserta:v.nobp+'-'+this.$route.params.idUjian,id_ujian:this.$route.params.idUjian,nobp:v.nobp})
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
