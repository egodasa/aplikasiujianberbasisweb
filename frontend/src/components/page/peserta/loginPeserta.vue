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
            <v-select v-model="selectedUjian" :options="listUjian" label="nm_ujian" placeholder="Klik disini untuk memilih ujian ...."></v-select>
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
      if(this.$lcs.get('infoLogin')) this.$router.push({path : '/ujian/petunjuk'})
  },
  created () {
    this.getUjian()
  },
  methods : {
      getUjian () {
          this.$ajx.get('/api/mahasiswa/'+this.$lcs.get('infoLogin').username+'/ujian')
          .then(res=>{
              this.listUjian = res.data.data
              })
          .catch(err=>{
              this.listUjian = []
              bus.$emit('showAlert','Kesalahan!','Tidak dapat mengambil daftar ujian. Silahkan tekan tombol "Kembali"!','warning')
              })
      },
      masukUjian(){
          this.$lcs.set('infoUjian',this.selectedUjian)
          this.$router.push({path : '/ujian/petunjuk'})
      },
      batalkanUjian (){
          this.$lcs.remove('infoLogin')
          this.$router.push({path : '/'})
      }
  }
}
</script>

<style scoped>

</style>
