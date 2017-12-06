<template>
<div>
    <sec-header onTop.Boolean="false"></sec-header>
    <sec-sidebar>
    <slot>
    <div class="w3-container">
        <h3>Pilih Soal</h3>
    <button type="button" class="w3-button w3-blue w3-small w3-border" v-for="(y,index,key) in listSoal" @click="showSoal(index); toggleMenu();">{{index+1}}</button>
    </div>
    <div class="w3-container">
        <h3>Informasi Ujian</h3>
        <div class="w3-row">
            <div class="w3-col l1 md1 s1">
                <i class="fa fa-user"></i> 
            </div>
            <div class="w3-col l11 md11 s11">
                {{infoUjian.nm_mahasiswa}}
            </div>
            <div class="w3-col l1 md1 s1">
                <i class="fa fa-newspaper-o"></i>  
            </div>
            <div class="w3-col l11 md11 s11">
                {{infoUjian.nm_matkul}}
            </div>
            <div class="w3-col l1 md1 s1">
                <i class="fa fa-calendar"></i> 
            </div>
            <div class="w3-col l11 md11 s11">
                {{hariSekarang}}
            </div>
            <div class="w3-col l1 md1 s1">
                <i class="fa fa-clock-o"></i>
            </div>
            <div class="w3-col l11 md11 s11">
                {{waktuSekarang}}
            </div>
        </div>
      <button type="button" class="w3-button w3-red w3-block" @click="kumpulkanUjian()">Kumpulkan Ujian</button>
   </div>
   </slot>
    </sec-sidebar>
<sec-content>
   <div class="w3-container" style="margin-top:30px;">
   <div class="w3-row" style="margin-top:30px;">
    <div class="w3-col l6 md6 s6">
        <a class="w3-button w3-border w3-border-gray w3-pale-blue w3-block w3-hover-blue">
            Total Soal : {{listSoal.length}}
        </a>
    </div>
    <div class="w3-col l6 md6 s6">
        <a class="w3-button w3-border w3-border-gray w3-pale-blue w3-block w3-hover-blue">
            Sisa Waktu : {{sisaWaktu}}
        </a>
    </div>
    <div class="w3-col l6 md6 s6">
        <a class="w3-button w3-border w3-border-gray w3-pale-blue w3-block w3-hover-blue">
            Selesai : {{soalDikerjakan}}
        </a>
    </div>
    <div class="w3-col l6 md6 s6">
        <a class="w3-button w3-border w3-border-gray w3-pale-blue w3-block w3-hover-blue">
            Belum Selesai : {{listSoal.length-soalDikerjakan}}
        </a>
    </div>
   </div>
   <div class="w3-border">
   </div>
   <b><i>Jawablah soal dibawah ini dengan benar!</i></b>
   </div>
   <div class="w3-container">
      <p>{{posisiSoal+1}}. <span v-html="listSoal[posisiSoal].isi_soal"></span></p>
      <template v-if="infoUjian.id_jsoal == 1">
         <label for="jawaban" v-for="x in listSoal[posisiSoal].pilihanGanda">
         <input class="w3-radio" type="radio" name="jawaban" @click="simpanJawaban(posisiSoal,x.huruf)" :value="x.huruf" v-model="jawaban"/> {{x.isi_pilihan}}<br/>
         </label>
   <br/>
   </template>
   <template v-else>
      <label>Jawaban Anda</label>
      <wysiwyg v-model="jawaban" placeholder="Ketik jawaban disini ..." /><br/>
     <button type="button" class="w3-button w3-blue w3-right w3-block" @click="simpanJawaban(posisiSoal,jawaban)">Simpan Jawaban</button>
   </template>
   <div class="w3-col l6 s6">
       <button type="button" :disabled="posisiSoal == 0" class="w3-button w3-blue w3-small w3-block w3-border w3-border-light-gray" style="margin-right:5px;" @click="showSoal(posisiSoal-1)"><i class="fa fa-arrow-left"></i> </button>
   </div>

   <div class="w3-col l6 s6">
       <button type="button" :disabled="posisiSoal+1 == listSoal.length" class="w3-button w3-small w3-blue w3-block w3-border w3-border-light-gray" style="margin-right:5px;" @click="showSoal(posisiSoal+1)"> <i class="fa fa-arrow-right"></i> </button>
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
import hitungWaktu from 'date-fns/distance_in_words'
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
          sisaWaktu : null,
          waktuString : null
        }
  },
  beforeCreated () {
    if(!this.$session.has('infoUjian')) this.$router.push({path: '/ujian/login'})
  },
  watch : {
      waktuSekarang () {
         var self = this
         setInterval(function () {
            self.waktuSekarang = formatWaktu(new Date(), 'h:m:s', {locale : lokalisasi})
      }, 1000)
      },
      sisaWaktu () {
          var self = this
          setInterval(function () {
             self.sisaWaktu = hitungWaktu(
              new Date(),
              new Date(self.waktuString)
            ,{locale : lokalisasi})
          }, 1000)
      }
  },
  created (){
      this.infoUjian = this.$session.get('infoUjian')  
      this.hariSekarang = formatWaktu(new Date(), 'DD MMMM YYYY', {locale : lokalisasi})
      this.waktuSekarang = formatWaktu(new Date(), 'h:m:s', {locale : lokalisasi})
      this.sisaWaktu = formatWaktu(new Date(this.$session.get('infoUjian').selesai), 'h:m:s', {locale : lokalisasi})
      this.waktuString = this.$session.get('infoUjian').hari.substr(0,10) + " " + this.$session.get('infoUjian').selesai
      console.log(this.waktuString)
      this.genLjk()
  },
  computed : {
        soalDikerjakan () {
            var hasil = 0
            _.forEach(this.listSoal, (v,k)=>{
                if(v.jawaban != null) hasil++
                })
            return hasil
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
          axios.get('/api/ujian/'+this.infoUjian.id_ujian+'/soal')
          .then(res=>{
                this.listSoal = res.data.data
                //cek sesi ujian apakah sudah ada
                if(this.$session.has('ljk')){
                   this.jawabanPeserta = this.$session.get('ljk').jawabanPeserta
                   this.posisiSoal = this.$session.get('ljk').posisiSoal
                   this.showSoal(this.posisiSoal)
                }else{
                    _.forEach(res.data.data, (v,k)=>{
                        this.jawabanPeserta.push({id_soal : v.id_soal, jawaban : null}) 
                        })
                    var tmp = {
                      jawabanPeserta : this.jawabanPeserta,
                      posisiSoal : this.posisiSoal
                    }
                    this.$session.set('ljk',tmp)
                }
                this.showSoal(this.posisiSoal)
              })
          .catch(err=>{
              console.log(err)
              })
           
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
                  nobp : this.infoUjian.nobp,
                  nilai : parseInt(nilai)
              }
              console.log('benar ' + benar + 'salah ' + salah)
              axios.post('api/ujian/hasil',hasil)
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
                      nobp : this.infoUjian.nobp,
                      jawaban : v.jawaban
                      })
                  })
              console.log(hasil)
              axios.post('api/ujian/jawaban',hasil)
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
          this.posisiSoal = x
          var tmp = {
              jawabanPeserta : this.jawabanPeserta,
              posisiSoal : this.posisiSoal
          }
          this.$session.set('ljk',tmp)
          console.log(this.$session.get('ljk'))
          
      }
  }
}
</script>

<style src="../../../../node_modules/vue-wysiwyg/dist/vueWysiwyg.css">

</style>
