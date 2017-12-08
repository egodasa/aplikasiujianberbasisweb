<template>
<!-- Top container -->
<div id="sidebar">
<nav class="w3-sidebar w3-collapse w3-white" :style="'z-index:3;width:300px;display:'+menuStatus+';'" id="mySidebar"><br>
  <template v-if="$session.has('user')">
  <div class="w3-container w3-row">
    <div class="w3-col s8 w3-bar">
      {{welcomeMessage}}
    </div>
  </div>
  <hr>
  </template>
  <slot>
      <div class="w3-container">
        <h5>{{title}}</h5>
      </div>
      <div class="w3-bar-block">
        <a href="#" class="w3-bar-item w3-button w3-padding-16 w3-hide-large w3-dark-grey w3-hover-black" @click="toggleMenu()" title="close menu"><i class="fa fa-remove fa-fw"></i>  Tutup Menu</a>
        <router-link @click="toggleMenu()" v-for="x in listMenu" :to="x.path" :key="x.key" :class="$route.fullPath == x.path ? 'w3-bar-item w3-button w3-padding w3-gray' : 'w3-bar-item w3-button w3-padding'"><i :class="'fa ' + x.icon "></i>  {{x.name}}</router-link>
        <template v-if="$session.has('user')">
            <a v-if="$session.get('user').id_juser <= 2" class="w3-bar-item w3-button w3-padding" @click="logout()"><i class="fa fa-sign-out fa-fw"></i>  Logout</a>
        </template>
      </div>
   </slot>
</nav>
<div class="w3-overlay w3-hide-large w3-animate-opacity" @click="toggleMenu()" style="cursor:pointer" title="close side menu" id="myOverlay"></div>
</div>
</template>
<script>
import { Bus } from '../../bus.js';
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
  },/*
  watch : {
      jamSekarang () {
         var self = this
         setInterval(function () {
         self.jamSekarang = formatWaktu(new Date(), 'h:m:s', {locale : lokalisasi})
      }, 1000)
      },
      sisaWaktu () {
         var self = this
         var mili = new Date().getTime()
         var mili_akhir = new Date(2017,12,6,22,0,0).getTime()
         var sisa = mili_akhir - mili
         setInterval(function () {
         self.sisaWaktu = new Date(sisa).getTime()}, 1000)
     }
  },*/
  data (){
      return {
          menuStatus : "none",
          hariSekarang : null,
          jamSekarang : null,
          sisaWaktu : null
      }
  },
  created(){
      Bus.$on('toggleMenu',()=>{
          this.toggleMenu()
          })
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
          this.$session.destroy()
          this.$router.push({path : '/'})
      }
  }
}
</script>
<style scoped>

</style>
