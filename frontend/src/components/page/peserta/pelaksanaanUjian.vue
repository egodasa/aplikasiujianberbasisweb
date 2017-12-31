<template>
<div>
<sec-header onTop.Boolean="false"></sec-header>
<sec-sidebar>
<template slot="sidebarAtas">
<div class="w3-container">
    <h3>Pilih Soal</h3>
<button style="padding: 5px;width:40px;margin : 3px;" type="button" :class="jawabanPeserta[index].jawaban != null ? 'w3-button w3-green  w3-hover-pale-blue w3-border' : 'w3-button w3-red w3-hover-pale-blue w3-border'" v-for="(y,index,key) in listSoal" @click="showSoal(index); toggleMenu();">{{index+1}}</button>
</div>
</template>
<template slot="sidebarBawah">
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
</template>
</sec-sidebar>
<sec-content>
<div class="w3-container" style="margin-top:30px;">
<div class="w3-row" style="margin-top:30px;">
<div class="w3-col l6 md6 s12 xs12">
    <a class="w3-button w3-border w3-border-gray w3-pale-blue w3-block w3-hover-blue">
        Total Soal : {{listSoal.length}}
    </a>
</div>
<div class="w3-col l6 md6 s12 xs12">
    <a class="w3-button w3-border w3-border-gray w3-pale-blue w3-block w3-hover-blue">
        Sisa Waktu : {{sisaWaktu}}
    </a>
</div>
<div class="w3-col l6 md6 s12 xs12">
    <a class="w3-button w3-border w3-border-gray w3-pale-blue w3-block w3-hover-blue">
        Selesai : {{soalDikerjakan}}
    </a>
</div>
<div class="w3-col l6 md6 s12 xs12">
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
    <quill-editor v-model="jawaban" ref="quillEditor"></quill-editor>
    <!--<textarea v-model="jawaban" placeholder="Ketik jawaban disini ..." class="w3-border w3-input" rows="7"></textarea>--><br/>
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

import formatWaktu from 'date-fns/format'
import lokalisasi from 'date-fns/locale/id'
import hitungWaktu from 'date-fns/distance_in_words'
import peserta from './halamanUjian.vue'
import secHeader from '../../template/header.vue'
import secFooter from '../../template/footer.vue'
import secContent from '../../template/content.vue'
import secSidebar from '../../template/sidebar.vue'
import jarakMili from 'date-fns/difference_in_milliseconds'
export default {
name: 'pelaksanaanUjian',
components : {
    peserta, secHeader, secFooter, secContent, secSidebar
},
data () {
    return {
        jawaban : "",
        quillEditor : {
            modules : {
                toolbar : [
                'bold',
                'italic',
                'size',
                'color',
                'underline',
                'list',
                'align',
                'blockquote'
            ]
            },
            placeholder : "Ketik Jawaban Disini..."
        },
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
        waktuString : null,
        waktuSelesai : null,
        soalDikerjakan : 0,
        sisaWaktuJalan : null,
        waktuSekarangJalan : null
    }
},
beforeRouteEnter: (to, from, next)=>{
    next(vm => {
    if(vm.$cks.getCookies('infoLogin')){
        if(vm.$cks.getCookies('infoLogin').id_juser == 1) vm.$router.push({path:'/admin'})
        else if(vm.$cks.getCookies('infoLogin').id_juser == 2) vm.$router.push({path:'/dosen/'+vm.$cks.getCookies('infoLogin').username})
        else if(vm.$cks.getCookies('infoLogin').id_juser == 3) {
            if(!vm.$lcs.getLcs('infoUjian')){
               vm.$router.push({path:'/ujian/login'}) 
            }
        }
        else vm.$router.push({path:'/'})
    }else vm.$router.push({path:'/'})
    })
},
beforeDestroy () {
    clearInterval(this.sisaWaktuJalan)
    clearInterval(this.waktuSekarangJalan)
},
created (){
    this.infoUjian = this.$lcs.getLcs('infoUjian')  
    this.hariSekarang = formatWaktu(new Date(), 'DD MMMM YYYY', {locale : lokalisasi})
    this.waktuSekarang = formatWaktu(new Date(), 'h:m:s', {locale : lokalisasi})
    this.waktuSelesai = new Date(this.$lcs.getLcs('infoUjian').hari.substr(0,10) + " " + this.$lcs.getLcs('infoUjian').selesai).getTime()
    this.genLjk()
    this.runSisaWaktu()
    this.runWaktuSekarang()
},
methods : {
    runSisaWaktu () {
        var sisa = new Date(this.$lcs.getLcs('infoUjian').hari + " " + this.$lcs.getLcs('infoUjian').selesai).getTime() - new Date().getTime()
        this.sisaWaktuJalan = setInterval(()=>{
            if(sisa < 0) {
                this.kumpulkanUjian()
            }
            this.waktuUjian(sisa)
            sisa = sisa - 1000
            },1000)
    },
    runWaktuSekarang () {
        this.waktuSekarangJalan = setInterval(()=> {
        this.waktuSekarang = formatWaktu(new Date(), 'h:m:s', {locale : lokalisasi})
        }, 1000)
    },
    waktuUjian (ms) {
        var hours = Math.floor(ms / 3600000) // 1 Hour = 36000 Milliseconds
        var minutes = Math.floor((ms % 3600000) / 60000) // 1 Minutes = 60000 Milliseconds
        var seconds = Math.floor(((ms % 360000) % 60000) / 1000) // 1 Second = 1000 Milliseconds
        if(hours != 0){
            this.sisaWaktu = hours+" Jam "+minutes+" Menit "+seconds+" Detik"
        }else{
            if(minutes != 0){
                this.sisaWaktu = minutes+" Menit "+seconds+" Detik"
            }else{
                this.sisaWaktu = seconds+" Detik"
            }
        }
    },
    toggleMenu () {
        bus.$emit('toggleMenu')
    },
    setWaktu () {
        this.waktuSekarang = formatWaktu(new Date(), 'H : M : S', {locale : lokalisasi})
    },
    showSoal (noSoal) {
        this.posisiSoal = noSoal
        this.jawaban = this.jawabanPeserta[this.posisiSoal].jawaban || null
    },
    genLjk () {
        this.$ajx.get('/api/ujian/'+this.infoUjian.id_ujian+'/soal')
        .then(res=>{
            this.listSoal = res.data.data
            //cek sesi ujian apakah sudah ada
            if(this.$lcs.getLcs('ljk')){
                this.jawabanPeserta = this.$lcs.getLcs('ljk').jawabanPeserta
                this.posisiSoal = this.$lcs.getLcs('ljk').posisiSoal
                this.showSoal(this.posisiSoal)
            }else{
                _.forEach(res.data.data, (v,k)=>{
                    this.jawabanPeserta.push({id_soal : v.id_soal, jawaban : null}) 
                    })
                var tmp = {
                    jawabanPeserta : this.jawabanPeserta,
                    posisiSoal : this.posisiSoal
                }
                this.$lcs.setLcs('ljk',tmp)
            }
            this.hitungSoalSiap()
            this.showSoal(this.posisiSoal)
            })
        .catch(err=>{
            console.log(err)
            })
        
    },
    kumpulkanUjian () {
        this.simpanJawaban(this.posisiSoal,this.jawaban)
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
            this.$ajx.post('api/ujian/hasil',hasil)
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
            this.$ajx.post('api/ujian/jawaban',hasil)
            .then(res=>{
                this.$lcs.removeLcs('infoUjian')
                this.$cks.clearCookies('infoLogin')
                this.$lcs.removeLcs('ljk')
                this.$router.push({path: '/'})
                })
            .catch(err=>{
                console.log(err)
                bus.$emit('showAlert','Kesalahan!','Tidak dapat mengumpukan ujian. Silahkan diulangi kembali!','warning')
                })
        }
    },
    simpanJawaban (x,jawaban){
        this.jawabanPeserta[x].jawaban = jawaban
        this.posisiSoal = x
        var tmp = {
            jawabanPeserta : this.jawabanPeserta,
            posisiSoal : this.posisiSoal
        }
        this.$lcs.setLcs('ljk',tmp)
        this.hitungSoalSiap()
    },
    hitungSoalSiap () {
        var b = 0
        var s = 0
        _.forEach(this.jawabanPeserta,(v,k)=>{
            if(v.jawaban == null) b++
            else s++
            })
        this.soalDikerjakan = s
    }
}
}
</script>

<style scopped>
</style>
