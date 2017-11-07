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
          axios.get('/api/kuliah/'+this.listUjian[this.selectedUjian].id_kuliah+'/mahasiswa')
          .then(res=>{
            var y = null
            if(res.data.status == true){
                var hasil = res.data.data
                var x = 0
                _.forEach(hasil, (value,key)=>{
                    if(value.nobp == this.nobp){
                      x++
                      y = key
                    }
                })
                if(x != 1) console.log('tidak terdaftar')
                else{
                    var a = res.data.data[y]
                    var b = this.listUjian[this.selectedUjian]
                    var infoUjian = Object.assign(a,b)
                    infoUjian.nobp = hasil[y].nobp,
                    infoUjian.nm_peserta = hasil[y].nm_peserta,
                    this.$session.set('infoUjian',infoUjian)
                    console.log(this.$session.get('infoUjian'))
                    this.$router.push({path: '/ujian/petunjuk'})
                }
            }
            else{
                console.log('tidak dapat mengecek peserta')
            }
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
