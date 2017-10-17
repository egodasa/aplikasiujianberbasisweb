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
            <option v-for="(x,index,key) in listUjian" :value="index">{{x.nm_ujian}}</option>
        </select>
        <input class="w3-input w3-section" placeholder="Nomor Peserta" v-model="id_peserta"/>
        <button type="submit" class="w3-btn w3-blue w3-section">Login</button>
	</div>
	</form>
</div>
</template>

<script>
import axios from 'axios'

export default {
  name: 'loginPeserta',
  data () {
      return {
          listUjian : [{}],
          id_peserta : 0,
          selectedUjian : 0
        }
  },
  created () {
    this.getUjian()
    console.log(this.$session.id())
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
          axios.get('/api/ujian/'+this.listUjian[this.selectedUjian].id+'/peserta/'+this.id_peserta)
          .then(res=>{
              var hasil = res.data
              if(hasil.data.length == 0) console.log('anda tidak terdaftar diujian ini')
              else {
                var infoUjian = {
                    id_peserta : hasil.data[0].id,
                    nm_peserta : hasil.data[0].nm_peserta,
                    id_ujian : this.listUjian[this.selectedUjian].id,
                    nm_ujian : this.listUjian[this.selectedUjian].nm_ujian
                }
                this.$session.set('infoUjian',infoUjian)
                console.log(this.$session.get('infoUjian'))
                this.$router.push({path: '/ujian/petunjuk'})
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
