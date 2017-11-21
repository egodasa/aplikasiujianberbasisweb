<template>
    <admin>
<div class="w3-container">
    <h2>Daftar Kuliah</h2>
    <gen-form :pk="tableContent.content[0]" :url="url" :input="listForm" contentType="lain">
        <h2>Tambah Data</h2>
        <form id="addData" @submit.prevent="submitData()" name="addData">
            <span class="w3-container">
                <label>Pilih Mata Kuliah</label>
                <v-select v-model="matkul" :on-change="getDataDosen" :options="listMatkul" label="nm_matkul"></v-select>
            </span>
            <span class="w3-container">
                <label>Pilih Dosen</label>
                <v-select v-model="dosen" :options="listDosen" label="nm_dosen"></v-select>
            </span>
            <span class="w3-container">
                <label>Pilih Kelas</label>
                <select class="w3-input" v-model="kelas">
                    <option v-for="x in listKelas" :value="x.id_kelas">{{x.nm_kelas}}</option>
                </select>
            </span>
            <span class="w3-container">
                <label>Tahun Akademik</label>
                <input type="text" class="w3-input w3-border" v-model="tahun" />
            </span>
            <span class="w3-container">
                <button type="submit" class="w3-button w3-blue">Simpan</button>
                <button type="button" class="w3-button w3-red" @click="toggleFormData()">Batal</button>
            </span>
        </form>
    </gen-form>
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
import { Bus } from '../../../bus.js';

export default {
  name: 'kelolaKuliah',
  components : {
      genTable, genForm, admin
  },
  data () {
      return {
          url : 'kuliah',
            tableContent : {
                header : ['Mata Kuliah','Dosen','Kelas'],
                content : ['id_kuliah','nm_matkul','nm_dosen','nm_kelas']
            },
            listMatkul : [],
            listDosen : [],
            listKelas : [],
            matkul : null,
            dosen : null,
            kelas : null
        }
  },
  created () {
      this.getDataKelas()
      this.getDataMatkul()
  },
  methods : {
        toggleFormData() {
            Bus.$emit('toggleFormData')
        },
        submitData (){
            var data = {
                id_mdosen : this.dosen.nidn+""+this.dosen.kd_matkul,
                id_kelas : this.kelas,
                tahun_akademik : this.tahun
            }
            axios.post('api/kuliah',data)
            .then(res=>{
                console.log('ok')
                this.toggleFormData()
                Bus.$emit("newData")
                })
            .catch(err=>{
                console.log(err)
                this.toggleFormData()
                })
        },
        getDataMatkul () {
            axios.get('api/matkul')
                .then(res=>{
                    this.listMatkul = res.data.data
                    })
                .catch((err)=>{
                    console.log(err)
                    })
        },
        getDataDosen (v) {
            axios.get('api/matkul/'+v.kd_matkul+'/dosen')
                .then(res=>{
                    this.listDosen = res.data.data
                    })
                .catch((err)=>{
                    console.log(err)
                    })
        },
        getDataKelas () {
            axios.get('api/kelas')
                .then(res=>{
                    this.listKelas = res.data.data
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
