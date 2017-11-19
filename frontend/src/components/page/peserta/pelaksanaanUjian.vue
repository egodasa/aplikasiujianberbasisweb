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
            <div class="w3-left-align">{{infoUjian.nm_mahasiswa}}</div>
        </div>
        <div class="w3-col l6 s12">
            <div class="w3-right-align">Nama Ujian : </div>
        </div>
        <div class="w3-col l6 s12">
            <div class="w3-left-align">{{infoUjian.nm_matkul}}</div>
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
            <p>{{posisiSoal+1}}. {{listSoal[posisiSoal].isi_soal}}</p>
            <template v-if="infoUjian.id_jsoal == 1">
            <label for="jawaban" v-for="x in listSoal[posisiSoal].pilihanGanda">
                <input class="w3-radio" type="radio" name="jawaban" @click="simpanJawaban(posisiSoal,x.huruf)" :value="x.huruf" v-model="jawaban"/> {{x.isi_pilihan}}<br/>
            </label>
            </template>
            <template v-else>
            <textarea class="w3-input" v-model="jawaban" placeholder="Ketik jawaban disini ..."></textarea><br/>
            <button type="button" class="w3-button w3-blue w3-right w3-section w3-right" @click="simpanJawaban(posisiSoal,jawaban)">Simpan Jawaban</button>
            </template>
        </div>
    </div>
    <div class="w3-col l6 s12 w3-large">
        <h3>Pilih Soal</h3>
        <button type="button" class="w3-button w3-blue" style="margin-right:5px;" v-for="(y,index,key) in listSoal" @click="showSoal(index)">{{index+1}}</button>
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
import formatWaktu from 'date-fns/format'
import lokalisasi from 'date-fns/locale/id'
export default {
  name: 'pelaksanaanUjian',
  data () {
      return {
          infoUjian : {},
          listSoal : [{}],
          soalSekarang : {
                isi_soal : null,
                pilihanGanda : [
                   {
                       huruf : null,
                       isi_pilihan : null
                   }
                ]
          },
          jawabanPeserta : [],
          posisiSoal : 0,
          ljk : [],
          jawabanHuruf : null,
          hariSekarang : null,
          waktuSekarang : null,
          interval : null
        }
  },
  created () {
    if(this.$session.has('infoUjian') === false){
        this.$router.push({path: '/ujian/login'})
    }else{
        this.infoUjian = this.$session.get('infoUjian')  
        this.hariSekarang = formatWaktu(new Date(), 'DD MMMM YYYY', {locale : lokalisasi})
        this.genLjk()
    }
  },
  methods : {
      setWaktu () {
          this.waktuSekarang = formatWaktu(new Date(), 'H : M : S', {locale : lokalisasi})
      },
      showSoal (noSoal) {
          this.posisiSoal = noSoal
          this.jawaban = this.jawabanPeserta[this.posisiSoal].jawaban || null
      },
      genLjk () {
          if(!this.$session.has('ljk')){
              axios.get('/api/ujian/'+this.infoUjian.id_ujian+'/soal')
              .then(res=>{
                    this.listSoal = res.data.data
                    _.forEach(res.data.data, (v,k)=>{
                        this.jawabanPeserta.push({id_soal : v.id_soal, jawaban : null}) 
                        })
                    this.showSoal(this.posisiSoal)
                    this.$session.set('ljk',this.jawabanPeserta)
                  })
              .catch(err=>{
                  console.log(err)
                  })
           }else{
               this.jawabanPeserta = this.$session.get('ljk')
               this.showSoal(this.posisiSoal)
           }
      },
      kumpulkanUjian () {
          if(this.infoUjian.id_jsoal == 1){
              var benar = 0
              var salah = 0
              console.log(this.ljk)
              _.forEach(this.jawabanPeserta, (x, index)=>{
                  x.jawaban == this.listSoal[index].jawaban ? benar++ : salah++
              })
              var nilai = benar*(100/(benar+salah))
              var hasil = {
                  id_ujian : this.infoUjian.id_ujian,
                  id_peserta : this.infoUjian.id_mahasiswa,
                  nilai : nilai
              }
              axios.post('api/ujian/'+this.infoUjian.id_ujian+'/hasil',hasil)
              .then(res=>{
                  console.log(res.data)
                  })
              .catch(err=>{
                  console.log(err)
                  })
          }else if(this.infoUjian.id_jsoal == 2){
              var hasil = []
              _.forEach(this.jawabanPeserta, (v,k)=>{
                  hasil.push({
                      id_ujian : this.infoUjian.id_ujian,
                      id_soal : v.id_soal,
                      id_peserta : this.infoUjian.id_mahasiswa,
                      jawaban : v.jawaban
                      })
                  })
              axios.post('api/ujian/'+this.infoUjian.id_ujian+'/jawaban',hasil)
              .then(res=>{
                  console.log(res.data)
                  })
              .catch(err=>{
                  console.log(err)
                  })
          }
          this.$session.destroy()
          this.$router.push({path: '/'})
      },
      simpanJawaban (x,jawaban){
          this.jawabanPeserta[x].jawaban = jawaban
          console.log(this.jawabanPeserta)
      }
  },
  mounted () {
      this.interval = setInterval(this.setWaktu, 1000)
  },
  beforeDestroy() {
    clearInterval(this.interval)
  }
}
</script>

<style scoped>

</style>
