<template>
<div class="w3-container">
    <h2>Informasi Ujian</h2>
    <div class="w3-row">
            <div class="w3-col l6 s12 xs12">
            <table class="w3-table w3-border w3-bordered">
                    <tr>
                    <td class="w3-white">Mata Kuliah</td>
                    <td class="w3-white">{{infoUjian.nm_matkul}}</td>
                    </tr>
                    <tr>
                    <td class="w3-white">Kelas</td>
                    <td class="w3-white">
                        {{infoUjian.nm_kelas.toString()}}</td>
                    </tr>
                    <tr>
                    <td class="w3-white">Hari</td>
                    <td class="w3-white">{{infoUjian.hari}}</td>
                    </tr>
                    <tr>
                    <td class="w3-white">Jenis Ujian</td>
                    <td class="w3-white">{{infoUjian.nm_jujian}}</td>
                    </tr>
            </table>
            </div>
            <div class="w3-col l6 s12 xs12">
            <table class="w3-table w3-border w3-bordered">
                <tr>
                <td class="w3-white">Dosen</td>
                <td class="w3-white">{{infoUjian.nm_dosen}}</td>
                </tr>
                <tr>
                <td class="w3-white">Tahun Akademik</td>
                <td class="w3-white">{{infoUjian.tahun_akademik}}</td>
                </tr>
                <tr>
                <td class="w3-white">Waktu</td>
                <td class="w3-white">{{infoUjian.mulai +' - '+ infoUjian.selesai}}</td>
                </tr>
                <tr>
                <td class="w3-white">Jenis Soal</td>
                <td class="w3-white">{{infoUjian.nm_jsoal}}</td>
                </tr>
            </table>
            </div>
        </div>
<h2>Pemeriksaan Jawaban</h2>
<div class="w3-row-padding w3-white">
    <div class="w3-col l6 m6 s12 xs12">
        <h5>Pilih Soal</h5>
        <button type="button" style="padding: 5px;width:40px;margin : 3px;" v-for="(y,index,key) in listJawaban" @click="showSoal(index)" :class="posisiSoal == index ? 'w3-button w3-pale-blue w3-border w3-border-light-gray' : ' w3-border w3-border-light-gray w3-button w3-blue'">{{index+1}}</button>
    </div>
    <div class="w3-col l6 m6 s12 xs12">
        <h5>Informasi Peserta</h5>
        <div class="w3-row">
            <div class="w3-col l4 m4 s4 xs4">
            <label>NOBP</label>
            </div>
            <div class="w3-col l8 m8 s8 xs8">
            <label>: {{infoPeserta.nobp}}</label>
            </div>
            <div class="w3-col l4 m4 s4 xs4">
            <label>Nama Mahasiswa</label>
            </div>
            <div class="w3-col l8 m8 s8 xs8">
            <label>: {{infoPeserta.nm_mahasiswa}}</label>
            </div>
            <div class="w3-col l4 m4 s4 xs4">
            <label>Kelas</label>
            </div>
            <div class="w3-col l8 m8 s8 xs8">
            <label>: {{infoPeserta.nm_kelas}}</label>
            </div>

        </div>
    </div>
    <div class="w3-clear"></div>
    <hr>
    <div class="w3-col s12 xs12">
        <h5>Soal</h5>
        <span v-html="listJawaban[posisiSoal].isi_soal"></span>
            <hr>
    </div>
    <div class="w3-col s12 xs12">
        <h5>Jawaban</h5>
        <span v-html="listJawaban[posisiSoal].jawaban_peserta"></span>
            <hr>
    </div>
    <div class="w3-col l6 m6 s12 xs12">
        <h5>Nilai yang diberikan</h5>
        {{'Maks. Nilai Soal ini : '+listJawaban[posisiSoal].bobot}}
        <form @submit.prevent="simpanNilai(bobot)">
        <div class="w3-bar">
            <input class="w3-input w3-border w3-bar-item" style="width:50%;height:38px;" type="number" min=0 :max.number="listJawaban[posisiSoal].bobot" v-model.number="bobot" />
            <button type="submit" class="w3-button w3-blue w3-bar-item">Simpan</button>
        </div>
        </form>
    </div>
    <div class="w3-col l6 m6 s12 xs12">
        <h5>Nilai Akhir </h5>
        {{'Total Nilai Peserta : '+totalBobot}}<br/>
        <button type="button" class="w3-button w3-red" @click="simpanPeriksa()">Simpan Hasil Pemeriksaan</button>
    </div>
    <div class="w3-clear"></div>
    <hr>
</div>
</div>
</template>

<script>


import { dosenConf } from './dosen.js'
import dosen from './halamanDosen.vue'
import formatWaktu from 'date-fns/format'
import lokalisasi from 'date-fns/locale/id'
export default {
name: 'DcekJawaban',
components : {
    dosen
},
data () {
    return {
        infoUjian : {},
        listJawaban :[{}],
        posisiSoal : 0,
        totalBobot : 0,
        bobot : 0,
        infoPeserta : {}
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
        var query = `
        query detailPesertaUjian($id : String,$nobp : String){
            detailPesertaUjian(id:$id,nobp:$nobp) {
                nobp
                nm_mahasiswa
                nm_kelas
            }
        }`
        var kueri = {query : query,variables : {id : this.$route.params.idUjian,nobp:this.$route.params.idPeserta}}
        this.$ajx.get('api/ujian/'+this.$route.params.idUjian)
        .then(res=>{
            this.infoUjian = res.data.data[0]
            this.infoUjian.hari = formatWaktu(new Date(this.infoUjian.hari), 'DD MMMM YYYY', {locale : lokalisasi})
            return this.$ajx.post('api/v2/ujian/',kueri)
            })
        .then(res=>{
            this.infoPeserta = res.data.data.detailPesertaUjian[0]
            })
        .catch(err=>{
            
            if(err){
                if(err.response.status == 204) this.$router.push({path:'/dosen/ujian/'+this.$cks.getCookies('infoLogin').username})
                else {
                    bus.$emit('showAlert','Kesalahan!','Tidak dapat mengambil data jawaban. Silahkan ulangi kembali ...','warning')
                }
            }
            
        })       
    },
    getListJawaban (){
        this.$ajx.get('api/ujian/'+this.$route.params.idUjian+'/jawaban/'+this.$route.params.idPeserta)
        .then(res=>{
            
            this.listJawaban = res.data.data
            _.forEach(this.listJawaban, (v,k)=>{
                this.listJawaban[k].bobot_peserta = 0
                })
            })
        .catch(err=>{
            this.listJawaban = []
            
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
        this.$ajx.post('api/ujian/hasil',data)
        .then(res=>{
            this.$router.push({path: '/dosen/'+this.$cks.getCookies('infoLogin').username+'/ujian/'+this.$route.params.idUjian})
            })
        .catch(err=>{
            
            })
        
    }
}
}
</script>

<style scoped>

</style>
