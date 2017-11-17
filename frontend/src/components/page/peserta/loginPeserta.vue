<template>
<div class="w3-section">
	<form method="POST" @submit.prevent="cekPeserta()">
	<div class="w3-center" style="margin:0 auto;width:75%;">
        <!--<div class="w3-panel w3-red" ng-show="pesanWarning">
             <span class="w3-closebtn" ng-click="closeWarning()">X</span>
             <p>{{isiPesan}}</p>
        </div>
        -->
        <h2>Login Peserta Ujian</h2>
        <select class="w3-select w3-section" name="ujian" v-model="selectedUjian">
            <option v-for="(x,index,key) in listUjian" :value="index">{{x.nm_matkul + ' - ' + x.nm_dosen + ' - ' + x.nm_kelas}}</option>
        </select>
        <input class="w3-input w3-section" placeholder="NOBP" v-model="nobp"/>
        <button type="submit" class="w3-btn w3-blue w3-section">Login</button>
	</div>
	</form>
</div>
</template>

<script>
import axios from 'axios'
import _ from 'lodash'
export default {
  name: 'loginPeserta',
  data () {
      return {
          listUjian : [{}],
          nobp : 0,
          selectedUjian : 0
        }
  },
  created () {
    this.getUjian()
  },
  methods : {
      getUjian () {
          axios.get('/api/ujian')
          .then(res=>{
              this.listUjian = res.data.data
              })
          .catch(err=>{
              console.log(err)
              })
      },
      cekPeserta () {
          axios.get('/api/cek/'+this.listUjian[this.selectedUjian].id_tsoal+'/ujian/'+this.listUjian[this.selectedUjian].id_ujian+'/peserta/'+this.nobp)
          .then(res=>{
            var hasil = res.data.data
            console.log(hasil.length)
            if(hasil.length > 0){
                if(hasil[0].status == true) console.log('anda sudah ujian')
                else{
                    console.log('anda belum ujian')
                    hasil = hasil[0]
                    var b = this.listUjian[this.selectedUjian]
                    var infoUjian = Object.assign(hasil,b)
                    this.$session.set('infoUjian',infoUjian)
                    console.log(this.$session.get('infoUjian'))
                    this.$router.push({path: '/ujian/petunjuk'})
                }
            }else console.log('anda tidak terdaftar')
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
