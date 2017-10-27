<template>
    <div>
    <div class="w3-container w3-blue-gray w3-round">
        <h2>Bank Soal</h2>
    </div>
    <button type="button" @click="toggleFormData()" class="w3-button w3-blue">Tambah Data</button>
    <div class="w3-modal" :style="showForm ? 'display:block;' : 'display:none;'">
        <div class="w3-modal-content w3-animate-top">
        <form class="w3-card-8 w3-container w3-section" id="addData" @submit.prevent="submitData()" name="addData">
            <h3>Tambah Soal</h3>
            <textarea class="w3-input w3-border" type="text" v-model="dataForm.isi_soal" placeholder="Isi Soal"></textarea>
            <div class="w3-row">
                <div class="w3-col l1">
                    <input v-for="(x,index,key) in dataForm.pilihanGanda" class="w3-input w3-border" type="text" v-model="dataForm.pilihanGanda[index].huruf" :value='x.huruf' placeholder="Huruf" /><label class="w3-label w3-text-red"></label>
                </div>
                <div class="w3-col l11">
                    <input v-for="(x,index,key) in dataForm.pilihanGanda" class="w3-input w3-border" type="text" v-model="dataForm.pilihanGanda[index].isi_pilihan" :value='x.isi_pilihan' placeholder="Isi Pilihan Ganda" /><label class="w3-label w3-text-red"></label><br/>
                </div>
            </div>
            <button class="w3-btn w3-tiny w3-teal" type="button" @click="addPG()">+</button>
            <button class="w3-btn w3-tiny w3-red" type="button" @click="deletePG()">-</button>
            <br/> Jawaban :
            <div v-for="x in dataForm.pilihanGanda">
                <input class="w3-radio" type="radio" name="Huruf" v-model="dataForm.jawaban" :value="x.huruf" /> <label class="w3-label">{{x.huruf}}</label>
            </div>
            <button type="submit" class="w3-button w3-teal w3-section">Simpan</button>
            <button type="button" class="w3-button w3-reset w3-section" @click="resetForm()">Reset</button>
            <button type="button" class="w3-button w3-blue w3-section" @click="toggleFormData()">Batal</button>
        </form>
        </div>
    </div>
    <gen-table :url="url" :header="tableHeader"></gen-table>
    </div>
</template>

<script>
import genTable from './GenTable.vue'
import axios from 'axios'
import { Bus } from '../bus.js';

export default {
  name: 'kelolaSoal',
  components : {
      genTable
  },
  data () {
      return {
          tableHeader : ['Isi Soal','Jawaban','Tipe Soal'],
          url : 'soal',
          showForm : false,
          dataForm : {
              isi_soal : null,
              jawaban : null,
              pilihanGanda : [
                  {huruf:'A',isi_pilihan:null},
                  {huruf:'B',isi_pilihan:null},
                  {huruf:'C',isi_pilihan:null},
                  {huruf:'D',isi_pilihan:null},
                  {huruf:'E',isi_pilihan:null}
                ],
          },
          pilihanGandaDef : [
          {huruf:'A',isi_pilihan:null},
          {huruf:'B',isi_pilihan:null},
          {huruf:'C',isi_pilihan:null},
          {huruf:'D',isi_pilihan:null},
          {huruf:'E',isi_pilihan:null}
          ]
        }
  },
  created () {
      Bus.$on('getDataDetail', x =>{
            this.getDataDetail(x)
        })
  },
  methods : {
      toggleFormData () {
           this.showForm = !this.showForm
        },
      addPG () {
           this.dataForm.pilihanGanda.push({huruf:null,isi_pilihan:null})
      },
      deletePG () {
          this.dataForm.pilihanGanda.pop()
      },
      resetForm () {
          this.dataForm.isi_soal = null
          this.dataForm.jawaban = null
          this.dataForm.pilihanGanda = this.pilihanGandaDef
      },
      submitData () {
          if(this.dataForm.id == undefined || this.dataForm.id == null){
              var method = 'POST'
              var url = ""
          }else {
              var method = 'PUT'
              var url = '/'+this.dataForm.id
          }
          axios({
            method : method,
            data : this.dataForm,
            url :'/api/'+this.url+url,
            })
          .then(res=>{
            if(res.data.status == false) console.log(res.data)
            else {
                this.dataForm.id = undefined
                this.toggleFormData()
            }
        })
        .catch(err=>{
            console.log(err)
        })
		},
      getDataDetail (x) {
          axios({
            method : 'GET',
            url :'/api/'+this.url+'/'+x,
            })
          .then(res=>{
            if(res.data.status == false) console.log(res.data)
            else {
                let hasil = res.data.data[0]
                this.dataForm = hasil
                this.toggleFormData()
            }
        })
        .catch(err=>{
            console.log(err)
        })
		}
  }
}
</script>

<style scoped>

</style>
