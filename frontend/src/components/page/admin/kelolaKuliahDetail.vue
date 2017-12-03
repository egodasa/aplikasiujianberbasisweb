<template>
<admin>
<div class="w3-container">
    <h2>Detail Kuliah</h2>
        <div class="w3-center w3-container" :style="loading ? 'display:block;height:250px;':'display:none;height:300px;'">
        <div class="w3-big w3-margin-top">Mengecek Login Pengguna
        <div class="sk-three-bounce">
        <div class="sk-child sk-bounce1"></div>
        <div class="sk-child sk-bounce2"></div>
        <div class="sk-child sk-bounce3"></div>
        </div>
        </div>
        </div>
    <div id="infoKuliah" :style="!loading ? 'display:block;':'display:none;height:300px;'">
            <div class="w3-row">
                <div class="w3-col l6 s12 xs12">
                <table class="w3-table w3-border w3-bordered">
                        <tr>
                        <td class="w3-white">Nama Dosen</td>
                        <td class="w3-white">{{infoKuliah.nm_dosen}}</td>
                        </tr>
                        <tr>
                        <td class="w3-white">Mata Kuliah</td>
                        <td class="w3-white">{{infoKuliah.nm_matkul}}</td>
                        </tr>
                        <tr>
                        <td class="w3-white">Kelas</td>
                        <td class="w3-white">
                            {{infoKuliah.nm_kelas}}</td>
                        </tr>
                        <tr>
                    <td class="w3-white">Tahun Akademik</td>
                    <td class="w3-white">{{infoKuliah.tahun_akademik}}</td>
                    </tr>
                </table>
                </div>
            </div>
    </div>
    <h2>Daftar Peserta Kuliah</h2>
    <gen-form :pk="tableContent.content[0]" :url="url" :input="listForm" contentType="lain">
        <h2>Tambah Data</h2>
        <span class="w3-container">
            <label>Pilih Kelas</label>
            <select class="w3-select w3-border" v-model="id_kelas" @change="getDataSelect('mahasiswa','listMahasiswa','mahasiswaNotInKelasKuliah',{id_ujian:$route.params.idUjian})">
                <option v-for='x in listKelas' :value="x.id_kelas">{{x.nm_kelas}}</option>
            </select>
        </span>
        <span class="w3-container">
        <label>Pilih Mahasiswa</label>
        <v-select v-model="mahasiswa" multiple :options="listMahasiswa" label="nm_mahasiswa"></v-select>
        </span>
        <span class="w3-container">
        <button class="w3-button w3-blue " @click="submitData()">Tambahkan</button>
        <button class="w3-button w3-red" @click="toggleFormData()">Batal</button>
        </span>
    </gen-form>
    <gen-table :pk="tableContent.content[0]" :url="url" :table-content="tableContent"></gen-table>
</div>
</admin>
</template>

<script>
import genTable from '../../template/GenTable.vue'
import genForm from '../../template/formGenerator.vue'
import admin from './halamanAdmin.vue'
import axios from 'axios'
import _ from 'lodash'
import formatWaktu from 'date-fns/format'
import lokalisasi from 'date-fns/locale/id'
import { Bus } from '../../../bus.js'

export default {
  name: 'kelolaKuliahDetail',
  components : {
      'genTable' : genTable,
      'genForm' : genForm,
      'admin' : admin
  },
  data () {
      return {
          url : 'kuliah/'+this.$route.params.idKuliah+'/mahasiswa',
          infoKuliah : {},
          tableContent : {
              header : ['NOBP','Nama Mahasiswa','Kelas'],
              content : ['id_peserta','nobp','nm_mahasiswa','nm_kelas']
          },
          loading : false,
          mahasiswa : null,
            id_kelas : null,
            listMahasiswa : [],
            listKelas : [],
            file : null
        }
    },
  created (){
      this.detailKuliah()
  },
  methods : {
      changeTabs (x){
          this.currentTabs = x
      },
      submitData (){
            var tmp = []
            _.forEach(this.mahasiswa, (v,k)=>{
                tmp.push({id_peserta:v.nobp+'-'+this.$route.params.idKuliah,id_kuliah:this.$route.params.idKuliah,nobp:v.nobp,id_kelas:this.id_kelas})
                })
            axios.post('api/'+this.url,tmp)
            .then(res=>{
                Bus.$emit('toggleFormData')
                Bus.$emit('newData')
                this.mahasiswa = null,
                this.id_kelas = null
                })
            .catch(err=>{
                console.log(err)
                })
        },
      getDataSelect (x,y,name,args) {
            let query = `query mahasiswaNotInKelasKuliah($id_kuliah : String) {mahasiswaNotInKelasKuliah(id_kuliah : $id_kuliah){nobp,nm_mahasiswa}}`
            let kueri = {query:query, variables : {id_kuliah : this.$route.params.idKuliah}}
            console.log(kueri)
            axios.post('api/v2/'+x,kueri)
                .then(res=>{
                    console.log(res.data.data[name])
                    this[y] = res.data.data[name]
                    })
                .catch((err)=>{
                    console.log(err)
                    this[y] = []
                    })
        },
      detailKuliah () {
          axios.get('api/kuliah/'+this.$route.params.idKuliah)
            .then(res=>{
                this.infoKuliah = res.data.data[0]
                this.getKelas(this.infoKuliah.id_kelas)
                })
            .catch(err=>{
                this.infoKuliah = [{}]
                console.log(err)
                })
      },
      getKelas (x) {
          var tmp = []
            _.forEach(x,(v,k)=>{
                tmp.push({id_kelas : v,nm_kelas: this.infoKuliah.nm_kelas[k]})
                })
            this.listKelas = tmp
            console.log(this.listKelas)
        },
        toggleFormData() {
            Bus.$emit('toggleFormData')
        }
  }
}
</script>

<style scoped>

</style>
