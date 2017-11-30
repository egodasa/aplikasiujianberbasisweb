<template>
<admin>
<div class="w3-container">
    <h2>Kelola Ujian</h2>
    <div class="w3-border"></div>
    <br/>
    <gen-form :pk="tableContent.content[0]" :url="url" :input="listForm" contentType="lain">
        <h2>Tambah Data</h2>
        <span class="w3-container">
            <label>Tahun Akademik</label>
            <input type="text" v-model="tahun_akademik" disabled class="w3-input w3-border" /> 
        </span>
        <span class="w3-container">
            <label>Pilih Matkul</label>
            <v-select v-model="matkul" :options="listMatkul" label="nm_matkul"></v-select>
        </span>
        <span class="w3-container">
            <label>Pilih Dosen</label>
            <v-select v-model="dosen" :options="listDosen" label="nm_dosen"></v-select>
        </span>
        <span class="w3-container">
            <label>Pilih Jenis Ujian</label>
            <select class="w3-select w3-border" v-model="id_jujian">
                <option v-for='x in listJujian' :value="x.id_jujian">{{x.nm_jujian}}</option>
            </select>
        </span>
        <span class="w3-container">
            <label>Pilih Jenis Soal</label>
            <select class="w3-select w3-border" v-model="id_jsoal">
                <option v-for='x in listJsoal' :value="x.id_jsoal">{{x.nm_jsoal}}</option>
            </select>
        </span>
        <div class="w3-row">
          <div class="w3-third">
            <label>Waktu Ujian</label>
            <datepicker input-class="w3-input w3-border" v-model="hari"></datepicker>
          </div>
          <div class="w3-third">
            <label>Jam Mulai</label>
            <input class="w3-input w3-border" type="text" v-model="mulai">
          </div>
          <div class="w3-third">
            <label>Jam Selesai</label>
            <input class="w3-input w3-border" type="text" v-model="selesai">
          </div>
        </div>
        <span class="w3-container">
            <label>Pilih Kelas-kelas ujian</label>
            <v-select placeholder="Semua kelas yang diampu pada sebuah kuliah" v-model="kelas" multiple :options="listKelas" label="nm_kelas"></v-select>
        </span>
        <span class="w3-container">
            <label>Keterangan Ujian</label>
            <textarea class='w3-input w3-border' v-model="deskripsi"></textarea>
        </span>
        
        <span class="w3-container">
        <button class="w3-button w3-blue " @click="submitData()">Tambahkan</button>
        <button class="w3-button w3-red" @click="toggleFormData()">Batal</button>
        </span>
    </gen-form>
    <gen-table :pk="tableContent.content[0]" :url="url" :tableContent="tableContent" tableType="edit_hapus">
        <template slot="customAction" scope="ca">
            <span class="hint--top" aria-label="Kelola Ujian">
                <router-link :to="{name:'kelolaUjianDetail',params:{idUjian:ca.pkData[tableContent.content[0]]}}" class="w3-button w3-hover-white w3-white"><i class="fa fa-cog "></i></router-link>
            </span>
        </template>
    </gen-table>
</div>
</admin>
</template>

<script>
import genTable from '../../template/GenTable.vue'
import genForm from '../../template/formGenerator.vue'
import admin from './halamanAdmin.vue'
import axios from 'axios'
import _ from 'lodash'
import Datepicker from 'vuejs-datepicker';
import pengaturan from '../../../pengaturan.json'
import { Bus } from '../../../bus.js';

export default {
  name: 'kelolaUjian',
  components : {
      genTable, genForm, admin, Datepicker
  },
  data () {
      return {
          id_ujian : null,
          url : 'ujian',
            tableContent : {
                header :  ['Matkul','Kelas',],
                content : ['id_ujian','nm_matkul','nm_kelas']
            },
            conf : pengaturan,
            tahun_akademik : pengaturan.tahun_akademik,
            matkul : null,
            dosen : null,
            id_jujian : null,
            id_jsoal : null,
            hari : null,
            mulai : null,
            selesai : null,
            kelas : null,
            deskripsi : null,
            listDosen : [],
            listMatkul : [],
            listKelas : [],
            listJujian : [],
            listJsoal : []
        }
  },
  created () {
      this.getDataSelect('dosen','listDosen')
      this.getDataSelect('matkul','listMatkul')
      this.getDataSelect('kelas','listKelas')
      this.getDataSelect('jenis_soal','listJsoal')
      this.getDataSelect('jenis_ujian','listJujian')
  },
  methods : {
        submitData (){
            var kelas_tmp = []
            _.forEach(this.kelas,(v,k)=>{
                kelas_tmp.push({id_ujian : this.matkul.kd_matkul+'-'+this.dosen.nidn+'-'+this.tahun_akademik+'-'+this.id_jujian,id_kelas : v.id_kelas})
                })
            var tmp = {
                kd_matkul : this.matkul.kd_matkul,
                nidn : this.dosen.nidn,
                hari : this.hari,
                mulai : this.mulai,
                selesai : this.selesai,
                tahun_akademik : this.conf.tahun_akademik,
                id_jujian : this.id_jujian,
                id_jsoal : this.id_jsoal,
                deskripsi : this.deskripsi,
                kelas : kelas_tmp
            }
            axios.post('api/'+this.url,tmp)
            .then(res=>{
                if(res.data.status == true){
                    Bus.$emit('toggleFormData')
                    Bus.$emit('newData')
                    this.matkul = null
                    this.dosen = null
                    this.id_jujian = null
                    this.id_jsoal = null
                    this.hari = null
                    this.mulai = null
                    this.selesai = null
                    this.kelas = null
                    this.deskripsi = null
                }
                })
            .catch(err=>{
                console.log(err)
                })
            
        },
        getDataSelect (x,y) {
            axios.get('api/'+x)
                .then(res=>{
                    this[y] = res.data.data
                    })
                .catch((err)=>{
                    this[y] = []
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
