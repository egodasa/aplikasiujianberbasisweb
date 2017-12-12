<template>
<div class="w3-container">
    <h2>Daftar Kuliah</h2>
    <gen-form :pk="tableContent.content[0]" :url="url" :input="listForm" contentType="lain">
        <h2>Tambah Data</h2>
        <form id="addData" @submit.prevent="submitData()" name="addData">
            <span class="w3-container">
                <label>Pilih Mata Kuliah</label>
                <v-select v-model="matkul" :options="listMatkul" label="nm_matkul"></v-select>
            </span>
            <span class="w3-container">
                <label>Tentukan Kelas</label>
                <v-select v-model="kelas" multiple :options="listKelas" label="nm_kelas"></v-select>
            </span>
            <span class="w3-container">
                <label>Tahun Akademik</label>
                <input type="text" class="w3-input w3-border" v-model="tahun_akademik" />
            </span>
            <span class="w3-container">
                <button type="submit" class="w3-button w3-blue">Simpan</button>
                <button type="button" class="w3-button w3-red" @click="toggleFormData()">Batal</button>
            </span>
        </form>
    </gen-form>
    <gen-table :pk="tableContent.content[0]" :url="url" :table-content="tableContent" tableType="hapus">
    <template slot="customAction" slot-scope="ca">
        <span class="hint--top" aria-label="Kelola Kuliah">
            <router-link :to="{name:'DkelolaKuliahDetail',params:{nidn:$session.get('user').username,idKuliah:ca.pkData[tableContent.content[0]]}}" class="w3-button w3-hover-white w3-white"><i class="fa fa-cog "></i></router-link>
        </span>
    </template>
    </gen-table>
</div>
</template>

<script>
import genTable from '../../template/GenTable.vue'
import genForm from '../../template/formGenerator.vue'
import axios from 'axios'
import _ from 'lodash'
import dosen from './halamanDosen.vue'
import { Bus } from '../../../bus.js';

export default {
  name: 'kelolaKuliah',
  components : {
      genTable, genForm, dosen
  },
  data () {
      return {
          url : 'dosen/'+this.$session.get('user').username+'/kuliah',
            tableContent : {
                header : ['Mata Kuliah','Tahun Akademik','Kelas'],
                content : ['id_kuliah','nm_matkul','tahun_akademik','ket_nm_kelas']
            },
            listMatkul : [],
            listKelas : [],
            matkul : null,
            kelas : null,
            tahun_akademik : null,
            edit : false
        }
  },
  beforeCreate () {

  },
  created () {
      this.getDataKelas()
      this.getDataMatkul()
  },
  methods : {
        toggleFormData() {
            this.edit = false
            Bus.$emit('toggleFormData')
        },
        submitData (){
            var method
            var url
            if(this.edit == false){
                method = 'post'
                url = "api/kuliah"
            }else {
                method = 'put'
                url = "api/kuliah/"+this.matkul.kd_matkul+'-'+this.$session.get('user').username+"-"+this.tahun_akademik
            }
            var kelas = []
            _.forEach(this.kelas,(v,k)=>{
                kelas.push({id_kuliah: this.matkul.kd_matkul+'-'+this.$session.get('user').username+"-"+this.tahun_akademik,id_kelas:v.id_kelas})
                })
            var data = {
                id_kuliah : this.matkul.kd_matkul+'-'+this.$session.get('user').username+"-"+this.tahun_akademik,
                nidn : this.$session.get('user').username,
                kd_matkul : this.matkul.kd_matkul,
                tahun_akademik : this.tahun_akademik,
                kelas : kelas
            }
            console.log(data)
            axios[method](url,data)
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
        getDetailKuliah (id){
            this.edit = true
            axios.get('api/kuliah/'+id)
            .then(res=>{
                var d = res.data.data[0]
                this.matkul = d.nm_matkul
                this.kelas = d.nm_kelas
                this.tahun_akademik = d.tahun_akademik
                this.toggleFormData()
                })
            .catch(err=>{
                console.log(err)
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

<style slot-scoped>

</style>
