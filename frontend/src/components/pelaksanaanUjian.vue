<template>
<div>
<div class="w3-container w3-light-gray">
    <div class="w3-row-padding">
        <div class="w3-col s12">
            <div class="w3-center">
                <h1>Informasi Ujian</h1>
            </div>
        </div>
        <div class="w3-col l6 s12">
            <div class="w3-right-align">Nama Peserta : </div>
        </div>
        <div class="w3-col l6 s12">
            <div class="w3-left-align">{{infoUjian.nm_peserta}}</div>
        </div>
        <div class="w3-col l6 s12">
            <div class="w3-right-align">Nama Ujian : </div>
        </div>
        <div class="w3-col l6 s12">
            <div class="w3-left-align">{{infoUjian.nm_ujian}}</div>
        </div>
        <div class="w3-col s12">
            <div class="w3-border"></div>
            <div class="w3-medium"><i><b>Jawablah soal dibawah ini dengan benar!</b></i></div>
        </div>
    </div>
</div>
<div class="w3-container">
    <div class="w3-col l6 s12 w3-large">
        <div class="w3-padding">
            <p>{{posisiSoal}}. {{soalSekarang.isi_soal}}</p>
            <label for="jawaban" v-for="x in soalSekarang.pilihanGanda">
                <input class="w3-radio" type="radio" name="jawaban" /> {{x.isi_pilihan}}<br/>
            </label>
        </div>
    </div>
    <div class="w3-col l6 s12 w3-large">
        <h3>Pilih Soal</h3>
        <button type="button" class="w3-button w3-blue" style="margin-right:5px;" v-for="(y,index,key) in listIdSoal" @click="showSoal(y,index+1)">{{index+1}}</button>
    </div>
</div>
<div class="w3-container">
    <div class="w3-col s12">
        <button type="button" class="w3-button w3-red w3-right w3-section w3-right" @click="kumpulkanUjian()">Kumpulkan Ujian >></button>
    </div>
</div>
</div>
</template>

<script>
import axios from 'axios'
import _ from 'lodash'

export default {
  name: 'pelaksanaanUjian',
  data () {
      return {
          infoUjian : {
                id_peserta : null,
                nm_peserta : null,
                id_ujian : null,
                nm_ujian : null
              },
          soalSekarang : {
                isi_soal : null,
                pilihanGanda : [
                   {
                       huruf : null,
                       isi_pilihan : null
                   }
                ]
          },
          listIdSoal : [],
          posisiSoal : 1
        }
  },
  created () {
    this.infoUjian = this.$session.get('infoUjian')
    this.getListIdSoal()
  },
  methods : {
      showSoal (x,noSoal) {
          this.posisiSoal = noSoal
          axios.get('/api/soal/'+x)
          .then(res=>{
              this.soalSekarang = res.data.data[0]
              })
          .catch(err=>{
              console.log(err)
              })
      },
      getListIdSoal () {
          axios.get('/api/ujian/'+this.infoUjian.id_ujian+'/soal')
          .then(res=>{
              _.forEach(res.data.data, (x, index)=>{
                  this.listIdSoal.push(x.id)
                })
              this.showSoal(this.listIdSoal[0],this.posisiSoal)
              })
          .catch(err=>{
              console.log(err)
              })
      },
      kumpulkanUjian () {
          this.$session.destroy()
          this.$router.push({path: '/ujian/login'})
      }
  }
}
</script>

<style scoped>

</style>
