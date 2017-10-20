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
        <div class="w3-col l6 s12">
            <div class="w3-right-align">Hari/Tanggal : </div>
        </div>
        <div class="w3-col l6 s12">
            <div class="w3-left-align">{{hariSekarang}}</div>
        </div>
        <div class="w3-col l6 s12">
            <div class="w3-right-align">Waktu : </div>
        </div>
        <div class="w3-col l6 s12">
            <div class="w3-left-align">{{waktuSekarang}}</div>
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
                <input class="w3-radio" type="radio" name="jawaban" @click="jawabLjk(posisiSoal,x.huruf)" :value="x.huruf" v-model="jawabanHuruf"/> {{x.isi_pilihan}}<br/>
            </label>
        </div>
    </div>
    <div class="w3-col l6 s12 w3-large">
        <h3>Pilih Soal</h3>
        <button type="button" class="w3-button w3-blue" style="margin-right:5px;" v-for="(y,index,key) in ljk" @click="showSoal(y.id_soal,index+1)">{{index+1}}</button>
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
import moment from 'moment-timezone'
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
          posisiSoal : 1,
          ljk : [],
          jawabanHuruf : null,
          hariSekarang : null,
          waktuSekarang : null
        }
  },
  created () {
    if(this.$session.has('infoUjian') === false){
        this.$router.push({path: '/ujian/login'})
    }else{
        this.$moment.locale('id');
        this.$moment().tz("Asia/Pontianak")
        this.infoUjian = this.$session.get('infoUjian')  
        this.hariSekarang = this.$moment().format('LTS')
        var waktuSekarang = setInterval(this.setWaktu, 1000);
        this.genLjk()
    }
  },
  methods : {
      setWaktu () {
          this.waktuSekarang = this.$moment().format('LL')
      },
      showSoal (x,noSoal) {
          this.posisiSoal = noSoal
          this.jawabanHuruf = null
          axios.get('/api/soal/'+x)
          .then(res=>{
              this.soalSekarang = res.data.data[0]
              this.jawabanHuruf = this.ljk[noSoal-1].jawaban_peserta
              })
          .catch(err=>{
              console.log(err)
              })
      },
      genLjk () {
          console.log(this.ljk)
          if(!this.$session.has('ljk')){
              axios.get('/api/ujian/'+this.infoUjian.id_ujian+'/soal')
              .then(res=>{
                    _.forEach(res.data.data, (x, index)=>{
                       this.ljk.push({id_soal:res.data.data[index].id,jawaban:res.data.data[index].jawaban,jawaban_peserta:null})
                    })
                    this.$session.set('ljk',this.ljk)
                  })
              .then(()=>{
                  this.showSoal(this.ljk[0].id_soal,this.posisiSoal)
                  })
              .catch(err=>{
                  console.log(err)
                  })
           }else{
               this.ljk = this.$session.get('ljk')
               this.showSoal(this.ljk[0].id_soal,this.posisiSoal)
           }
      },
      jawabLjk (noSoal,jawaban) {
          this.ljk[noSoal-1].jawaban_peserta = jawaban
          this.$session.set('ljk',this.ljk)
          console.log(this.$session.get('ljk'))
          console.log(this.ljk)
      },
      kumpulkanUjian () {
          var benar = 0
          var salah = 0
          console.log(this.ljk)
          _.forEach(this.ljk, (x, index)=>{
              x.jawaban == x.jawaban_peserta ? benar++ : salah++
          })
          console.log('Benar '+benar+', Salah '+salah)
          this.$session.destroy()
          this.$router.push({path: '/ujian/login'})
      }
  }
}
</script>

<style scoped>

</style>
