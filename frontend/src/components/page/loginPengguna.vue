<template>
<div class="w3-container">
<div class="w3-modal" style="display:block;">
<div class="w3-modal-content w3-card-4">
<div class="w3-container w3-blue-gray w3-center">
  <h2>Login Pengguna</h2>
</div>
<div class="w3-center w3-container" :style="Blogin.disabled ? 'display:block;height:250px;':'display:none;height:300px;'">
    <div class="w3-big w3-margin-top">Mengecek Login Pengguna
  <div class="sk-three-bounce">
    <img src="/images/loading.gif" class="w3-image" width="200" />
  </div>
  </div>
</div>
<div class="w3-container" :style="!Blogin.disabled ? 'display:block;':'display:none;'">
	<form method="POST" @submit.prevent="cekUser()">
	<div class="w3-center" style="margin:0 auto;width:75%;">
        <!--<div class="w3-panel w3-red" ng-show="pesanWarning">
             <span class="w3-closebtn" ng-click="closeWarning()">X</span>
             <p>{{isiPesan}}</p>
        </div>
        -->
        <input class="w3-input w3-section" placeholder="username" type="text" v-model="username"/>
        <input class="w3-input w3-section" placeholder="Password" type="password" v-model="password"/>
        <button type="submit" class="w3-btn w3-blue w3-section">{{Blogin.caption}}</button>
	</div>
	</form>
</div>
</div>
</div>
</div>
</template>

<script>

import md5 from 'md5'
import modal from '../template/modal.vue'
export default {
  name: 'loginPengguna',
  components : {
    modal
  },
  beforeRouteEnter (to, from, next) {
      next(vm => {
            if(vm.$lcs.get('user')){
                if(vm.$lcs.get('user').id_juser == 1) vm.$router.push({path:'/admin'})
                else if(vm.$lcs.get('user').id_juser == 2) vm.$router.push({path:'/dosen/'+vm.$lcs.get('user').username})
                else if(vm.$lcs.get('user').id_juser == 3) vm.$router.push({path:'/ujian/soal'})
            }
        })
  },
  data () {
      return {
      username : null,
      password : null,
      Blogin : {
        disabled : false,
        caption : "login"
      }
    }
  },
  created (){
      bus.$emit('toggleModal')
  },
  methods : {
      cekUser () {
          if(this.username == null || this.password == null){
              bus.$emit("showAlert","Pesan!","Username dan password tidak boleh kosong!","warning")
          }else{
              this.Blogin.disabled = true
              this.Blogin.caption = "Mengecek"
              var data = {
                username : this.username,
                password : md5(this.password)
              }
              this.$ajx.post('api/user/cek',data)
              .then(res=>{
                  this.Blogin.disabled = false
                  this.Blogin.caption = "Login"
                  console.log(this.Blogin)
                  let hasil = res.data.data
                  if(hasil.length == 0) {
                      bus.$emit('showAlert','Peringatan!','Username atau password tidak cocok!','warning')
                      }
                  else {
                      var x = {}
                      if(hasil[0].id_juser == 1){
                          this.$lcs.set('user',hasil[0])
                          x = {path : '/admin'}
                      }else if(hasil[0].id_juser == 2){
                          this.$lcs.set('user',hasil[0])
                          x = {path : '/dosen/'+this.username}
                      }else if(hasil[0].id_juser == 3){
                          this.$lcs.set('infoUjian',hasil[0])
                          x = {path : '/ujian/login'}
                      }else this.$router.push({path: '/'})
                      this.$router.push(x)
                  }
                  })
              .catch(err=>{
                  this.Blogin.disabled = false
                  this.Blogin.caption = "Login"
                  console.log(err)
                  })
          }
      }
  }
}
</script>

<style scoped>
</style>
