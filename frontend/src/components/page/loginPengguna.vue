<template>
<div class="w3-container">
<div class="w3-modal" style="display:block;">
<div class="w3-modal-content w3-card-4">
<div class="w3-container w3-blue-gray w3-center">
  <h2>Login Pengguna</h2>
</div>
<div class="w3-container">
	<form method="POST" @submit.prevent="cekUser()">
	<div class="w3-center" style="margin:0 auto;width:75%;">
        <!--<div class="w3-panel w3-red" ng-show="pesanWarning">
             <span class="w3-closebtn" ng-click="closeWarning()">X</span>
             <p>{{isiPesan}}</p>
        </div>
        -->
        <input class="w3-input w3-section" placeholder="username" type="text" v-model="username"/>
        <input class="w3-input w3-section" placeholder="Password" type="password" v-model="password"/>
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
import md5 from 'md5'
import { Bus } from '../../bus.js';
export default {
  name: 'loginPengguna',
  data () {
      return {
      username : null,
      password : null
    }
  },
  methods : {
      cekUser () {
          var data = {
              username : this.username,
              password : md5(this.password)
          }
          axios.post('api/user/cek',data)
          .then(res=>{
              let hasil = res.data.data
              if(hasil.length == 0) console.log('username atau password salah')
              else {
                  var x = {}
                  if(hasil[0].id_juser == 1){
                      this.$session.set('user',hasil[0])
                      x = {path : '/admin'}
                  }else if(hasil[0].id_juser == 2){
                      this.$session.set('user',hasil[0])
                      x = {path : '/dosen'}
                  }else if(hasil[0].id_juser == 3){
                      this.$session.set('infoUjian',hasil[0])
                      x = {path : '/ujian/login'}
                  }else this.$router.push({path: '/'})
                  this.$router.push(x)
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
