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
            if(vm.$lcs.get('infoLogin')){
                if(vm.$lcs.get('infoLogin').id_juser == 1) vm.$router.push({path:'/admin'})
                else if(vm.$lcs.get('infoLogin').id_juser == 2) vm.$router.push({path:'/dosen/'+vm.$lcs.get('infoLogin').username})
                else if(vm.$lcs.get('infoLogin').id_juser == 3) vm.$router.push({path:'/ujian/soal'})
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
            bus.$emit("showAlert","Pesan!","Username atau password tidak boleh kosong!","warning")
        }else{
            this.Blogin.disabled = true
            this.Blogin.caption = "Mengecek"
            var query = `query cekUser($username : String,$password : String){
                            cekUser(username : $username,password : $password){
                                id_user,
                                username,
                                id_juser,
                                nm_juser,
                                status_user,
                                }
                            }`
            var kueri = {query : query,variables : {username : this.username,password : md5(this.password)}}
            this.$ajx.post('api/v2/user',kueri)
            .then(res=>{
                this.Blogin.disabled = false
                this.Blogin.caption = "Login"
                let hasil = res.data.data.cekUser
                if(hasil.length == 0) {
                    bus.$emit('showAlert','Peringatan!','Username atau password tidak cocok!','warning')
                    }
                else {
                    if(hasil.status_user == 0){
                        bus.$emit('showAlert','Peringatan!','Akun Anda sudah tidak bisa digunakan lagi!','warning')
                    }else{
                        hasil[0].loginDate = new Date().getTime(),
                        hasil[0].expireLogin = new Date().getTime() + 108000 //waktu sekarang tambah 3 jam wakt login
                        this.$lcs.set('infoLogin',hasil[0])
                        }
                    }
                var x = {}
                if(hasil[0].id_juser == 1){
                    x = {path : '/admin'}
                }else if(hasil[0].id_juser == 2){
                    x = {path : '/dosen/'+this.username}
                }else if(hasil[0].id_juser == 3){
                    x = {path : '/ujian/login'}
                }else this.$router.push({path: '/'})
                this.$router.push(x)
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
