<template>
<div>
    <sec-header onTop.Boolean="false"></sec-header>
    <sec-sidebar>
    <div class="w3-container">
        <h3>Pilih Soal</h3>
    <button type="button" class="w3-button w3-blue w3-small w3-border" v-for="(y,index,key) in listSoal" @click="showSoal(index); toggleMenu();">{{index+1}}</button>
    </div>
    <div class="w3-container">
        <h3>Informasi Ujian</h3>
         <i class="fa fa-user"></i> 
         {{infoUjian.nm_mahasiswa}}
      <br/>
         <i class="fa fa-newspaper-o"></i> 
         {{infoUjian.nm_matkul}}
         <br/>
        <i class="fa fa-calendar"></i> 
         {{hariSekarang}}
         <br/>
        <i class="fa fa-clock-o"></i> 
         {{waktuSekarang}}

      <button type="button" class="w3-button w3-red w3-block" @click="kumpulkanUjian()">Kumpulkan Ujian >></button>
   </div>
    </sec-sidebar>
<sec-content>
   <div class="w3-container">
      <p>{{posisiSoal+1}}. {{listSoal[posisiSoal].isi_soal}}</p>
      <template v-if="infoUjian.id_jsoal == 1">
         <label for="jawaban" v-for="x in listSoal[posisiSoal].pilihanGanda">
         <input class="w3-radio" type="radio" name="jawaban" @click="simpanJawaban(posisiSoal,x.huruf)" :value="x.huruf" v-model="jawaban"/> {{x.isi_pilihan}}<br/>
         </label>
   <br/>
   </template>
   <template v-else>
      <textarea class="w3-input" v-model="jawaban" placeholder="Ketik jawaban disini ..."></textarea>
     <button type="button" class="w3-button w3-blue w3-right w3-block" @click="simpanJawaban(posisiSoal,jawaban)">Simpan Jawaban</button>
   </template>
   <div class="w3-col l6 s6">
       <button type="button" :disabled="posisiSoal == 0" class="w3-button w3-blue w3-small w3-block w3-border w3-border-light-gray" style="margin-right:5px;" @click="showSoal(posisiSoal-1)"><< </button>
   </div>

   <div class="w3-col l6 s6">
       <button type="button" :disabled="posisiSoal+1 == listSoal.length" class="w3-button w3-small w3-blue w3-block w3-border w3-border-light-gray" style="margin-right:5px;" @click="showSoal(posisiSoal+1)"> >> </button>
   </div>
    <hr/>
   <hr/>
   <hr/>
   </div>
</sec-content>
</div>
</template>
<script>
import axios from 'axios'
import { Bus } from '../../../bus.js';
import _ from 'lodash'
import formatWaktu from 'date-fns/format'
import lokalisasi from 'date-fns/locale/id'
import peserta from './halamanUjian.vue'
import secHeader from '../../template/header.vue'
import secFooter from '../../template/footer.vue'
import secContent from '../../template/content.vue'
import secSidebar from '../../template/sidebar.vue'

export default {
  name: 'pelaksanaanUjian',
  components : {
      peserta, secHeader, secFooter, secContent, secSidebar
  },
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
      toggleMenu () {
          Bus.$emit('toggleMenu')
      },
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
      kumpulkanUjian () {/*
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
          }*/
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
