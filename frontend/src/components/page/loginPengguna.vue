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
import jwt_decode from 'jwt-decode'
export default {
name: 'loginPengguna',
components : {
    modal
},
beforeRouteEnter (to, from, next) {
    next(vm => {
            if(vm.$cks.isCookies('infoLogin')){
                if(vm.$cks.getCookies('infoLogin').id_juser == 1) vm.$router.push({path:'/admin'})
                else if(vm.$cks.getCookies('infoLogin').id_juser == 2) vm.$router.push({path:'/dosen/'+vm.$cks.getCookies('infoLogin').username})
                else if(vm.$cks.getCookies('infoLogin').id_juser == 3){
                    if(vm.$lcs.getLcs('infoUjian')){
                        vm.$router.push({path:'/ujian/petunjuk'})
                    }else vm.$router.push({path:'/ujian/login'})
                }
            }
        })
},
data () {
    return {
    username : '0005076607',
    password : 'upi0005076607yptk',
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
        if(this.username == null || this.password == null || this.username.length == 0 || this.password.length == 0){
            bus.$emit("showAlert","Pesan!","Username atau password tidak boleh kosong!","warning")
        }else{
            this.Blogin.disabled = true
            this.Blogin.caption = "Mengecek"
            this.$ajx.post('login',{username : this.username,password : md5(this.password)})
            .then(res=>{
                this.Blogin.disabled = false
                this.Blogin.caption = "Login"
                let hasil = res.data.data
                
                if(hasil.token == null) {
                    bus.$emit('showAlert','Peringatan!','Username atau password tidak cocok!','warning')
                    }
                else {
                    var userInfo = jwt_decode(hasil.token).data
                    if(userInfo.status_user == 0){
                        bus.$emit('showAlert','Peringatan!','Akun Anda sudah tidak bisa digunakan lagi!','warning')
                    }else{
                        this.$cks.setCookies('infoLogin',hasil.token,'6h')
                        var x = {}
                            if(userInfo.id_juser == 1){
                                this.$router.push({path : '/admin'})
                            }else if(userInfo.id_juser == 2){
                                this.$router.push({path : '/dosen/'+this.username})
                            }else if(userInfo.id_juser == 3){
                                this.$router.push({path : '/ujian/login'})
                            }else this.$router.push({path: '/'})
                        }
                    }
                })
            .catch(err=>{
                this.Blogin.disabled = false
                this.Blogin.caption = "Login"
                bus.$emit('showAlert','Kesalahan!','Tidak dapat login. Silahkan ulangi kembali!','warning')
                })
        }
    }
}
}
</script>

<style scoped>
</style>
