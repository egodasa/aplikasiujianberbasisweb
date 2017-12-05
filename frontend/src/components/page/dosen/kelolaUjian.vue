<template>
<dosen>
<div class="w3-container">
    <h2>Kelola Ujian</h2>
    <i>* Status ujian akan aktif jika terdapat minimal 1 soal pada ujian tersebut.</i>
    <div class="w3-border"></div>
    <br/>
    <gen-form :pk="tableContent.content[0]" :url="url" :input="listForm" contentType="lain">
        <h2>Tambah Data</h2>
        <span class="w3-container">
            <label>Pilih Kuliah</label>
            <v-select v-model="kuliah" :options="listKuliah" :on-change="getDataJujian" label="nm_kuliah"></v-select>
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
            <label>Keterangan Ujian</label>
            <textarea class='w3-input w3-border' v-model="deskripsi"></textarea>
        </span>
        <span class="w3-container">
        <button class="w3-button w3-blue " @click="submitData()">Tambahkan</button>
        <button class="w3-button w3-red" @click="toggleFormData()">Batal</button>
        </span>
    </gen-form>
    <gen-table :pk="tableContent.content[0]" :url="url" :tableContent="tableContent" tableType="hapus">
        <template slot="customAction" slot-scope="ca">
            <span class="hint--top" aria-label="Kelola Ujian">
                <router-link :to="{name:'DkelolaUjianDetail',params:{nidn:$session.get('user').username,idUjian:ca.pkData[tableContent.content[0]]}}" class="w3-button w3-hover-white w3-white"><i class="fa fa-cog "></i></router-link>
            </span>
        </template>
    </gen-table>
</div>
</dosen>
</template>

<script>
import genTable from '../../template/GenTable.vue'
import genForm from '../../template/formGenerator.vue'
import dosen from './halamanDosen.vue'
import axios from 'axios'
import _ from 'lodash'
import Datepicker from 'vuejs-datepicker';
import { Bus } from '../../../bus.js';

export default {
  name: 'kelolaUjian',
  components : {
      genTable, genForm, dosen, Datepicker
  },
  data () {
      return {
          id_ujian : null,
          url : 'dosen/'+this.$session.get('user').username+'/ujian',
            tableContent : {
                header :  ['Matkul','Jenis Ujian','Hari','TA','Status'],
                content : ['id_ujian','nm_matkul','nm_jujian','hari','tahun_akademik','nm_status_ujian']
            },
            id_jujian : null,
            id_jsoal : null,
            hari : null,
            mulai : null,
            selesai : null,
            kelas : null,
            kuliah : null,
            selectedKuliah : null,
            deskripsi : null,
            listKuliah : [],
            listJujian : [],
            listJsoal : []
        }
  },
  created () {
      this.getDataSelect('jenis_soal','listJsoal')
      this.getDataKuliah()
  },
  methods : {
        submitData (){
            console.log(this.kuliah)
            var tmp = {
                id_ujian : this.selectedKuliah.id_kuliah+'-'+this.id_jujian,
                id_kuliah : this.selectedKuliah.id_kuliah,
                hari : this.hari,
                mulai : this.mulai,
                selesai : this.selesai,
                id_jujian : this.id_jujian,
                id_jsoal : this.id_jsoal,
                deskripsi : this.deskripsi
            }
            axios.post('api/ujian',tmp)
            .then(res=>{
                if(res.data.status == true){
                    Bus.$emit('toggleFormData')
                    Bus.$emit('newData')
                    this.id_jujian = null
                    this.id_jsoal = null
                    this.hari = null
                    this.mulai = null
                    this.selesai = null
                    this.deskripsi = null
                    this.kuliah = null
                    this.selectedKuliah = null
                }
                })
            .catch(err=>{
                console.log(err)
                })
            
        },
        getDataJujian (x) {
            this.selectedKuliah = x
            let query = `query jenisUjianTersedia($id_kuliah : String) {jenisUjianTersedia(id_kuliah : $id_kuliah){id_jujian,nm_jujian}}`
            let kueri = {query:query, variables : {id_kuliah : x.id_kuliah}}
            axios.post('api/v2/jenis_ujian',kueri)
            .then(res=>{
                console.log(res.data.data)
                this.listJujian = res.data.data['jenisUjianTersedia']
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
        getDataKuliah() {
            axios.get('api/dosen/'+this.$session.get('user').username+'/kuliah')
                .then(res=>{
                    var tmp = res.data.data
                    var kuliah = []
                    _.forEach(tmp,(v,k)=>{
                        kuliah.push({id_kuliah:v.id_kuliah,nm_kuliah:v.nm_matkul+'/'+v.tahun_akademik+'/'+v.nm_kelas.toString()})
                        })
                    this.listKuliah = kuliah
                    })
                .catch((err)=>{
                    this.listKuliah = []
                    })
        },
        toggleFormData() {
            Bus.$emit('toggleFormData')
        }
  }
}
</script>

<style slot-scoped>

</style>
