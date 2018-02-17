<template>
<div class="w3-container">
<div class="w3-modal" style="display:block;">
<div class="w3-modal-content w3-card-4">
<div class="w3-container w3-blue-gray w3-center">
  <h2>Silahkan Pilih Ujian</h2>
</div>
<div class="w3-container w3-center">
	<div style="margin:0 auto;width:75%;">
        <template v-if="loading">
            <h4>Memuat Data ...</h4>
                <div class="sk-three-bounce">
                <img src="/images/loading.gif" class="w3-image" width="200" />
            </div>
        </template>
        <template v-else>
            <template v-if="listUjian.length < 1">
                <div class="w3-display-container" style="height:300px;">
                    <div class="w3-display-middle">
                        <div class="w3-text-blue-gray" style="font-size:40px;text-align:center;">Jadwal Ujian kosong ...</div><br/>
                        <div class="w3-center">
                        <button type="button"  @click="batalkanUjian()" class="w3-button w3-center w3-red"><i class="fa fa-sign-out"></i> Kembali</button>
                        </div>
                    </div>
                </div>
            </template>
            <template v-else>
                <a v-for="x in listUjian" @click="masukUjian(x)">
                <div class="w3-panel w3-leftbar w3-pale-green">
                    <p>{{x.nm_dosen}}</p>
                    <p>{{x.nm_ujian+' ( '+x.nm_kelas+' )'+' ( '+x.mulai+' - '+x.selesai+' )'}}</p>
                </div> 
                </a>
                <button type="button" class="w3-button w3-center w3-red w3-margin" @click="batalkanUjian()"><i class="fa fa-sign-out"></i> Kembali</button>
            </template>
        </template>
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
          selectedUjian : null,
          loading : false
        }
  },
  beforeRouteEnter: (to, from, next)=>{
    next(vm => {
    if(vm.$cks.isCookies('infoLogin')){
        if(vm.$cks.getCookies('infoLogin').id_juser == 1) vm.$router.push({path:'/admin'})
        else if(vm.$cks.getCookies('infoLogin').id_juser == 2) vm.$router.push({path:'/dosen/'+vm.$cks.getCookies('infoLogin').username})
        else if(vm.$cks.getCookies('infoLogin').id_juser == 3) {
            if(vm.$lcs.getLcs('infoUjian')){
               vm.$router.push({path:'/ujian/petunjuk'}) 
            }
        }
        else vm.$router.push({path:'/'})
    }else vm.$router.push({path:'/'})
    })
},
  created () {
    this.getUjian()
  },
  methods : {
      getUjian () {
          this.loading = true
          this.$ajx.get('/api/mahasiswa/'+this.$cks.getCookies('infoLogin').username+'/ujian')
          .then(res=>{
              this.listUjian = res.data.data
              this.loading = false
              })
          .catch(err=>{
              this.loading = false
              this.listUjian = []
              bus.$emit('showAlert','Kesalahan!','Tidak dapat mengambil daftar ujian. Silahkan tekan tombol "Kembali"!','warning')
              })
      },
      masukUjian(x){
          this.$lcs.setLcs('infoUjian',x)
          this.$router.push({path : '/ujian/petunjuk'})
      },
      batalkanUjian (){
          this.$cks.clearCookies('infoLogin')
          this.$router.push({path : '/'})
      }
  }
}
</script>

<style scoped>

</style>
