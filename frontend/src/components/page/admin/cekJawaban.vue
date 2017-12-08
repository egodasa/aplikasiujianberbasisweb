<template>
<div>
 <div class="w3-container">
    <h2>{{'Pemeriksaan Jawaban Ujian '+infoUjian.nm_matkul}}</h2>
    <table class="w3-table w3-border w3-bordered w3-pale-blue">
        <tr>
            <td style="width:30%;">
                <h4>Nilai Akhir</h4>
                {{'Total Bobot Peserta : '+totalBobot}}
            </td>
            <td style="width:70%;">
                <h4>Soal</h4>
                <span v-html="listJawaban[posisiSoal].isi_soal"></span>
                </td>
        </tr>
        <tr>
            <td>
                <h4>Pilih Soal</h4>
                <button type="button" style="margin-right:5px;" v-for="(y,index,key) in listJawaban" @click="showSoal(index)" :class="posisiSoal == index ? 'w3-button w3-green' : 'w3-button w3-blue'">{{index+1}}</button>
            </td>
            <td>
                <h4>Jawaban Dosen</h4>
                <span v-html="listJawaban[posisiSoal].jawaban"></span>
            </td>
        </tr>
        <tr>
            <td>
                <h4>Ketentuan Penilaian</h4>
                
                Bobot Maksimal : {{listJawaban[posisiSoal].bobot}}
                <h4>Bobot Yang Diberikan</h4>
                <form @submit.prevent="simpanNilai(bobot)">
                <input class="w3-input w3-border" type="number" min=0 :max.number="listJawaban[posisiSoal].bobot" v-model.number="bobot" />
                <button type="submit" class="w3-button w3-blue">Simpan</button>
                </form>
            </td>
            <td>
                <h4>Jawaban Peserta</h4>
                <span v-html="listJawaban[posisiSoal].jawaban_peserta"></span>
                <br/>
            </td>
        </tr>
    </table>
</div>
<div class="w3-container">
    <div class="w3-col s12">
        <button type="button" class="w3-button w3-red w3-right" @click="simpanPeriksa()">Simpan Hasil Pemeriksaan</button>
    </div>
</div>
</div>
</template>

<script>
import axios from 'axios'
import _ from 'lodash'
import { adminConf } from './admin.js'
import admin from './halamanAdmin.vue'
export default {
  name: 'cekJawaban',
  components : {
      admin
  },
  beforeCreated () {
      axios.get('api/ujian/'+this.$route.params.idUjian+'/hasil/'+this.$route.params.idPeserta)
      .then(res=>{
          if(res.data.data.length == 1) {
              console.log('dup')
              this.$router.push({path:'/admin/ujian'})
          }else  console.log('ntek')
          })
      .catch(err=>{
          console.log(err)
          })
  },
  data () {
      return {
          infoUjian : {},
          listJawaban :[{}],
          posisiSoal : 0,
          totalBobot : 0,
          bobot : 0
        }
  },
  computed : {

  },
  created () {
      this.getUjian()
      this.getListJawaban()
  },
  methods : {
      getUjian (){
          axios.get('api/ujian/'+this.$route.params.idUjian)
          .then(res=>{
              this.infoUjian = res.data.data[0]
              })
          .catch(err=>{
              this.infoUjian = []
              console.log(err)
              })
      },
      getListJawaban (){
          axios.get('api/ujian/'+this.$route.params.idUjian+'/jawaban/'+this.$route.params.idPeserta)
          .then(res=>{
              console.log(res.data.data)
              this.listJawaban = res.data.data
              _.forEach(this.listJawaban, (v,k)=>{
                  this.listJawaban[k].bobot_peserta = 0
                  })
              })
          .catch(err=>{
              this.listJawaban = []
              console.log(err)
              })
      },
      showSoal (x){
          this.posisiSoal = x
          this.bobot = this.listJawaban[x].bobot_peserta || 0
      },
      simpanNilai (x) {
          this.listJawaban[this.posisiSoal].bobot_peserta = x
          var nilai = 0
          _.forEach(this.listJawaban, (v,k)=>{
              nilai += v.bobot_peserta
              })
          this.totalBobot = nilai
      },
      simpanPeriksa (){
          var data = {
              id_ujian : this.infoUjian.id_ujian,
              nobp : this.$route.params.idPeserta,
              nilai : this.totalBobot
              }
          axios.post('api/ujian/hasil',data)
          .then(res=>{
              console.log(res)
              this.$router.push({path: '/admin/ujian/'+this.$route.params.idUjian})
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
