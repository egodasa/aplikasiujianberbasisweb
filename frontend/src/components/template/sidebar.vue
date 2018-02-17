<template>
<!-- Top container -->
<div id="sidebar">
<nav class="w3-sidebar w3-collapse w3-white" :style="'z-index:3;padding-top:30px;width:250px;display:'+menuStatus+';'" id="mySidebar"><br>
    <slot name="sidebarAtas"></slot>
<div class="w3-border-bottom"></div>
<slot name="sidebarBawah">
    <div class="w3-container">
        <h5>{{title}}</h5>
    </div>
    <div class="w3-bar-block">
        <a href="#" class="w3-bar-item w3-button w3-padding-16 w3-hide-large w3-red w3-dark-grey w3-hover-black" @click="toggleMenu()" title="close menu"><i class="fa fa-remove fa-fw"></i>  Tutup Menu</a>
        <router-link @click="toggleMenu()" v-for="x in listMenu" :to="x.path" :key="x.key" :class="$route.fullPath == x.path ? 'w3-bar-item w3-button w3-padding w3-gray' : 'w3-bar-item w3-button w3-padding'"><i :class="'fa ' + x.icon "></i>  {{x.name}}</router-link>
        <a class="w3-bar-item w3-button w3-padding" @click="logout()"><i class="fa fa-sign-out fa-fw"></i>  Logout</a>
    </div>
</slot>
</nav>
<div class="w3-overlay w3-hide-large w3-animate-opacity" @click="toggleMenu()" style="cursor:pointer" title="close side menu" id="myOverlay"></div>
</div>
</template>
<script>
import formatWaktu from 'date-fns/format'
import lokalisasi from 'date-fns/locale/id'
import hitungWaktu from 'date-fns/distance_in_words'
import hitungWaktuMili from 'date-fns/difference_in_milliseconds'

export default {
name: 'secSidebar',
props : {
    welcomeMessage : {
        type : String,
        required : false,
        default : ''
    },
    listMenu : {
        type : Array,
        required : false,
        default : function () {
            return [{}]
            }
    },
    title : {
        type : String,
        required : false,
        default : 'Menu'
    }
},
data (){
    return {
        menuStatus : "none",
        hariSekarang : null,
        jamSekarang : null,
        sisaWaktu : null,
        infoUser : {}
    }
},
created () {
    bus.$on('toggleMenu',this.toggleMenu)
    this.hariSekarang = formatWaktu(new Date(), 'dddd, DD MMMM YYYY', {locale : lokalisasi})
    this.jamSekarang = formatWaktu(new Date(), 'h:m:s', {locale : lokalisasi})
    this.sisaWaktu = 0
    },
methods : {
    toggleMenu () {
        if(this.menuStatus == "none"){
            this.menuStatus = "block"
        }else this.menuStatus = "none"
    },
    logout () {
        this.$cks.clearCookies('infoLogin')
        this.$router.push({path : '/'})
    }
},
destroyed (){
    bus.$off('toggleMenu',this.toggleMenu)
}
}
</script>
<style scoped>

</style>
