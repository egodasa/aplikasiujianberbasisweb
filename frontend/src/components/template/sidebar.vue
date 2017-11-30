<template>
<!-- Top container -->
<div id="sidebar">
<nav class="w3-sidebar w3-collapse w3-white" :style="'z-index:3;width:300px;display:'+menuStatus+';'" id="mySidebar"><br>
  <div class="w3-container w3-row">
    <div class="w3-col s8 w3-bar">
      <span>{{welcomeMessage}}</span><br>
    </div>
  </div>
  <hr>
  <slot>
      <div class="w3-container">
        <h5>{{title}}</h5>
      </div>
      <div class="w3-bar-block">
        <a href="#" class="w3-bar-item w3-button w3-padding-16 w3-hide-large w3-dark-grey w3-hover-black" @click="toggleMenu()" title="close menu"><i class="fa fa-remove fa-fw"></i>  Close Menu</a>
        <router-link v-for="x in listMenu" :to="x.path" class="w3-bar-item w3-button w3-padding"><i :class="'fa ' + x.icon "></i>  {{x.name}}</router-link>
      </div>
   </slot>
</nav>
<div class="w3-overlay w3-hide-large w3-animate-opacity" @click="toggleMenu()" style="cursor:pointer" title="close side menu" id="myOverlay"></div>
</div>
</template>
<script>
import { Bus } from '../../bus.js';
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
          menuStatus : "none"
      }
  },
  created(){
      Bus.$on('toggleMenu',()=>{
          this.toggleMenu()
          })
      },
  methods : {
      toggleMenu () {
          if(this.menuStatus == "none"){
              this.menuStatus = "block"
          }else this.menuStatus = "none"
      }
  }
}
</script>
<style scoped>

</style>
