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
    <div class="sk-child sk-bounce1"></div>
    <div class="sk-child sk-bounce2"></div>
    <div class="sk-child sk-bounce3"></div>
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
import axios from 'axios'
import _ from 'lodash'
import md5 from 'md5'
import { Bus } from '../../bus.js';
import modal from '../template/modal.vue'
export default {
  name: 'loginPengguna',
  components : {
    modal
  },
  beforeRouteEnter (to, from, next) {
      next(vm => {
            if(vm.$session.has('user')){
                if(vm.$session.get('user').id_juser == 1) vm.$router.push({path:'/admin'})
                else if(vm.$session.get('user').id_juser == 2) vm.$router.push({path:'/dosen/'+vm.$session.get('user').username})
                else if(vm.$session.get('user').id_juser == 3) vm.$router.push({path:'/ujian/soal'})
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
      Bus.$emit('toggleModal')
  },
  methods : {
      cekUser () {
          this.Blogin.disabled = true
          this.Blogin.caption = "Mengecek"
          var data = {
              username : this.username,
              password : md5(this.password || "password")
          }
          axios.post('api/user/cek',data)
          .then(res=>{
              this.Blogin.disabled = false
              this.Blogin.caption = "Login"
              console.log(this.Blogin)
              let hasil = res.data.data
              if(hasil.length == 0) {
                  Bus.$emit('showAlert','Peringatan!','Username atau password tidak cocok!','warning')
                  }
              else {
                  var x = {}
                  if(hasil[0].id_juser == 1){
                      this.$session.set('user',hasil[0])
                      x = {path : '/admin'}
                  }else if(hasil[0].id_juser == 2){
                      this.$session.set('user',hasil[0])
                      x = {path : '/dosen/'+this.username}
                  }else if(hasil[0].id_juser == 3){
                      this.$session.set('infoUjian',hasil[0])
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
</script>

<style scoped>
.sk-three-bounce {
  margin: 40px auto;
  width: 80px;
  text-align: center; }
  .sk-three-bounce .sk-child {
    width: 20px;
    height: 20px;
    background-color: #333;
    border-radius: 100%;
    display: inline-block;
    -webkit-animation: sk-three-bounce 1.4s ease-in-out 0s infinite both;
            animation: sk-three-bounce 1.4s ease-in-out 0s infinite both; }
  .sk-three-bounce .sk-bounce1 {
    -webkit-animation-delay: -0.32s;
            animation-delay: -0.32s; }
  .sk-three-bounce .sk-bounce2 {
    -webkit-animation-delay: -0.16s;
            animation-delay: -0.16s; }

@-webkit-keyframes sk-three-bounce {
  0%, 80%, 100% {
    -webkit-transform: scale(0);
            transform: scale(0); }
  40% {
    -webkit-transform: scale(1);
            transform: scale(1); } }

@keyframes sk-three-bounce {
  0%, 80%, 100% {
    -webkit-transform: scale(0);
            transform: scale(0); }
  40% {
    -webkit-transform: scale(1);
            transform: scale(1); } }
</style>
