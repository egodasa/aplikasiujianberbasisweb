<template>
<!-- Top container -->
<div class="w3-bar w3-top w3-black w3-large" style="z-index:4">
  <span class="w3-bar-item w3-left">{{title}}</span>
  <button class="w3-bar-item w3-button w3-hide-large w3-hover-none w3-hover-text-light-grey" onclick="w3_open();"><i class="fa fa-bars"></i>  Menu</button>
  <span class="w3-bar-item w3-right"></span>
</div>
</template>
<script>
export default {
  name: 'secHeader',
  props : {
      title : {
          type : String,
          required : false,
          default : 'Universitas Putra Indonesia YPTK Padang'
      }
  }
}
</script>
<style scoped>

</style>
