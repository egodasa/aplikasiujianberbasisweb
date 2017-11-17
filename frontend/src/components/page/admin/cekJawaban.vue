<template>
    <admin>
<div>
 <div class="w3-container w3-blue-gray w3-round">
    <h2>{{'Pemeriksaan Jawaban Ujian '+infoUjian.nm_matkul}}</h2>
</div>
<div class="w3-container">
    <div class="w3-col l6 s12 w3-large">
        <div class="w3-padding">
            <h3>Soal </h3>
            {{listJawaban[posisiSoal].isi_soal}}
            <h3>Jawaban</h3>
            {{listJawaban[posisiSoal].jawaban}}
            <h3>Jawaban Peserta</h3>
            {{listJawaban[posisiSoal].jawaban_peserta}}
            <h3>Bobot</h3>
            {{listJawaban[posisiSoal].bobot}}
            <h3>Bobot Yang Diberikan</h3>
            <input class="w3-input" type="number" min=0 :max.number="listJawaban[posisiSoal].bobot" v-model.number="bobot" />
            <button type="button" class="w3-button w3-blue" @click="simpanNilai(bobot)">Simpan</button>
        </div>
    </div>
    <div class="w3-col l6 s12 w3-large">
        <h3>Pilih Soal</h3>
        <button type="button" class="w3-button w3-blue" style="margin-right:5px;" v-for="(y,index,key) in listJawaban" @click="showSoal(index)">{{index+1}}</button>
        <h3>{{'Total Bobot Diberikan : '+totalBobot}}</h3>
    </div>
</div>
<div class="w3-container">
    <div class="w3-col s12">
        <button type="button" class="w3-button w3-red w3-right w3-section w3-right" @click="simpanPeriksa()">Simpan Hasil Pemeriksaan >></button>
    </div>
</div>
</div>
</admin>
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
              id_peserta : this.$route.params.idPeserta,
              nilai : this.totalBobot
              }
          axios.post('api/ujian/'+this.$route.params.idUjian+'/jawaban',data)
          .then(res=>{
              console.log(res)
              this.$router.push({path: '/admin/ujian/'+this.$route.params.idUjian+'/jawaban/'})
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
