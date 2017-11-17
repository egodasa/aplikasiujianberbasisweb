<template>
<!-- Top container -->
<div id="sidebar">
<nav class="w3-sidebar w3-collapse w3-white" style="z-index:3;width:300px;" id="mySidebar"><br>
  <div class="w3-container w3-row">
    <div class="w3-col s4">
      <img src="/w3images/avatar2.png" class="w3-circle w3-margin-right" style="width:46px">
    </div>
    <div class="w3-col s8 w3-bar">
      <span>{{welcomeMessage}}</span><br>
    </div>
  </div>
  <hr>
  <div class="w3-container">
    <h5>{{title}}</h5>
  </div>
  <div class="w3-bar-block">
    <a href="#" class="w3-bar-item w3-button w3-padding-16 w3-hide-large w3-dark-grey w3-hover-black" onclick="w3_close()" title="close menu"><i class="fa fa-remove fa-fw"></i>  Close Menu</a>
    <router-link v-for="x in listMenu" :to="x.path" class="w3-bar-item w3-button w3-padding"><i :class="'fa ' + x.icon "></i>  {{x.name}}</router-link>
  </div>
</nav>
<div class="w3-overlay w3-hide-large w3-animate-opacity" onclick="w3_close()" style="cursor:pointer" title="close side menu" id="myOverlay"></div>
</div>
</template>
<script>
export default {
  name: 'secSidebar',
  props : {
      welcomeMessage : {
          type : String,
          required : false,
          default : 'Welcome'
      },
      listMenu : {
          type : Array,
          required : true,
          default : function () {
              return [{}]
              }
      },
      title : {
          type : String,
          required : false,
          default : 'Menu'
      }
  }
}
</script>
<style scoped>

</style>
