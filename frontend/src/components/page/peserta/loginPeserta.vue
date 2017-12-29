<template>
<div class="w3-container">
<div class="w3-modal" style="display:block;">
<div class="w3-modal-content w3-card-4">
<div class="w3-container w3-blue-gray w3-center">
  <h2>Silahkan Pilih Ujian</h2>
</div>
<div class="w3-container">
	<div style="margin:0 auto;width:75%;">
        <a v-for="x in listUjian" @click="masukUjian(x)">
        <div class="w3-panel w3-leftbar w3-pale-green">
            <p>{{x.nm_dosen}}</p>
            <p>{{x.nm_ujian+' ( '+x.nm_kelas+' )'+' ( '+x.mulai+' - '+x.selesai+' )'}}</p>
        </div> 
        </a>
        <button type="button" class="w3-btn w3-red w3-section w3-right" @click="batalkanUjian()">Kembali</button>
	</div>
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
  beforeRouteEnter: (to, from, next)=>{
    next(vm => {
    if(vm.$cks.getCookies('infoLogin')){
        if(vm.$cks.getCookies('infoLogin').id_juser != 3) vm.$router.push({path:'/'})
    }else vm.$router.push({path:'/'})
    })
},
  created () {
    this.getUjian()
  },
  methods : {
      getUjian () {
          this.$ajx.get('/api/mahasiswa/'+this.$cks.getCookies('infoLogin').username+'/ujian')
          .then(res=>{
              this.listUjian = res.data.data
              })
          .catch(err=>{
              this.listUjian = []
              bus.$emit('showAlert','Kesalahan!','Tidak dapat mengambil daftar ujian. Silahkan tekan tombol "Kembali"!','warning')
              })
      },
      masukUjian(x){
          this.$lcs.set('infoUjian',x)
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
