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
            <label>
                <span>Tipe Soal : </span>
                <input class="w3-radio" type="radio" value="1" name="tipe_soal" v-model="dataForm.tipe_soal" />Pilihan Ganda
                <input class="w3-radio" type="radio" value="2" name="tipe_soal" v-model="dataForm.tipe_soal" />Essai<br/>
            </label>
            <textarea name="isi_soal" v-validate data-vv-rules="required" data-vv-as="Isi soal" class="w3-input w3-border" type="text" v-model="dataForm.isi_soal" placeholder="Isi Soal"></textarea>
            <span class="w3-text-red" v-if="errors.has('isi_soal')">{{ errors.first('isi_soal') }}</span>
            <template v-if="dataForm.tipe_soal == 1">
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
                <div v-for="(x,index,key) in dataForm.pilihanGanda">
                    <template v-if="index  == 1">
                    <input class="w3-radio" type="radio" name="Huruf" v-validate data-vv-rules="required" data-vv-as="Jawaban" v-model="dataForm.jawaban" :value="x.huruf" /> <label class="w3-label">{{x.huruf}}</label>
                    </template>
                    <template v-else>
                    <input class="w3-radio" type="radio" name="Huruf" v-model="dataForm.jawaban" :value="x.huruf" /> <label class="w3-label">{{x.huruf}}</label>
                    </template>
                </div>
            </template>
            <template v-else>
            <textarea name="jawaban" v-validate data-vv-rules="required" data-vv-as="Jawaban" class="w3-input w3-border" type="text" v-model="dataForm.jawaban" placeholder="Jawaban"></textarea>
            <span class="w3-text-red" v-if="errors.has('jawaban')">{{ errors.first('jawaban') }}</span>
            </template>
            <span class="w3-text-red" v-if="errors.has('jawaban')">{{ errors.first('jawaban') }}</span>
            <button :disabled="errors.any()" type="submit" class="w3-button w3-teal w3-section">Simpan</button>
            <button type="button" class="w3-button w3-reset w3-section" @click="resetForm()">Reset</button>
            <button type="button" class="w3-button w3-blue w3-section" @click="toggleFormData()">Batal</button>
        </form>
        </div>
    </div>
    <gen-table :url="url" :tableContent="tableContent"></gen-table>
    </div>
</template>

<script>
import genTable from '../GenTable.vue'
import axios from 'axios'
import { Bus } from '../../bus.js';

export default {
  name: 'kelolaSoal',
  components : {
      genTable
  },
  data () {
      return {
          tableContent : {
              header : ['Isi Soal','Jawaban','Tipe Soal'],
              content : ['id','isi_soal','jawaban','tipe_soal']
          },
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
            tipe_soal : 1
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
          if(this.dataForm.tipe_soal == 2) this.dataForm.pilihanGanda = undefined
          console.log(this.dataForm)
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
                Bus.$emit("newData")
                this.resetForm()
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
  },
  destroyed () {
      //Bus.$off('getDataDetail')
  }
}
</script>

<style scoped>

</style>
