<template>
<div class="w3-section">
	<form method="POST" @submit.prevent="cekUser()">
	<div class="w3-center" style="margin:0 auto;width:75%;">
        <!--<div class="w3-panel w3-red" ng-show="pesanWarning">
             <span class="w3-closebtn" ng-click="closeWarning()">X</span>
             <p>{{isiPesan}}</p>
        </div>
        -->
        <h2>Login Pengguna</h2>
        <input class="w3-input w3-section" placeholder="username" type="text" v-model="username"/>
        <input class="w3-input w3-section" placeholder="Password" type="password" v-model="password"/>
        <button type="submit" class="w3-btn w3-blue w3-section">Login</button>
	</div>
	</form>
</div>
</template>

<script>
import axios from 'axios'
import _ from 'lodash'
import md5 from 'md5'
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
              else console.log('login berhasil')
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
