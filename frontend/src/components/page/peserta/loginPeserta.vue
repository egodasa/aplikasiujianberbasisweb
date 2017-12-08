<template>
<div class="w3-container">
<div class="w3-modal" style="display:block;">
<div class="w3-modal-content w3-card-4">
<div class="w3-container w3-blue-gray w3-center">
  <h2>Silahkan Pilih Ujian</h2>
</div>
<div class="w3-container">
	<form method="POST" @submit.prevent="masukUjian()">
	<div class="w3-center" style="margin:0 auto;width:75%;">
        <span class="w3-container">
            <v-select v-model="selectedUjian" :options="listUjian" label="nm_ujian"></v-select>
        </span>
        <button type="button" class="w3-btn w3-red w3-section" @click="batalkanUjian()">Kembali</button>
        <button type="submit" class="w3-btn w3-blue w3-section">Login</button>
	</div>
	</form>
</div>
</div>
</div>
</div>
</template>

<script>
import axios from 'axios'
import _ from 'lodash'
export default {
  name: 'loginPeserta',
  data () {
      return {
          listUjian : [],
          nobp : 0,
          selectedUjian : null
        }
  },
  beforeCreated (){
      if(this.$session.has('infoUjian')) this.$router.push({path : '/ujian/petunjuk'})
  },
  created () {
    this.getUjian()
  },
  methods : {
      getUjian () {
          axios.get('/api/mahasiswa/'+this.$session.get('infoUjian').username+'/ujian')
          .then(res=>{
              this.listUjian = res.data.data
              })
          .catch(err=>{
              this.listUjian = []
              console.log(err)
              })
      },
      masukUjian(){
          this.$session.set('infoUjian',this.selectedUjian)
          this.$router.push({path : '/ujian/petunjuk'})
      },
      batalkanUjian (){
          this.$session.destroy()
          this.$router.push({path : '/'})
      }
  }
}
</script>

<style scoped>

</style>
